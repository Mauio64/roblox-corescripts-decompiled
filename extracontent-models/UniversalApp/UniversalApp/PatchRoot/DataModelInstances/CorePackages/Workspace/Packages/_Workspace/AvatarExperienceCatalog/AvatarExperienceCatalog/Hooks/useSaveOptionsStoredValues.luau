local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local SafeAppStorageService = require(Parent.AvatarExperienceCommon).Lib.SafeAppStorageService
local v4 = game:DefineFastFlag("AXCatalogSaveOptionsUseMemStorage", false)

local function getStorage() -- line: 18
	-- upvalues: SafeAppStorageService (copy), v4 (copy), HttpService (copy)
	local u8 = SafeAppStorageService.getItem("AXCatalogCheckoutPageSaveOptionValues", v4)

	if not u8 or u8 == "" then
		u8 = "{}"
	end

	local t1 = {}

	pcall(function() -- line: 25
		-- upvalues: t1 (ref), HttpService (copy), u8 (ref)
		t1 = HttpService:JSONDecode(u8)
	end)

	return t1
end
local function setStorage(t2: {[any]: any}) -- line: 32
	-- upvalues: HttpService (copy), SafeAppStorageService (copy), v4 (copy)
	pcall(function() -- line: 33
		-- upvalues: HttpService (copy), t2 (copy), SafeAppStorageService (copy), v4 (copy)
		local json = HttpService:JSONEncode(t2)

		SafeAppStorageService.setItem("AXCatalogCheckoutPageSaveOptionValues", json, v4)
		SafeAppStorageService.flush()
	end)
end
local function useSaveOptionsStoredValues() -- line: 40
	-- upvalues: getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v4 (copy)
	return {
		setWearAfterPurchase = function(b1: boolean) -- line: 58
			-- upvalues: getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v4 (copy)
			local v15 = getStorage()

			v15.wearAfterPurchase = b1
			pcall(function() -- line: 33
				-- upvalues: HttpService (copy), v15 (copy), SafeAppStorageService (copy), v4 (copy)
				local json = HttpService:JSONEncode(v15)

				SafeAppStorageService.setItem("AXCatalogCheckoutPageSaveOptionValues", json, v4)
				SafeAppStorageService.flush()
			end)
		end,
		getWearAfterPurchase = function() -- line: 41
			-- upvalues: getStorage (copy)
			local v12 = getStorage()

			if v12.wearAfterPurchase == nil then
				return true
			end

			return v12.wearAfterPurchase
		end,
		setAddToAvatars = function(b2: boolean) -- line: 64
			-- upvalues: getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v4 (copy)
			local v17 = getStorage()

			v17.addToAvatars = b2
			pcall(function() -- line: 33
				-- upvalues: HttpService (copy), v17 (copy), SafeAppStorageService (copy), v4 (copy)
				local json = HttpService:JSONEncode(v17)

				SafeAppStorageService.setItem("AXCatalogCheckoutPageSaveOptionValues", json, v4)
				SafeAppStorageService.flush()
			end)
		end,
		getAddToAvatars = function() -- line: 50
			-- upvalues: getStorage (copy)
			local v13 = getStorage()

			if v13.addToAvatars == nil then
				return false
			end

			return v13.addToAvatars
		end
	}
end

return useSaveOptionsStoredValues
