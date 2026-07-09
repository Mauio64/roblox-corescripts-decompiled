local RobloxSubscriptionPurchaseApp = script:FindFirstAncestor("RobloxSubscriptionPurchaseApp")
local RobloxSubscriptionPurchaseAppParent = RobloxSubscriptionPurchaseApp.Parent
local Foundation = require(RobloxSubscriptionPurchaseAppParent.Foundation)
local React = require(RobloxSubscriptionPurchaseAppParent.React)
local InlineRichText = require(RobloxSubscriptionPurchaseAppParent.InlineRichText)
local Renderer = InlineRichText.Renderer
local LinkBehavior = InlineRichText.Enums.LinkBehavior
local useLocalization = require(RobloxSubscriptionPurchaseAppParent.Localization).Hooks.useLocalization
local FFlagSupportFreeTrial = require(RobloxSubscriptionPurchaseApp.Flags.FFlagSupportFreeTrial)
local FFlagRobloxPlusFAEFreeTrial = require(RobloxSubscriptionPurchaseApp.Flags.FFlagRobloxPlusFAEFreeTrial)
local v11 = game:DefineFastString("RobloxSubscriptionTermsOfUseLink", "https://en.help.roblox.com/hc/articles/46804865425300")

local function decodeLuauUnicodeEscapes(s1: string) -- line: 18
	return (s1:gsub("\\u{(%x+)}", function(s2: string) -- line: 20
		local num = tonumber(s2, 16)

		if num == nil or num < 0 or num > 1114111 then
			return ""
		end

		return utf8.char(num)
	end))
end
local function decodeInlineRichTextEntities(s3: string) -- line: 32
	return s3:gsub("&amp;lt;", "<"):gsub("&amp;gt;", ">"):gsub("&amp;quot;", "\""):gsub("&amp;apos;", "'"):gsub("&amp;amp;", "&"):gsub("&lt;", "<"):gsub("&gt;", ">"):gsub("&quot;", "\""):gsub("&apos;", "'"):gsub("&amp;", "&")
end
local function replaceQuotesOutsideTags(s4: string) -- line: 48
	local t1 = {}
	local v21 = false
	local v22 = true

	for i = 1, #s4 do
		local v24 = s4:sub(i, i)

		if v24 == "<" then
			v21 = true
			table.insert(t1, v24)
		elseif v24 == ">" then
			v21 = false
			table.insert(t1, v24)
		elseif v24 == "\"" and not v21 then
			table.insert(t1, if not v22 then utf8.char(8221) else utf8.char(8220))
			v22 = not v22
		else
			table.insert(t1, v24)
		end
	end

	return table.concat(t1)
end
local function prepareTermsAgreementRichText(s5: string) -- line: 70
	-- upvalues: FFlagSupportFreeTrial (copy), replaceQuotesOutsideTags (copy), decodeInlineRichTextEntities (copy)
	if FFlagSupportFreeTrial then
		return replaceQuotesOutsideTags(decodeInlineRichTextEntities((s5:gsub("\\u{(%x+)}", function(s6: string) -- line: 20
			local num = tonumber(s6, 16)

			if num == nil or num < 0 or num > 1114111 then
				return ""
			end

			return utf8.char(num)
		end))))
	end

	return decodeInlineRichTextEntities((s5:gsub("\\u{(%x+)}", function(s7: string) -- line: 20
		local num = tonumber(s7, 16)

		if num == nil or num < 0 or num > 1114111 then
			return ""
		end

		return utf8.char(num)
	end)))
end
local function LegalDisclosure(t2: {[any]: any}) -- line: 85
	-- upvalues: Foundation (copy), useLocalization (copy), v11 (copy), FFlagSupportFreeTrial (copy), FFlagRobloxPlusFAEFreeTrial (copy), React (copy), LinkBehavior (copy), Renderer (copy), replaceQuotesOutsideTags (copy), decodeInlineRichTextEntities (copy)
	local v27 = Foundation.Hooks.useTokens()
	local v28 = useLocalization({
		subscribe = "Feature.RobloxSubscription.Action.Subscribe"
	})
	local v29 = useLocalization({
		termsAgreement = {
			"Feature.RobloxSubscription.Disclosure.BlackbirdTermsAgreement",
			termsUrl = v11,
			ctaText = if not t2.ctaText or t2.ctaText == "" then v28.subscribe else t2.ctaText
		},
		freeTrialTermsAgreement = if not FFlagSupportFreeTrial then nil else {
			"Feature.RobloxSubscription.Label.FreeTrialDisclosureV2",
			linkStart = "<a href=\"" .. v11 .. "\">",
			linkEnd = "</a>"
		},
		shortFreeTrialTermsAgreement = if not FFlagRobloxPlusFAEFreeTrial then nil else {
			"Feature.RobloxSubscription.Label.FreeTrialDisclosureShort",
			linkStart = "<a href=\"" .. v11 .. "\">",
			linkEnd = "</a>"
		}
	})
	local v30 = React.useMemo(function() -- line: 114
		-- upvalues: LinkBehavior (copy)
		return {
			evaluateLinkBehavior = function(_: string, _) -- line: 116
				-- upvalues: LinkBehavior (copy)
				return LinkBehavior.Webview
			end
		}
	end, {})
	local v31 = if not FFlagRobloxPlusFAEFreeTrial or not t2.shortenFreeTrialTerms then if not FFlagSupportFreeTrial or not t2.isFreeTrial then v29.termsAgreement else v29.freeTrialTermsAgreement else v29.shortFreeTrialTermsAgreement

	return React.createElement(Renderer, {
		text = if not FFlagSupportFreeTrial then decodeInlineRichTextEntities((v31:gsub("\\u{(%x+)}", function(s9: string) -- line: 20
			local num = tonumber(s9, 16)

			if num == nil or num < 0 or num > 1114111 then
				return ""
			end

			return utf8.char(num)
		end))) else replaceQuotesOutsideTags(decodeInlineRichTextEntities((v31:gsub("\\u{(%x+)}", function(s10: string) -- line: 20
			local num = tonumber(s10, 16)

			if num == nil or num < 0 or num > 1114111 then
				return ""
			end

			return utf8.char(num)
		end)))),
		textStyle = v27.Color.Content.Default,
		fontStyle = v27.Typography.BodySmall,
		linkerOptions = v30,
		wrapperProps = {
			tag = "size-full-0 auto-y",
			LayoutOrder = t2.layoutOrder
		},
		nodeProps = {
			LINK = {
				showUnderline = true
			}
		}
	})
end

return LegalDisclosure
