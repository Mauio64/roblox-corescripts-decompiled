local module = require("@luauforge/bundled/ecR")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")

local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module3 = require("@luauforge/bundled/eda")
local module4 = require("@luauforge/bundled/fBc")
local module5 = require("@luauforge/bundled/fBe")

local module6 = require("@luauforge/bundled/hYB")

local extended = module.Component:extend("BadgeEventReceiver")

function extended:init()
	local setNotificationCount = self.props.setNotificationCount
	local getNotificationCount = self.props.getNotificationCount
	local robloxEventReceiver = self.props.RobloxEventReceiver
	local networking = self.props.networking

	if module6() then
		self.lastSeqNumOfNotificationStream = nil
	end

	self.tokens = {
		robloxEventReceiver:observeEvent("UpdateNotificationBadge", function(p2, p3)
			if p3 == "NotificationIcon" then
				setNotificationCount((tonumber(p2.badgeString)))
			end
		end),
		robloxEventReceiver:observeEvent("NotificationStream", function(p2, p3)
			if p3 == "NotificationsRead" then
				setNotificationCount(0)
			else
				getNotificationCount(networking)
			end

			if module6() and p2 and p2.SequenceNumber then
				self.lastSeqNumOfNotificationStream = p2.SequenceNumber
			end
		end)
	}

	if module6() then
		table.insert(self.tokens, robloxEventReceiver:observeEvent("signalR", function(p2, p3, p4)
			if p2 == Enum.ConnectionState.Connected and p4 and p4.NotificationStream then
				if self.lastSeqNumOfNotificationStream ~= p4.NotificationStream then
					getNotificationCount(networking)
				end

				self.lastSeqNumOfNotificationStream = p4.NotificationStream
			end
		end))
	end
end

function extended.render(p2) end

function extended.willUnmount(p2)
	for k, token in pairs(p2.tokens) do
		token:disconnect()
	end
end

local v5 = useSheetNavigation.connect(nil, function(callback)
	return {
		getNotificationCount = function(p2)
			return callback(module4(p2))
		end,
		setNotificationCount = function(...)
			return callback(module5(...))
		end
	}
end)(extended)

return (roactServices.connect({ networking = module3 })(v5))
