local module = require("@luauforge/bundled/fHU")
local module2 = require("@luauforge/bundled/fHV")
local module3 = require("@luauforge/bundled/fIu")
local module4 = require("@luauforge/bundled/fIf")
local module5 = require("@luauforge/bundled/fIm")
local useLocalization = require("@luauforge/bundled/fHZ").Hooks.useLocalization

local disclaimerLinks = module4.Components.DisclaimerLinks
local disclaimerLinksVariant = module4.Enums.DisclaimerLinksVariant
local eventStreamConstants = module5.EventStreamConstants

require("@luauforge/bundled/fIa")
local fFlagEnablePioneerBrazilContentRatingBadge = require("@luauforge/bundled/fIg").FFlagEnablePioneerBrazilContentRatingBadge
local fFlagGameLandingPageAuthLayout = require("@luauforge/bundled/fIg").FFlagGameLandingPageAuthLayout
local module6 = require("@luauforge/bundled/fIr")
local module7 = require("@luauforge/bundled/fIv")
local module8 = require("@luauforge/bundled/fIx")
local module9 = require("@luauforge/bundled/fHN")

local view = module2.View
local button = module2.Button
local buttonVariant = module2.Enums.ButtonVariant
local inputSize = module2.Enums.InputSize
local useTokens = module2.Hooks.useTokens
local footer = module3.Components.Footer
local tiltLockup = module3.Components.TiltLockup
local useLoadingScreenAnimation = module3.useLoadingScreenAnimation

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function GameLandingPageView(props)
	local v5 = useTokens()
	local v6 = useLocalization({
		playNow = "Feature.Landing.Action.PlayNow",
		signInWithRoblox = "Feature.Landing.Action.SignInWithRoblox",
		signIn = fFlagGameLandingPageAuthLayout and "Authentication.Login.Action.SignInSentenceCase" or nil
	})

	local pioneer = module9.Pioneer

	local v7 = useLoadingScreenAnimation({
		reducedMotion = UserGameSettings.ReducedMotion,
		contentReady = props.gameName ~= nil,
		isDismissing = false
	})

	local v8 = if fFlagGameLandingPageAuthLayout then v5.Size.Size_1600 else v5.Size.Size_2500

	local v9 = if fFlagGameLandingPageAuthLayout then v6.signIn else v6.signInWithRoblox

	local createElement = module.createElement
	local v11 = {
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

	local v15 = {
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
				animation = v7,
				textWidthScale = fFlagGameLandingPageAuthLayout and 1 or nil
			})
		}),
		Content = 0
	}

	local createElement3 = module.createElement
	local v17 = {
		tag = "col align-x-center size-full-0 auto-y",
		LayoutOrder = 2,
		padding = {
			top = UDim.new(0, v8),
			left = UDim.new(0, v5.Size.Size_500),
			right = UDim.new(0, v5.Size.Size_500)
		}
	}

	local createElement4 = module.createElement
	local v20 = {
		tag = "col align-x-center gap-small size-full-0 auto-y",
		LayoutOrder = 1,
		sizeConstraint = { MaxSize = pioneer.MAX_CONTENT_SIZE }
	}

	local v22 = if not fFlagGameLandingPageAuthLayout then module.createElement(button, {
		LayoutOrder = 1,
		variant = buttonVariant.Emphasis,
		size = inputSize.Medium,
		text = v6.playNow,
		onActivated = props.onPlayNow,
		isLoading = props.isSignUpInProgress,
		width = UDim.new(1, 0),
		ref = props.defaultRef,
		testId = "game-landing-page-play-now"
	}) else nil

	local createElement5 = module.createElement
	local v24 = {
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
	local v25 = if fFlagGameLandingPageAuthLayout then inputSize.Large else inputSize.Medium
	v24.size = v25
	v24.text = v9
	v24.onActivated = props.onSignIn
	v24.isDisabled = props.isSignUpInProgress
	v24.width = UDim.new(1, 0)
	local v26 = if fFlagGameLandingPageAuthLayout then props.defaultRef else nil
	v24.ref = v26
	local v21 = {
		PlayNowButton = v22,
		SignInButton = createElement5(button, v24),
		CreateAccountLink = 0
	}
	local v27

	if fFlagGameLandingPageAuthLayout then
		v27 = module.createElement(module7, {
			LayoutOrder = 3,
			onCreateAccount = props.onCreateAccount or function() end
		})
	end

	v21.CreateAccountLink = v27
	local v18 = { Actions = createElement4(view, v20, v21), Disclaimer = 0 }

	local v28 = if not fFlagGameLandingPageAuthLayout then module.createElement(module8) else nil
	v18.Disclaimer = v28
	v15.Content = createElement3(view, v17, v18)
	local v12 = {
		Main = createElement2(view, {
			tag = {
				["col align-x-center align-y-center size-full"] = fFlagGameLandingPageAuthLayout,
				["col align-x-center align-y-center fill size-full-0"] = not fFlagGameLandingPageAuthLayout
			},
			LayoutOrder = 1
		}, v15),
		LegalFooter = 0,
		Footer = 0
	}

	local v29 = if fFlagGameLandingPageAuthLayout then module.createElement(view, {
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
	v12.LegalFooter = v29

	local v30 = if not fFlagGameLandingPageAuthLayout then module.createElement(footer, {
		LayoutOrder = 2,
		tag = "auto-xy padding-bottom-xxlarge",
		testId = "game-landing-page-powered-by",
		textTestId = "game-landing-page-powered-by-text",
		wordmarkTestId = "game-landing-page-powered-by-wordmark"
	}) else nil
	v12.Footer = v30
	local element = createElement(view, v11, v12)

	if not fFlagEnablePioneerBrazilContentRatingBadge then
		return element
	end

	local createElement6 = module.createElement
	local v32 = {
		tag = "size-full",
		backgroundStyle = v5.Color.Extended.Black.Black_100
	}

	local v34 = if props.showBrazilContentRatingBadge then module.createElement(view, {
		tag = "auto-xy",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -v5.Size.Size_600, 0, v5.Size.Size_600),
		ZIndex = 2,
		testId = "game-landing-page-brazil-content-rating-badge"
	}, { Badge = module.createElement(module6) }) else nil
	return createElement6(view, v32, {
		PageContent = element,
		BrazilContentRatingBadge = v34
	})
end

return GameLandingPageView
