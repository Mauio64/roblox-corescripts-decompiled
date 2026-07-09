local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(Modules.Common.Roact)
local RoactRodux = require(Modules.Common.RoactRodux)
local CorePackages = game:GetService("CorePackages")
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local ApiFetchUnreadNotificationCount = require(Modules.LuaApp.Thunks.ApiFetchUnreadNotificationCount)
local SetNotificationCount = require(Modules.LuaApp.Actions.SetNotificationCount)
local GetFFlagLuaAppUpdateNotificationBadgeCountEnabled = require(Modules.LuaApp.Flags.GetFFlagLuaAppUpdateNotificationBadgeCountEnabled)
local v10 = Roact.Component:extend("BadgeEventReceiver")

function v10.init(p1) -- line: 16
	-- upvalues: GetFFlagLuaAppUpdateNotificationBadgeCountEnabled (copy)
	local setNotificationCount = p1.props.setNotificationCount
	local getNotificationCount = p1.props.getNotificationCount
	local RobloxEventReceiver = p1.props.RobloxEventReceiver
	local networking = p1.props.networking

	if GetFFlagLuaAppUpdateNotificationBadgeCountEnabled() then
		p1.lastSeqNumOfNotificationStream = nil
	end

	p1.tokens = {
		RobloxEventReceiver:observeEvent("UpdateNotificationBadge", function(p2, p3) -- line: 26
			-- upvalues: setNotificationCount (copy)
			if p3 == "NotificationIcon" then
				setNotificationCount((tonumber(p2.badgeString)))
			end
		end),
		RobloxEventReceiver:observeEvent("NotificationStream", function(p4, p5) -- line: 32
			-- upvalues: setNotificationCount (copy), getNotificationCount (copy), networking (copy), GetFFlagLuaAppUpdateNotificationBadgeCountEnabled (copy), p1 (copy)
			if p5 == "NotificationsRead" then
				setNotificationCount(0)
			else
				getNotificationCount(networking)
			end

			if GetFFlagLuaAppUpdateNotificationBadgeCountEnabled() and p4 and p4.SequenceNumber then
				p1.lastSeqNumOfNotificationStream = p4.SequenceNumber
			end
		end)
	}

	if GetFFlagLuaAppUpdateNotificationBadgeCountEnabled() then
		table.insert(p1.tokens, RobloxEventReceiver:observeEvent("signalR", function(p6, _, p8) -- line: 53
			-- upvalues: p1 (copy), getNotificationCount (copy), networking (copy)
			if p6 == Enum.ConnectionState.Connected and (p8 and p8.NotificationStream) then
				if p1.lastSeqNumOfNotificationStream ~= p8.NotificationStream then
					getNotificationCount(networking)
				end

				p1.lastSeqNumOfNotificationStream = p8.NotificationStream
			end
		end))
	end
end
function v10.render(_) -- line: 67
end
function v10.willUnmount(p10) -- line: 69
	for _, v in pairs(p10.tokens) do
		v:disconnect()
	end
end

local v11 = RoactRodux.connect(nil, function(p11) -- line: 75
	-- upvalues: ApiFetchUnreadNotificationCount (copy), SetNotificationCount (copy)
	return {
		getNotificationCount = function(p12) -- line: 77
			-- upvalues: p11 (copy), ApiFetchUnreadNotificationCount (copy)
			return p11(ApiFetchUnreadNotificationCount(p12))
		end,
		setNotificationCount = function(...) -- line: 80
			-- upvalues: p11 (copy), SetNotificationCount (copy)
			return p11(SetNotificationCount(...))
		end
	}
end)(v10)

return (RoactServices.connect({
	networking = RoactNetworking
})(v11))
