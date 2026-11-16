local createDeepLinkStore = require(script.createDeepLinkStore)

local deepLinkStore = nil

local function getDeepLinkStore()
	if deepLinkStore == nil then
		deepLinkStore = createDeepLinkStore()
	end

	return deepLinkStore
end

return getDeepLinkStore
