local AppChat = script:FindFirstAncestor("AppChat")

local AppChatNetworking = require(AppChat.Parent.AppChatNetworking)
local Logger = require(AppChat.Logger)

return function(p)
	return function(object)
		object:dispatch(AppChatNetworking.rodux.UpdateTypingStatus.API(p)):catch(function(p2)
			Logger:error(`AppChatNetworking failure in updateTypingStatus, Status: {tostring(p2)}`)
		end)
	end
end
