local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

require(Parent.AvatarExperienceUIKit)
require(script.Parent.Parent.Types)
require(script.Parent.Parent.Enums.Categories)

local function buildSlotCategoryTabItems(t1: {[any]: any}, t2: {[any]: any}) -- line: 13
	local t3 = {}

	for v6, v7 in t1 do
		if not v7.hide then
			table.insert(t3, {
				id = v6,
				text = t2[v7.nameTranslationKey] or v7.nameTranslationKey
			})
		end
	end

	table.sort(t3, function(p1, p2) -- line: 26
		-- upvalues: t1 (copy)
		return t1[p1.id].index < t1[p2.id].index
	end)

	return t3
end

return buildSlotCategoryTabItems
