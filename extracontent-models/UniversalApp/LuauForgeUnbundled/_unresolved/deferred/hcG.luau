return function(p2)
	return function(object)
		local category = object:getState().AvatarExperience.AvatarEditor.Categories.category
		local subcategory = object:getState().AvatarExperience.AvatarEditor.Categories.subcategory
		p2.clickShopForMore(category, subcategory)
	end
end
