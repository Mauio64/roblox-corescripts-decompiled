local filterImpressionsEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameFilters").filterImpressionsEvent

local sduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").SduiErrors

local function SduiFilterImpressionsHandler(p2, list, list2, data, p3)
	if not data then
		p2.dependencies.logger.reportError(
			sduiErrors.SduiErrorType.FailedToLogFilterImpressions,
			{
				name = "SduiFilterImpressionsHandler",
				message = "Missing collectionAnalyticsData"
			},
			p2.appPage
		)
		return
	end

	if #list == 0 or #list2 == 0 then
		return
	end

	local v5 = {}
	local filterIds = {}
	local selectedOptionIds = {}
	local selectedOptionContextTags = {}

	for k, item in list do
		local item2 = list2[item]

		if item2 then
			table.insert(v5, item)
			table.insert(filterIds, item2.filterId or item2.id)
			table.insert(selectedOptionIds, item2.selectedOptionId or "")
			table.insert(selectedOptionContextTags, item2.selectedOptionContextTag or "0")
		else
			p2.dependencies.logger.reportError(
				sduiErrors.SduiErrorType.FailedToLogFilterImpressions,
				{
					name = "SduiFilterImpressionsHandler",
					message = `Missing itemData at index {item}`
				},
				p2.appPage
			)
		end
	end

	if #filterIds == 0 then
		return
	end

	filterImpressionsEvent(p2.dependencies.eventIngest, p2.appPage, {
		absPositions = table.concat(v5, ","),
		filterIds = table.concat(filterIds, ","),
		selectedOptionIds = table.concat(selectedOptionIds, ","),
		selectedOptionContextTags = table.concat(selectedOptionContextTags, ","),
		gameSetTypeId = tostring(data.collectionId),
		gameSetTargetId = data.gameSetTargetId,
		sortPos = data.collectionPosition
	})
end

return SduiFilterImpressionsHandler
