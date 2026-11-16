local url = nil
local PreAuthDeepLinkUrlStore = {}

function PreAuthDeepLinkUrlStore.getUrl()
	return url
end

function PreAuthDeepLinkUrlStore.setUrl(p: string?)
	url = p
end

return PreAuthDeepLinkUrlStore
