local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/RobloxAppEnums").AppPage

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Loggers").mutedError
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/t")

local fFlagLuaAppChartsFilterOptionTextTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagLuaAppChartsFilterOptionTextTag

local strictInterface = t.strictInterface
local v5 = {
	absPositions = t.string,
	filterIds = t.string,
	selectedOptionIds = t.string,
	selectedOptionContextTags = 0,
	gameSetTypeId = 0,
	gameSetTargetId = 0,
	sortPos = 0
}
local v6 = if fFlagLuaAppChartsFilterOptionTextTag then t.optional(t.string) else nil
v5.selectedOptionContextTags = v6
v5.gameSetTypeId = t.string
v5.gameSetTargetId = t.optional(t.number)
v5.sortPos = t.number
local v7 = strictInterface(v5)

local v8 = { [appPage.Games] = v7 }

local function filterImpressionsEvent(object, p2, p3)
	local v9 = v8[p2]

	if v9 then
		local v10, v11 = v9(p3)

		if not v10 then
			mutedError(v11)
		end
	else
		mutedError(string.format(
			"Missing interface for eventContext %s to type check filterImpressions event parameters",
			p2
		))
	end

	object:sendEventDeferred(p2, "filterImpressions", p3)
end

return filterImpressionsEvent
