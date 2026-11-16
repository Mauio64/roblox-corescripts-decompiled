local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)

local TextWithTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.TextWithTranslation)
require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local function Eyebrow(p)
	if p.eyebrow then
		return React.createElement(TextWithTranslation, {
			input = p.eyebrow,
			tag = "size-full-0 auto-y text-label-large",
			LayoutOrder = p.layoutOrder
		})
	end

	return nil
end

return React.memo(Eyebrow)
