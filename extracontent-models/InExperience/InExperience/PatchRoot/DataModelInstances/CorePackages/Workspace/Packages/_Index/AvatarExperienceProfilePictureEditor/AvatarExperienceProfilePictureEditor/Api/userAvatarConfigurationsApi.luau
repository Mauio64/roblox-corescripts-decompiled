local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local Http = require(parent.Http)
local Enums = require(AvatarExperienceProfilePictureEditor.Common.Enums)

local v = { "ProfileFrame", "ThumbnailCustomizations" }

local function appendSelectionTypeQueryParams(list, value) -- 1 equivalent call inferred from this helper
	if typeof(value) == "string" then
		table.insert(list, `selectionTypes={value}`)
		return
	end

	for _, v2 in value do
		table.insert(list, `selectionTypes={v2}`)
	end
end

local function buildUserAvatarConfigurationsUrl(p: string, p2)
	local v2 = {}
	appendSelectionTypeQueryParams(v2, p2 or v) -- inferred equivalent call
	return `{Http.Url.AVATAR_URL}v4/avatar/users/{p}?{table.concat(v2, "&")}`
end

return {
	DEFAULT_SELECTION_TYPES = v,
	buildUserAvatarConfigurationsUrl = buildUserAvatarConfigurationsUrl,
	fetchUserAvatarConfigurations = function(callback, p: string, p2)
		return callback(buildUserAvatarConfigurationsUrl(p, p2), Enums.RequestMethods.GET)
	end
}
