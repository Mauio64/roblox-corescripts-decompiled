local list = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/llama").List

local function getNumberOfParticipants(instance)
	return list.count(instance:GetChildren(), function(textSource)
		return textSource:IsA("TextSource")
	end)
end

return getNumberOfParticipants
