local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local filterImpressionsEvent = require(Parent.GameFilters).filterImpressionsEvent
local SduiErrors = require(Parent.SduiCoreSystem).SduiErrors

local function SduiFilterImpressionsHandler(p1, t1: {[any]: any}, t2: {[any]: any}, p2, _: number?) -- line: 13
	-- upvalues: SduiErrors (copy), filterImpressionsEvent (copy)
	if not p2 then
		p1.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogFilterImpressions, {
			name = "SduiFilterImpressionsHandler",
			message = "Missing collectionAnalyticsData"
		}, p1.appPage)

		return
	end

	if #t1 == 0 or #t2 == 0 then
		return
	end

	local t3 = {}
	local t4 = {}
	local t5 = {}
	local t6 = {}

	for _, v15 in t1 do
		local v16 = t2[v15]

		if v16 then
			table.insert(t3, v15)
			table.insert(t4, v16.filterId or v16.id)
			table.insert(t5, v16.selectedOptionId or "")
			table.insert(t6, v16.selectedOptionContextTag or "0")
		else
			p1.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogFilterImpressions, {
				name = "SduiFilterImpressionsHandler",
				message = `Missing itemData at index { v15 }`
			}, p1.appPage)
		end
	end

	if #t4 == 0 then
		return
	end

	filterImpressionsEvent(p1.dependencies.eventIngest, p1.appPage, {
		absPositions = table.concat(t3, ","),
		filterIds = table.concat(t4, ","),
		selectedOptionIds = table.concat(t5, ","),
		selectedOptionContextTags = table.concat(t6, ","),
		gameSetTypeId = tostring(p2.collectionId),
		gameSetTargetId = p2.gameSetTargetId,
		sortPos = p2.collectionPosition
	})
end

return SduiFilterImpressionsHandler
