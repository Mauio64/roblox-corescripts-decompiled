local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local dialogSize = Foundation.Enums.DialogSize
local divider = Foundation.Divider
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View
local useOverlay = Foundation.Hooks.useOverlay
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens

local FFlagShareSheetDesktopReadiness = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetDesktopReadiness")
local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SharedFlags").FFlagShareSheetFriendsSort
local FFlagShareSheetPeoplePickerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetPeoplePickerEnabled")

local FFlagShareSheetUseFoundationCenterSheetHeightFix = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetUseFoundationCenterSheetHeightFix")

local fIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/ShareSheetConstants").FIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent
local getCenterSheetHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/getCenterSheetHeight")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker")
local ShareSheetActionRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetActionRow")
local ShareSheetSocialRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetSocialRow")
local ShareSendRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSendRow")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")
local ShareSheetTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/telemetry/ShareSheetTelemetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")

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

local function useOverlaySize()
	local v5 = useOverlay()
	local state, setState = React.useState(Vector2.zero)

	if v5 then
		state = v5.AbsoluteSize
	end

	React.useLayoutEffect(function()
		if v5 == nil then
			return
		end

		local function updateSize()
			local absoluteSize = v5.AbsoluteSize
			setState(function(p2)
				if p2 == absoluteSize then
					return p2
				end

				return absoluteSize
			end)
		end

		local absoluteSizeChangedConnection = v5:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
		return function()
			absoluteSizeChangedConnection:Disconnect()
		end
	end, { v5 })

	return state
end

local function ShareSheetView(props)
	local v5, v6, v7

	if not FFlagShareSheetUseFoundationCenterSheetHeightFix then
		v6 = useTokens()
		v5 = useOverlaySize()
		v7 = useScaledValue(600)
	end

	local v8 = next(props.selectedConversationIds) ~= nil or props.isSending == true

	local v9 = nil
	local v10 = nil
	local peoplePicker, v11

	if FFlagShareSheetPeoplePickerEnabled then
		peoplePicker = props.peoplePicker
		v11 = props.isPeoplePickerDisplayed == true

		if v11 then
			v10 = fIntShareSheetPeoplePickerEnabledSnapPointHundredthsPercent / 10000
			v9 = { v10 }

			if not FFlagShareSheetUseFoundationCenterSheetHeightFix then
				v10 = getCenterSheetHeight(v5.Y, v6.Margin.Medium * 2, v7, v10)
			end
		end
	else
		v11 = false
	end

	local v12 = React.useCallback(function()
		props.onCloseWithReason(ShareSheetTelemetry.CloseReason.UserDismissed)
	end, { props.onCloseWithReason })

	local createElement = React.createElement
	local root = sheet.Root

	if not FFlagShareSheetPeoplePickerEnabled then
		v10 = nil
	end

	local v13 = {
		centerSheetHeight = v10,
		isOpen = props.isOpen,
		onClose = v12,
		preferCenterSheet = true,
		size = 0,
		snapPoints = 0
	}

	local v14 = if FFlagShareSheetDesktopReadiness then dialogSize.Large else nil
	v13.size = v14

	if not FFlagShareSheetPeoplePickerEnabled then
		v9 = nil
	end

	v13.snapPoints = v9

	local createElement2 = React.createElement
	local header = sheet.Header
	local v16

	if FFlagShareSheetPeoplePickerEnabled and v11 then
		v16 = {
			Picker = React.createElement(module7.PeoplePickerHeader, peoplePicker.headerProps)
		}
	else
		v16 = {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.shareLabel,
				tag = "auto-xy text-heading-small content-emphasis"
			})
		}
	end

	local children = {
		Header = createElement2(header, {
			hasCloseAffordance = not FFlagShareSheetPeoplePickerEnabled or not v11
		}, v16),
		Content = 0,
		Actions = 0
	}

	local createElement3 = React.createElement
	local content = sheet.Content
	local v18 = if FFlagShareSheetPeoplePickerEnabled and v11 then setPeoplePickerContentScrollingFrameRef else setDefaultContentScrollingFrameRef
	local createElement4 = React.createElement
	local v22

	if FFlagShareSheetPeoplePickerEnabled and v11 then
		v22 = {
			PeoplePicker = React.createElement(module7.PeoplePickerList, peoplePicker.listProps)
		}
	else
		v22 = { SocialRow = 0, RowDivider = 0, ActionsRow = 0 }
		local v23

		if props.shouldShowSocialRow then
			local createElement5 = React.createElement

			local v26 = if not fFlagShareSheetFriendsSort then props.conversationEligibility else nil

			local v27 = if fFlagShareSheetFriendsSort then props.socialRowRecipients else nil
			local v25 = {
				conversationEligibility = v26,
				socialRowRecipients = v27,
				isLoading = props.isSocialRowLoading,
				onConversationActivated = props.onConversationActivated,
				onMoreActivated = 0,
				selectedConversationIds = 0,
				LayoutOrder = 1
			}

			local v28 = if FFlagShareSheetPeoplePickerEnabled then props.onMoreActivated else nil
			v25.onMoreActivated = v28

			v25.selectedConversationIds = props.selectedConversationIds
			v23 = createElement5(ShareSheetSocialRow, v25)
		end

		v22.SocialRow = v23

		local v24 = if props.shouldShowSocialRow then React.createElement(divider, {
			LayoutOrder = 2,
			testId = "share-sheet-row-divider"
		}) else nil
		v22.RowDivider = v24
		local v25

		if not FFlagShareSheetPeoplePickerEnabled then
			if v8 then
				v25 = React.createElement(ShareSendRow, {
					isLoading = props.isSending,
					label = props.sendLabel,
					LayoutOrder = 3,
					messagePlaceholder = props.messagePlaceholder,
					onActivated = props.onSendActivated,
					onFocusGained = props.onComposerFocused
				})
			else
				v25 = React.createElement(ShareSheetActionRow, {
					canShare = props.canShareLink,
					context = props.context,
					LayoutOrder = 3,
					recipientSource = props.recipientSource,
					telemetryId = props.telemetryId,
					url = props.url
				})
			end
		end

		v22.ActionsRow = v25
	end

	children.Content = createElement3(content, {
		scrollingFrameRef = v18,
		isContentFullBleed = not FFlagShareSheetPeoplePickerEnabled or not v11
	}, {
		ContentLayout = createElement4(view, {
			tag = {
				["col size-full"] = FFlagShareSheetPeoplePickerEnabled and v11,
				["col size-full-0 auto-y"] = not (FFlagShareSheetPeoplePickerEnabled and v11),
				["gap-xlarge"] = not FFlagShareSheetPeoplePickerEnabled or not v11
			}
		}, v22)
	})
	local v23

	if FFlagShareSheetPeoplePickerEnabled then
		local createElement5 = React.createElement
		local actions = sheet.Actions
		local v26

		if v8 then
			v26 = React.createElement(ShareSendRow, {
				isLoading = props.isSending,
				label = props.sendLabel,
				messagePlaceholder = props.messagePlaceholder,
				onActivated = props.onSendActivated,
				onFocusGained = props.onComposerFocused,
				shouldFillButton = false
			})
		elseif not v11 then
			v26 = React.createElement(ShareSheetActionRow, {
				canShare = props.canShareLink,
				context = props.context,
				recipientSource = props.recipientSource,
				telemetryId = props.telemetryId,
				url = props.url
			})
		end

		v23 = createElement5(actions, nil, { Footer = v26 })
	end

	children.Actions = v23
	return createElement(root, v13, children)
end

return ShareSheetView
