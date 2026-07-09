local Modules = game:GetService("CoreGui").RobloxGui.Modules
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local buildRobloxWebNavQueryParams = require(script.Parent.buildRobloxWebNavQueryParams)

local function buildCreatorWebNavUrl(p1) -- line: 11
	-- upvalues: UrlBuilder (copy), buildRobloxWebNavQueryParams (copy)
	return UrlBuilder.addQueryString(UrlBuilder.static.creatorHub(), buildRobloxWebNavQueryParams(p1))
end

return buildCreatorWebNavUrl
