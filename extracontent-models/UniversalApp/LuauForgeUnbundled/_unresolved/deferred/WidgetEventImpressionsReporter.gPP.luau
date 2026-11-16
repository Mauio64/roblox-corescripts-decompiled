local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums

local function WidgetEventImpressionsReporter(p2, p3)
	local ITEM_IMPRESSION = impressionEnums.ActionType.ITEM_IMPRESSION
	p2.widgetInteractionV2(p3, ITEM_IMPRESSION)
end

return WidgetEventImpressionsReporter
