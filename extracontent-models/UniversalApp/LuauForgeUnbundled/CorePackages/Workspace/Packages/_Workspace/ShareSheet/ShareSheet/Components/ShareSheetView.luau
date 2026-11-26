local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local dialogSize = Foundation.Enums.DialogSize
local divider = Foundation.Divider
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local FFlagShareSheetDesktopReadiness = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetDesktopReadiness")
local FFlagShareSheetOmitsEmptyActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetOmitsEmptyActions")

local fIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/ShareSheetConstants").FIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker")
local ShareSheetActionRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetActionRow")
local useMeasuredRows = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/useMeasuredRows")
local ShareSheetSocialRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetSocialRow")
local ShareSendRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSendRow")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")
local ShareSheetTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/telemetry/ShareSheetTelemetry")

local function setDefaultContentScrollingFrameRef(p2)
	if p2 then
		p2.AutomaticSize = Enum.AutomaticSize.Y
		p2.ScrollBarThickness = 0
	end
end

local function setPeoplePickerContentScrollingFrameRef(p2)
	if p2 then
		p2.AutomaticSize = Enum.AutomaticSize.None
		p2.ScrollBarThickness = 0
	end
end

local function ShareSheetView(props)
	local v5 = next(props.selectedConversationIds) ~= nil or props.isSending == true
	local peoplePicker = props.peoplePicker
	local isPeoplePickerDisplayed = props.isPeoplePickerDisplayed
	local v6 = if FFlagShareSheetOmitsEmptyActions then v5 or not isPeoplePickerDisplayed else nil
	local v7 = if FFlagShareSheetDesktopReadiness then useMeasuredRows() else nil

	local v8 = if FFlagShareSheetDesktopReadiness then v7.isLayoutReady and not (isPeoplePickerDisplayed or v5) else nil
	local v9, v10

	if isPeoplePickerDisplayed then
		v9 = fIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent / 10000
		v10 = { v9 }
	end

	local v11 = React.useCallback(function()
		props.onCloseWithReason(ShareSheetTelemetry.CloseReason.UserDismissed)
	end, { props.onCloseWithReason })

	local createElement = React.createElement
	local root = sheet.Root
	local v12 = {
		centerSheetHeight = v9,
		isOpen = props.isOpen,
		onClose = v11,
		preferCenterSheet = true,
		size = 0,
		snapPoints = 0
	}

	local v13 = if FFlagShareSheetDesktopReadiness then dialogSize.Large else nil
	v12.size = v13
	v12.snapPoints = v10

	local createElement2 = React.createElement
	local header = sheet.Header
	local v15

	if isPeoplePickerDisplayed then
		v15 = {
			Picker = React.createElement(module5.PeoplePickerHeader, peoplePicker.headerProps)
		}
	else
		v15 = {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.shareLabel,
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}
	end

	local children = {
		Header = createElement2(header, {
			hasCloseAffordance = not isPeoplePickerDisplayed
		}, v15),
		Content = 0,
		Actions = 0
	}

	local createElement3 = React.createElement
	local content = sheet.Content

	local createElement4 = React.createElement

	local v21 = if FFlagShareSheetDesktopReadiness and not isPeoplePickerDisplayed then v7.onAbsoluteSizeChanged else nil
	local v22

	if isPeoplePickerDisplayed then
		v22 = {
			PeoplePicker = React.createElement(module5.PeoplePickerList, peoplePicker.listProps)
		}
	else
		v22 = { SocialRow = 0, RowDivider = 0, ActionRow = 0 }
		local v23

		if FFlagShareSheetDesktopReadiness and props.shouldShowSocialRow and not v7.isLayoutReady then
			v23 = React.createElement(
				view,
				{
					tag = "col gap-small size-full-0 auto-y",
					LayoutOrder = 1,
					testId = "share-sheet-rows-loading"
				},
				{
					Tile = React.createElement(view, {
						tag = "size-full-1700",
						LayoutOrder = 1
					}),
					Label = React.createElement(text, {
						tag = "size-full-0 auto-y text-body-small",
						Text = " ",
						LayoutOrder = 2
					})
				}
			)
		elseif props.shouldShowSocialRow then
			local createElement5 = React.createElement
			local v25 = {
				socialRowRecipients = props.socialRowRecipients,
				isLoading = props.isSocialRowLoading,
				onConversationActivated = props.onConversationActivated,
				onMoreActivated = props.onMoreActivated,
				selectedConversationIds = props.selectedConversationIds,
				rowLayout = 0,
				LayoutOrder = 1
			}

			local v26 = if FFlagShareSheetDesktopReadiness then v7.layout else nil
			v25.rowLayout = v26
			v23 = createElement5(ShareSheetSocialRow, v25)
		end

		v22.SocialRow = v23

		local v24 = if props.shouldShowSocialRow then React.createElement(divider, {
			LayoutOrder = 2,
			testId = "share-sheet-row-divider"
		}) else nil
		v22.RowDivider = v24

		local v25 = if FFlagShareSheetDesktopReadiness and v8 then React.createElement(ShareSheetActionRow, {
			canShare = props.canShareLink,
			context = props.context,
			recipientSource = props.recipientSource,
			telemetryId = props.telemetryId,
			url = props.url,
			rowLayout = v7.layout,
			LayoutOrder = 3
		}) else nil
		v22.ActionRow = v25
	end

	children.Content = createElement3(content, {
		scrollingFrameRef = if isPeoplePickerDisplayed then setPeoplePickerContentScrollingFrameRef else setDefaultContentScrollingFrameRef,
		isContentFullBleed = not isPeoplePickerDisplayed
	}, {
		ContentLayout = createElement4(view, {
			tag = {
				["col size-full"] = isPeoplePickerDisplayed,
				["col size-full-0 auto-y"] = not isPeoplePickerDisplayed,
				["gap-xlarge"] = not isPeoplePickerDisplayed
			},
			onAbsoluteSizeChanged = v21
		}, v22)
	})
	local v23 = if FFlagShareSheetDesktopReadiness then v5 else not FFlagShareSheetOmitsEmptyActions or v6
	local v24

	if v23 then
		local createElement5 = React.createElement
		local actions = sheet.Actions
		local v27

		if v5 then
			v27 = React.createElement(ShareSendRow, {
				isLoading = props.isSending,
				label = props.sendLabel,
				messagePlaceholder = props.messagePlaceholder,
				onActivated = props.onSendActivated,
				onFocusGained = props.onComposerFocused
			})
		elseif not (FFlagShareSheetDesktopReadiness or isPeoplePickerDisplayed) then
			v27 = React.createElement(ShareSheetActionRow, {
				canShare = props.canShareLink,
				context = props.context,
				recipientSource = props.recipientSource,
				telemetryId = props.telemetryId,
				url = props.url,
				rowLayout = nil,
				LayoutOrder = nil
			})
		end

		v24 = createElement5(actions, nil, { Footer = v27 })
	end

	children.Actions = v24
	return createElement(root, v12, children)
end

return ShareSheetView
