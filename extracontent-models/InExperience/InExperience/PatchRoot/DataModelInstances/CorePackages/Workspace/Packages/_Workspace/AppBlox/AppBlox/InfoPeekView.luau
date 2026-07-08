local Parent = script:FindFirstAncestor("AppBlox").Parent
local Foundation = require(Parent.Foundation)
local PeekView = require(Parent.PeekView)
local PeekView2 = PeekView.PeekView
local PeekViewState = PeekView.PeekViewState
local React = require(Parent.React)
local useNavigation = require(Parent.Navigation).useNavigation
local useNavigationProps = require(Parent.RobloxAppNavigation).useNavigationProps
local useTokens = Foundation.Hooks.useTokens

local function InfoPeekView(t1: {[any]: any}) -- line: 24
	-- upvalues: useNavigationProps (copy), React (copy), useNavigation (copy), useTokens (copy), PeekViewState (copy), PeekView2 (copy)
	local v12 = useNavigationProps(function(_, p2) -- line: 25
		return {
			title = p2.title,
			body = p2.body
		}
	end)
	local v13 = React.useRef(nil)
	local v14 = useNavigation()
	local v15 = useTokens()
	local v16 = t1.title or v12.title
	local v17 = t1.body or v12.body
	local HeadingSmall = v15.Typography.HeadingSmall
	local Emphasis = v15.Color.Content.Emphasis
	local BodyLarge = v15.Typography.BodyLarge
	local Default = v15.Color.Content.Default
	local v22 = React.useCallback(function(p3, _) -- line: 45
		-- upvalues: PeekViewState (copy), v14 (copy)
		if p3 == PeekViewState.Closed or p3 == PeekViewState.Hidden then
			v14.goBack()
		end
	end, { v14 })

	return React.createElement(PeekView2, {
		hasScrim = true,
		mountAsFullView = true,
		returnToFullView = true,
		showDraggerInClosedState = false,
		thumbstickScrollEnabled = true,
		briefViewContentHeight = UDim.new(0, 0),
		contentFrameRef = v13,
		viewStateChanged = v22
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v15.Padding.Medium)
		}),
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v15.Padding.XXLarge),
			PaddingLeft = UDim.new(0, v15.Padding.XXLarge),
			PaddingRight = UDim.new(0, v15.Padding.XXLarge),
			PaddingBottom = UDim.new(0, v15.Padding.XXLarge)
		}),
		TitleText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 1,
			Text = v16,
			Font = HeadingSmall.Font,
			TextSize = HeadingSmall.FontSize,
			TextColor3 = Emphasis.Color3,
			TextTransparency = Emphasis.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}),
		BodyText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 2,
			Text = v17,
			Font = BodyLarge.Font,
			TextSize = BodyLarge.FontSize,
			TextColor3 = Default.Color3,
			TextTransparency = Default.Transparency,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		})
	})
end

return InfoPeekView
