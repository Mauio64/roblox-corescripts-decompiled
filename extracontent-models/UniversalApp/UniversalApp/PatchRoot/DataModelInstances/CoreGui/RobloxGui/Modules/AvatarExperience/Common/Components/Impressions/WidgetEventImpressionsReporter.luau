local CorePackages = game:GetService("CorePackages")
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums

local function WidgetEventImpressionsReporter(p1, p2) -- line: 4
	-- upvalues: ImpressionEnums (copy)
	local ITEM_IMPRESSION = ImpressionEnums.ActionType.ITEM_IMPRESSION

	p1.widgetInteractionV2(p2, ITEM_IMPRESSION)
end

return WidgetEventImpressionsReporter
