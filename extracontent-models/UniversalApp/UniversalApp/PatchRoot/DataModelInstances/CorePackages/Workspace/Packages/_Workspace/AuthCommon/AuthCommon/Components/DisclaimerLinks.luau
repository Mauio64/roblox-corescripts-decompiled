local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local Roact = require(AuthCommonParent.Roact)
local RoactRodux = require(AuthCommonParent.RoactRodux)
local UIBlox = require(AuthCommonParent.UIBlox)
local Text = require(AuthCommonParent.AppCommonLib).Text
local LinkButton = UIBlox.App.Button.LinkButton
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local AppLinking = require(AuthCommonParent.RoactServiceTags).AppLinking
local RoactServices = require(AuthCommonParent.RoactServices).RoactServices
local RoactAppPolicy = require(AuthCommonParent.UniversalAppPolicy).RoactAppPolicy
local Cryo = require(AuthCommonParent.Cryo)
local useDesignTokens = require(AuthCommonParent.Style).useDesignTokens
local UiMode = require(AuthCommonParent.RobloxAppEnums).UiMode
local useUiModeInfo = require(AuthCommonParent.RobloxAppHooks).useUiModeInfo
local FFlagFoundationStylingOnSignUp = require(AuthCommonParent.SharedFlags).FFlagFoundationStylingOnSignUp
local DisclaimerLinksVariant = require(AuthCommon.Enums.DisclaimerLinksVariant)
local FitChildren = require(AuthCommon.Components.FitChildren)
local NavigateDown = require(AuthCommonParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(AuthCommonParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v23 = if not FFlagSignalsNavP3Dispatch then nil else require(AuthCommonParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(AuthCommonParent.RobloxAppEnums).AppPage
local TransitionAnimation = require(AuthCommon.Enums.TransitionAnimation)
local withLocalization = require(AuthCommonParent.Localization).withLocalization
local withStyle = UIBlox.Style.withStyle
local OpenExternalBrowser = require(AuthCommon.Thunks.OpenExternalBrowser)
local UrlBuilder = require(AuthCommonParent.UrlBuilder).UrlBuilder
local AuthAnalytics = require(AuthCommonParent.AuthAnalytics)
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local DisclaimerLinkButtons = require(script.Parent.DisclaimerLinkButtons)
local RegisterAuditContent = require(AuthCommon.Components.RegisterAuditContent)
local RegisterAdditionalAuditContent = require(AuthCommon.Components.RegisterAdditionalAuditContent)
local GetFFlagEnableAuditForSinglePageSignUp = require(AuthCommonParent.SharedFlags).GetFFlagEnableAuditForSinglePageSignUp
local t1 = {
	[DisclaimerLinksVariant.Default] = "TextDefault",
	[DisclaimerLinksVariant.Link] = nil
}
local v38 = Roact.PureComponent:extend("DisclaimerLinks")

function v38.init(p1) -- line: 62
	-- upvalues: OpenExternalBrowser (copy), AppPage (copy), TransitionAnimation (copy), UrlBuilder (copy), authFormInteraction (copy), EventStreamConstants (copy)
	function p1.openDisclaimerLink(p2) -- line: 63
		-- upvalues: p1 (copy), OpenExternalBrowser (copy), AppPage (copy), TransitionAnimation (copy)
		if p1.props.useExternalBrowserForDisclaimerLinks then
			OpenExternalBrowser(p1.props.linking, p2)

			return
		end

		p1.props.navigateDown({
			name = AppPage.GenericWebPage,
			detail = p2,
			extraProps = {
				title = "",
				transitionAnimation = TransitionAnimation.SlideInFromRight
			}
		})
	end
	function p1.openTermsLink() -- line: 78
		-- upvalues: UrlBuilder (copy), p1 (copy), authFormInteraction (copy), EventStreamConstants (copy)
		local v55 = UrlBuilder.static.about.terms()

		if p1.props.ctx then
			authFormInteraction(p1.props.ctx, EventStreamConstants.Field.TermsOfService, p1.props.state)
		end

		p1.openDisclaimerLink(v55)
	end
	function p1.openPrivacyLink() -- line: 86
		-- upvalues: UrlBuilder (copy), p1 (copy), authFormInteraction (copy), EventStreamConstants (copy)
		local v56 = UrlBuilder.static.about.privacy()

		if p1.props.ctx then
			authFormInteraction(p1.props.ctx, EventStreamConstants.Field.PrivacyPolicy, p1.props.state)
		end

		p1.openDisclaimerLink(v56)
	end
end
function v38.render(p3) -- line: 95
	-- upvalues: withLocalization (copy), withStyle (copy), UiMode (copy), FFlagFoundationStylingOnSignUp (copy), t1 (copy), Text (copy), FitChildren (copy), Roact (copy), ImageSetLabel (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), RegisterAuditContent (copy), RegisterAdditionalAuditContent (copy), UrlBuilder (copy), ContextualMenu (copy), MenuDirection (copy), LinkButton (copy), Cryo (copy), DisclaimerLinkButtons (copy)
	local isDualLayout = p3.props.isDualLayout
	local LoginView = p3.props.tokens.LuaApps.LoginView
	local v46 = not LoginView and 4 or LoginView.boxPadding

	return withLocalization({
		termsOfUseText = "CommonUI.Features.Label.Terms",
		termsOfUseTextLong = "CommonUI.Features.Label.TermsOfUse",
		privacyPolicyText = "CommonUI.Features.Label.Privacy",
		privacyPolicyTextLong = "CommonUI.Features.Label.PrivacyPolicy"
	})(function(p4) -- line: 106
		-- upvalues: withStyle (copy), p3 (copy), UiMode (copy), FFlagFoundationStylingOnSignUp (copy), t1 (copy), isDualLayout (copy), Text (copy), v46 (copy), FitChildren (copy), Roact (copy), ImageSetLabel (copy), LoginView (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), RegisterAuditContent (copy), RegisterAdditionalAuditContent (copy), UrlBuilder (copy), ContextualMenu (copy), MenuDirection (copy), LinkButton (copy), Cryo (copy), DisclaimerLinkButtons (copy)
		return withStyle(function(p5) -- line: 107
			-- upvalues: p3 (copy), UiMode (copy), FFlagFoundationStylingOnSignUp (copy), t1 (copy), isDualLayout (copy), p4 (copy), Text (copy), v46 (copy), FitChildren (copy), Roact (copy), ImageSetLabel (copy), LoginView (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), RegisterAuditContent (copy), RegisterAdditionalAuditContent (copy), UrlBuilder (copy), ContextualMenu (copy), MenuDirection (copy), LinkButton (copy), Cryo (copy), DisclaimerLinkButtons (copy)
			local v60 = p3.props.uiModeInfo.uiMode == UiMode.TenFoot
			local propsLayoutOrder = p3.props.LayoutOrder
			local v62 = if not FFlagFoundationStylingOnSignUp then nil else t1[p3.props.variant]
			local BaseSize = p5.Font.BaseSize
			local v64 = not isDualLayout and "CommonUI.Features.Label.Terms" or "CommonUI.Features.Label.TermsOfUse"
			local v65 = not isDualLayout and "CommonUI.Features.Label.Privacy" or "CommonUI.Features.Label.PrivacyPolicy"
			local v66 = if not isDualLayout then p4.termsOfUseText else p4.termsOfUseTextLong
			local v67 = if not isDualLayout then "<b>" .. p4.privacyPolicyText .. "</b>" else p4.privacyPolicyTextLong
			local Header2Font = p5.Font.Header2.Font
			local v69 = Text.GetTextWidth(" ", Header2Font, BaseSize) / 2
			local v70 = Text.GetTextWidth("-", Header2Font, BaseSize)
			local v71 = Text.GetTextHeight(p4.privacyPolicyText, Header2Font, BaseSize) + v46

			if isDualLayout then
				v71 = 2 * (Text.GetTextHeight(p4.privacyPolicyText, Header2Font, BaseSize) + 2 * v46)
			end

			local v72 = if not isDualLayout then FitChildren.FitFrame else "Frame"

			local function v73() -- line: 141
				-- upvalues: Roact (copy), ImageSetLabel (copy), LoginView (copy), p5 (copy)
				return {
					Image = Roact.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						ImageTransparency = 0,
						Size = UDim2.new(0, LoginView.disclaimerIconSize, 0, LoginView.disclaimerIconSize),
						Position = UDim2.fromOffset(0, 0),
						ScaleType = Enum.ScaleType.Fit,
						Image = LoginView.linkIcon,
						ImageColor3 = p5.Theme.UIEmphasis.Color
					})
				}
			end
			local function v74() -- line: 156
				-- upvalues: p3 (copy), GetFFlagEnableAuditForSinglePageSignUp (copy), RegisterAuditContent (copy), v66 (copy), Roact (copy), v64 (copy), v67 (copy), v65 (copy), isDualLayout (copy), p4 (copy), RegisterAdditionalAuditContent (copy), UrlBuilder (copy)
				if not p3.props.enableAuditContentCapture or not GetFFlagEnableAuditForSinglePageSignUp() then
					return {}
				end

				return {
					TermsAuditContent = RegisterAuditContent and (v66 and Roact.createElement(RegisterAuditContent, {
						translationKey = v64,
						translatedSourceString = v66
					})),
					PrivacyAuditContent = RegisterAuditContent and (v67 and Roact.createElement(RegisterAuditContent, {
						translationKey = v65,
						translatedSourceString = if not isDualLayout then p4.privacyPolicyText else p4.privacyPolicyTextLong
					})),
					TermsLinkAuditContent = RegisterAdditionalAuditContent and Roact.createElement(RegisterAdditionalAuditContent, {
						contentKey = "termsLink",
						value = UrlBuilder.static.about.terms()
					}),
					PrivacyLinkAuditContent = RegisterAdditionalAuditContent and Roact.createElement(RegisterAdditionalAuditContent, {
						contentKey = "privacyLink",
						value = UrlBuilder.static.about.privacy()
					})
				}
			end
			local function v75() -- line: 189
				-- upvalues: Roact (copy), v69 (copy), isDualLayout (copy), ContextualMenu (copy), v66 (copy), p5 (copy), p3 (copy), LoginView (copy), v73 (copy), v67 (copy), MenuDirection (copy), LinkButton (copy), v62 (copy), v70 (copy), Header2Font (copy), BaseSize (copy)
				return {
					UIListLayout = Roact.createElement("UIListLayout", {
						Padding = UDim.new(0, v69),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = if not isDualLayout then Enum.FillDirection.Horizontal else Enum.FillDirection.Vertical,
						HorizontalAlignment = if not isDualLayout then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					ContextualMenu = if not isDualLayout then nil else Roact.createElement(ContextualMenu, {
						open = true,
						stayOnActivated = true,
						isElementBackgroundVisible = false,
						isElementDividerVisible = false,
						closeBackgroundVisible = false,
						topElementRounded = false,
						bottomElementRounded = false,
						buttonProps = {
							{
								text = v66,
								fontStyle = p5.Font.Header1,
								onActivated = p3.openTermsLink,
								rightSideGadgetSize = Vector2.new(LoginView.disclaimerIconSize + LoginView.disclaimerPadding, LoginView.disclaimerIconSize),
								renderRightSideGadget = v73
							},
							{
								text = v67,
								fontStyle = p5.Font.Header1,
								onActivated = p3.openPrivacyLink,
								rightSideGadgetSize = Vector2.new(LoginView.disclaimerIconSize + LoginView.disclaimerPadding, LoginView.disclaimerIconSize),
								renderRightSideGadget = v73
							}
						},
						horizontalAlignment = Enum.HorizontalAlignment.Center,
						menuDirection = MenuDirection.Down,
						contextMenuWidthOverride = UDim.new(1, 0),
						elementHeight = LoginView.disclaimerElementHeight,
						openPositionX = UDim.new(0, 0),
						openPositionY = UDim.new(0, 0),
						screenSize = Vector2.new(0, 0)
					}),
					TermsOfUse = if isDualLayout then nil else Roact.createElement(LinkButton, {
						fontStyle = "Header2",
						layoutOrder = 1,
						underlineAlwaysEnabled = true,
						text = v66,
						size = if not isDualLayout then UDim2.new(0, 0, 1, 0) else UDim2.new(1, 0, 0.5, 0),
						onActivated = p3.openTermsLink,
						colorStyleDefault = v62,
						colorStyleHover = v62
					}),
					Hyphen = if isDualLayout then nil else Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Text = " ",
						LayoutOrder = 2,
						Size = UDim2.new(0, v70, 1, 0),
						Font = Header2Font,
						TextColor3 = p5.Theme.TextEmphasis.Color,
						TextTransparency = p5.Theme.TextEmphasis.Transparency,
						TextSize = BaseSize
					}),
					PrivacyPolicy = if isDualLayout then nil else Roact.createElement(LinkButton, {
						fontStyle = "Header2",
						layoutOrder = 3,
						underlineAlwaysEnabled = true,
						text = v67,
						size = if not isDualLayout then UDim2.new(0, 0, 1, 0) else UDim2.new(1, 0, 0.5, 0),
						onActivated = p3.openPrivacyLink,
						colorStyleDefault = v62,
						colorStyleHover = v62
					})
				}
			end

			if v60 then
				if GetFFlagEnableAuditForSinglePageSignUp() then
					return Roact.createFragment(Cryo.Dictionary.join({
						DisclaimerLinkButtons = Roact.createElement(DisclaimerLinkButtons, {
							textTos = v66,
							activatedTos = p3.openTermsLink,
							textPrivacy = v67,
							activatedPrivacy = p3.openPrivacyLink,
							fillDirection = p3.props.fillDirection,
							layoutOrder = propsLayoutOrder,
							tokens = LoginView
						})
					}, (v74())))
				end

				return Roact.createElement(DisclaimerLinkButtons, {
					textTos = v66,
					activatedTos = p3.openTermsLink,
					textPrivacy = v67,
					activatedPrivacy = p3.openPrivacyLink,
					fillDirection = p3.props.fillDirection,
					layoutOrder = propsLayoutOrder,
					tokens = LoginView
				})
			end

			local t2 = {
				BackgroundTransparency = 1,
				fitAxis = if isDualLayout then nil else FitChildren.FitAxis.Width,
				Size = UDim2.new(1, 0, 0, v71),
				LayoutOrder = propsLayoutOrder
			}

			if GetFFlagEnableAuditForSinglePageSignUp() then
				return Roact.createElement(v72, t2, Cryo.Dictionary.join(v75(), (v74())))
			end

			return Roact.createElement(v72, t2, (v75()))
		end)
	end)
end

local v39 = RoactRodux.connect(function(_, _) -- line: 328
	return {}
end, function(p8) -- line: 330
	-- upvalues: FFlagSignalsNavP3Dispatch (copy), v23 (copy), NavigateDown (copy)
	return {
		navigateDown = function(p9) -- line: 332
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v23 (copy), p8 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v23.down(v23.fromLegacyPage(p9))
			end

			return p8(NavigateDown(p9))
		end
	}
end)(v38)
local v40 = RoactAppPolicy.connect(function(p10) -- line: 342
	return {
		useExternalBrowserForDisclaimerLinks = p10.shouldUseExternalBrowserForDisclaimerLinks()
	}
end)(v39)
local v41 = RoactServices.connect({
	linking = AppLinking
})(v40)

return function(p11) -- line: 353
	-- upvalues: useDesignTokens (copy), useUiModeInfo (copy), Roact (copy), v41 (copy), Cryo (copy)
	local v52 = useDesignTokens()
	local v53 = useUiModeInfo()

	return Roact.createElement(v41, Cryo.Dictionary.join({
		tokens = v52,
		uiModeInfo = v53
	}, p11))
end
