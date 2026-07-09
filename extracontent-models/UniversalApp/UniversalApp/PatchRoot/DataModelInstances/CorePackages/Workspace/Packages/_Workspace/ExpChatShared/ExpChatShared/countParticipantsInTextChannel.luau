local Parent = script:FindFirstAncestor("ExpChatShared").Parent
local List = require(Parent.llama).List

local function getNumberOfParticipants(p1) -- line: 5
	-- upvalues: List (copy)
	return List.count(p1:GetChildren(), function(p2) -- line: 6
		return p2:IsA("TextSource")
	end)
end

return getNumberOfParticipants
