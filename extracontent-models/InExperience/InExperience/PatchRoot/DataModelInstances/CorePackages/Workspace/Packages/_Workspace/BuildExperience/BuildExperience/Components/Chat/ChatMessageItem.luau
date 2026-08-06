local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)

require(BuildExperience.Chat.chatTypes)

local ChatTurnBlock = require(script.Parent.ChatTurnBlock)
local ChatUserMessage = require(script.Parent.ChatUserMessage)

local function ChatMessageItem(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), ChatUserMessage (copy), ChatTurnBlock (copy)
	local message = t1.message

	if message.kind == "user_message" then
		return React.createElement(ChatUserMessage, {
			message = message,
			LayoutOrder = t1.LayoutOrder
		})
	end

	return React.createElement(ChatTurnBlock, {
		turn = message,
		LayoutOrder = t1.LayoutOrder,
		clockBinding = t1.clockBinding,
		localToolActions = t1.localToolActions,
		onPlaytest = t1.onPlaytest,
		isPlaytestLoading = t1.isPlaytestLoading
	})
end
local function arePropsEqual(t2: {[any]: any}, t3: {[any]: any}) -- line: 43
	local message = t2.message
	local message2 = t3.message

	if message.id == nil or message.id ~= message2.id then
		return false
	end

	if message.kind ~= message2.kind then
		return false
	end

	if t2.LayoutOrder ~= t3.LayoutOrder then
		return false
	end

	if message2.kind == "user_message" then
		return message.text == message2.text
	end

	if t2.isPlaytestLoading ~= t3.isPlaytestLoading then
		return false
	end

	local v14 = message.isDone == true
	local v15 = message2.isDone == true

	return v14 and v15
end

return React.memo(ChatMessageItem, arePropsEqual)
