local module = require("@luauforge/deferred/gMk")

return function(p2, p3)
	local kind = nil
	local size = nil

	if p3 == "Profile" or p3 == "Chat" then
		kind = module.PROFILE_THUMBNAIL_DATA.Type
		size = module.PROFILE_THUMBNAIL_DATA.Size
	elseif p3 == "ExperienceDetails" then
		kind = module.EXP_THUMBNAIL_DATA.Type
		size = module.EXP_THUMBNAIL_DATA.Size
	elseif p3 == "Item" then
		kind = module.ITEM_THUMBNAIL_DATA.Type
		size = module.ITEM_THUMBNAIL_DATA.Size
	end

	if kind then
		return string.format("rbxthumb://type=%s&id=%s&w=%d&h=%d", kind, p2, size, size)
	end

	return nil
end
