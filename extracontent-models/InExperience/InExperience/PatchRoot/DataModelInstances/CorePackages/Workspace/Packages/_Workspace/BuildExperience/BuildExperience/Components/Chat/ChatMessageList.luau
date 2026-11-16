local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local chatConstants = require(BuildExperience.Chat.chatConstants)
require(BuildExperience.Chat.chatTypes)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)

local View = Foundation.View

local ChatHistoryLoadingState = require(script.Parent.ChatHistoryLoadingState)
local ChatMessageItem = require(script.Parent.ChatMessageItem)

local function ChatMessageList(props)
	local children = {}

	if #props.messages == 0 then
		local v = props.emptyState

		if props.isHistoryLoading then
			v = React.createElement(ChatHistoryLoadingState)
		end

		if v ~= nil then
			children.EmptyState = React.createElement(
				View,
				{
					LayoutOrder = 0,
					Size = UDim2.fromScale(1, 1),
					tag = "col align-x-center align-y-center padding-large"
				},
				v
			)
		end

		return children
	end

	for k, message in props.messages do
		local id = message.id or `Message{k}`
		local createElement = React.createElement
		local v = {
			message = message,
			LayoutOrder = k * chatConstants.MESSAGE_LAYOUT_ORDER_STRIDE,
			clockBinding = props.clockBinding,
			localToolActions = props.localToolActions,
			onPlaytest = props.onPlaytest,
			onPublish = props.onPublish,
			isPlaytestLoading = props.isPlaytestLoading,
			onAgentAdCampaignOfferSelected = 0,
			isPageVisible = 0,
			scrollingFrameRef = 0,
			isAgentAdCampaignCreateDisabled = 0,
			getAgentAdCampaignCardState = 0,
			onAgentAdCampaignActive = 0
		}
		local onAgentAdCampaignOfferSelected

		if FFlagBuildAgentAdCampaignCard then
			onAgentAdCampaignOfferSelected = props.onAgentAdCampaignOfferSelected
		end

		v.onAgentAdCampaignOfferSelected = onAgentAdCampaignOfferSelected

		v.isPageVisible = props.isPageVisible
		v.scrollingFrameRef = props.scrollingFrameRef
		v.isAgentAdCampaignCreateDisabled = props.isAgentAdCampaignCreateDisabled
		local getAgentAdCampaignCardState

		if FFlagBuildAgentAdCampaignCard then
			getAgentAdCampaignCardState = props.getAgentAdCampaignCardState
		end

		v.getAgentAdCampaignCardState = getAgentAdCampaignCardState
		local onAgentAdCampaignActive

		if FFlagBuildAgentAdCampaignCard then
			onAgentAdCampaignActive = props.onAgentAdCampaignActive
		end

		v.onAgentAdCampaignActive = onAgentAdCampaignActive
		children[id] = createElement(ChatMessageItem, v)
	end

	return children
end

return ChatMessageList
