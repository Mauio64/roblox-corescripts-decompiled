local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Http")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/HttpClient")

local function getCurrentlyWearingSavedOutfitId(p2)
	local formatted = `{module.Url.AVATAR_URL}v1/avatar/currently-wearing-saved-outfit`

	return HttpClient.asPromise(HttpClient.fetch({
		method = "GET",
		url = formatted,
		analyticsKey = "avatar-experience.get-currently-wearing-saved-outfit",
		legacy = true,
		network = p2,
		decode = function(p3)
			local savedOutfitId = p3.savedOutfitId

			if savedOutfitId == nil then
				return nil
			end

			return (tostring(savedOutfitId))
		end
	}))
end

return getCurrentlyWearingSavedOutfitId
