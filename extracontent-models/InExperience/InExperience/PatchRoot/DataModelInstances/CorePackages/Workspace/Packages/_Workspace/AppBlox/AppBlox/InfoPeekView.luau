local parent = script:FindFirstAncestor("AppBlox").Parent
local Foundation = require(parent.Foundation)
local PeekView = require(parent.PeekView)
local peekView = PeekView.PeekView
local PeekViewState = PeekView.PeekViewState
local React = require(parent.React)

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local useNavigationProps = RobloxAppNavigation.useNavigationProps
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local function InfoPeekView(p)
	local v = useNavigationProps(function(_, p2)
		return { title = p2.title, body = p2.body }
	end)

	local ref = React.useRef(nil)

	local v2 = useNavigation()
	local v3 = useTokens()

	local title = p.title or v.title
	local body = p.body or v.body

	local headingSmall = v3.Typography.HeadingSmall
	local emphasis = v3.Color.Content.Emphasis
	local bodyLarge = v3.Typography.BodyLarge
	local default = v3.Color.Content.Default

	local viewStateChanged = React.useCallback(function(p2, _)
		if p2 == PeekViewState.Closed or p2 == PeekViewState.Hidden then
			v2.goBack()
		end
	end, { v2 })

	return React.createElement(peekView, {
		briefViewContentHeight = UDim.new(0, 0),
		contentFrameRef = ref,
		hasScrim = true,
		mountAsFullView = true,
		returnToFullView = true,
		showDraggerInClosedState = false,
		thumbstickScrollEnabled = true,
		viewStateChanged = viewStateChanged
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v3.Padding.Medium)
		}),
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v3.Padding.XXLarge),
			PaddingLeft = UDim.new(0, v3.Padding.XXLarge),
			PaddingRight = UDim.new(0, v3.Padding.XXLarge),
			PaddingBottom = UDim.new(0, v3.Padding.XXLarge)
		}),
		TitleText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = title,
			FontFace = normalizeFontFace(headingSmall.Font),
			TextSize = headingSmall.FontSize,
			TextColor3 = emphasis.Color3,
			TextTransparency = emphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 1
		}),
		BodyText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = body,
			FontFace = normalizeFontFace(bodyLarge.Font),
			TextSize = bodyLarge.FontSize,
			TextColor3 = default.Color3,
			TextTransparency = default.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2
		})
	})
end

return InfoPeekView
