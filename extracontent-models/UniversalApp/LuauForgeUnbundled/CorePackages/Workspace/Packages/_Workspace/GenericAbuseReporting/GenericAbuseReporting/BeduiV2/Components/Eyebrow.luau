local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local TextWithTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/TextWithTranslation")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")

local function Eyebrow(p2)
	if p2.eyebrow then
		return React.createElement(TextWithTranslation, {
			input = p2.eyebrow,
			tag = "size-full-0 auto-y text-label-large",
			LayoutOrder = p2.layoutOrder
		})
	end

	return nil
end

return React.memo(Eyebrow)
