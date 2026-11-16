local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local HttpService = game:GetService("HttpService")

local parent = AvatarExperienceCatalog.Parent
local Http = require(parent.Http)
local Url = Http.Url
require(parent.LuauPolyfill)

local function createMakeupLook(callback, p)
	local v, v2 = callback(`{Url.AVATAR_URL}v3/outfits/create`, "POST", {
		postBody = HttpService:JSONEncode(p)
	})

	return v, v2
end

return createMakeupLook
