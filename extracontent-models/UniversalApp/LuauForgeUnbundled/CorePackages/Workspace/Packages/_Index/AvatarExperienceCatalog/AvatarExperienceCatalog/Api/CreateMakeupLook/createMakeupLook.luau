local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").Url
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/LuauPolyfill")

local function createMakeupLook(callback, p2)
	local v5, v6 = callback(`{url.AVATAR_URL}v3/outfits/create`, "POST", {
		postBody = HttpService:JSONEncode(p2)
	})

	return v5, v6
end

return createMakeupLook
