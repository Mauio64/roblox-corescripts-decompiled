local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Http")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")

local v5 = { "ProfileFrame", "ThumbnailCustomizations" }

local function appendSelectionTypeQueryParams(list, value)
	if typeof(value) == "string" then
		table.insert(list, `selectionTypes={value}`)
		return
	end

	for k, v6 in value do
		table.insert(list, `selectionTypes={v6}`)
	end
end

local function buildUserAvatarConfigurationsUrl(p2, p3)
	local v6 = p3 or v5
	local v7 = {}

	if typeof(v6) == "string" then
		table.insert(v7, `selectionTypes={v6}`)
	else
		for k, v8 in v6 do
			table.insert(v7, `selectionTypes={v8}`)
		end
	end

	return `{module.Url.AVATAR_URL}v4/avatar/users/{p2}?{table.concat(v7, "&")}`
end

return {
	DEFAULT_SELECTION_TYPES = v5,
	buildUserAvatarConfigurationsUrl = buildUserAvatarConfigurationsUrl,
	fetchUserAvatarConfigurations = function(callback, p2, p3)
		return callback(buildUserAvatarConfigurationsUrl(p2, p3), Enums.RequestMethods.GET)
	end
}
