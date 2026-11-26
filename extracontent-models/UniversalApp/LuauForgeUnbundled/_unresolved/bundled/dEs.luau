local url = require("@luauforge/bundled/dEt").Url
local urlBuilder = require("@luauforge/bundled/dEu").UrlBuilder

local defineFastFlag = game:DefineFastFlag("LuaAppEnableCommunityLinksRedirect", false)

return function(p2)
	if defineFastFlag then
		return (urlBuilder.new({
			base = url.APIS_URL,
			path = "community-links/v1/guilded/{communityId}/join",
			query = { a = "red" }
		})({ communityId = p2 }))
	end

	return "https://guilded.gg/teams/" .. p2 .. "?a=red"
end
