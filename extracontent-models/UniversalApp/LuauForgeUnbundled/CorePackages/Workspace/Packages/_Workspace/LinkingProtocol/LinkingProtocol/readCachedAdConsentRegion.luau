local MockableProxyServices = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/MockableProxyServices")

local function readCachedAdConsentRegion()
	return MockableProxyServices.AppStorageService:GetItem("CountryCode")
end

return readCachedAdConsentRegion
