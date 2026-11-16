local parent = script:FindFirstAncestor("GameFilters").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local t = require(parent.t)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppChartsFilterOptionTextTag = SharedFlags.FFlagLuaAppChartsFilterOptionTextTag

local strictInterface = t.strictInterface
local v = {
	absPositions = t.string,
	filterIds = t.string,
	selectedOptionIds = t.string,
	selectedOptionContextTags = 0,
	gameSetTypeId = 0,
	gameSetTargetId = 0,
	sortPos = 0
}
local selectedOptionContextTags

if FFlagLuaAppChartsFilterOptionTextTag then
	selectedOptionContextTags = t.optional(t.string)
end

v.selectedOptionContextTags = selectedOptionContextTags
v.gameSetTypeId = t.string
v.gameSetTargetId = t.optional(t.number)
v.sortPos = t.number
local v2 = strictInterface(v)

local v3 = { [AppPage.Games] = v2 }

local function filterImpressionsEvent(object, p, p2)
	local v4 = v3[p]

	if v4 then
		local v5, v6 = v4(p2)

		if not v5 then
			mutedError(v6)
		end
	else
		mutedError(string.format(
			"Missing interface for eventContext %s to type check filterImpressions event parameters",
			p
		))
	end

	object:sendEventDeferred(p, "filterImpressions", p2)
end

return filterImpressionsEvent
