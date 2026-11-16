local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local createBackFunc = require(script.Parent.createBackFunc)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local AppNavBar = require(parent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway

local HeaderBar = UIBlox.App.Bar.HeaderBar
local AppHeaderBar = require(parent.AppHeaderBar)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local SignalsReact = require(parent.SignalsReact)
local ThemeBackground = require(parent.ThemeBackground)
local FFlagAppThemeHalloween2026ChatBackground = require(AppChat.Flags.FFlagAppThemeHalloween2026ChatBackground)

local useSignalState = SignalsReact.useSignalState

local function noOp(): nil
	return nil
end

local function ChatTopBarBase(props)
	React.useEffect(function()
		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.finish(AppChatPerfTracker.Events.TopBarRenderInterval)
		end
	end, {})

	local screenName = props.screenName
	local navigation = props.navigation

	local v = useSignalState((GetTopBarStore(false).getScreenTopBar(screenName)))
	local v2

	if FFlagAppIaScrollAway then
		v2 = navigation.getScreenProps("isInExperience", false)
	end

	local screenProps = navigation.getScreenProps("topBarHeight", 0)
	local screenProps2 = navigation.getScreenProps("navigateToRootStack", nil)

	local headerText = v.headerText or {}
	local backButtonEnabled = v.backButtonEnabled
	local closeButtonEnabled = v.closeButtonEnabled
	local isRoot = v.isRoot
	local shouldBoldHeader = v.shouldBoldHeader
	local isTitleLeftAligned = v.isTitleLeftAligned
	local v3 = v.leftPaddingOverride
	local rightPaddingOverride = v.rightPaddingOverride
	local closeInputBar = v.closeInputBar
	local isSecondary = v.isSecondary

	local makeBackButton = AppHeaderBar.makeBackButton
	local makeCloseButton = AppHeaderBar.makeCloseButton
	local headerText3

	if headerText.shouldLocalize then
		headerText3 = headerText.raw or nil
	end

	local v4 = useLocalization({ headerText = headerText3 })

	local headerText2 = headerText.shouldLocalize and v4.headerText or headerText.raw or ""

	local v5 = useStyle()
	local v6 = useTokens()
	local renderRight

	if props.renderRight then
		renderRight = props.renderRight
	else
		renderRight = noOp
	end

	local renderCenter

	if props.renderCenter then
		renderCenter = props.renderCenter
	end

	if renderCenter then
		renderRight = nil
	end

	local renderLeft

	if not renderCenter then
		if props.renderLeft then
			renderLeft = props.renderLeft
		else
			local backFunc = createBackFunc({
				navigation = navigation,
				navigateToRootStack = screenProps2,
				isRoot = isRoot,
				closeInputBar = closeInputBar
			})

			if backButtonEnabled then
				renderLeft = makeBackButton(backFunc)
			elseif closeButtonEnabled then
				renderLeft = makeCloseButton(backFunc)
			else
				renderLeft = noOp
			end
		end
	end

	local v7 = not backButtonEnabled and not closeButtonEnabled and renderCenter == nil

	if shouldBoldHeader and renderLeft == noOp then
		renderLeft = nil
	end

	local v8 = v6.Padding.Medium

	if v3 == nil then
		v3 = v8
	end

	local udim = UDim.new(0, v3)

	if rightPaddingOverride ~= nil then
		v8 = rightPaddingOverride
	end

	local udim2 = UDim.new(0, v8)
	local position

	if FFlagAppIaScrollAway and not v2 and AppNavBar.getScrollAwayEnabled() then
		position = VisibilityControl.getHeaderBinding():map(function(p: number)
			local v9 = (p - 1) * (screenProps + 36)
			return UDim2.new(0, 0, 0, v9)
		end)
	end

	if renderCenter then
		renderLeft = nil
	elseif not (props.renderLeft or screenProps2) and (v7 or not renderLeft) then
		renderLeft = nil
	end

	if renderCenter or props.hideTitle then
		headerText2 = nil
	end

	local v9

	if FFlagAppThemeHalloween2026ChatBackground then
		v9 = ThemeBackground.useThemeBackground()
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v10 = {
		tag = "size-full-0",
		Size = UDim2.new(1, 0, 0, screenProps),
		LayoutOrder = -1,
		ZIndex = FFlagAppIaScrollAway and 2 or nil,
		Position = 0
	}

	if not FFlagAppIaScrollAway then
		position = nil
	end

	v10.Position = position
	local backgroundSlot

	if v9 then
		backgroundSlot = React.createElement(ThemeBackground.ThemeBackgroundHeaderSlot)
	end

	local createElement2 = React.createElement
	local v11 = {
		title = headerText2,
		barHeight = screenProps,
		renderLeft = renderLeft,
		isSecondary = isSecondary,
		renderCenter = renderCenter,
		renderRight = renderRight,
		paddingLeft = udim,
		paddingRight = udim2,
		isTitleCentered = not isTitleLeftAligned,
		contentPaddingRight = UDim.new(0, 0),
		backgroundTransparency = 0
	}
	local backgroundTransparency

	if v9 then
		backgroundTransparency = 1
	elseif not (FFlagAppIaScrollAway and not v2) then
		backgroundTransparency = v5.Tokens.Color.None.Transparency
	end

	v11.backgroundTransparency = backgroundTransparency
	return createElement(view, v10, {
		BackgroundSlot = backgroundSlot,
		headerBar = createElement2(HeaderBar, v11)
	})
end

return ChatTopBarBase
