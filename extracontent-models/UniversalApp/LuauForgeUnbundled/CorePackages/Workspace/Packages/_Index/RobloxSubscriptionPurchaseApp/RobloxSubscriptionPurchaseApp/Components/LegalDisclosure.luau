local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/React")
local InlineRichText = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/InlineRichText")
local renderer = InlineRichText.Renderer
local linkBehavior = InlineRichText.Enums.LinkBehavior
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxSubscriptionPurchaseApp/Localization").Hooks.useLocalization
local getPeriodTypeDisplayLabel = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/getPeriodTypeDisplayLabel")
local isSupportedTrialPeriodType = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Utils/isSupportedTrialPeriodType")
local FFlagSupportFreeTrial = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagSupportFreeTrial")
local FFlagRobloxPlusDynamicFreeTrialLength = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagRobloxPlusDynamicFreeTrialLength")
local FFlagEnablePlusReferralLegalDisclosure = require("@game/CorePackages/Workspace/Packages/_Index/RobloxSubscriptionPurchaseApp/RobloxSubscriptionPurchaseApp/Flags/FFlagEnablePlusReferralLegalDisclosure")

local defineFastString = game:DefineFastString(
	"RobloxSubscriptionTermsOfUseLink",
	"https://en.help.roblox.com/hc/articles/46804865425300"
)

local defineFastString2 = game:DefineFastString(
	"PlusReferralProgramTermsURL2",
	"https://en.help.roblox.com/hc/en-us/articles/52737229124628"
)

local function decodeLuauUnicodeEscapes(value)
	return (value:gsub("\\u{(%x+)}", function(p2)
		local v5 = tonumber(p2, 16)

		if v5 == nil or v5 < 0 or v5 > 1114111 then
			return ""
		end

		return utf8.char(v5)
	end))
end

local function decodeInlineRichTextEntities(value)
	return value:gsub("&amp;lt;", "<"):gsub("&amp;gt;", ">"):gsub("&amp;quot;", "\""):gsub(
		"&amp;apos;",
		"'"
	):gsub(
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

local function replaceQuotesOutsideTags(value)
	local v5 = {}
	local v6 = false
	local v7 = true

	for i = 1, #value do
		local v8 = value:sub(i, i)

		if v8 == "<" then
			table.insert(v5, "<")
			v6 = true
		elseif v8 == ">" then
			table.insert(v5, ">")
			v6 = false
		elseif v8 == "\"" and not v6 then
			local v9 = if v7 then utf8.char(8220) else utf8.char(8221)
			table.insert(v5, v9)
			v7 = not v7
		else
			table.insert(v5, v8)
		end
	end

	return table.concat(v5)
end

local function prepareTermsAgreementRichText(value)
	local function fn(p2)
		local v5 = tonumber(p2, 16)

		if v5 == nil or v5 < 0 or v5 > 1114111 then
			return ""
		end

		return utf8.char(v5)
	end

	if FFlagSupportFreeTrial then
		return replaceQuotesOutsideTags(decodeInlineRichTextEntities(value:gsub("\\u{(%x+)}", fn)))
	end

	return decodeInlineRichTextEntities(value:gsub("\\u{(%x+)}", fn))
end

local function LegalDisclosure(props)
	local v5 = Foundation.Hooks.useTokens()

	local trialDuration = props.trialDuration or 1

	local v6 = FFlagSupportFreeTrial and FFlagRobloxPlusDynamicFreeTrialLength

	if v6 then
		if props.isFreeTrial == true and props.trialDuration ~= nil then
			v6 = isSupportedTrialPeriodType(props.trialPeriodType)
		else
			v6 = false
		end
	end

	local v7 = { subscribe = "Feature.RobloxSubscription.Action.Subscribe" }

	if v6 then
		v7.trialPeriodLabel = getPeriodTypeDisplayLabel(props.trialPeriodType or "", trialDuration > 1)
		v7.billingPeriodLabel = getPeriodTypeDisplayLabel(props.billingPeriodType or "", false)
	end

	local v8 = useLocalization(v7)

	local v11 = {
		[1] = nil,
		"Feature.RobloxSubscription.Disclosure.BlackbirdTermsAgreement",
		termsUrl = defineFastString
	}

	local v12 = if props.ctaText and props.ctaText ~= "" then props.ctaText else v8.subscribe
	v11.ctaText = v12
	local v10 = {
		termsAgreement = v11,
		freeTrialTermsAgreement = FFlagSupportFreeTrial and {
			"Feature.RobloxSubscription.Label.FreeTrialDisclosureV2",
			linkStart = "<a href=\"" .. defineFastString .. "\">",
			linkEnd = "</a>"
		} or nil,
		freeTrialTermsAgreementV3 = v6 and {
			"Feature.RobloxSubscription.Label.FreeTrialDisclosureV3",
			linkStart = "<a href=\"" .. defineFastString .. "\">",
			linkEnd = "</a>",
			trialDuration = trialDuration,
			trialPeriodLabel = v8.trialPeriodLabel,
			billingPeriodLabel = v8.billingPeriodLabel
		} or nil,
		shortFreeTrialTermsAgreement = {
			"Feature.RobloxSubscription.Label.FreeTrialDisclosureShort",
			linkStart = "<a href=\"" .. defineFastString .. "\">",
			linkEnd = "</a>"
		},
		referralTermsAgreement = 0
	}
	local v13

	if FFlagEnablePlusReferralLegalDisclosure then
		v13 = {
			[1] = nil,
			"Feature.RobloxSubscription.Description.ReferralRecipientLegalDisclosurePurchase",
			referralTermsUrl = defineFastString2,
			termsUrl = defineFastString
		}

		local v14 = if props.ctaText and props.ctaText ~= "" then props.ctaText else v8.subscribe
		v13.ctaText = v14
	end

	v10.referralTermsAgreement = v13
	local v14 = useLocalization(v10)

	local v15 = React.useMemo(function()
		return {
			evaluateLinkBehavior = function(p2, p3)
				return linkBehavior.Webview
			end
		}
	end, {})
	local v16

	if FFlagEnablePlusReferralLegalDisclosure and props.isReferral then
		v16 = v14.referralTermsAgreement
	elseif props.shortenFreeTrialTerms then
		v16 = v14.shortFreeTrialTermsAgreement
	elseif v6 then
		v16 = v14.freeTrialTermsAgreementV3
	else
		v16 = if FFlagSupportFreeTrial and props.isFreeTrial then v14.freeTrialTermsAgreement else v14.termsAgreement
	end

	local createElement = React.createElement
	local v19

	local function fn(p2)
		local v20 = tonumber(p2, 16)

		if v20 == nil or v20 < 0 or v20 > 1114111 then
			return ""
		end

		return utf8.char(v20)
	end

	if FFlagSupportFreeTrial then
		v19 = replaceQuotesOutsideTags(decodeInlineRichTextEntities(v16:gsub("\\u{(%x+)}", fn)))
	else
		v19 = decodeInlineRichTextEntities(v16:gsub("\\u{(%x+)}", fn))
	end

	return createElement(renderer, {
		text = v19,
		textStyle = v5.Color.Content.Default,
		fontStyle = v5.Typography.BodySmall,
		linkerOptions = v15,
		wrapperProps = { tag = "size-full-0 auto-y", LayoutOrder = props.layoutOrder },
		nodeProps = {
			LINK = { showUnderline = true }
		}
	})
end

return LegalDisclosure
