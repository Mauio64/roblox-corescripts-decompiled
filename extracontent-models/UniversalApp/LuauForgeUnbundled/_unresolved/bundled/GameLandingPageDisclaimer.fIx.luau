local module = require("@luauforge/bundled/fHU")
local module2 = require("@luauforge/bundled/fHV")
local module3 = require("@luauforge/bundled/fIf")
local module4 = require("@luauforge/bundled/fIm")
local useLocalization = require("@luauforge/bundled/fHZ").Hooks.useLocalization
local module5 = require("@luauforge/bundled/fIw")
local renderer = module5.Renderer
local prepareRichTextCopy = module5.prepareRichTextCopy

local createLegalLinkRenderer = module3.Utils.createLegalLinkRenderer
local module6 = require("@luauforge/bundled/fHN")

local eventStreamConstants = module4.EventStreamConstants
local useOpenDisclaimerLinks = module3.Hooks.useOpenDisclaimerLinks

local view = module2.View
local useTokens = module2.Hooks.useTokens

local function GameLandingPageDisclaimer()
	local v5 = useTokens()
	local v6 = useLocalization({
		legalText = {
			"Feature.Landing.Description.ContinuedTermsDisclaimer",
			startTermsTag = "<a href=\"terms\">",
			endTermsTag = "</a>",
			startPrivacyTag = "<a href=\"privacy\">",
			endPrivacyTag = "</a>"
		}
	})

	local v7 = useOpenDisclaimerLinks({
		ctx = eventStreamConstants.Context.LandingScreen,
		disableExternalLinks = true
	})

	local v8 = module.useCallback(function(p2)
		if p2 == "terms" then
			v7.openTerms()
		elseif p2 == "privacy" then
			v7.openPrivacy()
		else
			v7.openLink(p2)
		end
	end, { v7 })

	local v9 = module.useMemo(function()
		return { LINK = createLegalLinkRenderer(v8) }
	end, { v8 })

	local v10 = module.useMemo(function()
		return prepareRichTextCopy(v6.legalText)
	end, { v6.legalText })

	return module.createElement(view, {
		tag = "col align-x-center size-full-0 auto-y",
		LayoutOrder = 2,
		padding = { top = UDim.new(0, v5.Size.Size_250) }
	}, {
		LegalText = module.createElement(renderer, {
			text = v10,
			renderers = v9,
			textStyle = v5.Color.Content.Muted,
			fontStyle = v5.Typography.CaptionSmall,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			wrapperProps = {
				tag = "size-full-0 auto-y",
				padding = {
					left = UDim.new(0, v5.Padding.XSmall),
					right = UDim.new(0, v5.Padding.XSmall)
				},
				sizeConstraint = { MaxSize = module6.Pioneer.MAX_CONTENT_SIZE },
				testId = "game-landing-page-disclaimer"
			}
		})
	})
end

return GameLandingPageDisclaimer
