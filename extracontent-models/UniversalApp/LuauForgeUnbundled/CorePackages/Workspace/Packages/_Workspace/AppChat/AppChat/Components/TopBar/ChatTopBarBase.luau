local FFlagAppChatFoundationHeaderBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFoundationHeaderBar")

local FFlagAppChatFoundationHeaderBarPageMarginInset = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFoundationHeaderBarPageMarginInset")
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
local headerBar2 = Foundation.HeaderBar
local AppHeaderBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppHeaderBar")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local ThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ThemeBackground")
local FFlagAppThemeHalloween2026ChatBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppThemeHalloween2026ChatBackground")

local useSignalState = SignalsReact.useSignalState

local function noOp(): nil
	return nil
end

local function createFoundationTitle(headerText, shouldBoldHeader, isTitleLeftAligned)
	if headerText and headerText ~= "" then
		return React.createElement(Foundation.Text, {
			Text = headerText,
			LayoutOrder = 1,
			tag = {
				["auto-xy text-no-wrap text-truncate-end content-emphasis"] = true,
				["text-heading-large"] = shouldBoldHeader == true,
				["text-heading-medium"] = not shouldBoldHeader,
				shrink = not isTitleLeftAligned
			}
		})
	end

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
	local v8 = v5.rightPaddingOverride
	local closeInputBar = v5.closeInputBar
	local isSecondary = v5.isSecondary

	local makeBackButton = AppHeaderBar.makeBackButton
	local makeCloseButton = AppHeaderBar.makeCloseButton

	local v11 = if headerText.shouldLocalize then headerText.raw or nil else nil
	local v12 = useLocalization({ headerText = v11 })

	local headerText2 = headerText.shouldLocalize and v12.headerText or headerText.raw or ""

	local v13 = useStyle()
	local v14 = useTokens()

	local v15 = if props.renderRight then props.renderRight else noOp
	local renderCenter = if props.renderCenter then props.renderCenter else nil

	if renderCenter then
		v15 = nil
	end

	local v16

	if not renderCenter then
		if props.renderLeft then
			v16 = props.renderLeft
		else
			local v17 = createBackFunc({
				navigation = navigation,
				navigateToRootStack = screenProps2,
				isRoot = isRoot,
				closeInputBar = closeInputBar
			})

			if backButtonEnabled then
				v16 = makeBackButton(v17)
			else
				v16 = if closeButtonEnabled then makeCloseButton(v17) else noOp
			end
		end
	end

	local v17 = not backButtonEnabled and not closeButtonEnabled and renderCenter == nil

	if shouldBoldHeader and v16 == noOp then
		v16 = nil
	end

	local medium = v14.Padding.Medium
	local newUDim = UDim.new

	if v7 == nil then
		v7 = medium
	end

	local udim = newUDim(0, v7)
	local newUDim2 = UDim.new

	if v8 == nil then
		v8 = medium
	end

	local udim2 = newUDim2(0, v8)
	local v20

	if fFlagAppIaScrollAway and not v6 and AppNavBar.getScrollAwayEnabled() then
		v20 = visibilityControl.getHeaderBinding():map(function(p2)
			local v21 = (p2 - 1) * (screenProps + 36)
			return UDim2.new(0, 0, 0, v21)
		end)
	end

	if renderCenter then
		v16 = nil
	elseif not (props.renderLeft or screenProps2) and (v17 or not v16) then
		v16 = nil
	end

	if renderCenter or props.hideTitle then
		headerText2 = nil
	end

	local v21 = if FFlagAppThemeHalloween2026ChatBackground then ThemeBackground.useThemeBackground() else nil

	if FFlagAppChatFoundationHeaderBar then
		local v22 = createFoundationTitle(headerText2, shouldBoldHeader, isTitleLeftAligned)
		local v23 = if v16 then v16() else nil
		local v24 = if isTitleLeftAligned then v22 else nil

		if renderCenter then
			v22 = renderCenter()
		elseif isTitleLeftAligned then
			v22 = nil
		end

		local v25 = if v15 then v15() else nil
		local v26 = v21 == nil and (fFlagAppIaScrollAway and not v6)

		local createElement = React.createElement
		local root = headerBar2.Root

		local v29 = if v23 or v24 then React.createElement(headerBar2.Leading, nil, {
			leftContent = v23,
			title = v24
		}) else nil

		local v30 = if v22 then React.createElement(headerBar2.Content, nil, {
			centerContent = v22
		}) else nil

		local v31 = if v25 then React.createElement(headerBar2.Trailing, nil, {
			rightContent = v25
		}) else nil
		local element = createElement(root, {
			hasBackground = v26 and not FFlagAppChatFoundationHeaderBarPageMarginInset
		}, { Leading = v29, Content = v30, Trailing = v31 })
		local v32

		if FFlagAppChatFoundationHeaderBarPageMarginInset then
			local v33 = udim.Offset - medium
			local v34 = udim2.Offset - medium
			v32 = React.createElement(Foundation.View, {
				Position = UDim2.fromOffset(v33, 0),
				Size = UDim2.new(1, -(v33 + v34), 1, 0)
			}, { headerBar = element })
		end

		local createElement2 = React.createElement
		local view = Foundation.View
		local v33 = {
			tag = FFlagAppChatFoundationHeaderBarPageMarginInset and { ["bg-surface-0"] = v26 } or nil,
			Size = UDim2.new(1, 0, 0, screenProps),
			LayoutOrder = -1,
			ZIndex = fFlagAppIaScrollAway and 2 or nil,
			Position = 0
		}

		if not fFlagAppIaScrollAway then
			v20 = nil
		end

		v33.Position = v20

		local v35 = if v21 then React.createElement(ThemeBackground.ThemeBackgroundHeaderSlot) else nil

		if v32 then
			element = nil
		end

		return createElement2(view, v33, {
			BackgroundSlot = v35,
			headerBar = element,
			headerBarInset = v32
		})
	else
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
			renderLeft = v16,
			isSecondary = isSecondary,
			renderCenter = renderCenter,
			renderRight = v15,
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
			v27 = v13.Tokens.Color.None.Transparency
		end

		v26.backgroundTransparency = v27
		return createElement(view, v22, {
			BackgroundSlot = v24,
			headerBar = createElement2(headerBar, v26)
		})
	end
end

return ChatTopBarBase
