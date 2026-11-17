local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
require(parent.ReactFocusNavigation)

local IconButton = Foundation.IconButton
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View
local DialogSize = Foundation.Enums.DialogSize
local IconName = Foundation.Enums.IconName
local useTextSize = Foundation.Hooks.useTextSize
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset
local useTokens = Foundation.Hooks.useTokens
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

local function useFooterLayout(captionText: string?)
	local v = useTokens()
	local v2 = useTextSizeOffset()
	local captionSmall = v.Typography.CaptionSmall

	local state, setState = React.useState(0)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		local x = math.floor(p.AbsoluteSize.X)
		setState(function(p2: number)
			return if p2 == x then p2 else x
		end)
	end, {})
	local v3

	if state > 0 then
		v3 = captionText
	end

	local v4 = useTextSize(v3, {
		Font = captionSmall.Font,
		FontSize = captionSmall.FontSize + v2
	}, Vector2.new(state, 1e999))

	local captionHeight = React.useMemo(function()
		if captionText == nil or state <= 0 then
			return 0
		end

		local lineHeight = captionSmall.LineHeight
		local v5

		if v4 then
			v5 = v4.Y
		else
			v5 = captionSmall.FontSize + v2
		end

		return lineHeight * v5
	end, { captionText, state, captionSmall, v2, v4 })

	local v5 = {
		topInset = v.Padding.Medium - v.Margin.Small,
		captionHeight = captionHeight,
		onAbsoluteSizeChanged = 0
	}

	if not captionText then
		onAbsoluteSizeChanged = nil
	end

	v5.onAbsoluteSizeChanged = onAbsoluteSizeChanged
	return v5
end

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function useSheetFocusRoot(props)
	local onBack = props.onBack or props.onClose
	local eventHandlers = React.useMemo(function()
		local v = {}
		v[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				object:cancel()
				onBack()
			end)
		}

		return v
	end, { onBack })

	return useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers,
		isAutoFocusRoot = true,
		isFocusable = props.isOpen
	})
end

local function GiftSheetLayoutView(props)
	local v = props.actions ~= nil or props.captionText ~= nil
	local v2 = useFooterLayout(props.captionText)
	local ref = useSheetFocusRoot(props)

	local createElement = React.createElement
	local root = Sheet.Root
	local v3 = {
		ref = ref,
		isOpen = props.isOpen,
		preferCenterSheet = true,
		size = DialogSize.Medium,
		centerSheetHeight = props.centerSheetHeight,
		snapPoints = props.snapPoints,
		onClose = props.onClose,
		testId = "GiftSheetLayoutView"
	}

	local createElement2 = React.createElement
	local header = Sheet.Header
	local back

	if props.onBack then
		back = React.createElement(IconButton, {
			icon = IconName.ChevronLargeLeft,
			onActivated = props.onBack,
			testId = "gift-sheet-layout-back",
			LayoutOrder = 1
		})
	end

	local children = {
		Header = createElement2(header, {}, {
			Back = back,
			Title = React.createElement(Text, {
				tag = "fill auto-y text-heading-small text-align-x-left content-emphasis",
				Text = props.titleText,
				testId = "gift-sheet-layout-title",
				LayoutOrder = 2
			})
		}),
		Content = React.createElement(Sheet.Content, { testId = "gift-sheet-layout-content" }, {
			Body = React.createElement(
				View,
				{
					tag = "col gap-medium size-full-0 auto-y padding-bottom-xsmall padding-top-xxsmall",
					testId = "gift-sheet-layout-body"
				},
				{
					Main = React.createElement(
						View,
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
	local actions2

	if v then
		local createElement3 = React.createElement
		local actions = Sheet.Actions
		local createElement4 = React.createElement
		local v4 = {
			tag = "col gap-medium size-full-0 auto-y",
			padding = { top = UDim.new(0, v2.topInset) },
			testId = "gift-sheet-layout-footer",
			onAbsoluteSizeChanged = v2.onAbsoluteSizeChanged
		}
		local actions3

		if props.actions then
			actions3 = React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 1 }, props.actions)
		end

		local caption

		if props.captionText then
			caption = React.createElement(Text, {
				Size = UDim2.new(1, 0, 0, v2.captionHeight),
				tag = "text-caption-small text-wrap text-align-x-left text-align-y-top content-muted",
				Text = props.captionText,
				testId = "gift-sheet-layout-caption",
				LayoutOrder = 2
			})
		end

		actions2 = createElement3(actions, {}, {
			Footer = createElement4(View, v4, { Actions = actions3, Caption = caption })
		})
	end

	children.Actions = actions2
	return createElement(root, v3, children)
end

return React.memo(GiftSheetLayoutView)
