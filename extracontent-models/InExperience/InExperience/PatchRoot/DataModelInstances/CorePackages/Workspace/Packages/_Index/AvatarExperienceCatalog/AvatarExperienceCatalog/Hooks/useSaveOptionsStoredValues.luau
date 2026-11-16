local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local SafeAppStorageService = AvatarExperienceCommon.Lib.SafeAppStorageService

local defineFastFlag = game:DefineFastFlag("AXCatalogSaveOptionsUseMemStorage", false)
local defineFastFlag2 = game:DefineFastFlag("AXSetSaveAsAvatarDefault", false)

local function getStorage()
	local item = SafeAppStorageService.getItem("AXCatalogCheckoutPageSaveOptionValues", defineFastFlag)
	local v = (not item or item == "") and "{}" or item
	local storage = {}
	pcall(function()
		storage = HttpService:JSONDecode(v)
	end)

	return storage
end

local function setStorage(storage) -- 2 equivalent calls inferred from this helper
	pcall(function()
		local jsonEncode = HttpService:JSONEncode(storage)
		SafeAppStorageService.setItem("AXCatalogCheckoutPageSaveOptionValues", jsonEncode, defineFastFlag)
		SafeAppStorageService.flush()
	end)
end

local function useSaveOptionsStoredValues()
	return {
		setWearAfterPurchase = function(wearAfterPurchase: boolean)
			local storage = getStorage()
			storage.wearAfterPurchase = wearAfterPurchase
			setStorage(storage) -- inferred equivalent call
		end,
		getWearAfterPurchase = function()
			local storage = getStorage()

			return storage.wearAfterPurchase == nil or storage.wearAfterPurchase
		end,
		setAddToAvatars = function(addToAvatars: boolean)
			local storage = getStorage()
			storage.addToAvatars = addToAvatars
			setStorage(storage) -- inferred equivalent call
		end,
		getAddToAvatars = function()
			local storage = getStorage()

			if storage.addToAvatars ~= nil then
				return storage.addToAvatars
			end

			return if defineFastFlag2 then true else false
		end
	}
end

return useSaveOptionsStoredValues
