local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local chatTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local adCampaignEligibilityTool = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/adCampaignEligibilityTool")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")

local ChatTurnBlock = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatTurnBlock")
local ChatUserMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Chat/ChatUserMessage")

local function ChatMessageItem(props)
	local message = props.message

	if message.kind == "user_message" then
		return React.createElement(ChatUserMessage, {
			message = message,
			LayoutOrder = props.LayoutOrder
		})
	end

	local createElement = React.createElement
	local v6 = {
		turn = message,
		LayoutOrder = props.LayoutOrder,
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
	return createElement(ChatTurnBlock, v6)
end

local function areUserImagesEqual(images, images2): boolean
	local v5 = images or {}
	local v6 = images2 or {}

	if #v5 ~= #v6 then
		return false
	end

	for k, v7 in v5 do
		local v8 = v6[k]

		if v8 == nil or v7.capture ~= v8.capture or v7.uri ~= v8.uri then
			return false
		end
	end

	return true
end

local function areResourceAttachmentsEqual(resourceAttachments, resourceAttachments2): boolean
	local v5 = resourceAttachments or {}
	local v6 = resourceAttachments2 or {}

	if #v5 ~= #v6 then
		return false
	end

	for k, v7 in v5 do
		local v8 = v6[k]

		if
			v8 == nil
			or v7.type ~= v8.type
			or chatTypes.getResourceAttachmentUri(v7) ~= chatTypes.getResourceAttachmentUri(v8)
		then
			return false
		end

		if v7.type == "resource_link" and v8.type == "resource_link" and v7.name ~= v8.name then
			return false
		end
	end

	return true
end

local function hasCampaignCard(message): boolean
	if message.turnState ~= nil and message.turnState.toolCalls ~= nil then
		for k, toolCall in message.turnState.toolCalls do
			if adCampaignEligibilityTool.isCompletedEligibilityToolCall(toolCall) then
				return true
			end
		end
	end

	return false
end

local function arePropsEqual(data, data2)
	local message = data.message
	local message2 = data2.message

	if
		message.id == nil
		or message.id ~= message2.id
		or message.kind ~= message2.kind
		or data.LayoutOrder ~= data2.LayoutOrder
	then
		return false
	end

	if message2.kind == "user_message" then
		return message.text == message2.text
			and areUserImagesEqual(message.images, message2.images)
			and areResourceAttachmentsEqual(message.resourceAttachments, message2.resourceAttachments)
	else
		if data.isPlaytestLoading ~= data2.isPlaytestLoading then
			return false
		end

		if
			FFlagBuildAgentAdCampaignCard
			and (hasCampaignCard(message) or hasCampaignCard(message2))
			and (data.onAgentAdCampaignOfferSelected ~= data2.onAgentAdCampaignOfferSelected or data.getAgentAdCampaignCardState ~= data2.getAgentAdCampaignCardState or data.onAgentAdCampaignActive ~= data2.onAgentAdCampaignActive or data.isPageVisible ~= data2.isPageVisible or data.scrollingFrameRef ~= data2.scrollingFrameRef or data.isAgentAdCampaignCreateDisabled ~= data2.isAgentAdCampaignCreateDisabled)
		then
			return false
		end

		if message.isLatestPublishTurn ~= message2.isLatestPublishTurn then
			return false
		end

		local isDone = message.isDone == true
		local isDone2 = message2.isDone == true
		return isDone and isDone2
	end
end

return React.memo(ChatMessageItem, arePropsEqual)
