local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local localStorageKey = require("@luauforge/bundled/hxL").Enums.LocalStorageKey

local module = require("@luauforge/bundled/hxM")

local firstTimePurchaseConsentAcknowledged = localStorageKey.FirstTimePurchaseConsentAcknowledged

local set = {}

local function readAcknowledged(object)
	local item = object:GetItem(firstTimePurchaseConsentAcknowledged)

	if item == "" then
		return {}
	end

	local success, result = pcall(HttpService.JSONDecode, HttpService, item)

	if success and typeof(result) == "table" then
		return result
	end

	return {}
end

return {
	hasAcknowledged = function(p2, p3): boolean
		local v5 = tostring(p2)

		if module.isFirstTimePurchaseConsentStorageSupported() then
			return readAcknowledged(p3 or AppStorageService)[v5] == true
		end

		return set[v5] == true
	end,
	markAcknowledged = function(p2, p3)
		local v5 = tostring(p2)
		set[v5] = true

		if not module.isFirstTimePurchaseConsentStorageSupported() then
			return
		end

		local v6 = p3 or AppStorageService
		local v7 = readAcknowledged(v6)
		v7[v5] = true
		v6:SetItem(firstTimePurchaseConsentAcknowledged, HttpService:JSONEncode(v7))
		v6:Flush()
	end,
	_resetSessionForTesting = function()
		set = {}
	end
}
