local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local AppPageShell = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/AppPageShell")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/DiscoveryAnalytics")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Responsive")

local scrollToTop = AppPageShell.scrollToTop
local backToTopClickEvent = DiscoveryAnalytics.Events.backToTopClickEvent
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local cursorType = Foundation.Enums.CursorType
local useLocalization = Localization.Hooks.useLocalization

local fFlagAppPageShellScrollToTopFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagAppPageShellScrollToTopFocus
local v5 = fFlagAppPageShellScrollToTopFocus and 1000000 or 1e999

local function scrollBackWithFocus(current)
	local tween = TweenService:Create(current, TweenInfo.new(0.3), {
		CanvasPosition = Vector2.new(0, 0)
	})

	tween:Play()
	tween.Completed:Connect(function()
		GuiService:Select(current)
	end)
end

local function BackToTopButton(props)
	local v6 = useTokens()
	local v7 = useCursor(cursorType.RoundedRect)
	local v8

	if fFlagAppPageShellScrollToTopFocus then
		v8 = nil
	else
		v8 = Responsive.useLastInput() == Responsive.Input.Directional
	end

	local v9 = useLocalization({ backToTop = "Feature.GamePage.Action.BackToTop" })

	local v10 = React.useCallback(function()
		local current = props.scrollingFrameRef.current

		if not current then
			return
		end

		if fFlagAppPageShellScrollToTopFocus then
			scrollToTop(current)
		elseif UserGameSettings.ReducedMotion then
			current.CanvasPosition = Vector2.new(0, 0)
		elseif v8 then
			scrollBackWithFocus(current)
		else
			current:ScrollToTop()
		end

		backToTopClickEvent(props.pageContext)
	end, { props.scrollingFrameRef, props.pageContext, v8 })

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 70),
			LayoutOrder = props.layoutOrder
		},
		{
			BackToTopButton = React.createElement("TextButton", {
				Size = UDim2.new(0.5, 0, 0, 30),
				Position = UDim2.new(0.25, 0, 0, 20),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				SelectionOrder = v5,
				Text = v9.backToTop,
				FontFace = normalizeFontFace(v6.Typography.BodyLarge.Font),
				TextSize = v6.Typography.BodyLarge.FontSize,
				TextColor3 = v6.Color.Content.Emphasis.Color3,
				TextTransparency = v6.Color.Content.Emphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				SelectionImageObject = v7,
				[React.Event.Activated] = v10
			})
		}
	)
end

return BackToTopButton
