local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactRodux")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local text = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AppCommonLib").Text
local linkButton = UIBlox.App.Button.LinkButton
local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local appLinking = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactServiceTags").AppLinking
local roactServices = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactServices").RoactServices
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").RoactAppPolicy
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Cryo")
local Style = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Style")
local getTextSize = Style.GetTextSize
local useDesignTokens = Style.useDesignTokens
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").UiMode
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppHooks").useUiModeInfo
local fFlagFoundationStylingOnSignUp = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagFoundationStylingOnSignUp
local DisclaimerLinksVariant = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/DisclaimerLinksVariant")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/FitChildren")
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppNavigation").NavigationCommands else nil

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").AppPage

local TransitionAnimation = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/TransitionAnimation")

local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Localization").withLocalization
local withStyle = UIBlox.Style.withStyle

local OpenExternalBrowser = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Thunks/OpenExternalBrowser")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UrlBuilder").UrlBuilder
local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/AuthAnalytics")
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local eventStreamConstants = AuthAnalytics.EventStreamConstants

local module12 = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/DisclaimerLinkButtons")

local RegisterAuditContent = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/RegisterAuditContent")
local RegisterAdditionalAuditContent = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Components/RegisterAdditionalAuditContent")

local getFFlagEnableAuditForSinglePageSignUp = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableAuditForSinglePageSignUp

local v5 = { [DisclaimerLinksVariant.Default] = "TextDefault", [DisclaimerLinksVariant.Link] = nil }

local v6 = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function createFoundationLink(p2, onActivated, p3, underlineLinks, underlinedLinkTextTag)
	if underlineLinks then
		return Roact.createElement(
			Foundation.View,
			{
				tag = "auto-xy padding-small",
				onActivated = onActivated,
				stateLayer = v6,
				LayoutOrder = p3
			},
			{
				Label = Roact.createElement(Foundation.Text, {
					Text = `<u>{p2}</u>`,
					RichText = true,
					tag = `auto-xy content-emphasis {underlinedLinkTextTag or "text-caption-small"}`
				})
			}
		)
	end

	return Roact.createElement(Foundation.Button, {
		text = p2,
		variant = Foundation.Enums.ButtonVariant.Utility,
		size = Foundation.Enums.ButtonSize.Small,
		onActivated = onActivated,
		LayoutOrder = p3
	})
end

local extended = Roact.PureComponent:extend("DisclaimerLinks")

function extended:init()
	function self.openDisclaimerLink(p2)
		if self.props.useExternalBrowserForDisclaimerLinks then
			OpenExternalBrowser(self.props.linking, p2)
		else
			self.props.navigateDown({
				name = appPage.GenericWebPage,
				detail = p2,
				extraProps = {
					title = "",
					transitionAnimation = TransitionAnimation.SlideInFromRight
				}
			})
		end
	end

	function self.openTermsLink()
		local terms = urlBuilder.static.about.terms()

		if self.props.ctx then
			authFormInteraction(self.props.ctx, eventStreamConstants.Field.TermsOfService, self.props.state)
		end

		self.openDisclaimerLink(terms)
	end

	function self.openPrivacyLink()
		local privacy = urlBuilder.static.about.privacy()

		if self.props.ctx then
			authFormInteraction(self.props.ctx, eventStreamConstants.Field.PrivacyPolicy, self.props.state)
		end

		self.openDisclaimerLink(privacy)
	end
end

function extended.render(data)
	local isDualLayout = data.props.isDualLayout

	local loginView = data.props.tokens.LuaApps.LoginView
	local v7 = not loginView and 4 or loginView.boxPadding

	return withLocalization({
		termsOfUseText = "CommonUI.Features.Label.Terms",
		termsOfUseTextLong = "CommonUI.Features.Label.TermsOfUse",
		privacyPolicyText = "CommonUI.Features.Label.Privacy",
		privacyPolicyTextLong = "CommonUI.Features.Label.PrivacyPolicy"
	})(function(data2)
		return withStyle(function(props)
			local v8 = data.props.uiModeInfo.uiMode == uiMode.TenFoot
			local layoutOrder = data.props.LayoutOrder

			local v9 = if fFlagFoundationStylingOnSignUp then v5[data.props.variant] else nil

			local baseSize = props.Font.BaseSize
			local v10 = isDualLayout and "CommonUI.Features.Label.TermsOfUse"
				or "CommonUI.Features.Label.Terms"
			local v11 = isDualLayout and "CommonUI.Features.Label.PrivacyPolicy"
				or "CommonUI.Features.Label.Privacy"
			local v12 = if isDualLayout then data2.termsOfUseTextLong else data2.termsOfUseText
			local v13

			if isDualLayout then
				v13 = data2.privacyPolicyTextLong
			else
				v13 = "<b>" .. data2.privacyPolicyText .. "</b>"
			end

			local font = props.Font.Header2.Font
			local v14

			if foundationFontFaceMigration then
				v14 = getTextSize(
					" ",
					baseSize,
					props.Tokens.Typography.TitleLarge.Font,
					Vector2.new(10000, 10000)
				).X / 2
			else
				v14 = text.GetTextWidth(" ", font, baseSize) / 2
			end

			local v15

			if foundationFontFaceMigration then
				v15 = getTextSize(
					"-",
					baseSize,
					props.Tokens.Typography.TitleLarge.Font,
					Vector2.new(10000, 10000)
				).X
			else
				v15 = text.GetTextWidth("-", font, baseSize)
			end

			local y

			if foundationFontFaceMigration then
				y = getTextSize(
					data2.privacyPolicyText,
					baseSize,
					props.Tokens.Typography.TitleLarge.Font,
					Vector2.new(10000, 10000)
				).Y
			end

			local v16

			if foundationFontFaceMigration then
				v16 = y + v7
			else
				v16 = text.GetTextHeight(data2.privacyPolicyText, font, baseSize) + v7
			end

			if isDualLayout then
				if foundationFontFaceMigration then
					v16 = 2 * (y + 2 * v7)
				else
					v16 = 2 * (text.GetTextHeight(data2.privacyPolicyText, font, baseSize) + 2 * v7)
				end
			end

			local v17 = isDualLayout and "Frame" or FitChildren.FitFrame

			local function fn()
				return {
					Image = Roact.createElement(imageSetLabel, {
						Size = UDim2.new(0, loginView.disclaimerIconSize, 0, loginView.disclaimerIconSize),
						Position = UDim2.fromOffset(0, 0),
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						ScaleType = Enum.ScaleType.Fit,
						Image = loginView.linkIcon,
						ImageColor3 = props.Theme.UIEmphasis.Color,
						ImageTransparency = 0
					})
				}
			end

			local function fn2()
				if not (data.props.enableAuditContentCapture and getFFlagEnableAuditForSinglePageSignUp()) then
					return {}
				end

				local v18 = {
					TermsAuditContent = RegisterAuditContent and v12 and Roact.createElement(RegisterAuditContent, {
						translationKey = v10,
						translatedSourceString = v12
					}),
					PrivacyAuditContent = 0,
					TermsLinkAuditContent = 0,
					PrivacyLinkAuditContent = 0
				}

				local v19 = RegisterAuditContent and v13

				if v19 then
					local createElement = Roact.createElement
					local v21 = { translationKey = v11, translatedSourceString = 0 }

					local v22 = if isDualLayout then data2.privacyPolicyTextLong else data2.privacyPolicyText
					v21.translatedSourceString = v22
					v19 = createElement(RegisterAuditContent, v21)
				end

				v18.PrivacyAuditContent = v19

				v18.TermsLinkAuditContent = RegisterAdditionalAuditContent
					and Roact.createElement(RegisterAdditionalAuditContent, {
						contentKey = "termsLink",
						value = urlBuilder.static.about.terms()
					})

				v18.PrivacyLinkAuditContent = RegisterAdditionalAuditContent
					and Roact.createElement(RegisterAdditionalAuditContent, {
						contentKey = "privacyLink",
						value = urlBuilder.static.about.privacy()
					})
				return v18
			end

			local function fn3()
				local createElement = Roact.createElement
				local v20 = {
					Padding = UDim.new(0, v14),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = 0,
					HorizontalAlignment = 0,
					VerticalAlignment = 0
				}

				local v21 = if isDualLayout then Enum.FillDirection.Vertical else Enum.FillDirection.Horizontal
				v20.FillDirection = v21

				local v22 = if isDualLayout then Enum.HorizontalAlignment.Left else Enum.HorizontalAlignment.Center
				v20.HorizontalAlignment = v22

				v20.VerticalAlignment = Enum.VerticalAlignment.Center
				local v18 = {
					UIListLayout = createElement("UIListLayout", v20),
					ContextualMenu = 0,
					TermsOfUse = 0,
					Hyphen = 0,
					PrivacyPolicy = 0
				}

				local v23 = if isDualLayout then Roact.createElement(contextualMenu, {
					buttonProps = {
						{
							text = v12,
							fontStyle = props.Font.Header1,
							onActivated = data.openTermsLink,
							rightSideGadgetSize = Vector2.new(
								loginView.disclaimerIconSize + loginView.disclaimerPadding,
								loginView.disclaimerIconSize
							),
							renderRightSideGadget = fn
						},
						{
							text = v13,
							fontStyle = props.Font.Header1,
							onActivated = data.openPrivacyLink,
							rightSideGadgetSize = Vector2.new(
								loginView.disclaimerIconSize + loginView.disclaimerPadding,
								loginView.disclaimerIconSize
							),
							renderRightSideGadget = fn
						}
					},
					open = true,
					stayOnActivated = true,
					isElementBackgroundVisible = false,
					isElementDividerVisible = false,
					closeBackgroundVisible = false,
					topElementRounded = false,
					bottomElementRounded = false,
					horizontalAlignment = Enum.HorizontalAlignment.Center,
					menuDirection = menuDirection.Down,
					contextMenuWidthOverride = UDim.new(1, 0),
					elementHeight = loginView.disclaimerElementHeight,
					openPositionX = UDim.new(0, 0),
					openPositionY = UDim.new(0, 0),
					screenSize = Vector2.new(0, 0)
				}) else nil
				v18.ContextualMenu = v23
				local v24

				if not isDualLayout then
					local createElement2 = Roact.createElement
					local v26 = {
						text = v12,
						size = 0,
						fontStyle = "Header2",
						layoutOrder = 1,
						underlineAlwaysEnabled = true,
						onActivated = 0,
						colorStyleDefault = 0,
						colorStyleHover = 0
					}

					local v27 = if isDualLayout then UDim2.new(1, 0, 0.5, 0) else UDim2.new(0, 0, 1, 0)
					v26.size = v27

					v26.onActivated = data.openTermsLink
					v26.colorStyleDefault = v9
					v26.colorStyleHover = v9
					v24 = createElement2(linkButton, v26)
				end

				v18.TermsOfUse = v24
				local v25

				if not isDualLayout then
					local createElement2 = Roact.createElement
					local v27 = {
						BackgroundTransparency = 1,
						Text = " ",
						Size = UDim2.new(0, v15, 1, 0),
						Font = if not foundationFontFaceMigration then font else nil,
						FontFace = 0,
						TextColor3 = 0,
						TextTransparency = 0,
						TextSize = 0,
						LayoutOrder = 2
					}

					local v29 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.TitleLarge.Font) else nil
					v27.FontFace = v29

					v27.TextColor3 = props.Theme.TextEmphasis.Color
					v27.TextTransparency = props.Theme.TextEmphasis.Transparency
					v27.TextSize = baseSize
					v25 = createElement2("TextLabel", v27)
				end

				v18.Hyphen = v25
				local v26

				if not isDualLayout then
					local createElement2 = Roact.createElement
					local v28 = {
						text = v13,
						size = 0,
						fontStyle = "Header2",
						layoutOrder = 3,
						underlineAlwaysEnabled = true,
						onActivated = 0,
						colorStyleDefault = 0,
						colorStyleHover = 0
					}

					local v29 = if isDualLayout then UDim2.new(1, 0, 0.5, 0) else UDim2.new(0, 0, 1, 0)
					v28.size = v29

					v28.onActivated = data.openPrivacyLink
					v28.colorStyleDefault = v9
					v28.colorStyleHover = v9
					v26 = createElement2(linkButton, v28)
				end

				v18.PrivacyPolicy = v26
				return v18
			end

			if data.props.variant == DisclaimerLinksVariant.Foundation and not (isDualLayout or v8) then
				return Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(0, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1,
						LayoutOrder = layoutOrder
					},
					Cryo.Dictionary.join({
						UIListLayout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						TermsOfUse = createFoundationLink(
							data2.termsOfUseText,
							data.openTermsLink,
							1,
							data.props.underlineLinks,
							data.props.underlinedLinkTextTag
						),
						PrivacyPolicy = createFoundationLink(
							data2.privacyPolicyText,
							data.openPrivacyLink,
							2,
							data.props.underlineLinks,
							data.props.underlinedLinkTextTag
						)
					}, fn2())
				)
			end

			if v8 then
				if getFFlagEnableAuditForSinglePageSignUp() then
					return Roact.createFragment(Cryo.Dictionary.join({
						DisclaimerLinkButtons = Roact.createElement(module12, {
							textTos = v12,
							activatedTos = data.openTermsLink,
							textPrivacy = v13,
							activatedPrivacy = data.openPrivacyLink,
							fillDirection = data.props.fillDirection,
							layoutOrder = layoutOrder,
							tokens = loginView
						})
					}, fn2()))
				end

				return Roact.createElement(module12, {
					textTos = v12,
					activatedTos = data.openTermsLink,
					textPrivacy = v13,
					activatedPrivacy = data.openPrivacyLink,
					fillDirection = data.props.fillDirection,
					layoutOrder = layoutOrder,
					tokens = loginView
				})
			else
				local v19 = if not isDualLayout then FitChildren.FitAxis.Width else nil
				local v18 = {
					fitAxis = v19,
					Size = UDim2.new(1, 0, 0, v16),
					BackgroundTransparency = 1,
					LayoutOrder = layoutOrder
				}

				if getFFlagEnableAuditForSinglePageSignUp() then
					return Roact.createElement(v17, v18, Cryo.Dictionary.join(fn3(), fn2()))
				end

				return Roact.createElement(v17, v18, fn3())
			end
		end)
	end)
end

local v7 = RoactRodux.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		navigateDown = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(navigateDown(p2))
		end
	}
end)(extended)

local v8 = roactAppPolicy.connect(function(p2)
	return {
		useExternalBrowserForDisclaimerLinks = p2.shouldUseExternalBrowserForDisclaimerLinks()
	}
end)(v7)

local v9 = roactServices.connect({ linking = appLinking })(v8)

return function(p2)
	local v10 = useDesignTokens()
	local v11 = useUiModeInfo()

	return Roact.createElement(v9, Cryo.Dictionary.join({
		tokens = v10,
		uiModeInfo = v11
	}, p2))
end
