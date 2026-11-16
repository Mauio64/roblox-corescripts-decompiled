local parent = script:FindFirstAncestor("ExpChatShared").Parent
local llama = require(parent.llama)
local list = llama.List

local function getNumberOfParticipants(instance)
	return list.count(instance:GetChildren(), function(textSource)
		return textSource:IsA("TextSource")
	end)
end

return getNumberOfParticipants
