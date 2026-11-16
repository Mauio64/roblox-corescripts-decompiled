local ContentProvider = game:GetService("ContentProvider")

local baseUrl = ContentProvider.BaseUrl:lower()
local v = string.gsub(baseUrl, "/m.", "/www.")
local v2 = string.gsub(v, "/www.", "/thumbnails.")
return {
	Headshot = "rbxthumb://type=AvatarHeadShot&id=%d&w=%d&h=%d",
	Bust = string.gsub(v2, "http:", "https:") .. "v1/users/avatar-bust?userIds=%d&size=%dx%d&format=Png&isCircular=false",
	Thumbnail = "rbxthumb://type=Avatar&id=%d&w=%d&h=%d"
}
