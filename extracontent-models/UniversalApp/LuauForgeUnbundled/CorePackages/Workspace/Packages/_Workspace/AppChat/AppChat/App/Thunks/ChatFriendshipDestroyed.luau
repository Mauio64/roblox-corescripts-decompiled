local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppCommonLib")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib")

local immutable = AppCommonLib.Immutable
local updateUsers = UserLib.Thunks.UpdateUsers

local getConversationMetadata = AppChatNetworking.rodux.GetConversationMetadata

return function(p2)
	return function(object)
		local user = object:getState().Users[p2]

		if user then
			object:dispatch(updateUsers({ (immutable.Set(user, "isFriend", false)) }))
			object:dispatch(getConversationMetadata.API())
		end
	end
end
