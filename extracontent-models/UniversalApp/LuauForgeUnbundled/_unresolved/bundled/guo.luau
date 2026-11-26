local module = require("@luauforge/bundled/gtJ")
local react = module.React
local uiBlox = module.UIBlox

local peekView = module.PeekView.PeekView
local cryo = module.Cryo
local roactNavigation = module.RoactNavigation
local peekViewState = module.PeekView.PeekViewState
local useNavigation = module.Hooks.useNavigation
local useState = react.useState
local useEffect = react.useEffect
local useLocalization = module.Localization.Hooks.useLocalization
local useDesignTokens = module.Style.useDesignTokens
local useSelector = module.RoactUtils.Hooks.RoactRodux.useSelector

local module2 = require("@luauforge/bundled/guh")
require("@luauforge/bundled/gui")

local module3 = require("@luauforge/bundled/guk")

local defineFastFlag = game:DefineFastFlag("MoveAccountSelectorClosingAfterOperation", false)
local defineFastInt = game:DefineFastInt("AccountSelectorInitialRowsShown", 6)

local defineFastFlag2 = game:DefineFastFlag("EnableAccountSelectorPeekviewRemoveSuperBriefState", false)
local getFFlagLuaAppEnableTopBanner = module.SharedFlags.GetFFlagLuaAppEnableTopBanner

local useStyle = uiBlox.Core.Style.useStyle

local function AccountSelectorPeekView(props)
	local v5 = useStyle()
	local v6 = useNavigation()

	local state, setState = useState(false)
	local state2, setState2 = useState(peekViewState.Full)

	local baseSize = v5.Font.BaseSize
	local v7 = v5.Font.Header1.RelativeSize * baseSize
	local v8 = useDesignTokens()

	local count = #props.users
	local size_1600 = v8.Size.Size_1600
	local v9 = size_1600 * 100.5

	local v10 = size_1600 * (math.min(defineFastInt, count) + 1.25 + 1)

	v9 = count < 100 and size_1600 * count or v9

	local v11 = useLocalization({
		titleText = props.titleTextKey,
		helpText = props.helpTextKey
	})

	local v12 = useSelector(function(p2)
		return p2.ScreenSize
	end)

	local v13 = not getFFlagLuaAppEnableTopBanner() and 0 or useSelector(function(p2)
		return p2.GlobalGuiInset.top
	end)

	local v14 = v12.X - 48
	local ref = react.useRef(false)

	local color = v5.Theme.BackgroundContrast.Color
	useEffect(function()
		local v15 = ""

		for k, user in props.users do
			v15 ..= tostring(user.id) .. ","
		end

		local v16 = v15:sub(1, -2)
		module3.sendPageLoadEvent(props.context, props.origin, v16)
		return function()
			if not ref.current then
				props.onAccountSelectionAbandoned()
			end
		end
	end, {})

	local function handleAccountSelection(p2)
		if not defineFastFlag then
			setState2(peekViewState.Closed)
		end

		setState(true)
		props.onAccountSelection(p2)
		module3.sendSelectEvent(props.context, props.origin, (tostring(p2)))
		ref.current = true

		if defineFastFlag then
			setState2(peekViewState.Closed)
		end
	end

	local createElement = react.createElement

	local v17 = if getFFlagLuaAppEnableTopBanner() then UDim2.new(1, 0, 0, v12.Y - v13) else UDim2.new(1, 0, 0, v12.Y)
	local v16 = {
		Size = v17,
		BackgroundColor3 = v5.Theme.Overlay.Color,
		BackgroundTransparency = 1
	}

	local createElement2 = react.createElement
	local v20 = {
		hasScrim = true,
		briefViewContentHeight = UDim.new(0, v10),
		superBriefViewContentHeight = 0,
		peekHeaderClose = false,
		style = 0,
		canDragFullViewToBrief = true,
		stateOnMount = 0,
		mountAnimation = true,
		returnToFullView = true,
		peekHeaderPositionYChange = 0,
		thumbstickScrollEnabled = true,
		showDraggerInClosedState = true,
		viewStateChanged = 0,
		peekViewState = 0
	}

	local v21 = if not defineFastFlag2 then UDim.new(0, 40) else nil
	v20.superBriefViewContentHeight = v21

	v20.style = v5

	v20.stateOnMount = peekViewState.Brief

	function v20.peekHeaderPositionYChange(p2)
		if p2 < 10 then
			setState2(peekViewState.Closed)
		end
	end

	function v20.viewStateChanged(p2, p3)
		setState2(p2)

		if p2 == peekViewState.Closed or p2 == peekViewState.Hidden then
			v6.goBack()
		end
	end
	v20.peekViewState = state2

	local createElement3 = react.createElement
	local v24 = {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 0,
		BorderColor3 = color,
		BackgroundColor3 = color,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v25 = {
		ContentPadding = react.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 48)
		}),
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 12),
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		TitleFrame = react.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 0),
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y
			},
			{
				ContentPadding = react.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				TitleText = react.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = v11.titleText,
					TextSize = v7,
					TextColor3 = v5.Theme.TextEmphasis.Color,
					TextTransparency = v5.Theme.TextDefault.Transparency,
					Font = v5.Font.Header2.Font,
					TextXAlignment = Enum.TextXAlignment.Center,
					TextWrapped = true,
					Size = UDim2.new(0, v14, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				})
			}
		),
		Divider = react.createElement("Frame", {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 1),
			BorderSizePixel = 0,
			BackgroundColor3 = v5.Theme.Divider.Color,
			BackgroundTransparency = v5.Theme.Divider.Transparency
		}),
		HelpText = 0,
		AccountSelectionContent = 0
	}

	local v26 = if v11.helpText then react.createElement("TextLabel", {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		Text = v11.helpText,
		TextSize = baseSize,
		TextColor3 = v5.Theme.TextDefault.Color,
		TextTransparency = v5.Theme.TextDefault.Transparency,
		Font = v5.Font.Body.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Size = UDim2.new(0, v14, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}) else nil
	v25.HelpText = v26

	local createElement4 = react.createElement
	local v28 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = 3
	}

	local v29 = {
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		AccountSelectionList = react.createElement(module2, {
			users = props.users,
			onAccountSelection = handleAccountSelection,
			height = v9,
			isDisabled = state,
			LayoutOrder = 0,
			isScrollable = false
		}),
		FooterContent = 0
	}

	local createElement5 = react.createElement
	local v31 = {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = v5.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y
	}

	local v33 = if props.renderFooterComponent then props.renderFooterComponent() else nil
	v29.FooterContent = createElement5("Frame", v31, { Contents = v33 })
	v25.AccountSelectionContent = createElement4("Frame", v28, v29)
	return createElement("Frame", v16, {
		PeekView = createElement2(peekView, v20, {
			Content = createElement3("Frame", v24, v25)
		})
	})
end

local v5 = roactNavigation.withNavigationFocus(AccountSelectorPeekView)

return react.forwardRef(function(p2, p3)
	return react.createElement(v5, cryo.Dictionary.join(p2, { defaultChildRef = p3 }))
end)
