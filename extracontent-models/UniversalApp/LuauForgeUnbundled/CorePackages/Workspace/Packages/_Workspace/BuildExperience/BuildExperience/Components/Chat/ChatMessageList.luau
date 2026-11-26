local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")

local view = Foundation.View

local ChatHistoryLoadingState = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatHistoryLoadingState")
local ChatMessageItem = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatMessageItem")

local function ChatMessageList(props)
	local children = {}

	if #props.messages == 0 then
		local v5 = props.emptyState

		if props.isHistoryLoading then
			v5 = React.createElement(ChatHistoryLoadingState)
		end

		if v5 ~= nil then
			children.EmptyState = React.createElement(
				view,
				{
					LayoutOrder = 0,
					Size = UDim2.fromScale(1, 1),
					tag = "col align-x-center align-y-center padding-large"
				},
				v5
			)
		end

		return children
	end

	for k, message in props.messages do
		local id = message.id or `Message{k}`
		local createElement = React.createElement
		local v6 = {
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

		local v7 = if FFlagBuildAgentAdCampaignCard then props.onAgentAdCampaignOfferSelected else nil
		v6.onAgentAdCampaignOfferSelected = v7

		v6.isPageVisible = props.isPageVisible
		v6.scrollingFrameRef = props.scrollingFrameRef
		v6.isAgentAdCampaignCreateDisabled = props.isAgentAdCampaignCreateDisabled

		local v8 = if FFlagBuildAgentAdCampaignCard then props.getAgentAdCampaignCardState else nil
		v6.getAgentAdCampaignCardState = v8

		local v9 = if FFlagBuildAgentAdCampaignCard then props.onAgentAdCampaignActive else nil
		v6.onAgentAdCampaignActive = v9
		children[id] = createElement(ChatMessageItem, v6)
	end

	return children
end

return ChatMessageList
