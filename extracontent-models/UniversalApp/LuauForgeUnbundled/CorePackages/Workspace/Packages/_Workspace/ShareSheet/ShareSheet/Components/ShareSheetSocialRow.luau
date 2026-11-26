local array = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/LuauPolyfill").Array
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Localization").Hooks.useLocalization

local skeleton = Foundation.Skeleton
local view = Foundation.View
local iconName = Foundation.Enums.IconName
local radius = Foundation.Enums.Radius

local FFlagShareSheetDesktopReadiness = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetDesktopReadiness")
local Recipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
local ShareSheetConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/ShareSheetConstants")
local ShareSheetRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetRow")
local ShareSheetItemContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetItemContainer")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/getShareSheetRowLayout")

local Players = game:GetService("Players")

local function createSkeletonItems(p2)
	local children = {}
	local v5

	if FFlagShareSheetDesktopReadiness then
		v5 = p2.rowLayout.visibleTileCount
	else
		v5 = ShareSheetConstants.FIntShareSheetNumAvatarSkeletons
	end

	for i = 1, v5 do
		local v6 = if FFlagShareSheetDesktopReadiness then p2.rowLayout.getTileWidth(i) else nil
		local formatted = `Skeleton{i}`
		local createElement = React.createElement
		local v8 = {
			LayoutOrder = i,
			tag = {
				["col align-x-center gap-small auto-y"] = true,
				["size-1700-0"] = not FFlagShareSheetDesktopReadiness
			},
			Size = 0
		}

		local v9 = if FFlagShareSheetDesktopReadiness then UDim2.fromOffset(v6, 0) else nil
		v8.Size = v9

		local createElement2 = React.createElement
		local v11 = {
			LayoutOrder = 1,
			tag = {
				["size-full-1700"] = not FFlagShareSheetDesktopReadiness
			},
			Size = 0,
			testId = "share-sheet-avatar-skeleton-container"
		}
		local v12 = if FFlagShareSheetDesktopReadiness then UDim2.fromOffset(v6, v6) else nil
		v11.Size = v12
		children[formatted] = createElement(view, v8, {
			Avatar = createElement2(view, v11, {
				Skeleton = React.createElement(skeleton, {
					radius = radius.Circle,
					testId = "share-sheet-avatar-skeleton"
				})
			}),
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
		})
	end

	return children
end

local function getRecipientsToShow(props)
	local recipients = props.socialRowRecipients.recipients
	local function isSelected(p2): boolean
		return props.selectedConversationIds[p2.id] == true
	end

	local v5 = props.rowLayout.maxTileCount - 1 - #array.filter(recipients, isSelected)

	return array.filter(recipients, function(p2): boolean
		if props.selectedConversationIds[p2.id] == true then
			return true
		end

		v5 -= 1
		return v5 >= 0
	end)
end

local function ShareSheetRecipientItem(props)
	local id = props.recipient.id
	local v5 = React.useCallback(function()
		props.onConversationActivated(id)
	end, { id, props.onConversationActivated })
	local participantIds = Recipient.getParticipantIds(props.recipient, props.localUserId)
	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			return Recipient.getName(props.recipient, p2)
		end)
	end, { props.recipient })
	local v7 = SignalsReact.useSignalState(v6)

	local createElement = React.createElement
	local v9 = {
		primaryUserId = participantIds[1] or props.localUserId,
		secondUserId = participantIds[2],
		isSelected = props.isSelected,
		label = v7,
		onActivated = v5,
		width = 0,
		LayoutOrder = 0
	}

	local v10 = if FFlagShareSheetDesktopReadiness then props.width else nil
	v9.width = v10
	v9.LayoutOrder = props.LayoutOrder
	return createElement(ShareSheetItemContainer, v9)
end

local function ShareSheetSocialRow(props)
	local userId = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	local v5 = useLocalization({ more = "CommonUI.Features.Label.More" })

	local children = {}
	local v6

	if props.isLoading or props.socialRowRecipients.isLoading then
		local v8 = if FFlagShareSheetDesktopReadiness then props else nil
		children = createSkeletonItems(v8)

		if FFlagShareSheetDesktopReadiness then
			v6 = props.rowLayout.visibleTileCount
		end
	else
		local v7 = if FFlagShareSheetDesktopReadiness then getRecipientsToShow(props) else props.socialRowRecipients.recipients

		for k, v8 in v7 do
			local id = v8.id
			local createElement = React.createElement
			local v10 = {
				recipient = v8,
				isSelected = props.selectedConversationIds[v8.id] == true,
				localUserId = userId,
				onConversationActivated = props.onConversationActivated,
				width = 0,
				LayoutOrder = 0
			}

			local v11 = if FFlagShareSheetDesktopReadiness then props.rowLayout.getTileWidth(k) else nil
			v10.width = v11

			v10.LayoutOrder = k
			children[id] = createElement(ShareSheetRecipientItem, v10)
		end

		if FFlagShareSheetDesktopReadiness then
			v6 = #v7 + 1
		end

		local createElement = React.createElement
		local v9 = {
			icon = iconName.ThreeDotsHorizontal,
			label = v5.more,
			onActivated = props.onMoreActivated,
			width = 0,
			LayoutOrder = 0
		}
		local v10 = if FFlagShareSheetDesktopReadiness then props.rowLayout.getTileWidth(v6) else nil
		v9.width = v10
		v9.LayoutOrder = #v7 + 1
		children.More = createElement(ShareSheetItemContainer, v9)
	end

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.LayoutOrder,
		margin = 0,
		gap = 0,
		isScrollingEnabled = 0
	}
	local v9 = if FFlagShareSheetDesktopReadiness then props.rowLayout.margin else nil
	v8.margin = v9
	local v10 = if FFlagShareSheetDesktopReadiness then props.rowLayout.gap else nil
	v8.gap = v10

	local v11 = if FFlagShareSheetDesktopReadiness then props.rowLayout.isScrollingEnabled(v6) else nil
	v8.isScrollingEnabled = v11
	return createElement(ShareSheetRow, v8, children)
end

return ShareSheetSocialRow
