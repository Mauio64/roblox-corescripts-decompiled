local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/translate")
local useArTranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Utils/Translate/arTranslation").useArTranslation

local badge = Foundation.Badge
local badgeVariant = Foundation.Enums.BadgeVariant

local function RecentlyLeftBadge(p2)
	local translateIntoString = useArTranslation().translateIntoString

	return React.createElement(badge, {
		text = translateIntoString(p2.text),
		variant = badgeVariant.Neutral,
		LayoutOrder = p2.layoutOrder
	})
end

return React.memo(RecentlyLeftBadge)
