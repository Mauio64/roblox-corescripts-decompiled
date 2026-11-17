local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local FFlagAppChatFoundationHeaderBar = require(AppChat.Flags.FFlagAppChatFoundationHeaderBar)

local FFlagAppChatFoundationHeaderBarPageMarginInset = require(AppChat.Flags.FFlagAppChatFoundationHeaderBarPageMarginInset)
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
local headerBar = Foundation.HeaderBar
local AppHeaderBar = require(parent.AppHeaderBar)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local SignalsReact = require(parent.SignalsReact)
local ThemeBackground = require(parent.ThemeBackground)
local FFlagAppThemeHalloween2026ChatBackground = require(AppChat.Flags.FFlagAppThemeHalloween2026ChatBackground)

local useSignalState = SignalsReact.useSignalState

local function noOp(): nil
	return nil
end

local function createFoundationTitle(headerText: string?, shouldBoldHeader: boolean?, isTitleLeftAligned: boolean?)
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
	local v4 = v.rightPaddingOverride
	local closeInputBar = v.closeInputBar
	local isSecondary = v.isSecondary

	local makeBackButton = AppHeaderBar.makeBackButton
	local makeCloseButton = AppHeaderBar.makeCloseButton
	local headerText3

	if headerText.shouldLocalize then
		headerText3 = headerText.raw or nil
	end

	local v5 = useLocalization({ headerText = headerText3 })

	local headerText2 = headerText.shouldLocalize and v5.headerText or headerText.raw or ""

	local v6 = useStyle()
	local v7 = useTokens()
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

	local v8 = not backButtonEnabled and not closeButtonEnabled and renderCenter == nil

	if shouldBoldHeader and renderLeft == noOp then
		renderLeft = nil
	end

	local medium = v7.Padding.Medium

	if v3 == nil then
		v3 = medium
	end

	local udim = UDim.new(0, v3)

	if v4 == nil then
		v4 = medium
	end

	local udim2 = UDim.new(0, v4)
	local position

	if FFlagAppIaScrollAway and not v2 and AppNavBar.getScrollAwayEnabled() then
		position = VisibilityControl.getHeaderBinding():map(function(p: number)
			local v9 = (p - 1) * (screenProps + 36)
			return UDim2.new(0, 0, 0, v9)
		end)
	end

	if renderCenter then
		renderLeft = nil
	elseif not (props.renderLeft or screenProps2) and (v8 or not renderLeft) then
		renderLeft = nil
	end

	if renderCenter or props.hideTitle then
		headerText2 = nil
	end

	local v9

	if FFlagAppThemeHalloween2026ChatBackground then
		v9 = ThemeBackground.useThemeBackground()
	end

	if FFlagAppChatFoundationHeaderBar then
		local centerContent = createFoundationTitle(headerText2, shouldBoldHeader, isTitleLeftAligned)
		local leftContent

		if renderLeft then
			leftContent = renderLeft()
		end

		local title

		if isTitleLeftAligned then
			title = centerContent
		end

		if renderCenter then
			centerContent = renderCenter()
		elseif isTitleLeftAligned then
			centerContent = nil
		end

		local rightContent

		if renderRight then
			rightContent = renderRight()
		end

		local bgsurface

		if v9 == nil then
			bgsurface = FFlagAppIaScrollAway and not v2
		else
			bgsurface = false
		end

		local createElement = React.createElement
		local root = headerBar.Root
		local leading

		if leftContent or title then
			leading = React.createElement(headerBar.Leading, nil, {
				leftContent = leftContent,
				title = title
			})
		end

		local content

		if centerContent then
			content = React.createElement(headerBar.Content, nil, { centerContent = centerContent })
		end

		local trailing

		if rightContent then
			trailing = React.createElement(headerBar.Trailing, nil, { rightContent = rightContent })
		end

		local element = createElement(root, {
			hasBackground = bgsurface and not FFlagAppChatFoundationHeaderBarPageMarginInset
		}, { Leading = leading, Content = content, Trailing = trailing })
		local headerBarInset

		if FFlagAppChatFoundationHeaderBarPageMarginInset then
			local v10 = udim.Offset - medium
			local v11 = udim2.Offset - medium
			headerBarInset = React.createElement(Foundation.View, {
				Position = UDim2.fromOffset(v10, 0),
				Size = UDim2.new(1, -(v10 + v11), 1, 0)
			}, { headerBar = element })
		end

		local createElement2 = React.createElement
		local view = Foundation.View
		local v10 = {
			tag = FFlagAppChatFoundationHeaderBarPageMarginInset and {
				["bg-surface-0"] = bgsurface
			} or nil,
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

		if headerBarInset then
			element = nil
		end

		return createElement2(view, v10, {
			BackgroundSlot = backgroundSlot,
			headerBar = element,
			headerBarInset = headerBarInset
		})
	else
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
			backgroundTransparency = v6.Tokens.Color.None.Transparency
		end

		v11.backgroundTransparency = backgroundTransparency
		return createElement(view, v10, {
			BackgroundSlot = backgroundSlot,
			headerBar = createElement2(HeaderBar, v11)
		})
	end
end

return ChatTopBarBase
