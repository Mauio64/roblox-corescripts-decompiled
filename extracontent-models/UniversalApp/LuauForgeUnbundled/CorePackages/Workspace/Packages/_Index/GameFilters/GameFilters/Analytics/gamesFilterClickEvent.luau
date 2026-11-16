local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/RobloxAppEnums").AppPage

local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/Loggers").mutedError
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/t")

local fFlagLuaAppChartsFilterOptionTextTag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameFilters/SharedFlags").FFlagLuaAppChartsFilterOptionTextTag

local strictInterface = t.strictInterface
local v5 = {
	buttonName = t.string,
	filterId = t.string,
	selectedOptionId = t.string,
	previousOptionId = t.optional(t.string),
	selectedOptionContextTag = 0,
	previousOptionContextTag = 0,
	gameSetTypeId = 0,
	gameSetTargetId = 0,
	sortPos = 0,
	isActive = 0
}
local v6 = if fFlagLuaAppChartsFilterOptionTextTag then t.optional(t.string) else nil
v5.selectedOptionContextTag = v6
local v7 = if fFlagLuaAppChartsFilterOptionTextTag then t.optional(t.string) else nil
v5.previousOptionContextTag = v7
v5.gameSetTypeId = t.string
v5.gameSetTargetId = t.optional(t.number)
v5.sortPos = t.number
v5.isActive = t.optional(t.boolean)
local v8 = strictInterface(v5)

local v9 = { [appPage.Games] = v8 }

local function gamesFilterClickEvent(object, p2, p3)
	local v10 = v9[p2]

	if v10 then
		local v11, v12 = v10(p3)

		if not v11 then
			mutedError(v12)
		end
	else
		mutedError(string.format(
			"Missing interface for eventContext %s to type check gamesFilterClick event parameters",
			p2
		))
	end

	object:sendEventDeferred(p2, "gamesFilterClick", p3)
end

return gamesFilterClickEvent
