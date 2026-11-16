local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName
local Text = Foundation.Text

require(GenericAbuseReporting.BeduiV2.Hooks.AbuseSheetFlow.AbuseSheetFlowTypes)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local useArTranslation = arTranslation.useArTranslation

local function Subtitle(p)
	local translateIntoString = useArTranslation().translateIntoString

	local v = React.useMemo(function()
		local v = p.subtitle and p.subtitle.leading and IconName[p.subtitle.leading]

		if v then
			return getIconRichText(v)
		end

		return ""
	end, { p.subtitle })

	if p.subtitle then
		return React.createElement(Text, {
			Text = `{v} {translateIntoString(p.subtitle.text)}`,
			RichText = true,
			tag = "auto-xy text-body-medium content-default",
			LayoutOrder = p.layoutOrder
		})
	end

	return nil
end

return React.memo(Subtitle)
