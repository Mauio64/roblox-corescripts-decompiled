local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local Roact = require(parent.Roact)
local RoactRodux = require(parent.RoactRodux)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local LinkButton = UIBlox.App.Button.LinkButton
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local RoactServiceTags = require(parent.RoactServiceTags)
local AppLinking = RoactServiceTags.AppLinking
local RoactServices = require(parent.RoactServices)
local roactServices = RoactServices.RoactServices
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local Cryo = require(parent.Cryo)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local useDesignTokens = Style.useDesignTokens
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UiMode = RobloxAppEnums.UiMode
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local SharedFlags = require(parent.SharedFlags)
local FFlagFoundationStylingOnSignUp = SharedFlags.FFlagFoundationStylingOnSignUp
local DisclaimerLinksVariant = require(AuthCommon.Enums.DisclaimerLinksVariant)

local FitChildren = require(AuthCommon.Components.FitChildren)
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local RobloxAppEnums2 = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums2.AppPage

local TransitionAnimation = require(AuthCommon.Enums.TransitionAnimation)

local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization
local withStyle = UIBlox.Style.withStyle

local OpenExternalBrowser = require(AuthCommon.Thunks.OpenExternalBrowser)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local AuthAnalytics = require(parent.AuthAnalytics)
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local EventStreamConstants = AuthAnalytics.EventStreamConstants

local DisclaimerLinkButtons = require(script.Parent.DisclaimerLinkButtons)

local RegisterAuditContent = require(AuthCommon.Components.RegisterAuditContent)
local RegisterAdditionalAuditContent = require(AuthCommon.Components.RegisterAdditionalAuditContent)

local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagEnableAuditForSinglePageSignUp = SharedFlags3.GetFFlagEnableAuditForSinglePageSignUp

local v = { [DisclaimerLinksVariant.Default] = "TextDefault", [DisclaimerLinksVariant.Link] = nil }

local stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function createFoundationLink(text, onActivated, layoutOrder, underlineLinks, underlinedLinkTextTag)
	if underlineLinks then
		return Roact.createElement(
			Foundation.View,
			{
				tag = "auto-xy padding-small",
				onActivated = onActivated,
				stateLayer = stateLayer,
				LayoutOrder = layoutOrder
			},
			{
				Label = Roact.createElement(Foundation.Text, {
					Text = `<u>{text}</u>`,
					RichText = true,
					tag = `auto-xy content-emphasis {underlinedLinkTextTag or "text-caption-small"}`
				})
			}
		)
	end

	return Roact.createElement(Foundation.Button, {
		text = text,
		variant = Foundation.Enums.ButtonVariant.Utility,
		size = Foundation.Enums.ButtonSize.Small,
		onActivated = onActivated,
		LayoutOrder = layoutOrder
	})
end

local extended = Roact.PureComponent:extend("DisclaimerLinks")

function extended:init()
	function self.openDisclaimerLink(detail)
		if self.props.useExternalBrowserForDisclaimerLinks then
			OpenExternalBrowser(self.props.linking, detail)
		else
			self.props.navigateDown({
				name = AppPage.GenericWebPage,
				detail = detail,
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
			authFormInteraction(self.props.ctx, EventStreamConstants.Field.TermsOfService, self.props.state)
		end

		self.openDisclaimerLink(terms)
	end

	function self.openPrivacyLink()
		local privacy = urlBuilder.static.about.privacy()

		if self.props.ctx then
			authFormInteraction(self.props.ctx, EventStreamConstants.Field.PrivacyPolicy, self.props.state)
		end

		self.openDisclaimerLink(privacy)
	end
end

function extended.render(data)
	local isDualLayout = data.props.isDualLayout

	local loginView = data.props.tokens.LuaApps.LoginView
	local v2 = not loginView and 4 or loginView.boxPadding

	return withLocalization({
		termsOfUseText = "CommonUI.Features.Label.Terms",
		termsOfUseTextLong = "CommonUI.Features.Label.TermsOfUse",
		privacyPolicyText = "CommonUI.Features.Label.Privacy",
		privacyPolicyTextLong = "CommonUI.Features.Label.PrivacyPolicy"
	})(function(data2)
		return withStyle(function(props)
			local v3 = data.props.uiModeInfo.uiMode == UiMode.TenFoot
			local layoutOrder = data.props.LayoutOrder
			local v4

			if FFlagFoundationStylingOnSignUp then
				v4 = v[data.props.variant]
			else
				v4 = nil
			end

			local baseSize = props.Font.BaseSize
			local translationKey = isDualLayout and "CommonUI.Features.Label.TermsOfUse"
				or "CommonUI.Features.Label.Terms"
			local translationKey2 = isDualLayout and "CommonUI.Features.Label.PrivacyPolicy"
				or "CommonUI.Features.Label.Privacy"
			local v5

			if isDualLayout then
				v5 = data2.termsOfUseTextLong
			else
				v5 = data2.termsOfUseText
			end

			local v6

			if isDualLayout then
				v6 = data2.privacyPolicyTextLong
			else
				v6 = "<b>" .. data2.privacyPolicyText .. "</b>"
			end

			local v7 = GetTextSize(" ", baseSize, props.Tokens.Typography.TitleLarge.Font, Vector2.new(10000, 10000)).X / 2

			local x = GetTextSize("-", baseSize, props.Tokens.Typography.TitleLarge.Font, Vector2.new(10000, 10000)).X
			local y = GetTextSize(
				data2.privacyPolicyText,
				baseSize,
				props.Tokens.Typography.TitleLarge.Font,
				Vector2.new(10000, 10000)
			).Y
			local v8 = y + v2

			if isDualLayout then
				v8 = 2 * (y + 2 * v2)
			end

			local v9 = isDualLayout and "Frame" or FitChildren.FitFrame

			local function fn()
				return {
					Image = Roact.createElement(ImageSetLabel, {
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
				if not (data.props.enableAuditContentCapture and GetFFlagEnableAuditForSinglePageSignUp()) then
					return {}
				end

				local v10 = {
					TermsAuditContent = RegisterAuditContent and v5 and Roact.createElement(RegisterAuditContent, {
						translationKey = translationKey,
						translatedSourceString = v5
					}),
					PrivacyAuditContent = 0,
					TermsLinkAuditContent = 0,
					PrivacyLinkAuditContent = 0
				}

				local privacyAuditContent = RegisterAuditContent and v6

				if privacyAuditContent then
					local createElement = Roact.createElement
					local v11 = { translationKey = translationKey2, translatedSourceString = 0 }
					local translatedSourceString

					if isDualLayout then
						translatedSourceString = data2.privacyPolicyTextLong
					else
						translatedSourceString = data2.privacyPolicyText
					end

					v11.translatedSourceString = translatedSourceString
					privacyAuditContent = createElement(RegisterAuditContent, v11)
				end

				v10.PrivacyAuditContent = privacyAuditContent

				v10.TermsLinkAuditContent = RegisterAdditionalAuditContent
					and Roact.createElement(RegisterAdditionalAuditContent, {
						contentKey = "termsLink",
						value = urlBuilder.static.about.terms()
					})

				v10.PrivacyLinkAuditContent = RegisterAdditionalAuditContent
					and Roact.createElement(RegisterAdditionalAuditContent, {
						contentKey = "privacyLink",
						value = urlBuilder.static.about.privacy()
					})
				return v10
			end

			local function fn3()
				local createElement = Roact.createElement
				local v10 = {
					Padding = UDim.new(0, v7),
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = 0,
					HorizontalAlignment = 0,
					VerticalAlignment = 0
				}
				local fillDirection

				if isDualLayout then
					fillDirection = Enum.FillDirection.Vertical
				else
					fillDirection = Enum.FillDirection.Horizontal
				end

				v10.FillDirection = fillDirection
				local horizontalAlignment

				if isDualLayout then
					horizontalAlignment = Enum.HorizontalAlignment.Left
				else
					horizontalAlignment = Enum.HorizontalAlignment.Center
				end

				v10.HorizontalAlignment = horizontalAlignment

				v10.VerticalAlignment = Enum.VerticalAlignment.Center
				local v11 = {
					UIListLayout = createElement("UIListLayout", v10),
					ContextualMenu = 0,
					TermsOfUse = 0,
					Hyphen = 0,
					PrivacyPolicy = 0
				}
				local contextualMenu

				if isDualLayout then
					contextualMenu = Roact.createElement(ContextualMenu, {
						buttonProps = {
							{
								text = v5,
								fontStyle = props.Font.Header1,
								onActivated = data.openTermsLink,
								rightSideGadgetSize = Vector2.new(
									loginView.disclaimerIconSize + loginView.disclaimerPadding,
									loginView.disclaimerIconSize
								),
								renderRightSideGadget = fn
							},
							{
								text = v6,
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
						menuDirection = MenuDirection.Down,
						contextMenuWidthOverride = UDim.new(1, 0),
						elementHeight = loginView.disclaimerElementHeight,
						openPositionX = UDim.new(0, 0),
						openPositionY = UDim.new(0, 0),
						screenSize = Vector2.new(0, 0)
					})
				end

				v11.ContextualMenu = contextualMenu
				local termsOfUse

				if not isDualLayout then
					local createElement2 = Roact.createElement
					local v12 = {
						text = v5,
						size = 0,
						fontStyle = "Header2",
						layoutOrder = 1,
						underlineAlwaysEnabled = true,
						onActivated = 0,
						colorStyleDefault = 0,
						colorStyleHover = 0
					}
					local size

					if isDualLayout then
						size = UDim2.new(1, 0, 0.5, 0)
					else
						size = UDim2.new(0, 0, 1, 0)
					end

					v12.size = size

					v12.onActivated = data.openTermsLink
					v12.colorStyleDefault = v4
					v12.colorStyleHover = v4
					termsOfUse = createElement2(LinkButton, v12)
				end

				v11.TermsOfUse = termsOfUse
				local hyphen

				if not isDualLayout then
					hyphen = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Text = " ",
						Size = UDim2.new(0, x, 1, 0),
						FontFace = normalizeFontFace(props.Tokens.Typography.TitleLarge.Font),
						TextColor3 = props.Theme.TextEmphasis.Color,
						TextTransparency = props.Theme.TextEmphasis.Transparency,
						TextSize = baseSize,
						LayoutOrder = 2
					})
				end

				v11.Hyphen = hyphen
				local privacyPolicy

				if not isDualLayout then
					local createElement2 = Roact.createElement
					local v12 = {
						text = v6,
						size = 0,
						fontStyle = "Header2",
						layoutOrder = 3,
						underlineAlwaysEnabled = true,
						onActivated = 0,
						colorStyleDefault = 0,
						colorStyleHover = 0
					}
					local size

					if isDualLayout then
						size = UDim2.new(1, 0, 0.5, 0)
					else
						size = UDim2.new(0, 0, 1, 0)
					end

					v12.size = size

					v12.onActivated = data.openPrivacyLink
					v12.colorStyleDefault = v4
					v12.colorStyleHover = v4
					privacyPolicy = createElement2(LinkButton, v12)
				end

				v11.PrivacyPolicy = privacyPolicy
				return v11
			end

			if data.props.variant == DisclaimerLinksVariant.Foundation and not (isDualLayout or v3) then
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

			if v3 then
				if GetFFlagEnableAuditForSinglePageSignUp() then
					return Roact.createFragment(Cryo.Dictionary.join({
						DisclaimerLinkButtons = Roact.createElement(DisclaimerLinkButtons, {
							textTos = v5,
							activatedTos = data.openTermsLink,
							textPrivacy = v6,
							activatedPrivacy = data.openPrivacyLink,
							fillDirection = data.props.fillDirection,
							layoutOrder = layoutOrder,
							tokens = loginView
						})
					}, fn2()))
				end

				return Roact.createElement(DisclaimerLinkButtons, {
					textTos = v5,
					activatedTos = data.openTermsLink,
					textPrivacy = v6,
					activatedPrivacy = data.openPrivacyLink,
					fillDirection = data.props.fillDirection,
					layoutOrder = layoutOrder,
					tokens = loginView
				})
			else
				local fitAxis

				if not isDualLayout then
					fitAxis = FitChildren.FitAxis.Width
				end

				local v10 = {
					fitAxis = fitAxis,
					Size = UDim2.new(1, 0, 0, v8),
					BackgroundTransparency = 1,
					LayoutOrder = layoutOrder
				}

				if GetFFlagEnableAuditForSinglePageSignUp() then
					return Roact.createElement(v9, v10, Cryo.Dictionary.join(fn3(), fn2()))
				end

				return Roact.createElement(v9, v10, fn3())
			end
		end)
	end)
end

local v2 = RoactRodux.connect(function(_, _)
	return {}
end, function(callback)
	return {
		navigateDown = function(p)
			if FFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p))
			end

			return callback(NavigateDown(p))
		end
	}
end)(extended)

local v3 = RoactAppPolicy.connect(function(p)
	return {
		useExternalBrowserForDisclaimerLinks = p.shouldUseExternalBrowserForDisclaimerLinks()
	}
end)(v2)

local v4 = roactServices.connect({ linking = AppLinking })(v3)

return function(p)
	local tokens = useDesignTokens()
	local uiModeInfo = useUiModeInfo()

	return Roact.createElement(v4, Cryo.Dictionary.join({ tokens = tokens, uiModeInfo = uiModeInfo }, p))
end
