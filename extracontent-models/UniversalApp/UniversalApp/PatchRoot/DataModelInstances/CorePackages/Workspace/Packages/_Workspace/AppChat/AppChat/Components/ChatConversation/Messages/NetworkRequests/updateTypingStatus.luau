local AppChat = script:FindFirstAncestor("AppChat")
local AppChatNetworking = require(AppChat.Parent.AppChatNetworking)
local Logger = require(AppChat.Logger)

return function(p1) -- line: 6
	-- upvalues: AppChatNetworking (copy), Logger (copy)
	return function(p2) -- line: 7
		-- upvalues: AppChatNetworking (copy), p1 (copy), Logger (copy)
		p2:dispatch(AppChatNetworking.rodux.UpdateTypingStatus.API(p1)):catch(function(p3) -- line: 8
			-- upvalues: Logger (copy)
			Logger:error(`AppChatNetworking failure in updateTypingStatus, Status: { tostring(p3) }`)
		end)
	end
end
