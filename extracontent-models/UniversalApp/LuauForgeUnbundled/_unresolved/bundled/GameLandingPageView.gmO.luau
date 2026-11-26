local module = require("@luauforge/bundled/gmo")
local module2 = require("@luauforge/bundled/gmp")
local module3 = require("@luauforge/bundled/gmP")
local module4 = require("@luauforge/bundled/gmz")
local module5 = require("@luauforge/bundled/gmH")
require("@luauforge/bundled/gmL")
local useLocalization = require("@luauforge/bundled/gmt").Hooks.useLocalization

local disclaimerLinks = module4.Components.DisclaimerLinks
local disclaimerLinksVariant = module4.Enums.DisclaimerLinksVariant
local eventStreamConstants = module5.EventStreamConstants

require("@luauforge/bundled/gmu")
local fFlagEnablePioneerBrazilContentRatingBadge = require("@luauforge/bundled/gmA").FFlagEnablePioneerBrazilContentRatingBadge
local fFlagGameLandingPageAuthLayout = require("@luauforge/bundled/gmA").FFlagGameLandingPageAuthLayout
local fFlagEnablePioneerLandingPageSso = require("@luauforge/bundled/gmA").FFlagEnablePioneerLandingPageSso
local module6 = require("@luauforge/bundled/gmK")
local module7 = require("@luauforge/bundled/gmM")
local module8 = require("@luauforge/bundled/gmQ")
local module9 = require("@luauforge/bundled/gmS")
local module10 = require("@luauforge/bundled/gmh")

local view = module2.View
local button = module2.Button
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize
local useTokens = module2.Hooks.useTokens
local normalizeFontFace = module2.Utility.normalizeFontFace
local footer = module3.Components.Footer
local tiltLockup = module3.Components.TiltLockup
local useLoadingScreenAnimation = module3.useLoadingScreenAnimation

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function GameLandingPageView(props)
	local v5 = useTokens()

	local v6 = nil
	local externalIdentityProviders, v7, v8

	if fFlagEnablePioneerLandingPageSso then
		externalIdentityProviders = props.externalIdentityProviders or {}
		v7 = fFlagGameLandingPageAuthLayout

		if v7 then
			v7 = #externalIdentityProviders > 0 and props.onExternalIdentityActivated ~= nil
		end

		v8 = props.activeExternalIdentityProvider ~= nil or props.isSignUpInProgress == true

		if v7 then
			v6 = normalizeFontFace(v5.Typography.CaptionSmall.Font)
		end
	end

	local v9 = useLocalization({
		playNow = "Feature.Landing.Action.PlayNow",
		signInWithRoblox = "Feature.Landing.Action.SignInWithRoblox",
		signIn = fFlagGameLandingPageAuthLayout and "Authentication.Login.Action.SignInSentenceCase" or nil,
		orText = fFlagEnablePioneerLandingPageSso and v7 and "Authentication.SignUp.Description.Or" or nil
	})

	local pioneer = module10.Pioneer

	local v10 = useLoadingScreenAnimation({
		reducedMotion = UserGameSettings.ReducedMotion,
		contentReady = props.gameName ~= nil,
		isDismissing = false
	})

	local v11 = if fFlagGameLandingPageAuthLayout then v5.Size.Size_1600 else v5.Size.Size_2500

	local v12 = if fFlagGameLandingPageAuthLayout then v9.signIn else v9.signInWithRoblox

	local createElement = module.createElement
	local v14 = {
		tag = {
			["size-full"] = fFlagGameLandingPageAuthLayout,
			["col align-x-center size-full"] = not fFlagGameLandingPageAuthLayout
		},
		backgroundStyle = v5.Color.Extended.Black.Black_100,
		testId = "game-landing-page",
		ref = props.containerRef,
		ZIndex = fFlagEnablePioneerBrazilContentRatingBadge and 1 or nil
	}

	local createElement2 = module.createElement

	local v18 = {
		Lockup = module.createElement(view, {
			tag = "col align-x-center auto-y",
			Size = UDim2.new(fFlagGameLandingPageAuthLayout and 1 or 0.7, 0, 0, 0),
			padding = fFlagGameLandingPageAuthLayout and {
				left = UDim.new(0, v5.Size.Size_500),
				right = UDim.new(0, v5.Size.Size_500)
			} or nil,
			LayoutOrder = 1
		}, {
			TiltLockup = module.createElement(tiltLockup, {
				gameName = props.gameName,
				creatorName = props.creatorName,
				isCreatorVerified = props.isCreatorVerified,
				thumbnailUrl = props.thumbnailUrl,
				animation = v10,
				textWidthScale = fFlagGameLandingPageAuthLayout and 1 or nil
			})
		}),
		Content = 0
	}

	local createElement3 = module.createElement
	local v20 = {
		tag = "col align-x-center size-full-0 auto-y",
		LayoutOrder = 2,
		padding = {
			top = UDim.new(0, v11),
			left = UDim.new(0, v5.Size.Size_500),
			right = UDim.new(0, v5.Size.Size_500)
		}
	}

	local createElement4 = module.createElement
	local v23 = {
		tag = "col align-x-center gap-small size-full-0 auto-y",
		LayoutOrder = 1,
		sizeConstraint = { MaxSize = pioneer.MAX_CONTENT_SIZE }
	}

	local v25 = if fFlagEnablePioneerLandingPageSso and v7 and externalIdentityProviders ~= nil and props.onExternalIdentityActivated ~= nil then module.createElement(
		view,
		{
			LayoutOrder = 1,
			tag = "col size-full-0 auto-y",
			testId = "game-landing-page-sso"
		},
		{
			Options = module.createElement(module6, {
				providers = externalIdentityProviders,
				layoutOrder = 1,
				size = inputSize.Large,
				showDivider = false,
				isDisabled = v8,
				onActivated = props.onExternalIdentityActivated
			}),
			Divider = module.createElement(view, {
				LayoutOrder = 2,
				tag = "row align-y-center gap-medium size-full-0 auto-y",
				padding = {
					top = UDim.new(0, v5.Size.Size_500),
					bottom = UDim.new(0, v5.Size.Size_500 - v5.Gap.Small)
				},
				testId = "game-landing-page-sso-divider"
			}, {
				Left = module.createElement(view, {
					LayoutOrder = 1,
					tag = "grow auto-y"
				}, {
					Line = module.createElement(module2.Divider, {
						orientation = module2.Enums.Orientation.Horizontal,
						testId = "game-landing-page-sso-divider-left"
					})
				}),
				Label = module.createElement(module2.Text, {
					LayoutOrder = 2,
					Text = v9.orText,
					tag = "auto-xy text-caption-small",
					textStyle = v5.Color.Content.Muted,
					fontStyle = v6 and {
						Font = Font.new(v6.Family, Enum.FontWeight.SemiBold, v6.Style)
					} or nil
				}),
				Right = module.createElement(view, {
					LayoutOrder = 3,
					tag = "grow auto-y"
				}, {
					Line = module.createElement(module2.Divider, {
						orientation = module2.Enums.Orientation.Horizontal,
						testId = "game-landing-page-sso-divider-right"
					})
				})
			})
		}
	) else nil

	local v26 = if not fFlagGameLandingPageAuthLayout then module.createElement(button, {
		LayoutOrder = 1,
		variant = buttonVariant.Emphasis,
		size = inputSize.Medium,
		text = v9.playNow,
		onActivated = props.onPlayNow,
		isLoading = props.isSignUpInProgress,
		width = UDim.new(1, 0),
		ref = props.defaultRef,
		testId = "game-landing-page-play-now"
	}) else nil

	local createElement5 = module.createElement
	local v28 = {
		LayoutOrder = 2,
		variant = buttonVariant.Standard,
		size = 0,
		text = 0,
		onActivated = 0,
		isDisabled = 0,
		width = 0,
		ref = 0,
		testId = "game-landing-page-sign-in"
	}
	local v29 = if fFlagGameLandingPageAuthLayout then inputSize.Large else inputSize.Medium
	v28.size = v29
	v28.text = v12
	v28.onActivated = props.onSignIn

	if not fFlagEnablePioneerLandingPageSso then
		v8 = props.isSignUpInProgress
	end

	v28.isDisabled = v8

	v28.width = UDim.new(1, 0)
	local v30 = if fFlagGameLandingPageAuthLayout then props.defaultRef else nil
	v28.ref = v30
	local v24 = {
		Sso = v25,
		PlayNowButton = v26,
		SignInButton = createElement5(button, v28),
		CreateAccountLink = 0
	}
	local v31

	if fFlagGameLandingPageAuthLayout then
		v31 = module.createElement(module8, {
			LayoutOrder = 3,
			onCreateAccount = props.onCreateAccount or function() end
		})
	end

	v24.CreateAccountLink = v31
	local v21 = { Actions = createElement4(view, v23, v24), Disclaimer = 0 }

	local v32 = if not fFlagGameLandingPageAuthLayout then module.createElement(module9) else nil
	v21.Disclaimer = v32
	v18.Content = createElement3(view, v20, v21)
	local v15 = {
		Main = createElement2(view, {
			tag = {
				["col align-x-center align-y-center size-full"] = fFlagGameLandingPageAuthLayout,
				["col align-x-center align-y-center fill size-full-0"] = not fFlagGameLandingPageAuthLayout
			},
			LayoutOrder = 1
		}, v18),
		LegalFooter = 0,
		Footer = 0
	}

	local v33 = if fFlagGameLandingPageAuthLayout then module.createElement(view, {
		tag = "col align-x-center auto-xy",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, 0),
		ZIndex = 2,
		padding = {
			bottom = UDim.new(0, v5.Size.Size_800 - v5.Padding.Small)
		},
		testId = "game-landing-page-legal-footer"
	}, {
		Links = module.createElement(disclaimerLinks, {
			variant = disclaimerLinksVariant.Foundation,
			underlineLinks = true,
			underlinedLinkTextTag = "text-body-small",
			ctx = eventStreamConstants.Context.LandingScreen
		})
	}) else nil
	v15.LegalFooter = v33

	local v34 = if not fFlagGameLandingPageAuthLayout then module.createElement(footer, {
		LayoutOrder = 2,
		tag = "auto-xy padding-bottom-xxlarge",
		testId = "game-landing-page-powered-by",
		textTestId = "game-landing-page-powered-by-text",
		wordmarkTestId = "game-landing-page-powered-by-wordmark"
	}) else nil
	v15.Footer = v34
	local element = createElement(view, v14, v15)

	if not fFlagEnablePioneerBrazilContentRatingBadge then
		return element
	end

	local createElement6 = module.createElement
	local v36 = {
		tag = "size-full",
		backgroundStyle = v5.Color.Extended.Black.Black_100
	}

	local v38 = if props.showBrazilContentRatingBadge then module.createElement(view, {
		tag = "auto-xy",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -v5.Size.Size_600, 0, v5.Size.Size_600),
		ZIndex = 2,
		testId = "game-landing-page-brazil-content-rating-badge"
	}, { Badge = module.createElement(module7) }) else nil
	return createElement6(view, v36, {
		PageContent = element,
		BrazilContentRatingBadge = v38
	})
end

return GameLandingPageView
