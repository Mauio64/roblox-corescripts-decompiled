local createDeepLinkStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetDeepLinkStore/createDeepLinkStore")

local deepLinkStore = nil

local function getDeepLinkStore()
	if deepLinkStore == nil then
		deepLinkStore = createDeepLinkStore()
	end

	return deepLinkStore
end

return getDeepLinkStore
