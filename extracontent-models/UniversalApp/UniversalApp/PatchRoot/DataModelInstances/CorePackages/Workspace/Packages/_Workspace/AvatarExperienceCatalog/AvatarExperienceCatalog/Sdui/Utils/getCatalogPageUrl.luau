local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local UrlBuilder = require(AvatarExperienceCatalogParent.UrlBuilder).UrlBuilder
local Url = require(AvatarExperienceCatalogParent.Http).Url
local Constants = require(AvatarExperienceCatalog.Sdui.Constants)
local v6 = UrlBuilder.new({
	base = Url.APIS_URL,
	path = Constants.CatalogSduiUrl
})

local function getCatalogPageUrl() -- line: 13
	-- upvalues: v6 (copy)
	return v6()
end

return getCatalogPageUrl
