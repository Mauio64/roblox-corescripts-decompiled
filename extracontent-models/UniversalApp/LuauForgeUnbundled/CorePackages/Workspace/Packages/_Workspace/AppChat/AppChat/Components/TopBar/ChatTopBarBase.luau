local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local createBackFunc = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/createBackFunc")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local useTokens = Foundation.Hooks.useTokens
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppNavBar")
local visibilityControl = AppNavBar.VisibilityControl
local fFlagAppIaScrollAway = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppIaScrollAway

local headerBar = UIBlox.App.Bar.HeaderBar
local AppHeaderBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppHeaderBar")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local ThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ThemeBackground")
local FFlagAppThemeHalloween2026ChatBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppThemeHalloween2026ChatBackground")

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

	local v5 = useSignalState((GetTopBarStore(false).getScreenTopBar(screenName)))

	local v6 = if fFlagAppIaScrollAway then navigation.getScreenProps("isInExperience", false) else nil
	local screenProps = navigation.getScreenProps("topBarHeight", 0)
	local screenProps2 = navigation.getScreenProps("navigateToRootStack", nil)

	local headerText = v5.headerText or {}
	local backButtonEnabled = v5.backButtonEnabled
	local closeButtonEnabled = v5.closeButtonEnabled
	local isRoot = v5.isRoot
	local shouldBoldHeader = v5.shouldBoldHeader
	local isTitleLeftAligned = v5.isTitleLeftAligned
	local v7 = v5.leftPaddingOverride
	local rightPaddingOverride = v5.rightPaddingOverride
	local closeInputBar = v5.closeInputBar
	local isSecondary = v5.isSecondary

	local makeBackButton = AppHeaderBar.makeBackButton
	local makeCloseButton = AppHeaderBar.makeCloseButton

	local v10 = if headerText.shouldLocalize then headerText.raw or nil else nil
	local v11 = useLocalization({ headerText = v10 })

	local headerText2 = headerText.shouldLocalize and v11.headerText or headerText.raw or ""

	local v12 = useStyle()
	local v13 = useTokens()

	local v14 = if props.renderRight then props.renderRight else noOp
	local renderCenter = if props.renderCenter then props.renderCenter else nil

	if renderCenter then
		v14 = nil
	end

	local v15

	if not renderCenter then
		if props.renderLeft then
			v15 = props.renderLeft
		else
			local v16 = createBackFunc({
				navigation = navigation,
				navigateToRootStack = screenProps2,
				isRoot = isRoot,
				closeInputBar = closeInputBar
			})

			if backButtonEnabled then
				v15 = makeBackButton(v16)
			else
				v15 = if closeButtonEnabled then makeCloseButton(v16) else noOp
			end
		end
	end

	local v16 = not backButtonEnabled and not closeButtonEnabled and renderCenter == nil

	if shouldBoldHeader and v15 == noOp then
		v15 = nil
	end

	local v17 = v13.Padding.Medium
	local newUDim = UDim.new

	if v7 == nil then
		v7 = v17
	end

	local udim = newUDim(0, v7)
	local newUDim2 = UDim.new

	if rightPaddingOverride ~= nil then
		v17 = rightPaddingOverride
	end

	local udim2 = newUDim2(0, v17)
	local v20

	if fFlagAppIaScrollAway and not v6 and AppNavBar.getScrollAwayEnabled() then
		v20 = visibilityControl.getHeaderBinding():map(function(p2)
			local v21 = (p2 - 1) * (screenProps + 36)
			return UDim2.new(0, 0, 0, v21)
		end)
	end

	if renderCenter then
		v15 = nil
	elseif not (props.renderLeft or screenProps2) and (v16 or not v15) then
		v15 = nil
	end

	if renderCenter or props.hideTitle then
		headerText2 = nil
	end

	local v21 = if FFlagAppThemeHalloween2026ChatBackground then ThemeBackground.useThemeBackground() else nil

	local createElement = React.createElement
	local view = Foundation.View
	local v22 = {
		tag = "size-full-0",
		Size = UDim2.new(1, 0, 0, screenProps),
		LayoutOrder = -1,
		ZIndex = fFlagAppIaScrollAway and 2 or nil,
		Position = 0
	}

	if not fFlagAppIaScrollAway then
		v20 = nil
	end

	v22.Position = v20

	local v24 = if v21 then React.createElement(ThemeBackground.ThemeBackgroundHeaderSlot) else nil

	local createElement2 = React.createElement
	local v26 = {
		title = headerText2,
		barHeight = screenProps,
		renderLeft = v15,
		isSecondary = isSecondary,
		renderCenter = renderCenter,
		renderRight = v14,
		paddingLeft = udim,
		paddingRight = udim2,
		isTitleCentered = not isTitleLeftAligned,
		contentPaddingRight = UDim.new(0, 0),
		backgroundTransparency = 0
	}
	local v27

	if v21 then
		v27 = 1
	elseif not (fFlagAppIaScrollAway and not v6) then
		v27 = v12.Tokens.Color.None.Transparency
	end

	v26.backgroundTransparency = v27
	return createElement(view, v22, {
		BackgroundSlot = v24,
		headerBar = createElement2(headerBar, v26)
	})
end

return ChatTopBarBase
