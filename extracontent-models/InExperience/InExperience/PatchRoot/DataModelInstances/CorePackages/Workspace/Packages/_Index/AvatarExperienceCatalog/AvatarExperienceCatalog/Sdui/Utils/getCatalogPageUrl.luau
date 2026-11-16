local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url
local Constants = require(AvatarExperienceCatalog.Sdui.Constants)

local v = urlBuilder.new({ base = Url.APIS_URL, path = Constants.CatalogSduiUrl })

local function getCatalogPageUrl()
	return v()
end

return getCatalogPageUrl
