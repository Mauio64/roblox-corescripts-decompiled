return function(p1) -- line: 1
	return function(p2) -- line: 2
		-- upvalues: p1 (copy)
		local category = p2:getState().AvatarExperience.AvatarEditor.Categories.category
		local subcategory = p2:getState().AvatarExperience.AvatarEditor.Categories.subcategory

		p1.clickShopForMore(category, subcategory)
	end
end
