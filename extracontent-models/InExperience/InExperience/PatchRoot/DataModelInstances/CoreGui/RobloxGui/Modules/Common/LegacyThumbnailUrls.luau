local v1 = game:GetService("ContentProvider").BaseUrl:lower()
local v2 = string.gsub(v1, "/m.", "/www.")
local v3 = string.gsub(v2, "/www.", "/thumbnails.")
local v4 = string.gsub(v3, "http:", "https:")

return {
	Headshot = "rbxthumb://type=AvatarHeadShot&id=%d&w=%d&h=%d",
	Thumbnail = "rbxthumb://type=Avatar&id=%d&w=%d&h=%d",
	Bust = v4 .. "v1/users/avatar-bust?userIds=%d&size=%dx%d&format=Png&isCircular=false"
}
