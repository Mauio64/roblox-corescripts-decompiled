local Parent = script:FindFirstAncestor("GameFilters").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local mutedError = require(Parent.Loggers).mutedError
local t = require(Parent.t)
local FFlagLuaAppChartsFilterOptionTextTag = require(Parent.SharedFlags).FFlagLuaAppChartsFilterOptionTextTag
local v6 = t.strictInterface({
	absPositions = t.string,
	filterIds = t.string,
	selectedOptionIds = t.string,
	selectedOptionContextTags = if not FFlagLuaAppChartsFilterOptionTextTag then nil else t.optional(t.string),
	gameSetTypeId = t.string,
	gameSetTargetId = t.optional(t.number),
	sortPos = t.number
})
local t1 = {
	[AppPage.Games] = v6
}

local function filterImpressionsEvent(p1, p2, p3) -- line: 27
	-- upvalues: t1 (copy), mutedError (copy)
	local v12 = t1[p2]

	if v12 then
		local v13, v14 = v12(p3)

		if not v13 then
			mutedError(v14)
		end
	else
		mutedError(string.format("Missing interface for eventContext %s to type check filterImpressions event parameters", p2))
	end

	p1:sendEventDeferred(p2, "filterImpressions", p3)
end

return filterImpressionsEvent
