local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local function sortRobuxPackagesByAmountDescending(t1: {[any]: any}) -- line: 6
	if #t1 <= 1 then
		return t1
	end

	local v4 = table.clone(t1)

	table.sort(v4, function(p1, p2) -- line: 12
		if p1.robuxAmount ~= p2.robuxAmount then
			return p1.robuxAmount > p2.robuxAmount
		end

		return p1.id < p2.id
	end)

	return v4
end

return sortRobuxPackagesByAmountDescending
