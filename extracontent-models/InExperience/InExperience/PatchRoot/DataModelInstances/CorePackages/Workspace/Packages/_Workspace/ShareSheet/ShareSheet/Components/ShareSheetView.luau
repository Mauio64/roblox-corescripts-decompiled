local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local DialogSize = Foundation.Enums.DialogSize
local Divider = Foundation.Divider
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View
local useOverlay = Foundation.Hooks.useOverlay
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local FFlagShareSheetDesktopReadiness = require(ShareSheet.Flags.FFlagShareSheetDesktopReadiness)
local SharedFlags = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort
local FFlagShareSheetPeoplePickerEnabled = require(ShareSheet.Flags.FFlagShareSheetPeoplePickerEnabled)

local FFlagShareSheetUseFoundationCenterSheetHeightFix = require(ShareSheet.Flags.FFlagShareSheetUseFoundationCenterSheetHeightFix)

local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)
local FIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent = ShareSheetConstants.FIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent
local getCenterSheetHeight = require(script.Parent.getCenterSheetHeight)
local PeoplePicker = require(ShareSheet.Components.PeoplePicker)
local ShareSheetActionRow = require(script.Parent.ShareSheetActionRow)
local ShareSheetSocialRow = require(script.Parent.ShareSheetSocialRow)
local ShareSendRow = require(script.Parent.ShareSendRow)
require(ShareSheet.Recipients.Recipient)
require(ShareSheet.Recipients.RecipientSource)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)
require(ShareSheet.Types)

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

local function useOverlaySize()
	local v = useOverlay()
	local state, setState = React.useState(Vector2.zero)

	if v then
		state = v.AbsoluteSize
	end

	React.useLayoutEffect(function()
		if v == nil then
			return
		end

		local function updateSize()
			local absoluteSize = v.AbsoluteSize
			setState(function(p)
				return if p == absoluteSize then p else absoluteSize
			end)
		end

		local absoluteSizeChangedConnection = v:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { v })

	return state
end

local function ShareSheetView(props)
	local v, v2, v3

	if not FFlagShareSheetUseFoundationCenterSheetHeightFix then
		v2 = useTokens()
		v = useOverlaySize()
		v3 = useScaledValue(600)
	end

	local v4 = next(props.selectedConversationIds) ~= nil or props.isSending == true

	local snapPoints = nil
	local centerSheetHeight = nil
	local peoplePicker, v5

	if FFlagShareSheetPeoplePickerEnabled then
		peoplePicker = props.peoplePicker
		v5 = props.isPeoplePickerDisplayed == true

		if v5 then
			centerSheetHeight = FIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent / 10000
			snapPoints = { centerSheetHeight }

			if not FFlagShareSheetUseFoundationCenterSheetHeightFix then
				centerSheetHeight = getCenterSheetHeight(v.Y, v2.Margin.Medium * 2, v3, centerSheetHeight)
			end
		end
	else
		v5 = false
	end

	local onClose = React.useCallback(function()
		props.onCloseWithReason(ShareSheetTelemetry.CloseReason.UserDismissed)
	end, { props.onCloseWithReason })

	local createElement = React.createElement
	local root = Sheet.Root

	if not FFlagShareSheetPeoplePickerEnabled then
		centerSheetHeight = nil
	end

	local v6 = {
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

	v6.size = size

	if not FFlagShareSheetPeoplePickerEnabled then
		snapPoints = nil
	end

	v6.snapPoints = snapPoints

	local createElement2 = React.createElement
	local header = Sheet.Header
	local v7

	if FFlagShareSheetPeoplePickerEnabled and v5 then
		v7 = {
			Picker = React.createElement(PeoplePicker.PeoplePickerHeader, peoplePicker.headerProps)
		}
	else
		v7 = {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.shareLabel,
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}
	end

	local children = {
		Header = createElement2(header, {
			hasCloseAffordance = not FFlagShareSheetPeoplePickerEnabled or not v5
		}, v7),
		Content = 0,
		Actions = 0
	}

	local createElement3 = React.createElement
	local content = Sheet.Content
	local scrollingFrameRef

	if FFlagShareSheetPeoplePickerEnabled and v5 then
		scrollingFrameRef = setPeoplePickerContentScrollingFrameRef
	else
		scrollingFrameRef = setDefaultContentScrollingFrameRef
	end

	local createElement4 = React.createElement
	local v8

	if FFlagShareSheetPeoplePickerEnabled and v5 then
		v8 = {
			PeoplePicker = React.createElement(PeoplePicker.PeoplePickerList, peoplePicker.listProps)
		}
	else
		v8 = { SocialRow = 0, RowDivider = 0, ActionsRow = 0 }
		local socialRow

		if props.shouldShowSocialRow then
			local createElement5 = React.createElement
			local conversationEligibility

			if not FFlagShareSheetFriendsSort then
				conversationEligibility = props.conversationEligibility
			end

			local socialRowRecipients

			if FFlagShareSheetFriendsSort then
				socialRowRecipients = props.socialRowRecipients
			end

			local v9 = {
				conversationEligibility = conversationEligibility,
				socialRowRecipients = socialRowRecipients,
				isLoading = props.isSocialRowLoading,
				onConversationActivated = props.onConversationActivated,
				onMoreActivated = 0,
				selectedConversationIds = 0,
				LayoutOrder = 1
			}
			local onMoreActivated

			if FFlagShareSheetPeoplePickerEnabled then
				onMoreActivated = props.onMoreActivated
			end

			v9.onMoreActivated = onMoreActivated

			v9.selectedConversationIds = props.selectedConversationIds
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
		local actionsRow

		if not FFlagShareSheetPeoplePickerEnabled then
			if v4 then
				actionsRow = React.createElement(ShareSendRow, {
					isLoading = props.isSending,
					label = props.sendLabel,
					LayoutOrder = 3,
					messagePlaceholder = props.messagePlaceholder,
					onActivated = props.onSendActivated,
					onFocusGained = props.onComposerFocused
				})
			else
				actionsRow = React.createElement(ShareSheetActionRow, {
					canShare = props.canShareLink,
					context = props.context,
					LayoutOrder = 3,
					recipientSource = props.recipientSource,
					telemetryId = props.telemetryId,
					url = props.url
				})
			end
		end

		v8.ActionsRow = actionsRow
	end

	children.Content = createElement3(content, {
		scrollingFrameRef = scrollingFrameRef,
		isContentFullBleed = not FFlagShareSheetPeoplePickerEnabled or not v5
	}, {
		ContentLayout = createElement4(View, {
			tag = {
				["col size-full"] = FFlagShareSheetPeoplePickerEnabled and v5,
				["col size-full-0 auto-y"] = not (FFlagShareSheetPeoplePickerEnabled and v5),
				["gap-xlarge"] = not FFlagShareSheetPeoplePickerEnabled or not v5
			}
		}, v8)
	})
	local actions2

	if FFlagShareSheetPeoplePickerEnabled then
		local createElement5 = React.createElement
		local actions = Sheet.Actions
		local footer

		if v4 then
			footer = React.createElement(ShareSendRow, {
				isLoading = props.isSending,
				label = props.sendLabel,
				messagePlaceholder = props.messagePlaceholder,
				onActivated = props.onSendActivated,
				onFocusGained = props.onComposerFocused,
				shouldFillButton = false
			})
		elseif not v5 then
			footer = React.createElement(ShareSheetActionRow, {
				canShare = props.canShareLink,
				context = props.context,
				recipientSource = props.recipientSource,
				telemetryId = props.telemetryId,
				url = props.url
			})
		end

		actions2 = createElement5(actions, nil, { Footer = footer })
	end

	children.Actions = actions2
	return createElement(root, v6, children)
end

return ShareSheetView
