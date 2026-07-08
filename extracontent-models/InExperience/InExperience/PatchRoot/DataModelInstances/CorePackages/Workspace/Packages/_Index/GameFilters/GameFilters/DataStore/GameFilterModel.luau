local Parent = script:FindFirstAncestor("GameFilters").Parent
local ArgCheck = require(Parent.ArgCheck)

require(Parent.DiscoveryTypes)

local FFlagLuaAppChartsActiveFilterChips = require(Parent.SharedFlags).FFlagLuaAppChartsActiveFilterChips
local FFlagLuaAppChartsFilterOptionTextTag = require(Parent.SharedFlags).FFlagLuaAppChartsFilterOptionTextTag
local t1 = {
	new = function() -- line: 12
		return {}
	end
}

function t1.mockFromExploreApi(s1: string, s2: string?) -- line: 18
	-- upvalues: t1 (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), FFlagLuaAppChartsActiveFilterChips (copy)
	local v8 = t1.fromExploreJsonData({
		filterType = "",
		filterDisplayName = "",
		filterId = s1,
		filterOptions = {{
			optionDisplayName = "",
			optionId = s1 .. "_option",
			optionContextTag = if not FFlagLuaAppChartsFilterOptionTextTag then nil else s1 .. "_context"
		}},
		defaultOptionId = s1 .. "_option",
		selectedOptionId = s1 .. "_option",
		inactiveOptionIds = if not FFlagLuaAppChartsActiveFilterChips then nil else { s1 .. "_option" }
	})

	v8.selectedOptionDisplayName = s2 or ""

	return v8
end
function t1.fromExploreJsonData(p1) -- line: 40
	-- upvalues: t1 (copy), FFlagLuaAppChartsActiveFilterChips (copy), FFlagLuaAppChartsFilterOptionTextTag (copy), ArgCheck (copy)
	local v10 = t1.new()

	v10.filterId = p1.filterId
	v10.filterType = p1.filterType
	v10.filterDisplayName = p1.filterDisplayName
	v10.defaultOptionId = p1.defaultOptionId
	v10.selectedOptionId = p1.selectedOptionId

	if FFlagLuaAppChartsActiveFilterChips and p1.inactiveOptionIds then
		local t2 = {}

		for _, v13 in p1.inactiveOptionIds do
			t2[v13] = true
		end

		v10.inactiveOptionIds = t2
	end

	local t3 = {}

	for _, v in ipairs(p1.filterOptions) do
		table.insert(t3, {
			optionId = v.optionId,
			optionDisplayName = v.optionDisplayName,
			optionContextTag = if not FFlagLuaAppChartsFilterOptionTextTag then nil else v.optionContextTag
		})

		if v.optionId == p1.selectedOptionId then
			ArgCheck.assert(v10.selectedOptionDisplayName == nil, "Multiple selected options found")
			v10.selectedOptionDisplayName = v.optionDisplayName
		end
	end

	v10.filterOptions = t3

	return v10
end

return t1
