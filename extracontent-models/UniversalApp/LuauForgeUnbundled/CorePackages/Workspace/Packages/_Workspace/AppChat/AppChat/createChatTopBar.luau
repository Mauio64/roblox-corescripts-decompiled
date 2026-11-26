local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").withLocalization
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox")
local withStyle = UIBlox.Style.withStyle
local AppNavBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppNavBar")
local visibilityControl = AppNavBar.VisibilityControl
local HeaderBarTitleLeftAligned = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/HeaderBarTitleLeftAligned")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo

local headerBar = UIBlox.App.Bar.HeaderBar
local AppHeaderBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppHeaderBar")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local FFlagAppChatDomLocatorFoundationMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDomLocatorFoundationMigration")
local createBackFunc = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/createBackFunc")
local ThemeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ThemeBackground")
local FFlagAppThemeHalloween2026ChatBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppThemeHalloween2026ChatBackground")
local flyoutSidePanelIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedExperimentDefinition").FlyoutSidePanelIXP
local flyoutLeftHeader

if flyoutSidePanelIXP.isFlyoutSidePanelEnabled() then
	flyoutLeftHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FlyoutSidePanel").Components.FlyoutLeftHeader
else
	flyoutLeftHeader = nil
end

local function noOpt(): nil
	return nil
end

return function(data)
	local v5 = if FFlagAppThemeHalloween2026ChatBackground then ThemeBackground.useThemeBackground() else nil
	local v6

	if fFlagAppIaScrollAway or flyoutSidePanelIXP.isFlyoutSidePanelEnabled() then
		v6 = data.navigation.getScreenProps("isInExperience", false)
	else
		v6 = nil
	end

	local screenProps = data.navigation.getScreenProps("topBarHeight", 0)

	local screenProps2 = data.navigation.getScreenProps("navigateToRootStack", nil)

	local v7 = data.shouldRenderCenter and data.renderCenter ~= nil
	local headerText = data.headerText or {}
	local makeBackButton = AppHeaderBar.makeBackButton

	local makeCloseButton = AppHeaderBar.makeCloseButton

	local v10 = if headerText.shouldLocalize then headerText.raw or nil else nil
	return withLocalization({ headerText = v10 })(function(p2)
		local v11 = headerText.shouldLocalize and p2.headerText or headerText.raw
		local renderCenter, v12, fn

		if v7 then
			renderCenter = data.renderCenter
			fn = nil
			v11 = ""
		else
			fn = function()
				return if data.renderRight then not data.rightHidden and data.renderRight() or nil else nil
			end

			renderCenter = nil

			local v13 = createBackFunc({
				navigation = data.navigation,
				navigateToRootStack = screenProps2,
				isRoot = data.isRoot,
				closeInputBar = data.closeInputBar
			})

			local function fn2()
				v13()
			end

			if data.backButtonEnabled then
				v12 = makeBackButton(fn2)

				if FFlagAppChatDomLocatorFoundationMigration and data.backButtonTestId then
					local v14 = v12
					v12 = function()
						return React.createElement(
							Foundation.View,
							{ tag = "auto-xy", testId = data.backButtonTestId },
							{ backButton = v14() }
						)
					end
				end
			else
				v12 = if data.closeButtonEnabled then makeCloseButton(fn2) else noOpt
			end
		end

		local v13 = not (data.backButtonEnabled or v7)

		local fn2 = flyoutSidePanelIXP.isFlyoutSidePanelEnabled()
			and not v6
			and v13
			and not data.conversationId
			and function()
				local createElement = Roact.createElement
				local v15 = {
					titleText = v11,
					isRobloxLogoEnabled = false,
					isFlyoutEntrypointEnabled = 0,
					isAlternateEntryPointEnabled = 0
				}

				local v16 = if fFlagEnableHomeRobloxLogo then flyoutSidePanelIXP.isFlyoutSidePanelEnabled() else nil
				v15.isFlyoutEntrypointEnabled = v16

				v15.isAlternateEntryPointEnabled = flyoutSidePanelIXP.isAlternateEntryPointEnabled()
				return createElement(flyoutLeftHeader, v15)
			end
			or v12

		if data.shouldBoldHeader and fn2 == noOpt then
			fn2 = nil
		end

		local function fn3()
			local createElement = Roact.createElement
			local v16 = if fn2 ~= noOpt then fn2 else nil
			return createElement(HeaderBarTitleLeftAligned, {
				renderLeft = v16,
				renderRight = fn,
				titleText = v11,
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

		local v14

		if fFlagAppIaScrollAway and not v6 and AppNavBar.getScrollAwayEnabled() then
			v14 = visibilityControl.getHeaderBinding():map(function(p3)
				local v15 = (p3 - 1) * (screenProps + 36)
				return UDim2.new(0, 0, 0, v15)
			end)
		end

		local v15 = flyoutSidePanelIXP.isFlyoutSidePanelEnabled() and not v6 and v13

		if screenProps2 then
			local createElement = Roact.createElement
			local v17 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, screenProps),
				LayoutOrder = -1,
				ZIndex = fFlagAppIaScrollAway and 2 or nil,
				Position = 0
			}

			if not fFlagAppIaScrollAway then
				v14 = nil
			end

			v17.Position = v14

			local v19 = if v5 then Roact.createElement(ThemeBackground.ThemeBackgroundHeaderSlot) else nil
			return createElement("Frame", v17, {
				BackgroundSlot = v19,
				headerBar = withStyle(function(p3)
					local createElement2 = Roact.createElement
					local v22 = if not (data.conversationId or v15) then v11 else nil
					local v21 = {
						title = v22,
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

					local v23 = if not data.conversationId then fn2 else nil
					v21.renderLeft = v23
					v21.isSecondary = data.isSecondary
					local v24 = if data.conversationId then fn3 else renderCenter
					v21.renderCenter = v24
					local v25 = if not data.conversationId then fn else nil
					v21.renderRight = v25
					v21.paddingLeft = udim
					v21.paddingRight = udim2
					v21.isTitleCentered = not data.isTitleLeftAligned
					v21.contentPaddingRight = UDim.new(0, 0)
					local v26

					if v5 then
						v26 = 1
					elseif not (fFlagAppIaScrollAway and not (v6 or data.isDialog)) then
						v26 = p3.Tokens.Color.None.Transparency
					end

					v21.backgroundTransparency = v26
					return createElement2(headerBar, v21)
				end)
			})
		else
			local createElement = Roact.createElement
			local v17 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, screenProps),
				LayoutOrder = -1,
				ZIndex = fFlagAppIaScrollAway and 2 or nil,
				Position = 0
			}

			if not fFlagAppIaScrollAway then
				v14 = nil
			end

			v17.Position = v14

			local v19 = if v5 then Roact.createElement(ThemeBackground.ThemeBackgroundHeaderSlot) else nil
			return createElement("Frame", v17, {
				BackgroundSlot = v19,
				headerBar = withStyle(function(p3)
					local createElement2 = Roact.createElement
					local v22 = if not (data.conversationId or v15) then v11 else nil
					local v21 = {
						title = v22,
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

					local v23 = if not (data.conversationId or v13) then fn2 or nil else nil
					v21.renderLeft = v23
					v21.isSecondary = data.isSecondary
					local v24 = if data.conversationId then fn3 else renderCenter
					v21.renderCenter = v24
					local v25 = if not data.conversationId then fn else nil
					v21.renderRight = v25
					v21.paddingLeft = udim
					v21.paddingRight = udim2
					v21.isTitleCentered = not data.isTitleLeftAligned
					v21.contentPaddingRight = UDim.new(0, 0)
					local v26

					if v5 then
						v26 = 1
					elseif not (fFlagAppIaScrollAway and not (v6 or data.isDialog)) then
						v26 = p3.Tokens.Color.None.Transparency
					end

					v21.backgroundTransparency = v26
					return createElement2(headerBar, v21)
				end)
			})
		end
	end)
end
