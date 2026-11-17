local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
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

local FFlagShareSheetDesktopReadiness = require(ShareSheet.Flags.FFlagShareSheetDesktopReadiness)
local Recipient = require(ShareSheet.Recipients.Recipient)
local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)
local ShareSheetRow = require(script.Parent.ShareSheetRow)
local ShareSheetItemContainer = require(script.Parent.ShareSheetItemContainer)
require(script.Parent.getShareSheetRowLayout)

local Players = game:GetService("Players")

local function createSkeletonItems(p)
	local children = {}
	local v

	if FFlagShareSheetDesktopReadiness then
		v = p.rowLayout.visibleTileCount
	else
		v = ShareSheetConstants.FIntShareSheetNumAvatarSkeletons
	end

	for i = 1, v do
		local v2

		if FFlagShareSheetDesktopReadiness then
			v2 = p.rowLayout.getTileWidth(i)
		end

		local formatted = `Skeleton{i}`
		local createElement = React.createElement
		local v3 = {
			LayoutOrder = i,
			tag = {
				["col align-x-center gap-small auto-y"] = true,
				["size-1700-0"] = not FFlagShareSheetDesktopReadiness
			},
			Size = 0
		}
		local size

		if FFlagShareSheetDesktopReadiness then
			size = UDim2.fromOffset(v2, 0)
		end

		v3.Size = size

		local createElement2 = React.createElement
		local v4 = {
			LayoutOrder = 1,
			tag = {
				["size-full-1700"] = not FFlagShareSheetDesktopReadiness
			},
			Size = 0,
			testId = "share-sheet-avatar-skeleton-container"
		}
		local size2

		if FFlagShareSheetDesktopReadiness then
			size2 = UDim2.fromOffset(v2, v2)
		end

		v4.Size = size2
		children[formatted] = createElement(View, v3, {
			Avatar = createElement2(View, v4, {
				Skeleton = React.createElement(Skeleton, {
					radius = Radius.Circle,
					testId = "share-sheet-avatar-skeleton"
				})
			}),
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
		})
	end

	return children
end

local function getRecipientsToShow(props)
	local recipients = props.socialRowRecipients.recipients
	local function isSelected(p): boolean -- 1 equivalent call inferred from this helper
		return props.selectedConversationIds[p.id] == true
	end

	local v = props.rowLayout.maxTileCount - 1 - #Array.filter(recipients, isSelected)

	return Array.filter(recipients, function(p): boolean
		if isSelected(p) then -- inferred equivalent call
			return true
		end

		v -= 1
		return v >= 0
	end)
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

	local createElement = React.createElement
	local v2 = {
		primaryUserId = participantIds[1] or props.localUserId,
		secondUserId = participantIds[2],
		isSelected = props.isSelected,
		label = label,
		onActivated = onActivated,
		width = 0,
		LayoutOrder = 0
	}
	local width

	if FFlagShareSheetDesktopReadiness then
		width = props.width
	end

	v2.width = width
	v2.LayoutOrder = props.LayoutOrder
	return createElement(ShareSheetItemContainer, v2)
end

local function ShareSheetSocialRow(props)
	local userId = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)
	local v = useLocalization({ more = "CommonUI.Features.Label.More" })

	local children = {}
	local v2

	if props.isLoading or props.socialRowRecipients.isLoading then
		local v3

		if FFlagShareSheetDesktopReadiness then
			v3 = props
		end

		children = createSkeletonItems(v3)

		if FFlagShareSheetDesktopReadiness then
			v2 = props.rowLayout.visibleTileCount
		end
	else
		local v3

		if FFlagShareSheetDesktopReadiness then
			v3 = getRecipientsToShow(props)
		else
			v3 = props.socialRowRecipients.recipients
		end

		for k, recipient in v3 do
			local id = recipient.id
			local createElement = React.createElement
			local v4 = {
				recipient = recipient,
				isSelected = props.selectedConversationIds[recipient.id] == true,
				localUserId = userId,
				onConversationActivated = props.onConversationActivated,
				width = 0,
				LayoutOrder = 0
			}
			local width

			if FFlagShareSheetDesktopReadiness then
				width = props.rowLayout.getTileWidth(k)
			end

			v4.width = width

			v4.LayoutOrder = k
			children[id] = createElement(ShareSheetRecipientItem, v4)
		end

		if FFlagShareSheetDesktopReadiness then
			v2 = #v3 + 1
		end

		local createElement = React.createElement
		local v4 = {
			icon = IconName.ThreeDotsHorizontal,
			label = v.more,
			onActivated = props.onMoreActivated,
			width = 0,
			LayoutOrder = 0
		}
		local width

		if FFlagShareSheetDesktopReadiness then
			width = props.rowLayout.getTileWidth(v2)
		end

		v4.width = width
		v4.LayoutOrder = #v3 + 1
		children.More = createElement(ShareSheetItemContainer, v4)
	end

	local createElement = React.createElement
	local v3 = { LayoutOrder = props.LayoutOrder, margin = 0, gap = 0, isScrollingEnabled = 0 }
	local margin

	if FFlagShareSheetDesktopReadiness then
		margin = props.rowLayout.margin
	end

	v3.margin = margin
	local gap

	if FFlagShareSheetDesktopReadiness then
		gap = props.rowLayout.gap
	end

	v3.gap = gap
	local isScrollingEnabled

	if FFlagShareSheetDesktopReadiness then
		isScrollingEnabled = props.rowLayout.isScrollingEnabled(v2)
	end

	v3.isScrollingEnabled = isScrollingEnabled
	return createElement(ShareSheetRow, v3, children)
end

return ShareSheetSocialRow
