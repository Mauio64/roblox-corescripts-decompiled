local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local Http = require(parent.Http)
local HttpClient = require(parent.HttpClient)

local function getCurrentlyWearingSavedOutfitId(network)
	local formatted = `{Http.Url.AVATAR_URL}v1/avatar/currently-wearing-saved-outfit`

	return HttpClient.asPromise(HttpClient.fetch({
		method = "GET",
		url = formatted,
		analyticsKey = "avatar-experience.get-currently-wearing-saved-outfit",
		legacy = true,
		network = network,
		decode = function(p)
			local savedOutfitId = p.savedOutfitId

			if savedOutfitId == nil then
				return nil
			end

			return (tostring(savedOutfitId))
		end
	}))
end

return getCurrentlyWearingSavedOutfitId
