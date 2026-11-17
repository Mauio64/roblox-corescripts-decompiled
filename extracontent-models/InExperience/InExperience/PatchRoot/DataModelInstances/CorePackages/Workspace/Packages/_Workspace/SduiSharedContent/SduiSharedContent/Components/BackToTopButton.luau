local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local AppPageShell = require(parent.AppPageShell)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local Responsive = require(parent.Responsive)

local scrollToTop = AppPageShell.scrollToTop
local backToTopClickEvent = DiscoveryAnalytics.Events.backToTopClickEvent
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local CursorType = Foundation.Enums.CursorType
local useLocalization = Localization.Hooks.useLocalization

local SharedFlags = require(parent.SharedFlags)
local FFlagAppPageShellScrollToTopFocus = SharedFlags.FFlagAppPageShellScrollToTopFocus
local selectionOrder = FFlagAppPageShellScrollToTopFocus and 1000000 or 1e999

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
	local v = useTokens()
	local selectionImageObject = useCursor(CursorType.RoundedRect)
	local v2

	if FFlagAppPageShellScrollToTopFocus then
		v2 = nil
	else
		v2 = Responsive.useLastInput() == Responsive.Input.Directional
	end

	local v3 = useLocalization({ backToTop = "Feature.GamePage.Action.BackToTop" })

	local v4 = React.useCallback(function()
		local current = props.scrollingFrameRef.current

		if not current then
			return
		end

		if FFlagAppPageShellScrollToTopFocus then
			scrollToTop(current)
		elseif UserGameSettings.ReducedMotion then
			current.CanvasPosition = Vector2.new(0, 0)
		elseif v2 then
			scrollBackWithFocus(current)
		else
			current:ScrollToTop()
		end

		backToTopClickEvent(props.pageContext)
	end, { props.scrollingFrameRef, props.pageContext, v2 })

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
				SelectionOrder = selectionOrder,
				Text = v3.backToTop,
				FontFace = normalizeFontFace(v.Typography.BodyLarge.Font),
				TextSize = v.Typography.BodyLarge.FontSize,
				TextColor3 = v.Color.Content.Emphasis.Color3,
				TextTransparency = v.Color.Content.Emphasis.Transparency,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				SelectionImageObject = selectionImageObject,
				[React.Event.Activated] = v4
			})
		}
	)
end

return BackToTopButton
