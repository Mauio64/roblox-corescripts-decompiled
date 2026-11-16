local parent = script.Parent.Parent

local MockableProxyServices = require(parent.MockableProxyServices)

local function readCachedAdConsentRegion()
	return MockableProxyServices.AppStorageService:GetItem("CountryCode")
end

return readCachedAdConsentRegion
