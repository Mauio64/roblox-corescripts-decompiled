local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local function findSection(t1: {[any]: any}, s1: string) -- line: 13
	for _, v6 in t1 do
		if s1 == v6.id then
			return v6
		end
	end

	return nil
end

return findSection
