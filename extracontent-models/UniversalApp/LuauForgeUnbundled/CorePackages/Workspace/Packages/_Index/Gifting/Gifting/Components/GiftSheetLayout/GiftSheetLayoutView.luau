local TextService = game:GetService("TextService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/InputHandlers")
require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/ReactFocusNavigation")

local iconButton = Foundation.IconButton
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View
local dialogSize = Foundation.Enums.DialogSize
local iconName = Foundation.Enums.IconName
local useTextSize = Foundation.Hooks.useTextSize
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset
local useTokens = Foundation.Hooks.useTokens
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function useFooterLayout(captionText)
	local v5 = useTokens()
	local v6 = useTextSizeOffset()
	local captionSmall = v5.Typography.CaptionSmall

	local state, setState = React.useState(0)
	local v7 = React.useCallback(function(p2)
		local x = math.floor(p2.AbsoluteSize.X)
		setState(function(p3)
			if p3 == x then
				return p3
			end

			return x
		end)
	end, {})
	local v8

	if foundationFontFaceMigration then
		local v10 = if state > 0 then captionText else nil
		v8 = useTextSize(v10, {
			Font = captionSmall.Font,
			FontSize = captionSmall.FontSize + v6
		}, Vector2.new(state, 1e999))
	else
		v8 = nil
	end

	local v9 = React.useMemo(function()
		if captionText == nil or state <= 0 then
			return 0
		end

		if not foundationFontFaceMigration then
			local textSize = TextService:GetTextSize(
				captionText,
				captionSmall.FontSize + v6,
				captionSmall.Font,
				Vector2.new(state, 1e999)
			)

			return captionSmall.LineHeight * textSize.Y
		end

		local lineHeight = captionSmall.LineHeight
		local v10 = if v8 then v8.Y else captionSmall.FontSize + v6
		return lineHeight * v10
	end, { captionText, state, captionSmall, v6, v8 })

	local v10 = {
		topInset = v5.Padding.Medium - v5.Margin.Small,
		captionHeight = v9,
		onAbsoluteSizeChanged = 0
	}

	if not captionText then
		v7 = nil
	end

	v10.onAbsoluteSizeChanged = v7
	return v10
end

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function useSheetFocusRoot(props)
	local onBack = props.onBack or props.onClose
	local v5 = React.useMemo(function()
		local v6 = {}
		v6[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				object:cancel()
				onBack()
			end)
		}

		return v6
	end, { onBack })

	return useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		eventMap = navigateBacks,
		eventHandlers = v5,
		isAutoFocusRoot = true,
		isFocusable = props.isOpen
	})
end

local function GiftSheetLayoutView(props)
	local v5 = props.actions ~= nil or props.captionText ~= nil
	local v6 = useFooterLayout(props.captionText)
	local v7 = useSheetFocusRoot(props)

	local createElement = React.createElement
	local root = sheet.Root
	local v8 = {
		ref = v7,
		isOpen = props.isOpen,
		preferCenterSheet = true,
		size = dialogSize.Medium,
		centerSheetHeight = props.centerSheetHeight,
		snapPoints = props.snapPoints,
		onClose = props.onClose,
		testId = "GiftSheetLayoutView"
	}

	local createElement2 = React.createElement
	local header = sheet.Header
	local v11 = if props.onBack then React.createElement(iconButton, {
		icon = iconName.ChevronLargeLeft,
		onActivated = props.onBack,
		testId = "gift-sheet-layout-back",
		LayoutOrder = 1
	}) else nil
	local children = {
		Header = createElement2(header, {}, {
			Back = v11,
			Title = React.createElement(text, {
				tag = "fill auto-y text-heading-small text-align-x-left content-emphasis",
				Text = props.titleText,
				testId = "gift-sheet-layout-title",
				LayoutOrder = 2
			})
		}),
		Content = React.createElement(sheet.Content, {
			testId = "gift-sheet-layout-content"
		}, {
			Body = React.createElement(
				view,
				{
					tag = "col gap-medium size-full-0 auto-y padding-bottom-xsmall padding-top-xxsmall",
					testId = "gift-sheet-layout-body"
				},
				{
					Main = React.createElement(
						view,
						{
							tag = "col size-full-0 auto-y",
							testId = "gift-sheet-layout-main",
							LayoutOrder = 1
						},
						props.content
					)
				}
			)
		}),
		Actions = 0
	}
	local v12

	if v5 then
		local createElement3 = React.createElement
		local actions = sheet.Actions
		local createElement4 = React.createElement
		local v16 = {
			tag = "col gap-medium size-full-0 auto-y",
			padding = { top = UDim.new(0, v6.topInset) },
			testId = "gift-sheet-layout-footer",
			onAbsoluteSizeChanged = v6.onAbsoluteSizeChanged
		}

		local v18 = if props.actions then React.createElement(
			view,
			{ tag = "col size-full-0 auto-y", LayoutOrder = 1 },
			props.actions
		) else nil

		local v19 = if props.captionText then React.createElement(text, {
			Size = UDim2.new(1, 0, 0, v6.captionHeight),
			tag = "text-caption-small text-wrap text-align-x-left text-align-y-top content-muted",
			Text = props.captionText,
			testId = "gift-sheet-layout-caption",
			LayoutOrder = 2
		}) else nil
		v12 = createElement3(actions, {}, {
			Footer = createElement4(view, v16, { Actions = v18, Caption = v19 })
		})
	end

	children.Actions = v12
	return createElement(root, v8, children)
end

return React.memo(GiftSheetLayoutView)
