local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Roact = require(parent.Roact)
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization
local UIBlox = require(parent.UIBlox)
local withStyle = UIBlox.Style.withStyle
local AppNavBar = require(parent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local HeaderBarTitleLeftAligned = require(AppChat.Components.ChatConversation.HeaderBarTitleLeftAligned)
local SharedFlags = require(parent.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo

local HeaderBar = UIBlox.App.Bar.HeaderBar
local AppHeaderBar = require(parent.AppHeaderBar)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local FFlagAppChatDomLocatorFoundationMigration = require(AppChat.Flags.FFlagAppChatDomLocatorFoundationMigration)
local createBackFunc = require(AppChat.Components.TopBar.createBackFunc)
local ThemeBackground = require(parent.ThemeBackground)
local FFlagAppThemeHalloween2026ChatBackground = require(AppChat.Flags.FFlagAppThemeHalloween2026ChatBackground)
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutSidePanelIXP = SharedExperimentDefinition.FlyoutSidePanelIXP
local flyoutLeftHeader

if FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() then
	local FlyoutSidePanel = require(parent.FlyoutSidePanel)
	flyoutLeftHeader = FlyoutSidePanel.Components.FlyoutLeftHeader
else
	flyoutLeftHeader = nil
end

local function noOpt(): nil
	return nil
end

return function(data)
	local v

	if FFlagAppThemeHalloween2026ChatBackground then
		v = ThemeBackground.useThemeBackground()
	else
		v = nil
	end

	local v2

	if FFlagAppIaScrollAway or FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() then
		v2 = data.navigation.getScreenProps("isInExperience", false)
	else
		v2 = nil
	end

	local screenProps = data.navigation.getScreenProps("topBarHeight", 0)

	local screenProps2 = data.navigation.getScreenProps("navigateToRootStack", nil)

	local v3 = data.shouldRenderCenter and data.renderCenter ~= nil
	local headerText = data.headerText or {}
	local makeBackButton = AppHeaderBar.makeBackButton

	local makeCloseButton = AppHeaderBar.makeCloseButton
	local headerText2

	if headerText.shouldLocalize then
		headerText2 = headerText.raw or nil
	end

	return withLocalization({ headerText = headerText2 })(function(p)
		local titleText = headerText.shouldLocalize and p.headerText or headerText.raw
		local renderCenter, v4, fn

		if v3 then
			renderCenter = data.renderCenter
			fn = nil
			titleText = ""
		else
			fn = function()
				local v5

				if data.renderRight then
					return not data.rightHidden and data.renderRight() or nil
				end

				return v5
			end

			renderCenter = nil

			local backFunc = createBackFunc({
				navigation = data.navigation,
				navigateToRootStack = screenProps2,
				isRoot = data.isRoot,
				closeInputBar = data.closeInputBar
			})

			local function fn2()
				backFunc()
			end

			if data.backButtonEnabled then
				v4 = makeBackButton(fn2)

				if FFlagAppChatDomLocatorFoundationMigration and data.backButtonTestId then
					local v5 = v4
					v4 = function()
						return React.createElement(
							Foundation.View,
							{ tag = "auto-xy", testId = data.backButtonTestId },
							{ backButton = v5() }
						)
					end
				end
			elseif data.closeButtonEnabled then
				v4 = makeCloseButton(fn2)
			else
				v4 = noOpt
			end
		end

		local v5 = not (data.backButtonEnabled or v3)

		local fn2 = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()
			and not v2
			and v5
			and not data.conversationId
			and function()
				local createElement = Roact.createElement
				local v6 = {
					titleText = titleText,
					isRobloxLogoEnabled = false,
					isFlyoutEntrypointEnabled = 0,
					isAlternateEntryPointEnabled = 0
				}
				local isFlyoutEntrypointEnabled

				if FFlagEnableHomeRobloxLogo then
					isFlyoutEntrypointEnabled = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled()
				end

				v6.isFlyoutEntrypointEnabled = isFlyoutEntrypointEnabled

				v6.isAlternateEntryPointEnabled = FlyoutSidePanelIXP.isAlternateEntryPointEnabled()
				return createElement(flyoutLeftHeader, v6)
			end
			or v4

		if data.shouldBoldHeader and fn2 == noOpt then
			fn2 = nil
		end

		local function fn3()
			local createElement = Roact.createElement
			local renderLeft

			if fn2 ~= noOpt then
				renderLeft = fn2
			end

			return createElement(HeaderBarTitleLeftAligned, {
				renderLeft = renderLeft,
				renderRight = fn,
				titleText = titleText,
				conversationId = data.conversationId,
				navigateToChatDetails = data.navigateToChatDetails,
				ignoreRightMargin = data.rightPaddingOverride ~= nil
			})
		end

		local udim = UDim.new(0, 12)
		local udim2 = UDim.new(0, 12)

		if data.leftPaddingOverride ~= nil then
			udim = UDim.new(0, data.leftPaddingOverride)
		end

		if data.rightPaddingOverride ~= nil then
			udim2 = UDim.new(0, data.rightPaddingOverride)
		end

		local position

		if FFlagAppIaScrollAway and not v2 and AppNavBar.getScrollAwayEnabled() then
			position = VisibilityControl.getHeaderBinding():map(function(p2: number)
				local v6 = (p2 - 1) * (screenProps + 36)
				return UDim2.new(0, 0, 0, v6)
			end)
		end

		local v6 = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() and not v2 and v5

		if screenProps2 then
			local createElement = Roact.createElement
			local v7 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, screenProps),
				LayoutOrder = -1,
				ZIndex = FFlagAppIaScrollAway and 2 or nil,
				Position = 0
			}

			if not FFlagAppIaScrollAway then
				position = nil
			end

			v7.Position = position
			local backgroundSlot

			if v then
				backgroundSlot = Roact.createElement(ThemeBackground.ThemeBackgroundHeaderSlot)
			end

			return createElement("Frame", v7, {
				BackgroundSlot = backgroundSlot,
				headerBar = withStyle(function(p2)
					local createElement2 = Roact.createElement
					local title

					if not (data.conversationId or v6) then
						title = titleText
					end

					local v8 = {
						title = title,
						barHeight = screenProps,
						renderLeft = 0,
						isSecondary = 0,
						renderCenter = 0,
						renderRight = 0,
						paddingLeft = 0,
						paddingRight = 0,
						isTitleCentered = 0,
						contentPaddingRight = 0,
						backgroundTransparency = 0
					}
					local renderLeft

					if not data.conversationId then
						renderLeft = fn2
					end

					v8.renderLeft = renderLeft
					v8.isSecondary = data.isSecondary
					local renderCenter2

					if data.conversationId then
						renderCenter2 = fn3
					else
						renderCenter2 = renderCenter
					end

					v8.renderCenter = renderCenter2
					local renderRight

					if not data.conversationId then
						renderRight = fn
					end

					v8.renderRight = renderRight
					v8.paddingLeft = udim
					v8.paddingRight = udim2
					v8.isTitleCentered = not data.isTitleLeftAligned
					v8.contentPaddingRight = UDim.new(0, 0)
					local backgroundTransparency

					if v then
						backgroundTransparency = 1
					elseif not (FFlagAppIaScrollAway and not (v2 or data.isDialog)) then
						backgroundTransparency = p2.Tokens.Color.None.Transparency
					end

					v8.backgroundTransparency = backgroundTransparency
					return createElement2(HeaderBar, v8)
				end)
			})
		else
			local createElement = Roact.createElement
			local v7 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, screenProps),
				LayoutOrder = -1,
				ZIndex = FFlagAppIaScrollAway and 2 or nil,
				Position = 0
			}

			if not FFlagAppIaScrollAway then
				position = nil
			end

			v7.Position = position
			local backgroundSlot

			if v then
				backgroundSlot = Roact.createElement(ThemeBackground.ThemeBackgroundHeaderSlot)
			end

			return createElement("Frame", v7, {
				BackgroundSlot = backgroundSlot,
				headerBar = withStyle(function(p2)
					local createElement2 = Roact.createElement
					local title

					if not (data.conversationId or v6) then
						title = titleText
					end

					local v8 = {
						title = title,
						barHeight = screenProps,
						renderLeft = 0,
						isSecondary = 0,
						renderCenter = 0,
						renderRight = 0,
						paddingLeft = 0,
						paddingRight = 0,
						isTitleCentered = 0,
						contentPaddingRight = 0,
						backgroundTransparency = 0
					}
					local renderLeft

					if not (data.conversationId or v5) then
						renderLeft = fn2 or nil
					end

					v8.renderLeft = renderLeft
					v8.isSecondary = data.isSecondary
					local renderCenter2

					if data.conversationId then
						renderCenter2 = fn3
					else
						renderCenter2 = renderCenter
					end

					v8.renderCenter = renderCenter2
					local renderRight

					if not data.conversationId then
						renderRight = fn
					end

					v8.renderRight = renderRight
					v8.paddingLeft = udim
					v8.paddingRight = udim2
					v8.isTitleCentered = not data.isTitleLeftAligned
					v8.contentPaddingRight = UDim.new(0, 0)
					local backgroundTransparency

					if v then
						backgroundTransparency = 1
					elseif not (FFlagAppIaScrollAway and not (v2 or data.isDialog)) then
						backgroundTransparency = p2.Tokens.Color.None.Transparency
					end

					v8.backgroundTransparency = backgroundTransparency
					return createElement2(HeaderBar, v8)
				end)
			})
		end
	end)
end
