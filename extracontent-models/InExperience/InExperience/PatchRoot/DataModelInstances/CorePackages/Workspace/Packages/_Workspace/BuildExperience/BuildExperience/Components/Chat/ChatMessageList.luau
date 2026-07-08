local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)

require(BuildExperience.Chat.chatTypes)

local View = Foundation.View
local ChatMessageItem = require(script.Parent.ChatMessageItem)

local function ChatMessageList(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), View (copy), ChatMessageItem (copy)
	local t2 = {}

	if #t1.messages == 0 and t1.emptyState ~= nil then
		t2.EmptyState = React.createElement(View, {
			LayoutOrder = 0,
			tag = "col align-x-center align-y-center padding-large",
			Size = UDim2.fromScale(1, 1)
		}, t1.emptyState)

		return t2
	end

	for v10, v11 in t1.messages do
		t2[v11.id or `Message{ v10 }`] = React.createElement(ChatMessageItem, {
			message = v11,
			LayoutOrder = v10,
			clockBinding = t1.clockBinding,
			localToolActions = t1.localToolActions,
			onPlaytest = t1.onPlaytest,
			isPlaytestLoading = t1.isPlaytestLoading
		})
	end

	return t2
end

return ChatMessageList
