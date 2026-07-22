local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
local ControlState = Foundation.Enums.ControlState
local FoundationText = Foundation.Text
local AbuseReportAnalyticsContext = require(GenericAbuseReporting.BeduiV2.Analytics.AbuseReportAnalyticsContext)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local useOpenLink = require(GenericAbuseReporting.BeduiV2.Hooks.useOpenLink)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local v12 = game:DefineFastFlag("AddFontStyleToTextWithTranslation", false)
local v13 = game:DefineFastFlag("AddUnderlineToLinksInTextWithTranslation", false)
local FFlagAbuseReportLinkOpenedAnalytics = SharedFlags.FFlagAbuseReportLinkOpenedAnalytics
local TelemetryEventType = analyticsService.TelemetryEventType
local useOptionalAbuseReportAnalytics = AbuseReportAnalyticsContext.useOptionalAbuseReportAnalytics

local function TextWithTranslation(t1: {[any]: any}) -- line: 47
	-- upvalues: useArTranslation (copy), useOpenLink (copy), React (copy), FFlagAbuseReportLinkOpenedAnalytics (copy), useOptionalAbuseReportAnalytics (copy), TelemetryEventType (copy), v13 (copy), ControlState (copy), FoundationText (copy), v12 (copy)
	local translateIntoString = useArTranslation().translateIntoString
	local translateIntoRichTextString = useArTranslation().translateIntoRichTextString
	local v21 = useOpenLink()
	local v22, v23 = React.useState(false)
	local u24 = nil

	if FFlagAbuseReportLinkOpenedAnalytics then
		local v25 = useOptionalAbuseReportAnalytics()

		u24 = if not v25 then nil else v25.sendEvent
	end

	local v26, v27 = React.useMemo(function() -- line: 59
		-- upvalues: translateIntoRichTextString (copy), t1 (copy)
		return translateIntoRichTextString(t1.input)
	end, {
		t1.input,
		translateIntoRichTextString
	})
	local v28 = React.useCallback(function() -- line: 64
		-- upvalues: v27 (copy), FFlagAbuseReportLinkOpenedAnalytics (copy), u24 (ref), TelemetryEventType (copy), t1 (copy), v21 (copy), translateIntoString (copy)
		local href = nil

		if v27 ~= nil then
			href = v27.href
		end

		if FFlagAbuseReportLinkOpenedAnalytics and u24 and href then
			u24({
				sub_event_type = TelemetryEventType.LinkOpened,
				link_detail = {
					href = href,
					link_id = t1.linkId,
					source = t1.linkSource
				}
			})
		end

		v21(translateIntoString(t1.input), href)
	end, {
		v27,
		t1.input,
		v21,
		translateIntoString,
		if not FFlagAbuseReportLinkOpenedAnalytics then nil else u24,
		if not FFlagAbuseReportLinkOpenedAnalytics then nil else t1.linkId,
		if not FFlagAbuseReportLinkOpenedAnalytics then nil else t1.linkSource
	})
	local v29 = if not v13 then nil else React.useCallback(function(p1) -- line: 93
		-- upvalues: ControlState (copy), v23 (copy)
		if p1 == ControlState.Hover then
			v23(true)

			return
		end

		v23(false)
	end, {})

	return React.createElement(FoundationText, {
		RichText = true,
		TextWrapped = true,
		Text = if not v22 then v26 else `<u>{ v26 }</u>`,
		TextXAlignment = Enum.TextXAlignment.Left,
		fontStyle = if not v12 then nil else t1.fontStyle,
		tag = t1.tag,
		LayoutOrder = t1.layoutOrder,
		onActivated = if v27 == nil then nil else v28,
		onStateChanged = if not v13 or v27 == nil then nil else v29
	})
end

return React.memo(TextWithTranslation)
