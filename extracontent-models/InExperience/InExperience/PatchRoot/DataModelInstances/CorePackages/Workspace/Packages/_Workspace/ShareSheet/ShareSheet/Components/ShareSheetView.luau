local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local DialogSize = Foundation.Enums.DialogSize
local Divider = Foundation.Divider
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local FFlagShareSheetDesktopReadiness = require(ShareSheet.Flags.FFlagShareSheetDesktopReadiness)
local FFlagShareSheetOmitsEmptyActions = require(ShareSheet.Flags.FFlagShareSheetOmitsEmptyActions)

local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)
local FIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent = ShareSheetConstants.FIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent
local PeoplePicker = require(ShareSheet.Components.PeoplePicker)
local ShareSheetActionRow = require(script.Parent.ShareSheetActionRow)
local useMeasuredRows = require(script.Parent.useMeasuredRows)
local ShareSheetSocialRow = require(script.Parent.ShareSheetSocialRow)
local ShareSendRow = require(script.Parent.ShareSendRow)
require(ShareSheet.Recipients.Recipient)
require(ShareSheet.Recipients.RecipientSource)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)

local function setDefaultContentScrollingFrameRef(p)
	if p then
		p.AutomaticSize = Enum.AutomaticSize.Y
		p.ScrollBarThickness = 0
	end
end

local function setPeoplePickerContentScrollingFrameRef(p)
	if p then
		p.AutomaticSize = Enum.AutomaticSize.None
		p.ScrollBarThickness = 0
	end
end

local function ShareSheetView(props)
	local v = next(props.selectedConversationIds) ~= nil or props.isSending == true
	local peoplePicker = props.peoplePicker
	local isPeoplePickerDisplayed = props.isPeoplePickerDisplayed
	local v2

	if FFlagShareSheetOmitsEmptyActions then
		v2 = v or not isPeoplePickerDisplayed
	end

	local v3

	if FFlagShareSheetDesktopReadiness then
		v3 = useMeasuredRows()
	end

	local v4

	if FFlagShareSheetDesktopReadiness then
		v4 = v3.isLayoutReady and not (isPeoplePickerDisplayed or v)
	end

	local centerSheetHeight, snapPoints

	if isPeoplePickerDisplayed then
		centerSheetHeight = FIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent / 10000
		snapPoints = { centerSheetHeight }
	end

	local onClose = React.useCallback(function()
		props.onCloseWithReason(ShareSheetTelemetry.CloseReason.UserDismissed)
	end, { props.onCloseWithReason })

	local createElement = React.createElement
	local root = Sheet.Root
	local v5 = {
		centerSheetHeight = centerSheetHeight,
		isOpen = props.isOpen,
		onClose = onClose,
		preferCenterSheet = true,
		size = 0,
		snapPoints = 0
	}
	local size

	if FFlagShareSheetDesktopReadiness then
		size = DialogSize.Large
	end

	v5.size = size
	v5.snapPoints = snapPoints

	local createElement2 = React.createElement
	local header = Sheet.Header
	local v6

	if isPeoplePickerDisplayed then
		v6 = {
			Picker = React.createElement(PeoplePicker.PeoplePickerHeader, peoplePicker.headerProps)
		}
	else
		v6 = {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.shareLabel,
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}
	end

	local children = {
		Header = createElement2(header, {
			hasCloseAffordance = not isPeoplePickerDisplayed
		}, v6),
		Content = 0,
		Actions = 0
	}

	local createElement3 = React.createElement
	local content = Sheet.Content
	local scrollingFrameRef

	if isPeoplePickerDisplayed then
		scrollingFrameRef = setPeoplePickerContentScrollingFrameRef
	else
		scrollingFrameRef = setDefaultContentScrollingFrameRef
	end

	local createElement4 = React.createElement

	local v7 = {
		tag = {
			["col size-full"] = isPeoplePickerDisplayed,
			["col size-full-0 auto-y"] = not isPeoplePickerDisplayed,
			["gap-xlarge"] = not isPeoplePickerDisplayed
		},
		onAbsoluteSizeChanged = 0
	}
	local onAbsoluteSizeChanged

	if FFlagShareSheetDesktopReadiness and not isPeoplePickerDisplayed then
		onAbsoluteSizeChanged = v3.onAbsoluteSizeChanged
	end

	v7.onAbsoluteSizeChanged = onAbsoluteSizeChanged
	local v8

	if isPeoplePickerDisplayed then
		v8 = {
			PeoplePicker = React.createElement(PeoplePicker.PeoplePickerList, peoplePicker.listProps)
		}
	else
		v8 = { SocialRow = 0, RowDivider = 0, ActionRow = 0 }
		local socialRow

		if FFlagShareSheetDesktopReadiness and props.shouldShowSocialRow and not v3.isLayoutReady then
			socialRow = React.createElement(
				View,
				{
					tag = "col gap-small size-full-0 auto-y",
					LayoutOrder = 1,
					testId = "share-sheet-rows-loading"
				},
				{
					Tile = React.createElement(View, { tag = "size-full-1700", LayoutOrder = 1 }),
					Label = React.createElement(Text, {
						tag = "size-full-0 auto-y text-body-small",
						Text = " ",
						LayoutOrder = 2
					})
				}
			)
		elseif props.shouldShowSocialRow then
			local createElement5 = React.createElement
			local v9 = {
				socialRowRecipients = props.socialRowRecipients,
				isLoading = props.isSocialRowLoading,
				onConversationActivated = props.onConversationActivated,
				onMoreActivated = props.onMoreActivated,
				selectedConversationIds = props.selectedConversationIds,
				rowLayout = 0,
				LayoutOrder = 1
			}
			local rowLayout

			if FFlagShareSheetDesktopReadiness then
				rowLayout = v3.layout
			end

			v9.rowLayout = rowLayout
			socialRow = createElement5(ShareSheetSocialRow, v9)
		end

		v8.SocialRow = socialRow
		local rowDivider

		if props.shouldShowSocialRow then
			rowDivider = React.createElement(Divider, {
				LayoutOrder = 2,
				testId = "share-sheet-row-divider"
			})
		end

		v8.RowDivider = rowDivider
		local actionRow

		if FFlagShareSheetDesktopReadiness and v4 then
			actionRow = React.createElement(ShareSheetActionRow, {
				canShare = props.canShareLink,
				context = props.context,
				recipientSource = props.recipientSource,
				telemetryId = props.telemetryId,
				url = props.url,
				rowLayout = v3.layout,
				LayoutOrder = 3
			})
		end

		v8.ActionRow = actionRow
	end

	children.Content = createElement3(content, {
		scrollingFrameRef = scrollingFrameRef,
		isContentFullBleed = not isPeoplePickerDisplayed
	}, { ContentLayout = createElement4(View, v7, v8) })
	local v9

	if FFlagShareSheetDesktopReadiness then
		v9 = v
	else
		v9 = not FFlagShareSheetOmitsEmptyActions or v2
	end

	local actions2

	if v9 then
		local createElement5 = React.createElement
		local actions = Sheet.Actions
		local footer

		if v then
			footer = React.createElement(ShareSendRow, {
				isLoading = props.isSending,
				label = props.sendLabel,
				messagePlaceholder = props.messagePlaceholder,
				onActivated = props.onSendActivated,
				onFocusGained = props.onComposerFocused
			})
		elseif not (FFlagShareSheetDesktopReadiness or isPeoplePickerDisplayed) then
			footer = React.createElement(ShareSheetActionRow, {
				canShare = props.canShareLink,
				context = props.context,
				recipientSource = props.recipientSource,
				telemetryId = props.telemetryId,
				url = props.url,
				rowLayout = nil,
				LayoutOrder = nil
			})
		end

		actions2 = createElement5(actions, nil, { Footer = footer })
	end

	children.Actions = actions2
	return createElement(root, v5, children)
end

return ShareSheetView
