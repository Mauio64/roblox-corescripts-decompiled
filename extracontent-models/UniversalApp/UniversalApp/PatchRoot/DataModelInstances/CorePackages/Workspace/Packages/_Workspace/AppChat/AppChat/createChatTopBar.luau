local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local Roact = require(AppChatParent.Roact)
local withLocalization = require(AppChatParent.Localization).withLocalization
local UIBlox = require(AppChatParent.UIBlox)
local withStyle = UIBlox.Style.withStyle
local AppNavBar = require(AppChatParent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local HeaderBarTitleLeftAligned = require(AppChat.Components.ChatConversation.HeaderBarTitleLeftAligned)
local SharedFlags = require(AppChatParent.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagEnableHomeRobloxLogo = SharedFlags.FFlagEnableHomeRobloxLogo
local HeaderBar = UIBlox.App.Bar.HeaderBar
local AppHeaderBar = require(AppChatParent.AppHeaderBar)
local Foundation = require(AppChatParent.Foundation)
local React = require(AppChatParent.React)
local FFlagAppChatDomLocatorFoundationMigration = require(AppChat.Flags.FFlagAppChatDomLocatorFoundationMigration)
local FFlagAppChatFixBackButtonOnRotation = require(AppChat.Flags.FFlagAppChatFixBackButtonOnRotation)
local canPopParentStack = require(AppChat.Utils.canPopParentStack)
local FlyoutSidePanelIXP = require(AppChatParent.SharedExperimentDefinition).FlyoutSidePanelIXP
local FlyoutLeftHeader = nil

if FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() then
	FlyoutLeftHeader = require(AppChatParent.FlyoutSidePanel).Components.FlyoutLeftHeader
end

local function noOpt() -- line: 30
	return nil
end

return function(p1) -- line: 37
	-- upvalues: FFlagAppIaScrollAway (copy), FlyoutSidePanelIXP (copy), AppHeaderBar (copy), withLocalization (copy), FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy), EnumScreens (copy), FFlagAppChatDomLocatorFoundationMigration (copy), React (copy), Foundation (copy), noOpt (copy), Roact (copy), FlyoutLeftHeader (ref), FFlagEnableHomeRobloxLogo (copy), HeaderBarTitleLeftAligned (copy), AppNavBar (copy), VisibilityControl (copy), withStyle (copy), HeaderBar (copy)
	local v25 = if not FFlagAppIaScrollAway and not FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() then nil else p1.navigation.getScreenProps("isInExperience", false)
	local v26 = p1.navigation.getScreenProps("topBarHeight", 0)
	local v27 = p1.navigation.getScreenProps("navigateToRootStack", nil)
	local v28 = p1.shouldRenderCenter and p1.renderCenter ~= nil
	local v29 = p1.headerText or {}
	local makeBackButton = AppHeaderBar.makeBackButton
	local makeCloseButton = AppHeaderBar.makeCloseButton

	return withLocalization({
		headerText = v29.shouldLocalize and v29.raw or nil
	})(function(p2) -- line: 53
		-- upvalues: v29 (copy), v28 (copy), p1 (copy), v27 (copy), FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy), EnumScreens (copy), makeBackButton (copy), FFlagAppChatDomLocatorFoundationMigration (copy), React (copy), Foundation (copy), makeCloseButton (copy), noOpt (copy), FlyoutSidePanelIXP (copy), v25 (copy), Roact (copy), FlyoutLeftHeader (ref), FFlagEnableHomeRobloxLogo (copy), HeaderBarTitleLeftAligned (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), VisibilityControl (copy), v26 (copy), withStyle (copy), HeaderBar (copy)
		local u33 = v29.shouldLocalize and p2.headerText or v29.raw
		local u34, u35, renderCenter

		if v28 then
			u33 = ""
			u34 = nil
			u35 = nil
			renderCenter = p1.renderCenter
		else
			function u34() -- line: 64
				-- upvalues: p1 (copy)
				return p1.renderRight and (not p1.rightHidden and p1.renderRight()) or nil
			end

			renderCenter = nil

			local v37 = not v27 and function() -- line: 92
				-- upvalues: p1 (copy)
				p1.navigation.pop()
			end or function() -- line: 71
				-- upvalues: p1 (copy), FFlagAppChatFixBackButtonOnRotation (copy), canPopParentStack (copy), EnumScreens (copy), v27 (copy)
				if p1.closeInputBar then
					p1.closeInputBar()
				end

				if p1.isRoot then
					if FFlagAppChatFixBackButtonOnRotation and canPopParentStack(p1.navigation) then
						p1.navigation.pop()

						return
					end

					p1.navigation.navigate(EnumScreens.EmptyConversation)
					v27()

					return
				end

				p1.navigation.pop()
			end

			if p1.backButtonEnabled then
				u35 = makeBackButton(v37)

				if FFlagAppChatDomLocatorFoundationMigration and p1.backButtonTestId then
					local v38 = u35

					function u35() -- line: 100
						-- upvalues: React (copy), Foundation (copy), p1 (copy), v38 (copy)
						return React.createElement(Foundation.View, {
							tag = "auto-xy",
							testId = p1.backButtonTestId
						}, {
							backButton = v38()
						})
					end
				end
			else
				u35 = if not p1.closeButtonEnabled then noOpt else makeCloseButton(v37)
			end
		end

		local v39 = not p1.backButtonEnabled and not v28

		if FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() and not v25 and v39 and not p1.conversationId then
			function u35() -- line: 122
				-- upvalues: Roact (copy), FlyoutLeftHeader (ref), u33 (ref), FFlagEnableHomeRobloxLogo (copy), FlyoutSidePanelIXP (copy)
				return Roact.createElement(FlyoutLeftHeader, {
					isRobloxLogoEnabled = false,
					titleText = u33,
					isFlyoutEntrypointEnabled = if not FFlagEnableHomeRobloxLogo then nil else FlyoutSidePanelIXP.isFlyoutSidePanelEnabled(),
					isAlternateEntryPointEnabled = FlyoutSidePanelIXP.isAlternateEntryPointEnabled()
				})
			end
		end

		if p1.shouldBoldHeader and u35 == noOpt then
			u35 = nil
		end

		local function v40() -- line: 140
			-- upvalues: Roact (copy), HeaderBarTitleLeftAligned (copy), u35 (ref), noOpt (copy), u34 (ref), u33 (ref), p1 (copy)
			return Roact.createElement(HeaderBarTitleLeftAligned, {
				renderLeft = if u35 ~= noOpt then u35 else nil,
				renderRight = u34,
				titleText = u33,
				conversationId = p1.conversationId,
				navigateToChatDetails = p1.navigateToChatDetails,
				ignoreRightMargin = p1.rightPaddingOverride ~= nil
			})
		end

		local uDim = UDim.new(0, 12)
		local uDim2 = UDim.new(0, 12)

		if p1.leftPaddingOverride ~= nil then
			uDim = UDim.new(0, p1.leftPaddingOverride)
		end

		if p1.rightPaddingOverride ~= nil then
			uDim2 = UDim.new(0, p1.rightPaddingOverride)
		end

		local v43 = if not FFlagAppIaScrollAway or (v25 or not AppNavBar.getScrollAwayEnabled()) then nil else VisibilityControl.getHeaderBinding():map(function(n1: number) -- line: 163
			-- upvalues: v26 (copy)
			local v46 = (n1 - 1) * (v26 + 36)

			return UDim2.new(0, 0, 0, v46)
		end)
		local v44 = FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() and (not v25 and v39)

		if v27 then
			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = -1,
				Size = UDim2.new(1, 0, 0, v26),
				ZIndex = if not FFlagAppIaScrollAway then nil else 2,
				Position = if not FFlagAppIaScrollAway then nil else v43
			}, {
				headerBar = withStyle(function(p3) -- line: 181
					-- upvalues: Roact (copy), HeaderBar (copy), p1 (copy), v44 (copy), u33 (ref), v26 (copy), u35 (ref), v40 (copy), renderCenter (ref), u34 (ref), uDim (ref), uDim2 (ref), FFlagAppIaScrollAway (copy), v25 (copy)
					return Roact.createElement(HeaderBar, {
						title = if not p1.conversationId and not v44 then u33 else nil,
						barHeight = v26,
						renderLeft = if not p1.conversationId then u35 else nil,
						isSecondary = p1.isSecondary,
						renderCenter = if not p1.conversationId then renderCenter else v40,
						renderRight = if not p1.conversationId then u34 else nil,
						paddingLeft = uDim,
						paddingRight = uDim2,
						isTitleCentered = not p1.isTitleLeftAligned,
						contentPaddingRight = UDim.new(0, 0),
						backgroundTransparency = if not FFlagAppIaScrollAway or (v25 or p1.isDialog) then p3.Tokens.Color.None.Transparency else nil
					})
				end)
			})
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = -1,
			Size = UDim2.new(1, 0, 0, v26),
			ZIndex = if not FFlagAppIaScrollAway then nil else 2,
			Position = if not FFlagAppIaScrollAway then nil else v43
		}, {
			headerBar = withStyle(function(p4) -- line: 209
				-- upvalues: Roact (copy), HeaderBar (copy), p1 (copy), v44 (copy), u33 (ref), v26 (copy), v39 (copy), u35 (ref), v40 (copy), renderCenter (ref), u34 (ref), uDim (ref), uDim2 (ref), FFlagAppIaScrollAway (copy), v25 (copy)
				return Roact.createElement(HeaderBar, {
					title = if not p1.conversationId and not v44 then u33 else nil,
					barHeight = v26,
					renderLeft = if not p1.conversationId then not v39 and u35 or nil else nil,
					isSecondary = p1.isSecondary,
					renderCenter = if not p1.conversationId then renderCenter else v40,
					renderRight = if not p1.conversationId then u34 else nil,
					paddingLeft = uDim,
					paddingRight = uDim2,
					isTitleCentered = not p1.isTitleLeftAligned,
					contentPaddingRight = UDim.new(0, 0),
					backgroundTransparency = if not FFlagAppIaScrollAway or (v25 or p1.isDialog) then p4.Tokens.Color.None.Transparency else nil
				})
			end)
		})
	end)
end
