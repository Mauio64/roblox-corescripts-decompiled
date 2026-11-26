local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger")

return function(p2)
	return function(object)
		object:dispatch(AppChatNetworking.rodux.UpdateTypingStatus.API(p2)):catch(function(p3)
			Logger:error(`AppChatNetworking failure in updateTypingStatus, Status: {tostring(p3)}`)
		end)
	end
end
