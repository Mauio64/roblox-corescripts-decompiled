local function initializeShopMenuController(object, object2)
	object2:connect(function(p)
		object:SetMenuIsOpen(p, "in_experience_shop")
	end)
end

return initializeShopMenuController
