local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local LocalStorageKey = require(CorePackages.Workspace.Packages.LocalStorage).Enums.LocalStorageKey
local EventNetworking = require(script.Parent.EventNetworking)
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local v6 = LuaSocialLibrariesDeps.SocialLibraries.config({})
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local llama = LuaSocialLibrariesDeps.llama
local ReceivedDisplayName = require(CorePackages.Workspace.Packages.UserLib).Actions.ReceivedDisplayName
local v11 = Roact.Component:extend("DisplayNameEventReceiver")
local t1 = {}

v11.defaultProps = {
	appStorageService = AppStorageService
}

function v11.init(p1) -- line: 21
	-- upvalues: LocalStorageKey (copy), llama (copy)
	p1.tokens = { p1.props.RobloxEventReceiver:observeEvent("DisplayNameNotifications", function(p2) -- line: 25
		-- upvalues: p1 (copy), LocalStorageKey (copy), llama (copy)
		local UserId = p2.UserId
		local NewDisplayName = p2.NewDisplayName

		p1.props.appStorageService:SetItem(LocalStorageKey.DisplayName, NewDisplayName)
		p1.props.appStorageService:Flush()
		p1.props.receivedDisplayName(UserId, NewDisplayName)

		local v23 = p1.props.users[tostring(UserId)]

		if v23 then
			p1.props.userUpdated(llama.Dictionary.join(v23, {
				displayName = NewDisplayName
			}))
		end
	end) }
end
function v11.render(_) -- line: 44
	return nil
end
function v11.willUnmount(p4) -- line: 48
	for _, v in pairs(p4.tokens) do
		v:disconnect()
	end
end

return RoactRodux.connect(function(p5) -- line: 54
	-- upvalues: v6 (copy), t1 (copy)
	return {
		localUserId = p5.LocalUserId,
		users = v6.Dictionary.getDeepValue(p5, "FriendsCarousel.Users.byUserId") or t1
	}
end, function(p6) -- line: 59
	-- upvalues: ReceivedDisplayName (copy), EventNetworking (copy)
	return {
		receivedDisplayName = function(p7, p8) -- line: 61
			-- upvalues: p6 (copy), ReceivedDisplayName (copy)
			p6(ReceivedDisplayName(p7, p8))
		end,
		userUpdated = function(p9) -- line: 64
			-- upvalues: p6 (copy), EventNetworking (copy)
			return p6(EventNetworking.RoduxUsers.Actions.UserUpdated(p9))
		end
	}
end)(v11)
