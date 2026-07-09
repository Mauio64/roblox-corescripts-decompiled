local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local PeekView = dependencies.PeekView.PeekView
local Cryo = dependencies.Cryo
local RoactNavigation = dependencies.RoactNavigation
local PeekViewState = dependencies.PeekView.PeekViewState
local useNavigation = dependencies.Hooks.useNavigation
local useState = React.useState
local useEffect = React.useEffect
local useLocalization = dependencies.Localization.Hooks.useLocalization
local useDesignTokens = dependencies.Style.useDesignTokens
local useSelector = dependencies.RoactUtils.Hooks.RoactRodux.useSelector
local AccountSelectionList = require(script.Parent.AccountSelectionList)

require(script.Parent.AccountSelection)

local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)
local v17 = game:DefineFastFlag("MoveAccountSelectorClosingAfterOperation", false)
local v18 = game:DefineFastInt("AccountSelectorInitialRowsShown", 6)
local v19 = game:DefineFastFlag("EnableAccountSelectorPeekviewRemoveSuperBriefState", false)
local GetFFlagLuaAppEnableTopBanner = dependencies.SharedFlags.GetFFlagLuaAppEnableTopBanner
local useStyle = UIBlox.Core.Style.useStyle

local function AccountSelectorPeekView(t1: {[any]: any}) -- line: 55
	-- upvalues: useStyle (copy), useNavigation (copy), useState (copy), PeekViewState (copy), useDesignTokens (copy), v18 (copy), useLocalization (copy), useSelector (copy), GetFFlagLuaAppEnableTopBanner (copy), React (copy), useEffect (copy), AnalyticsEvents (copy), v17 (copy), PeekView (copy), v19 (copy), AccountSelectionList (copy)
	local v25 = useStyle()
	local v26 = useNavigation()
	local v27, v28 = useState(false)
	local v29, v30 = useState(PeekViewState.Full)
	local BaseSize = v25.Font.BaseSize
	local v32 = v25.Font.Header1.RelativeSize * BaseSize
	local v33 = useDesignTokens()
	local v34 = #t1.users
	local Size_1600 = v33.Size.Size_1600
	local v36 = Size_1600 * 100.5
	local v37 = Size_1600 * (math.min(v18, v34) + 1.25 + 1)
	local v38 = v34 < 100 and Size_1600 * v34 or v36
	local v39 = useLocalization({
		titleText = t1.titleTextKey,
		helpText = t1.helpTextKey
	})
	local v40 = useSelector(function(p1) -- line: 89
		return p1.ScreenSize
	end)
	local v41 = not GetFFlagLuaAppEnableTopBanner() and 0 or useSelector(function(p2) -- line: 94
		return p2.GlobalGuiInset.top
	end)
	local v42 = v40.X - 48
	local v43 = React.useRef(false)
	local BackgroundContrastColor = v25.Theme.BackgroundContrast.Color

	useEffect(function() -- line: 103
		-- upvalues: t1 (copy), AnalyticsEvents (copy), v43 (copy)
		local s1 = ""

		for _, v52 in t1.users do
			s1 ..= tostring(v52.id) .. ","
		end

		local v53 = s1:sub(1, -2)

		AnalyticsEvents.sendPageLoadEvent(t1.context, t1.origin, v53)

		return function() -- line: 112
			-- upvalues: v43 (copy), t1 (copy)
			if not v43.current then
				t1.onAccountSelectionAbandoned()
			end
		end
	end, {})

	local function handleAccountSelection(p3) -- line: 121
		-- upvalues: v17 (copy), v30 (copy), PeekViewState (copy), v28 (copy), t1 (copy), AnalyticsEvents (copy), v43 (copy)
		if not v17 then
			v30(PeekViewState.Closed)
		end

		v28(true)
		t1.onAccountSelection(p3)
		AnalyticsEvents.sendSelectEvent(t1.context, t1.origin, (tostring(p3)))
		v43.current = true

		if v17 then
			v30(PeekViewState.Closed)
		end
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = if not GetFFlagLuaAppEnableTopBanner() then UDim2.new(1, 0, 0, v40.Y) else UDim2.new(1, 0, 0, v40.Y - v41),
		BackgroundColor3 = v25.Theme.Overlay.Color
	}, {
		PeekView = React.createElement(PeekView, {
			hasScrim = true,
			peekHeaderClose = false,
			canDragFullViewToBrief = true,
			mountAnimation = true,
			returnToFullView = true,
			thumbstickScrollEnabled = true,
			showDraggerInClosedState = true,
			briefViewContentHeight = UDim.new(0, v37),
			superBriefViewContentHeight = if not v19 then UDim.new(0, 40) else nil,
			style = v25,
			stateOnMount = PeekViewState.Brief,
			peekHeaderPositionYChange = function(p4) -- line: 141
				-- upvalues: v30 (copy), PeekViewState (copy)
				if p4 < 10 then
					v30(PeekViewState.Closed)
				end
			end,
			viewStateChanged = function(p5, _) -- line: 134
				-- upvalues: v30 (copy), PeekViewState (copy), v26 (copy)
				v30(p5)

				if p5 == PeekViewState.Closed or p5 == PeekViewState.Hidden then
					v26.goBack()
				end
			end,
			peekViewState = v29
		}, {
			Content = React.createElement("Frame", {
				BackgroundTransparency = 0,
				Size = UDim2.new(1, 0, 0, 0),
				BorderColor3 = BackgroundContrastColor,
				BackgroundColor3 = BackgroundContrastColor,
				AutomaticSize = Enum.AutomaticSize.Y
			}, {
				ContentPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 48)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 12),
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				TitleFrame = React.createElement("Frame", {
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					ContentPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 24),
						PaddingRight = UDim.new(0, 24)
					}),
					TitleText = React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = v39.titleText,
						TextSize = v32,
						TextColor3 = v25.Theme.TextEmphasis.Color,
						TextTransparency = v25.Theme.TextDefault.Transparency,
						Font = v25.Font.Header2.Font,
						TextXAlignment = Enum.TextXAlignment.Center,
						Size = UDim2.new(0, v42, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					})
				}),
				Divider = React.createElement("Frame", {
					LayoutOrder = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = v25.Theme.Divider.Color,
					BackgroundTransparency = v25.Theme.Divider.Transparency
				}),
				HelpText = if not v39.helpText then nil else React.createElement("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					TextWrapped = true,
					Text = v39.helpText,
					TextSize = BaseSize,
					TextColor3 = v25.Theme.TextDefault.Color,
					TextTransparency = v25.Theme.TextDefault.Transparency,
					Font = v25.Font.Body.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(0, v42, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}),
				AccountSelectionContent = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					AccountSelectionList = React.createElement(AccountSelectionList, {
						LayoutOrder = 0,
						isScrollable = false,
						users = t1.users,
						onAccountSelection = handleAccountSelection,
						height = v38,
						isDisabled = v27
					}),
					FooterContent = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundColor3 = v25.Theme.BackgroundUIDefault.Color,
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						Contents = if not t1.renderFooterComponent then nil else t1.renderFooterComponent()
					})
				})
			})
		})
	})
end

local u23 = RoactNavigation.withNavigationFocus(AccountSelectorPeekView)

return React.forwardRef(function(p7, p8) -- line: 279
	-- upvalues: React (copy), u23 (ref), Cryo (copy)
	return React.createElement(u23, Cryo.Dictionary.join(p7, {
		defaultChildRef = p8
	}))
end)
