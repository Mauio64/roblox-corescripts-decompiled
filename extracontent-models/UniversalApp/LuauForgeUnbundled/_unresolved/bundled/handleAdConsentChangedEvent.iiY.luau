local module = require("@luauforge/bundled/iiZ")
local linkingProtocol = module.LinkingProtocol
local adConsentAttributionAdapter = module.AdConsentAttributionAdapter
local readCachedAdConsentRegion = module.readCachedAdConsentRegion
local fFlagAdConsentForwardCachedRegion = require("@luauforge/bundled/iiX").FFlagAdConsentForwardCachedRegion

local function handleAdConsentChangedEvent(p2)
	local allowSellShareData = p2 and p2.allowSellShareData

	local v5 = p2 and p2.isUnder18 and "Disabled" or allowSellShareData

	if v5 == nil then
		return
	end

	local v6 = if fFlagAdConsentForwardCachedRegion then readCachedAdConsentRegion() else nil
	adConsentAttributionAdapter.resolveAndPublish(linkingProtocol.default, "ConsentChanged", function()
		return v5
	end, v6)
end

return handleAdConsentChangedEvent
