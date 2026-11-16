local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local function sortRobuxPackagesByAmountDescending(list)
	if #list <= 1 then
		return list
	end

	local clone = table.clone(list)
	table.sort(clone, function(a, b): boolean
		if a.robuxAmount == b.robuxAmount then
			return a.id < b.id
		end

		return a.robuxAmount > b.robuxAmount
	end)

	return clone
end

return sortRobuxPackagesByAmountDescending
