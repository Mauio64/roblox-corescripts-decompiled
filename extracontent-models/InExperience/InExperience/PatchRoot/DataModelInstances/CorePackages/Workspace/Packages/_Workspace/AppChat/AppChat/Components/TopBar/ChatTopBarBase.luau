local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local createBackFunc = require(script.Parent.createBackFunc)
local Foundation = require(AppChatParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local React = require(AppChatParent.React)
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local UIBlox = require(AppChatParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local AppNavBar = require(AppChatParent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local FFlagAppIaScrollAway = require(AppChatParent.SharedFlags).FFlagAppIaScrollAway
local HeaderBar = UIBlox.App.Bar.HeaderBar
local AppHeaderBar = require(AppChatParent.AppHeaderBar)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local useSignalState = require(AppChatParent.SignalsReact).useSignalState

local function noOp() -- line: 34
	return nil
end
local function ChatTopBarBase(t1: {[any]: any}) -- line: 50
	-- upvalues: FFlagAppChatTopBarConfigDriven (copy), React (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), GetTopBarStore (copy), useSignalState (copy), FFlagAppIaScrollAway (copy), AppHeaderBar (copy), useLocalization (copy), useStyle (copy), useTokens (copy), noOp (copy), createBackFunc (copy), AppNavBar (copy), VisibilityControl (copy), Foundation (copy), HeaderBar (copy)
	if not FFlagAppChatTopBarConfigDriven() then
		return nil
	end

	React.useEffect(function() -- line: 55
		-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy)
		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.finish(AppChatPerfTracker.Events.TopBarRenderInterval)
		end
	end, {})

	local screenName = t1.screenName
	local navigation = t1.navigation
	local v25 = GetTopBarStore(false).getScreenTopBar(screenName)
	local v26 = useSignalState(v25)
	local v27 = if not FFlagAppIaScrollAway then nil else navigation.getScreenProps("isInExperience", false)
	local v28 = navigation.getScreenProps("topBarHeight", 0)
	local v29 = navigation.getScreenProps("navigateToRootStack", nil)
	local v30 = v26.headerText or {}
	local backButtonEnabled = v26.backButtonEnabled
	local closeButtonEnabled = v26.closeButtonEnabled
	local isRoot = v26.isRoot
	local shouldBoldHeader = v26.shouldBoldHeader
	local isTitleLeftAligned = v26.isTitleLeftAligned
	local leftPaddingOverride = v26.leftPaddingOverride
	local rightPaddingOverride = v26.rightPaddingOverride
	local closeInputBar = v26.closeInputBar
	local isSecondary = v26.isSecondary
	local makeBackButton = AppHeaderBar.makeBackButton
	local makeCloseButton = AppHeaderBar.makeCloseButton
	local v42 = useLocalization({
		headerText = v30.shouldLocalize and v30.raw or nil
	})
	local v43 = v30.shouldLocalize and v42.headerText or (v30.raw or "")
	local v44 = useStyle()
	local v45 = useTokens()
	local v46 = if not t1.renderRight then noOp else t1.renderRight
	local v47 = if not t1.renderCenter then nil else t1.renderCenter

	if v47 then
		v46 = nil
	end

	local v48

	if v47 then
		v48 = nil
	elseif t1.renderLeft then
		v48 = t1.renderLeft
	else
		local v49 = createBackFunc({
			navigation = navigation,
			navigateToRootStack = v29,
			isRoot = isRoot,
			closeInputBar = closeInputBar
		})

		v48 = if not backButtonEnabled then if not closeButtonEnabled then noOp else makeCloseButton(v49) else makeBackButton(v49)
	end

	local v50 = not backButtonEnabled and (not closeButtonEnabled and v47 == nil)

	if shouldBoldHeader and v48 == noOp then
		v48 = nil
	end

	local Medium = v45.Padding.Medium
	local uDim = UDim.new(0, if leftPaddingOverride == nil then Medium else leftPaddingOverride)
	local uDim2 = UDim.new(0, if rightPaddingOverride == nil then Medium else rightPaddingOverride)
	local v54 = if not FFlagAppIaScrollAway or (v27 or not AppNavBar.getScrollAwayEnabled()) then nil else VisibilityControl.getHeaderBinding():map(function(n1: number) -- line: 137
		-- upvalues: v28 (copy)
		local v58 = (n1 - 1) * (v28 + 36)

		return UDim2.new(0, 0, 0, v58)
	end)
	local v55 = if not v47 then if not t1.renderLeft and not v29 then not v50 and v48 or nil else v48 else nil
	local v56 = if not v47 and not t1.hideTitle then v43 else nil

	return React.createElement(Foundation.View, {
		tag = "size-full-0",
		LayoutOrder = -1,
		Size = UDim2.new(1, 0, 0, v28),
		ZIndex = if not FFlagAppIaScrollAway then nil else 2,
		Position = if not FFlagAppIaScrollAway then nil else v54
	}, {
		headerBar = React.createElement(HeaderBar, {
			title = v56,
			barHeight = v28,
			renderLeft = v55,
			isSecondary = isSecondary,
			renderCenter = v47,
			renderRight = v46,
			paddingLeft = uDim,
			paddingRight = uDim2,
			isTitleCentered = not isTitleLeftAligned,
			contentPaddingRight = UDim.new(0, 0),
			backgroundTransparency = if not FFlagAppIaScrollAway or v27 then v44.Tokens.Color.None.Transparency else nil
		})
	})
end

return ChatTopBarBase
