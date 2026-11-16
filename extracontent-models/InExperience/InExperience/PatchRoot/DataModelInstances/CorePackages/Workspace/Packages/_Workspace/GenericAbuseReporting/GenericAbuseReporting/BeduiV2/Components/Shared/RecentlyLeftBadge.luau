local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

require(GenericAbuseReporting.BeduiV2.Utils.Translate.translate)
local arTranslation = require(GenericAbuseReporting.BeduiV2.Utils.Translate.arTranslation)
local useArTranslation = arTranslation.useArTranslation

local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant

local function RecentlyLeftBadge(p)
	local translateIntoString = useArTranslation().translateIntoString

	return React.createElement(Badge, {
		text = translateIntoString(p.text),
		variant = BadgeVariant.Neutral,
		LayoutOrder = p.layoutOrder
	})
end

return React.memo(RecentlyLeftBadge)
