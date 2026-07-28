local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Foundation = require(GenericAbuseReportingParent.Foundation)
local React = require(GenericAbuseReportingParent.React)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)

local useArTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation).useArTranslation
local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant

local function RecentlyLeftBadge(t1: {[any]: any}) -- line: 23
	-- upvalues: useArTranslation (copy), React (copy), Badge (copy), BadgeVariant (copy)
	local translateIntoString = useArTranslation().translateIntoString

	return React.createElement(Badge, {
		text = translateIntoString(t1.text),
		variant = BadgeVariant.Neutral,
		LayoutOrder = t1.layoutOrder
	})
end

return React.memo(RecentlyLeftBadge)
