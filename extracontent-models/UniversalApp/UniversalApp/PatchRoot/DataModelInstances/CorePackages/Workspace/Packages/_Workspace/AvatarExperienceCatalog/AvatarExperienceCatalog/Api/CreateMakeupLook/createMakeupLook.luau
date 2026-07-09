local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local HttpService = game:GetService("HttpService")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local Url = require(AvatarExperienceCatalogParent.Http).Url

require(AvatarExperienceCatalogParent.LuauPolyfill)

local function createMakeupLook(p1: ((...any) -> ...any), t1: {[any]: any}) -- line: 37
	-- upvalues: Url (copy), HttpService (copy)
	local v8, v9 = p1(`{ Url.AVATAR_URL }v3/outfits/create`, "POST", {
		postBody = HttpService:JSONEncode(t1)
	})

	return v8, v9
end

return createMakeupLook
