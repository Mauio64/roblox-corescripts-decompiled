local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local GameFilters = require(parent.GameFilters)
local filterImpressionsEvent = GameFilters.filterImpressionsEvent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors

local function SduiFilterImpressionsHandler(p, list, list2, data, _: number?)
	if not data then
		p.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.FailedToLogFilterImpressions,
			{ name = "SduiFilterImpressionsHandler", message = "Missing collectionAnalyticsData" },
			p.appPage
		)
		return
	end

	if #list == 0 or #list2 == 0 then
		return
	end

	local v = {}
	local filterIds = {}
	local selectedOptionIds = {}
	local selectedOptionContextTags = {}

	for _, item in list do
		local item2 = list2[item]

		if item2 then
			table.insert(v, item)
			table.insert(filterIds, item2.filterId or item2.id)
			table.insert(selectedOptionIds, item2.selectedOptionId or "")
			table.insert(selectedOptionContextTags, item2.selectedOptionContextTag or "0")
		else
			p.dependencies.logger.reportError(
				SduiErrors.SduiErrorType.FailedToLogFilterImpressions,
				{
					name = "SduiFilterImpressionsHandler",
					message = `Missing itemData at index {item}`
				},
				p.appPage
			)
		end
	end

	if #filterIds == 0 then
		return
	end

	filterImpressionsEvent(p.dependencies.eventIngest, p.appPage, {
		absPositions = table.concat(v, ","),
		filterIds = table.concat(filterIds, ","),
		selectedOptionIds = table.concat(selectedOptionIds, ","),
		selectedOptionContextTags = table.concat(selectedOptionContextTags, ","),
		gameSetTypeId = tostring(data.collectionId),
		gameSetTargetId = data.gameSetTargetId,
		sortPos = data.collectionPosition
	})
end

return SduiFilterImpressionsHandler
