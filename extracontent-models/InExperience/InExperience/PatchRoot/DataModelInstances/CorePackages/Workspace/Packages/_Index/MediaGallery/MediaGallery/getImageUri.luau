local Parent = script:FindFirstAncestor("MediaGallery").Parent
local FFlagLuaAppMediaGalleryNilImageIdFix = require(Parent.SharedFlags).FFlagLuaAppMediaGalleryNilImageIdFix

local function getImageUri(s1: string?) -- line: 9
	-- upvalues: FFlagLuaAppMediaGalleryNilImageIdFix (copy)
	if FFlagLuaAppMediaGalleryNilImageIdFix and (s1 == nil or s1 == "") then
		return ""
	end

	local v5 = string.find(s1, "http://www.roblox.com/asset/?id=", 1, true)

	if v5 and v5 == 1 then
		return `rbxthumb://type=Asset&id={ string.sub(s1, 33) }&w=768&h=432`
	end

	if tonumber(s1) then
		return `rbxthumb://type=Asset&id={ s1 }&w=768&h=432`
	end

	return s1
end

return getImageUri
