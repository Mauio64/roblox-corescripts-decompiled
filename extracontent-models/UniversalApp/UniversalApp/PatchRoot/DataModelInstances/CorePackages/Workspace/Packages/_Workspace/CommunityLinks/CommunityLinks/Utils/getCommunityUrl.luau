local Parent = script:FindFirstAncestor("CommunityLinks").Parent
local Url = require(Parent.Http).Url
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local v4 = game:DefineFastFlag("LuaAppEnableCommunityLinksRedirect", false)

return function(s1: string) -- line: 9
	-- upvalues: v4 (copy), UrlBuilder (copy), Url (copy)
	if v4 then
		return (UrlBuilder.new({
			path = "community-links/v1/guilded/{communityId}/join",
			base = Url.APIS_URL,
			query = {
				a = "red"
			}
		})({
			communityId = s1
		}))
	end

	return "https://guilded.gg/teams/" .. s1 .. "?a=red"
end
