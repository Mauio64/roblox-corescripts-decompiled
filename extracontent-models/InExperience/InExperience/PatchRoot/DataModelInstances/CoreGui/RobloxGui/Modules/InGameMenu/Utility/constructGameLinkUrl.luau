local ParentParent = script.Parent.Parent
local Url = require(ParentParent.Network.Url)

local function constructGameLinkUrl(n1: number) -- line: 4
	-- upvalues: Url (copy)
	return `{ Url.DOMAIN }games/{ n1 }`
end

return constructGameLinkUrl
