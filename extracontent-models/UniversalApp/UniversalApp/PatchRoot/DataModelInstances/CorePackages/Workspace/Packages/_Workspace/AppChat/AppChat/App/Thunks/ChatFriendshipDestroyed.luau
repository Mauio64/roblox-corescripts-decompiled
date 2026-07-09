local Parent = script:FindFirstAncestor("AppChat").Parent
local AppChatNetworking = require(Parent.AppChatNetworking)
local AppCommonLib = require(Parent.AppCommonLib)
local UserLib = require(Parent.UserLib)
local Immutable = AppCommonLib.Immutable
local UpdateUsers = UserLib.Thunks.UpdateUsers
local GetConversationMetadata = AppChatNetworking.rodux.GetConversationMetadata

return function(p1) -- line: 14
	-- upvalues: Immutable (copy), UpdateUsers (copy), GetConversationMetadata (copy)
	return function(p2) -- line: 15
		-- upvalues: p1 (copy), Immutable (copy), UpdateUsers (copy), GetConversationMetadata (copy)
		local v10 = p2:getState().Users[p1]

		if v10 then
			local v11 = Immutable.Set(v10, "isFriend", false)

			p2:dispatch(UpdateUsers({ v11 }))
			p2:dispatch(GetConversationMetadata.API())
		end
	end
end
