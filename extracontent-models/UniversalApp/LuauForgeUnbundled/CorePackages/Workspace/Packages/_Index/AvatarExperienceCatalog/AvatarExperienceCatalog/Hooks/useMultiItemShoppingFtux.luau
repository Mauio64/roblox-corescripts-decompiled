local HttpService = game:GetService("HttpService")

local safeAppStorageService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Lib.SafeAppStorageService

local fFlagAXDisableMultiItemShoppingFtux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXDisableMultiItemShoppingFtux

local defineFastFlag = game:DefineFastFlag("AXCatalogMultiItemShoppingFtuxUseMemStorage", false)

local defineFastInt = game:DefineFastInt("AXCatalogMultiItemShoppingFtuxOtherPromptMaxCount", 3)

local function getStorage()
	local item = safeAppStorageService.getItem("AXCatalogMultiItemShoppingFTUX", defineFastFlag)
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
		safeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", jsonEncode, defineFastFlag)

		safeAppStorageService.flush()
	end)
end

local function useMultiItemShoppingFtux()
	return {
		shouldShowTooltipOnCheckoutButton = function(): boolean
			if fFlagAXDisableMultiItemShoppingFtux then
				return false
			end

			return not getStorage().seenTooltipOnCheckoutButton
		end,
		shouldShowClearAllItemsPrompt = function(): boolean
			if fFlagAXDisableMultiItemShoppingFtux then
				return false
			end

			local storage = getStorage()

			return not storage.hideClearAllItemsPrompt
				and (storage.clearAllItemsPromptCount == nil or storage.clearAllItemsPromptCount < defineFastInt)
		end,
		shouldShowWearAvatarReplaceAllItemsPrompt = function(): boolean
			if fFlagAXDisableMultiItemShoppingFtux then
				return false
			end

			local storage = getStorage()

			return not storage.hideWearAvatarReplaceAllItemsPrompt
				and (storage.wearAvatarReplaceAllItemsPromptCount == nil or storage.wearAvatarReplaceAllItemsPromptCount < defineFastInt)
		end,
		setSeenTooltipOnCheckoutButton = function()
			local storage = getStorage()

			storage.seenTooltipOnCheckoutButton = true
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", jsonEncode, defineFastFlag)

				safeAppStorageService.flush()
			end)
		end,
		hideClearAllItemsPrompt = function()
			local storage = getStorage()

			storage.hideClearAllItemsPrompt = true
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", jsonEncode, defineFastFlag)

				safeAppStorageService.flush()
			end)
		end,
		incrementClearAllItemsPromptCount = function()
			local storage = getStorage()

			storage.clearAllItemsPromptCount = storage.clearAllItemsPromptCount == nil and 1
				or storage.clearAllItemsPromptCount + 1
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", jsonEncode, defineFastFlag)

				safeAppStorageService.flush()
			end)
		end,
		hideWearAvatarReplaceAllItemsPrompt = function()
			local storage = getStorage()

			storage.hideWearAvatarReplaceAllItemsPrompt = true
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", jsonEncode, defineFastFlag)

				safeAppStorageService.flush()
			end)
		end,
		incrementWearAvatarReplaceAllItemsPromptCount = function()
			local storage = getStorage()

			storage.wearAvatarReplaceAllItemsPromptCount = storage.wearAvatarReplaceAllItemsPromptCount == nil
				and 1
				or storage.wearAvatarReplaceAllItemsPromptCount + 1
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", jsonEncode, defineFastFlag)

				safeAppStorageService.flush()
			end)
		end,
		shouldShowItemReplacedOnAvatarPrompt = function(): boolean
			if fFlagAXDisableMultiItemShoppingFtux then
				return false
			end

			return not getStorage().seenItemReplacedOnAvatarPrompt
		end,
		setSeenItemReplaceOnAvatarPrompt = function()
			local storage = getStorage()

			storage.seenItemReplacedOnAvatarPrompt = true
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", jsonEncode, defineFastFlag)

				safeAppStorageService.flush()
			end)
		end
	}
end

return useMultiItemShoppingFtux
