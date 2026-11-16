local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local PeekView = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/PeekView")
local peekView = PeekView.PeekView
local peekViewState = PeekView.PeekViewState
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")

local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Navigation").useNavigation
local useNavigationProps = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/RobloxAppNavigation").useNavigationProps
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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

	local createElement = React.createElement
	local v10 = {
		briefViewContentHeight = UDim.new(0, 0),
		contentFrameRef = ref,
		hasScrim = true,
		mountAsFullView = true,
		returnToFullView = true,
		showDraggerInClosedState = false,
		thumbstickScrollEnabled = true,
		viewStateChanged = v8
	}

	local children = {
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
		TitleText = 0,
		BodyText = 0
	}

	local createElement2 = React.createElement

	local v13 = if not foundationFontFaceMigration then headingSmall.Font else nil
	local v14 = if foundationFontFaceMigration then normalizeFontFace(headingSmall.Font) else nil
	children.TitleText = createElement2("TextLabel", {
		BackgroundTransparency = 1,
		Text = title,
		Font = v13,
		FontFace = v14,
		TextSize = headingSmall.FontSize,
		TextColor3 = emphasis.Color3,
		TextTransparency = emphasis.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	})

	local createElement3 = React.createElement

	local v17 = if not foundationFontFaceMigration then bodyLarge.Font else nil
	local v18 = if foundationFontFaceMigration then normalizeFontFace(bodyLarge.Font) else nil
	children.BodyText = createElement3("TextLabel", {
		BackgroundTransparency = 1,
		Text = body,
		Font = v17,
		FontFace = v18,
		TextSize = bodyLarge.FontSize,
		TextColor3 = default.Color3,
		TextTransparency = default.Transparency,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2
	})
	return createElement(peekView, v10, children)
end

return InfoPeekView
