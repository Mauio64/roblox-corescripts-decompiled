local parent = script:FindFirstAncestor("AppChat").Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local AppCommonLib = require(parent.AppCommonLib)
local UserLib = require(parent.UserLib)

local Immutable = AppCommonLib.Immutable
local UpdateUsers = UserLib.Thunks.UpdateUsers

local getConversationMetadata = AppChatNetworking.rodux.GetConversationMetadata

return function(p)
	return function(object)
		local user = object:getState().Users[p]

		if user then
			object:dispatch(UpdateUsers({ (Immutable.Set(user, "isFriend", false)) }))
			object:dispatch(getConversationMetadata.API())
		end
	end
end
