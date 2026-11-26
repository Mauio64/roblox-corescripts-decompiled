local module = require("@luauforge/bundled/gVG")
local module2 = require("@luauforge/bundled/gVI")
local view = module2.View
local button = module2.Button
local buttonVariant = module2.Enums.ButtonVariant
local buttonSize = module2.Enums.ButtonSize
local fillBehavior = module2.Enums.FillBehavior
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/Localization").Hooks.useLocalization
local module3 = require("@luauforge/bundled/gVU")
local renderer = module3.Renderer
local linkBehavior = module3.Enums.LinkBehavior

local module4 = require("@luauforge/bundled/gVL")
local Escape = require("@game/CorePackages/Packages/_Index/MarkdownCore/MarkdownCore/Utils/Escape")

local module6 = require("@luauforge/bundled/gVW")

local defineFastString = game:DefineFastString(
	"PlusReferralProgramTermsURL",
	"https://en.help.roblox.com/hc/en-us/articles/52737229124628-Roblox-Plus-Referral-Program-Terms"
)

local function ReferActionBar(props)
	local v5 = module2.Hooks.useTokens()
	local bottomInset = props.bottomInset or 0

	local v8 = Escape(useLocalization({
		legalDisclosure = {
			"Feature.RobloxSubscription.Label.ReferralsLegalDisclosureV2",
			linkStart = "<a href=\"" .. defineFastString .. "\">",
			linkEnd = "</a>"
		}
	}).legalDisclosure)

	local v9 = module.useMemo(function()
		return {
			evaluateLinkBehavior = function(p2, p3)
				return linkBehavior.Webview
			end
		}
	end, {})

	local createElement = module.createElement
	local v11 = {
		tag = "col size-full-0 auto-y padding-x-xlarge padding-top-large bg-surface-0",
		LayoutOrder = props.layoutOrder,
		padding = {
			bottom = UDim.new(0, (math.max(bottomInset, module4.ACTION_BAR_MIN_BOTTOM_PADDING)))
		}
	}
	local v13

	if module6.FFlagFixPlusReferralButtonLayout then
		v13 = module.createElement(view, {
			tag = "size-full-0 auto-y",
			flexItem = { FlexMode = Enum.UIFlexMode.None },
			LayoutOrder = 1
		}, {
			Button = module.createElement(button, {
				text = props.buttonText,
				onActivated = props.onActivated,
				isDisabled = props.isDisabled,
				variant = buttonVariant.Emphasis,
				size = buttonSize.Medium,
				width = UDim.new(1, 0),
				fillBehavior = fillBehavior.Fill
			})
		})
	else
		v13 = module.createElement(button, {
			text = props.buttonText,
			onActivated = props.onActivated,
			isDisabled = props.isDisabled,
			variant = buttonVariant.Emphasis,
			size = buttonSize.Medium,
			width = UDim.new(1, 0),
			fillBehavior = fillBehavior.Fill,
			LayoutOrder = 1
		})
	end

	return createElement(view, v11, {
		ReferButton = v13,
		LegalDisclosure = module.createElement(renderer, {
			text = v8,
			textStyle = v5.Color.Content.Default,
			fontStyle = v5.Typography.CaptionSmall,
			linkerOptions = v9,
			wrapperProps = {
				tag = "size-full-0 auto-y padding-top-medium",
				LayoutOrder = 2
			},
			nodeProps = {
				LINK = { showUnderline = true }
			}
		})
	})
end

return ReferActionBar
