local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local function Eyebrow(t1: {[any]: any}) -- line: 20
	-- upvalues: React (copy), TextWithTranslation (copy)
	if not t1.eyebrow then
		return nil
	end

	return React.createElement(TextWithTranslation, {
		tag = "size-full-0 auto-y text-label-large",
		input = t1.eyebrow,
		LayoutOrder = t1.layoutOrder
	})
end

return React.memo(Eyebrow)
