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
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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

	local createElement = React.createElement
	local v12 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 70),
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local v15 = {}
	v15.Size = UDim2.new(0.5, 0, 0, 30)
	v15.Position = UDim2.new(0.25, 0, 0, 20)
	v15.BackgroundTransparency = 1
	v15.BorderSizePixel = 0
	v15.AutoButtonColor = false
	v15.SelectionOrder = v5
	v15.Text = v9.backToTop
	local v16 = if not foundationFontFaceMigration then v6.Typography.BodyLarge.Font else nil
	v15.Font = v16

	local v17 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodyLarge.Font) else nil
	v15.FontFace = v17

	v15.TextSize = v6.Typography.BodyLarge.FontSize
	v15.TextColor3 = v6.Color.Content.Emphasis.Color3
	v15.TextTransparency = v6.Color.Content.Emphasis.Transparency
	v15.TextXAlignment = Enum.TextXAlignment.Center
	v15.TextYAlignment = Enum.TextYAlignment.Center
	v15.SelectionImageObject = v7
	v15[React.Event.Activated] = v10
	return createElement("Frame", v12, {
		BackToTopButton = createElement2("TextButton", v15)
	})
end

return BackToTopButton
