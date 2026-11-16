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
local selectedOptionContextTag

if FFlagLuaAppChartsFilterOptionTextTag then
	selectedOptionContextTag = t.optional(t.string)
end

v.selectedOptionContextTag = selectedOptionContextTag
local previousOptionContextTag

if FFlagLuaAppChartsFilterOptionTextTag then
	previousOptionContextTag = t.optional(t.string)
end

v.previousOptionContextTag = previousOptionContextTag
v.gameSetTypeId = t.string
v.gameSetTargetId = t.optional(t.number)
v.sortPos = t.number
v.isActive = t.optional(t.boolean)
local v2 = strictInterface(v)

local v3 = { [AppPage.Games] = v2 }

local function gamesFilterClickEvent(object, p, p2)
	local v4 = v3[p]

	if v4 then
		local v5, v6 = v4(p2)

		if not v5 then
			mutedError(v6)
		end
	else
		mutedError(string.format(
			"Missing interface for eventContext %s to type check gamesFilterClick event parameters",
			p
		))
	end

	object:sendEventDeferred(p, "gamesFilterClick", p2)
end

return gamesFilterClickEvent
