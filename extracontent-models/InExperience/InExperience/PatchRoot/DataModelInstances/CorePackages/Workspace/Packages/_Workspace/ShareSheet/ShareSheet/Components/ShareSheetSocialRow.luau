local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Skeleton = Foundation.Skeleton
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local Radius = Foundation.Enums.Radius

local SharedFlags = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort
local FFlagShareSheetPeoplePickerEnabled = require(ShareSheet.Flags.FFlagShareSheetPeoplePickerEnabled)
local Recipient = require(ShareSheet.Recipients.Recipient)
local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)
local ShareSheetRow = require(script.Parent.ShareSheetRow)
local ShareSheetItemContainer = require(script.Parent.ShareSheetItemContainer)
local ConversationUtils

if FFlagShareSheetPeoplePickerEnabled then
	ConversationUtils = require(ShareSheet.Utils.ConversationUtils)
else
	ConversationUtils = nil
end

local Players = game:GetService("Players")

require(ShareSheet.Types)

local function getOtherParticipants(participants, localUserId: string) -- 1 equivalent call inferred from this helper
	local otherParticipants = {}

	for _, item in participants do
		if item ~= localUserId then
			table.insert(otherParticipants, item)
		end
	end

	return otherParticipants
end

local function createSkeletonItems()
	local children = {}

	for i = 1, ShareSheetConstants.FIntShareSheetNumAvatarSkeletons do
		children[`Skeleton{i}`] = React.createElement(
			View,
			{ LayoutOrder = i, tag = "col align-x-center gap-small size-1700-0 auto-y" },
			{
				Avatar = React.createElement(
					View,
					{
						LayoutOrder = 1,
						tag = "size-full-1700",
						testId = "share-sheet-avatar-skeleton-container"
					},
					{
						Skeleton = React.createElement(Skeleton, {
							radius = Radius.Circle,
							testId = "share-sheet-avatar-skeleton"
						})
					}
				),
				Text = React.createElement(
					View,
					{
						LayoutOrder = 2,
						tag = "size-full-400",
						testId = "share-sheet-text-skeleton-container"
					},
					{
						Skeleton = React.createElement(Skeleton, {
							radius = Radius.Medium,
							testId = "share-sheet-text-skeleton"
						})
					}
				)
			}
		)
	end

	return children
end

local function ShareSheetConversationItem(props)
	local conversation = props.conversation
	local id = conversation.id
	local onActivated = React.useCallback(function()
		props.onConversationActivated(id)
	end, { id, props.onConversationActivated })
	local primaryUserId, secondUserId, label

	if FFlagShareSheetPeoplePickerEnabled then
		primaryUserId, secondUserId = ConversationUtils.getParticipantUserIds(conversation, props.localUserId)
		label = ConversationUtils.getDisplayName(conversation)
	else
		local otherParticipants = getOtherParticipants(conversation.participants or {}, props.localUserId) -- inferred equivalent call
		primaryUserId = otherParticipants[1] or props.localUserId

		if #otherParticipants >= 2 then
			secondUserId = otherParticipants[2]
		end

		label = conversation.titleForViewer

		if not label or label == "" then
			label = conversation.title or ""
		end
	end

	return React.createElement(ShareSheetItemContainer, {
		primaryUserId = primaryUserId,
		secondUserId = secondUserId,
		isSelected = props.isSelected,
		label = label,
		onActivated = onActivated,
		LayoutOrder = props.LayoutOrder
	})
end

local function ShareSheetRecipientItem(props)
	local id = props.recipient.id
	local onActivated = React.useCallback(function()
		props.onConversationActivated(id)
	end, { id, props.onConversationActivated })
	local participantIds = Recipient.getParticipantIds(props.recipient, props.localUserId)
	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			return Recipient.getName(props.recipient, p)
		end)
	end, { props.recipient })
	local label = SignalsReact.useSignalState(v)

	return React.createElement(ShareSheetItemContainer, {
		primaryUserId = participantIds[1] or props.localUserId,
		secondUserId = participantIds[2],
		isSelected = props.isSelected,
		label = label,
		onActivated = onActivated,
		LayoutOrder = props.LayoutOrder
	})
end

local function ShareSheetSocialRow(props)
	local userId = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	local v

	if FFlagShareSheetPeoplePickerEnabled then
		v = useLocalization({ more = "CommonUI.Features.Label.More" })
	end

	local children = {}
	local v2

	if FFlagShareSheetFriendsSort then
		v2 = props.socialRowRecipients.isLoading
	else
		v2 = props.conversationEligibility.isLoading
	end

	if props.isLoading or v2 then
		children = createSkeletonItems()
	else
		local v3

		if FFlagShareSheetFriendsSort then
			local recipients = props.socialRowRecipients.recipients

			for k, recipient in recipients do
				children[recipient.id] = React.createElement(ShareSheetRecipientItem, {
					recipient = recipient,
					isSelected = props.selectedConversationIds[recipient.id] == true,
					localUserId = userId,
					onConversationActivated = props.onConversationActivated,
					LayoutOrder = k
				})
			end

			v3 = #recipients
		else
			local eligibleConversations = props.conversationEligibility.eligibleConversations

			for k, eligibleConversation in eligibleConversations do
				local id = eligibleConversation.id

				children[id] = React.createElement(ShareSheetConversationItem, {
					conversation = eligibleConversation,
					isSelected = props.selectedConversationIds[id] == true,
					localUserId = userId,
					onConversationActivated = props.onConversationActivated,
					LayoutOrder = k
				})
			end

			v3 = #eligibleConversations
		end

		if FFlagShareSheetPeoplePickerEnabled then
			children.More = React.createElement(ShareSheetItemContainer, {
				icon = IconName.ThreeDotsHorizontal,
				label = v.more,
				onActivated = props.onMoreActivated,
				LayoutOrder = v3 + 1
			})
		end
	end

	return React.createElement(ShareSheetRow, { LayoutOrder = props.LayoutOrder }, children)
end

return ShareSheetSocialRow
