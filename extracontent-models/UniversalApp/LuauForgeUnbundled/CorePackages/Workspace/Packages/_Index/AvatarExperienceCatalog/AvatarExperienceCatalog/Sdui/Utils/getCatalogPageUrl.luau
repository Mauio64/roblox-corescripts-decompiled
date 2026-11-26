local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Http").Url
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Constants")

local v5 = urlBuilder.new({ base = url.APIS_URL, path = Constants.CatalogSduiUrl })

local function getCatalogPageUrl()
	return v5()
end

return getCatalogPageUrl
