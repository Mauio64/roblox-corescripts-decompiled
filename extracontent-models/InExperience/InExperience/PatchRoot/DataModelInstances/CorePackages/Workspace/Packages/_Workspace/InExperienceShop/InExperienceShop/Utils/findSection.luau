local InExperienceShop = script:FindFirstAncestor("InExperienceShop")

require(InExperienceShop.Types)

local function findSection(items, p: string)
	for _, item in items do
		if item.id == p then
			return item
		end
	end

	return nil
end

return findSection
