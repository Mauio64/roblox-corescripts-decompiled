local parent = script.Parent.Parent
local Url = require(parent.Network.Url)

local function constructGameLinkUrl(p: number)
	return `{Url.DOMAIN}games/{p}`
end

return constructGameLinkUrl
