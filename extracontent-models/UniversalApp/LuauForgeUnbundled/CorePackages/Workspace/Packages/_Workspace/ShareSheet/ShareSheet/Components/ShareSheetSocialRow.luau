local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Localization").Hooks.useLocalization

local skeleton = Foundation.Skeleton
local view = Foundation.View
local iconName = Foundation.Enums.IconName
local radius = Foundation.Enums.Radius

local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SharedFlags").FFlagShareSheetFriendsSort
local FFlagShareSheetPeoplePickerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetPeoplePickerEnabled")
local Recipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
local ShareSheetConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/ShareSheetConstants")
local ShareSheetRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetRow")
local ShareSheetItemContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetItemContainer")

local v5 = if FFlagShareSheetPeoplePickerEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Utils/ConversationUtils") else nil

local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")

local function getOtherParticipants(items, p2)
	local otherParticipants = {}

	for k, item in items do
		if item ~= p2 then
			table.insert(otherParticipants, item)
		end
	end

	return otherParticipants
end

local function createSkeletonItems()
	local children = {}

	for i = 1, ShareSheetConstants.FIntShareSheetNumAvatarSkeletons do
		children[`Skeleton{i}`] = React.createElement(
			view,
			{ LayoutOrder = i, tag = "col align-x-center gap-small size-1700-0 auto-y" },
			{
				Avatar = React.createElement(
					view,
					{
						LayoutOrder = 1,
						tag = "size-full-1700",
						testId = "share-sheet-avatar-skeleton-container"
					},
					{
						Skeleton = React.createElement(skeleton, {
							radius = radius.Circle,
							testId = "share-sheet-avatar-skeleton"
						})
					}
				),
				Text = React.createElement(
					view,
					{
						LayoutOrder = 2,
						tag = "size-full-400",
						testId = "share-sheet-text-skeleton-container"
					},
					{
						Skeleton = React.createElement(skeleton, {
							radius = radius.Medium,
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
	local v6 = React.useCallback(function()
		props.onConversationActivated(id)
	end, { id, props.onConversationActivated })
	local v7, v8, v9

	if FFlagShareSheetPeoplePickerEnabled then
		v7, v8 = v5.getParticipantUserIds(conversation, props.localUserId)
		v9 = v5.getDisplayName(conversation)
	else
		local participants = conversation.participants or {}
		local localUserId = props.localUserId
		local participants2 = {}

		for k, participant in participants do
			if participant ~= localUserId then
				table.insert(participants2, participant)
			end
		end

		v7 = participants2[1] or props.localUserId

		if #participants2 >= 2 then
			v8 = participants2[2]
		end

		v9 = conversation.titleForViewer

		if not v9 or v9 == "" then
			v9 = conversation.title or ""
		end
	end

	return React.createElement(ShareSheetItemContainer, {
		primaryUserId = v7,
		secondUserId = v8,
		isSelected = props.isSelected,
		label = v9,
		onActivated = v6,
		LayoutOrder = props.LayoutOrder
	})
end

local function ShareSheetRecipientItem(props)
	local id = props.recipient.id
	local v6 = React.useCallback(function()
		props.onConversationActivated(id)
	end, { id, props.onConversationActivated })
	local participantIds = Recipient.getParticipantIds(props.recipient, props.localUserId)
	local v7 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return Recipient.getName(props.recipient, p2)
		end)
	end, { props.recipient })
	local v8 = SignalsReact.useSignalState(v7)

	return React.createElement(ShareSheetItemContainer, {
		primaryUserId = participantIds[1] or props.localUserId,
		secondUserId = participantIds[2],
		isSelected = props.isSelected,
		label = v8,
		onActivated = v6,
		LayoutOrder = props.LayoutOrder
	})
end

local function ShareSheetSocialRow(props)
	local userId = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	local v6

	if FFlagShareSheetPeoplePickerEnabled then
		v6 = useLocalization({ more = "CommonUI.Features.Label.More" })
	end

	local children = {}
	local v7

	if fFlagShareSheetFriendsSort then
		v7 = props.socialRowRecipients.isLoading
	else
		v7 = props.conversationEligibility.isLoading
	end

	if props.isLoading or v7 then
		children = createSkeletonItems()
	else
		local v8

		if fFlagShareSheetFriendsSort then
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

			v8 = #recipients
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

			v8 = #eligibleConversations
		end

		if FFlagShareSheetPeoplePickerEnabled then
			children.More = React.createElement(ShareSheetItemContainer, {
				icon = iconName.ThreeDotsHorizontal,
				label = v6.more,
				onActivated = props.onMoreActivated,
				LayoutOrder = v8 + 1
			})
		end
	end

	return React.createElement(ShareSheetRow, { LayoutOrder = props.LayoutOrder }, children)
end

return ShareSheetSocialRow
