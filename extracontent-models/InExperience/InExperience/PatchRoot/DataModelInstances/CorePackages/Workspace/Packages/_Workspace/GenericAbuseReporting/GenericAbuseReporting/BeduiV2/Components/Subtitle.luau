local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName
local FoundationText = Foundation.Text

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation

local function Subtitle(t1: {[any]: any}) -- line: 25
	-- upvalues: useArTranslation (copy), React (copy), IconName (copy), getIconRichText (copy), FoundationText (copy)
	local translateIntoString = useArTranslation().translateIntoString
	local v12 = React.useMemo(function() -- line: 28
		-- upvalues: t1 (copy), IconName (copy), getIconRichText (copy)
		if t1.subtitle and t1.subtitle.leading then
			local v13 = IconName[t1.subtitle.leading]

			if v13 then
				return getIconRichText(v13)
			end
		end

		return ""
	end, { t1.subtitle })

	if not t1.subtitle then
		return nil
	end

	return React.createElement(FoundationText, {
		RichText = true,
		tag = "auto-xy text-body-medium content-default",
		Text = `{ v12 } { translateIntoString(t1.subtitle.text) }`,
		LayoutOrder = t1.layoutOrder
	})
end

return React.memo(Subtitle)
