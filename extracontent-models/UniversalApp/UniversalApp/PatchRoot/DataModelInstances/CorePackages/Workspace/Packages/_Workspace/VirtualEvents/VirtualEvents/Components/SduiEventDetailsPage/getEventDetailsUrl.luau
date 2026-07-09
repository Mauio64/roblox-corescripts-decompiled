local Parent = script:FindFirstAncestor("VirtualEvents").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local v4 = UrlBuilder.new({
	path = "virtual-events/v1beta1/event-details-page",
	base = Url.APIS_URL
})

local function getEventDetailsUrl(s1: string) -- line: 12
	-- upvalues: UrlBuilder (copy), v4 (copy)
	return (UrlBuilder.addQueryString(v4(), {
		eventId = s1
	}))
end

return getEventDetailsUrl
