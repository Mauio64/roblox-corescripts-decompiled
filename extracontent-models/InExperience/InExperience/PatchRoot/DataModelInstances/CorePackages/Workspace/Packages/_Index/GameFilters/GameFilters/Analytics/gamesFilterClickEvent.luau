local Parent = script:FindFirstAncestor("GameFilters").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local mutedError = require(Parent.Loggers).mutedError
local t = require(Parent.t)
local FFlagLuaAppChartsFilterOptionTextTag = require(Parent.SharedFlags).FFlagLuaAppChartsFilterOptionTextTag
local FFlagLuaAppChartsActiveFilterChips = require(Parent.SharedFlags).FFlagLuaAppChartsActiveFilterChips
local v7 = t.strictInterface({
	buttonName = t.string,
	filterId = t.string,
	selectedOptionId = t.string,
	previousOptionId = t.optional(t.string),
	selectedOptionContextTag = if not FFlagLuaAppChartsFilterOptionTextTag then nil else t.optional(t.string),
	previousOptionContextTag = if not FFlagLuaAppChartsFilterOptionTextTag then nil else t.optional(t.string),
	gameSetTypeId = t.string,
	gameSetTargetId = t.optional(t.number),
	sortPos = t.number,
	isActive = if not FFlagLuaAppChartsActiveFilterChips then nil else t.optional(t.boolean)
})
local t1 = {
	[AppPage.Games] = v7
}

local function gamesFilterClickEvent(p1, p2, p3) -- line: 31
	-- upvalues: t1 (copy), mutedError (copy)
	local v13 = t1[p2]

	if v13 then
		local v14, v15 = v13(p3)

		if not v14 then
			mutedError(v15)
		end
	else
		mutedError(string.format("Missing interface for eventContext %s to type check gamesFilterClick event parameters", p2))
	end

	p1:sendEventDeferred(p2, "gamesFilterClick", p3)
end

return gamesFilterClickEvent
