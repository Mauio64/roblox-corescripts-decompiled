local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local PeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/PeekView")
local peekView = PeekView.PeekView
local peekViewState = PeekView.PeekViewState
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Navigation").useNavigation
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppNavigation").useNavigationProps
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local function InfoPeekView(p2)
	local v5 = useNavigationProps(function(p3, p4)
		return { title = p4.title, body = p4.body }
	end)

	local ref = React.useRef(nil)

	local v6 = useNavigation()
	local v7 = useTokens()

	local title = p2.title or v5.title
	local body = p2.body or v5.body

	local headingSmall = v7.Typography.HeadingSmall
	local emphasis = v7.Color.Content.Emphasis
	local bodyLarge = v7.Typography.BodyLarge
	local default = v7.Color.Content.Default

	local v8 = React.useCallback(function(p3, p4)
		if p3 == peekViewState.Closed or p3 == peekViewState.Hidden then
			v6.goBack()
		end
	end, { v6 })

	return React.createElement(peekView, {
		briefViewContentHeight = UDim.new(0, 0),
		contentFrameRef = ref,
		hasScrim = true,
		mountAsFullView = true,
		returnToFullView = true,
		showDraggerInClosedState = false,
		thumbstickScrollEnabled = true,
		viewStateChanged = v8
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v7.Padding.Medium)
		}),
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v7.Padding.XXLarge),
			PaddingLeft = UDim.new(0, v7.Padding.XXLarge),
			PaddingRight = UDim.new(0, v7.Padding.XXLarge),
			PaddingBottom = UDim.new(0, v7.Padding.XXLarge)
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
