local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local parent = RobloxSubscriptionPurchaseApp.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local InlineRichText = require(parent.InlineRichText)
local Renderer = InlineRichText.Renderer
local LinkBehavior = InlineRichText.Enums.LinkBehavior
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local getPeriodTypeDisplayLabel = require(RobloxSubscriptionPurchaseApp.Utils.getPeriodTypeDisplayLabel)
local isSupportedTrialPeriodType = require(RobloxSubscriptionPurchaseApp.Utils.isSupportedTrialPeriodType)
local FFlagSupportFreeTrial = require(RobloxSubscriptionPurchaseApp.Flags.FFlagSupportFreeTrial)
local FFlagRobloxPlusDynamicFreeTrialLength = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusDynamicFreeTrialLength)
local FFlagEnablePlusReferralLegalDisclosure = require(RobloxSubscriptionPurchaseApp.Flags.FFlagEnablePlusReferralLegalDisclosure)

local SharedFlags = require(parent.SharedFlags)
local FFlagSubscriptionSheetCampaignLocalizations = SharedFlags.FFlagSubscriptionSheetCampaignLocalizations

local defineFastString = game:DefineFastString(
	"RobloxSubscriptionTermsOfUseLink",
	"https://en.help.roblox.com/hc/articles/46804865425300"
)

local defineFastString2 = game:DefineFastString(
	"PlusReferralProgramTermsURL2",
	"https://en.help.roblox.com/hc/en-us/articles/52737229124628"
)

local function decodeLuauUnicodeEscapes(value: string)
	return (value:gsub("\\u{(%x+)}", function(p: string)
		local v = tonumber(p, 16)

		if v == nil or v < 0 or v > 1114111 then
			return ""
		end

		return utf8.char(v)
	end))
end

local function decodeInlineRichTextEntities(value: string)
	return value:gsub("&amp;lt;", "<"):gsub("&amp;gt;", ">"):gsub("&amp;quot;", "\""):gsub("&amp;apos;", "'"):gsub(
		"&amp;amp;",
		"&"
	):gsub(
		"&lt;",
		"<"
	):gsub(
		"&gt;",
		">"
	):gsub(
		"&quot;",
		"\""
	):gsub(
		"&apos;",
		"'"
	):gsub(
		"&amp;",
		"&"
	)
end

local function replaceQuotesOutsideTags(value: string)
	local v = {}
	local v2 = false
	local v3 = true

	for i = 1, #value do
		local v4 = value:sub(i, i)

		if v4 == "<" then
			table.insert(v, "<")
			v2 = true
		elseif v4 == ">" then
			table.insert(v, ">")
			v2 = false
		elseif v4 == "\"" and not v2 then
			local v5

			if v3 then
				v5 = utf8.char(8220)
			else
				v5 = utf8.char(8221)
			end

			table.insert(v, v5)
			v3 = not v3
		else
			table.insert(v, v4)
		end
	end

	return table.concat(v)
end

local function prepareTermsAgreementRichText(value: string)
	local function fn(p: string)
		local v = tonumber(p, 16)

		if v == nil or v < 0 or v > 1114111 then
			return ""
		end

		return utf8.char(v)
	end

	if FFlagSupportFreeTrial then
		return replaceQuotesOutsideTags(decodeInlineRichTextEntities(value:gsub("\\u{(%x+)}", fn)))
	end

	return decodeInlineRichTextEntities(value:gsub("\\u{(%x+)}", fn))
end

local function fillDisclosureTemplate(textTemplate: string, ctaText: string)
	local v = {
		linkStart = "<a href=\"" .. defineFastString .. "\">",
		linkEnd = "</a>",
		ctaText = ctaText
	}

	return (textTemplate:gsub("{(%w+)}", function(p: string)
		return v[p] or "{" .. p .. "}"
	end))
end

local function LegalDisclosure(props)
	local v = Foundation.Hooks.useTokens()

	local trialDuration = props.trialDuration or 1

	local v2 = FFlagSupportFreeTrial and FFlagRobloxPlusDynamicFreeTrialLength

	if v2 then
		if props.isFreeTrial == true and props.trialDuration ~= nil then
			v2 = isSupportedTrialPeriodType(props.trialPeriodType)
		else
			v2 = false
		end
	end

	local v3 = { subscribe = "Feature.RobloxSubscription.Action.Subscribe" }

	if v2 then
		v3.trialPeriodLabel = getPeriodTypeDisplayLabel(props.trialPeriodType or "", trialDuration > 1)
		v3.billingPeriodLabel = getPeriodTypeDisplayLabel(props.billingPeriodType or "", false)
	end

	local v4 = useLocalization(v3)

	local termsAgreement = {
		[1] = nil,
		"Feature.RobloxSubscription.Disclosure.BlackbirdTermsAgreement",
		termsUrl = defineFastString
	}
	local ctaText

	if props.ctaText and props.ctaText ~= "" then
		ctaText = props.ctaText
	else
		ctaText = v4.subscribe
	end

	termsAgreement.ctaText = ctaText
	local v5 = {
		termsAgreement = termsAgreement,
		freeTrialTermsAgreement = FFlagSupportFreeTrial and {
			"Feature.RobloxSubscription.Label.FreeTrialDisclosureV2",
			linkStart = "<a href=\"" .. defineFastString .. "\">",
			linkEnd = "</a>"
		} or nil,
		freeTrialTermsAgreementV3 = v2 and {
			"Feature.RobloxSubscription.Label.FreeTrialDisclosureV3",
			linkStart = "<a href=\"" .. defineFastString .. "\">",
			linkEnd = "</a>",
			trialDuration = trialDuration,
			trialPeriodLabel = v4.trialPeriodLabel,
			billingPeriodLabel = v4.billingPeriodLabel
		} or nil,
		shortFreeTrialTermsAgreement = {
			"Feature.RobloxSubscription.Label.FreeTrialDisclosureShort",
			linkStart = "<a href=\"" .. defineFastString .. "\">",
			linkEnd = "</a>"
		},
		referralTermsAgreement = 0
	}
	local referralTermsAgreement

	if FFlagEnablePlusReferralLegalDisclosure then
		referralTermsAgreement = {
			[1] = nil,
			"Feature.RobloxSubscription.Description.ReferralRecipientLegalDisclosurePurchase",
			referralTermsUrl = defineFastString2,
			termsUrl = defineFastString
		}
		local ctaText2

		if props.ctaText and props.ctaText ~= "" then
			ctaText2 = props.ctaText
		else
			ctaText2 = v4.subscribe
		end

		referralTermsAgreement.ctaText = ctaText2
	end

	v5.referralTermsAgreement = referralTermsAgreement
	local v6 = useLocalization(v5)

	local linkerOptions = React.useMemo(function()
		return {
			evaluateLinkBehavior = function(_: string, _)
				return LinkBehavior.Webview
			end
		}
	end, {})
	local v7

	if FFlagSubscriptionSheetCampaignLocalizations and props.textTemplate then
		local textTemplate = props.textTemplate
		local v8

		if props.ctaText and props.ctaText ~= "" then
			v8 = props.ctaText
		else
			v8 = v4.subscribe
		end

		v7 = fillDisclosureTemplate(textTemplate, v8)
	elseif FFlagEnablePlusReferralLegalDisclosure and props.isReferral then
		v7 = v6.referralTermsAgreement
	elseif props.shortenFreeTrialTerms then
		v7 = v6.shortFreeTrialTermsAgreement
	elseif v2 then
		v7 = v6.freeTrialTermsAgreementV3
	elseif FFlagSupportFreeTrial and props.isFreeTrial then
		v7 = v6.freeTrialTermsAgreement
	else
		v7 = v6.termsAgreement
	end

	local createElement = React.createElement
	local text

	local function fn(p: string)
		local v8 = tonumber(p, 16)

		if v8 == nil or v8 < 0 or v8 > 1114111 then
			return ""
		end

		return utf8.char(v8)
	end

	if FFlagSupportFreeTrial then
		text = replaceQuotesOutsideTags(decodeInlineRichTextEntities(v7:gsub("\\u{(%x+)}", fn)))
	else
		text = decodeInlineRichTextEntities(v7:gsub("\\u{(%x+)}", fn))
	end

	return createElement(Renderer, {
		text = text,
		textStyle = v.Color.Content.Default,
		fontStyle = v.Typography.BodySmall,
		linkerOptions = linkerOptions,
		wrapperProps = { tag = "size-full-0 auto-y", LayoutOrder = props.layoutOrder },
		nodeProps = {
			LINK = { showUnderline = true }
		}
	})
end

return LegalDisclosure
