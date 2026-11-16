local HttpService = game:GetService("HttpService")

local safeAppStorageService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Lib.SafeAppStorageService

local defineFastFlag = game:DefineFastFlag("AXCatalogSaveOptionsUseMemStorage", false)
local defineFastFlag2 = game:DefineFastFlag("AXSetSaveAsAvatarDefault", false)

local function getStorage()
	local item = safeAppStorageService.getItem("AXCatalogCheckoutPageSaveOptionValues", defineFastFlag)
	local v5 = (not item or item == "") and "{}" or item
	local storage = {}
	pcall(function()
		storage = HttpService:JSONDecode(v5)
	end)

	return storage
end

local function setStorage(p2)
	pcall(function()
		local jsonEncode = HttpService:JSONEncode(p2)
		safeAppStorageService.setItem("AXCatalogCheckoutPageSaveOptionValues", jsonEncode, defineFastFlag)
		safeAppStorageService.flush()
	end)
end

local function useSaveOptionsStoredValues()
	return {
		setWearAfterPurchase = function(wearAfterPurchase)
			local storage = getStorage()
			storage.wearAfterPurchase = wearAfterPurchase
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem(
					"AXCatalogCheckoutPageSaveOptionValues",
					jsonEncode,
					defineFastFlag
				)
				safeAppStorageService.flush()
			end)
		end,
		getWearAfterPurchase = function()
			local storage = getStorage()

			if storage.wearAfterPurchase == nil then
				return true
			end

			return storage.wearAfterPurchase
		end,
		setAddToAvatars = function(addToAvatars)
			local storage = getStorage()
			storage.addToAvatars = addToAvatars
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem(
					"AXCatalogCheckoutPageSaveOptionValues",
					jsonEncode,
					defineFastFlag
				)
				safeAppStorageService.flush()
			end)
		end,
		getAddToAvatars = function()
			local storage = getStorage()

			if storage.addToAvatars ~= nil then
				return storage.addToAvatars
			end

			if defineFastFlag2 then
				return true
			end

			return false
		end
	}
end

return useSaveOptionsStoredValues
