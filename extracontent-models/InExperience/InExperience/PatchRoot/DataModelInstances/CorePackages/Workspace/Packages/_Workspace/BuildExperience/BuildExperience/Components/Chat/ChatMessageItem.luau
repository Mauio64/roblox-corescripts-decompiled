local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local chatTypes = require(BuildExperience.Chat.chatTypes)
local adCampaignEligibilityTool = require(BuildExperience.Chat.adCampaignEligibilityTool)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)

local ChatTurnBlock = require(script.Parent.ChatTurnBlock)
local ChatUserMessage = require(script.Parent.ChatUserMessage)

local function ChatMessageItem(props)
	local message = props.message

	if message.kind == "user_message" then
		return React.createElement(ChatUserMessage, {
			message = message,
			LayoutOrder = props.LayoutOrder
		})
	end

	local createElement = React.createElement
	local v = {
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
	return createElement(ChatTurnBlock, v)
end

local function areUserImagesEqual(images, images2): boolean
	local v = images or {}
	local v2 = images2 or {}

	if #v ~= #v2 then
		return false
	end

	for k, v3 in v do
		local v4 = v2[k]

		if v4 == nil or v3.capture ~= v4.capture or v3.uri ~= v4.uri then
			return false
		end
	end

	return true
end

local function areResourceAttachmentsEqual(resourceAttachments, resourceAttachments2): boolean
	local v = resourceAttachments or {}
	local v2 = resourceAttachments2 or {}

	if #v ~= #v2 then
		return false
	end

	for k, v3 in v do
		local v4 = v2[k]

		if
			v4 == nil
			or v3.type ~= v4.type
			or chatTypes.getResourceAttachmentUri(v3) ~= chatTypes.getResourceAttachmentUri(v4)
		then
			return false
		end

		if v3.type == "resource_link" and v4.type == "resource_link" and v3.name ~= v4.name then
			return false
		end
	end

	return true
end

local function hasCampaignCard(message): boolean
	if message.turnState ~= nil and message.turnState.toolCalls ~= nil then
		for _, toolCall in message.turnState.toolCalls do
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
