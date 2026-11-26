local module = require("@luauforge/bundled/ehk")
local module2 = require("@luauforge/bundled/ehA")
local userModel = require("@luauforge/bundled/ciE").Models.UserModel

local fFlagDeprecatePeopleListContextualMenu = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDeprecatePeopleListContextualMenu

local function fn(p2, p3)
	local v5 = p2 and p2.Users[p3] or {}
	return v5.presence == userModel.PresenceType.IN_GAME and v5.lastLocation
end

return function(p2, data)
	return function(object)
		if not fFlagDeprecatePeopleListContextualMenu then
			local state = object:getState()
			local userInGame = data.userInGame or fn

			if data.openJoinable and data.contextualMenuProps and userInGame(state, p2) then
				object:dispatch(module(data.contextualMenuProps))
				return
			end
		end

		object:dispatch(module2(p2, data.profilePeekViewProps))
	end
end
