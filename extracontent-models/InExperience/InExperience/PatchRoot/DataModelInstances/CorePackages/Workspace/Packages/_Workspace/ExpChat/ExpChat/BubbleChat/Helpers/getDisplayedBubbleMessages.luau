local parent = script:FindFirstAncestor("ExpChat").Parent
local llama = require(parent.llama)
local list = llama.List

local isBorderlessBubbleChatMessage = require(script.Parent.isBorderlessBubbleChatMessage)
local getBubbleDurationInMillis = require(script.Parent.getBubbleDurationInMillis)
local getBubbleChatStartTimeMillis = require(script.Parent.getBubbleChatStartTimeMillis)

local function getDisplayedBubbleMessages(list2, p: number, p2: number, p3: number)
	local v = 0

	for i = #list2, 1, -1 do
		if list2[i].isVisibleInBubbleChat and isBorderlessBubbleChatMessage(list2[i]) then
			v = i
			break
		end
	end

	if v ~= #list2 then
		v += 1
	end

	return list.filter(list2, function(p4, p5)
		return v <= p5
			and #list2 - p2 < p5
			and p4.isVisibleInBubbleChat
			and p3 - getBubbleChatStartTimeMillis(p4) < getBubbleDurationInMillis(p4, p)
	end)
end

return getDisplayedBubbleMessages
