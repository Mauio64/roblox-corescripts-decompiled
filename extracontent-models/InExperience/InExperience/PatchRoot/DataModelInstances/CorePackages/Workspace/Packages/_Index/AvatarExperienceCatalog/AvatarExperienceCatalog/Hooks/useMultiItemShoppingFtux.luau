local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local SafeAppStorageService = AvatarExperienceCommon.Lib.SafeAppStorageService

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXDisableMultiItemShoppingFtux = AvatarExperienceFlags.FFlagAXDisableMultiItemShoppingFtux

local defineFastFlag = game:DefineFastFlag("AXCatalogMultiItemShoppingFtuxUseMemStorage", false)

local defineFastInt = game:DefineFastInt("AXCatalogMultiItemShoppingFtuxOtherPromptMaxCount", 3)

local function getStorage()
	local item = SafeAppStorageService.getItem("AXCatalogMultiItemShoppingFTUX", defineFastFlag)
	local v = (not item or item == "") and "{}" or item
	local storage = {}
	pcall(function()
		storage = HttpService:JSONDecode(v)
	end)

	return storage
end

local function setStorage(storage) -- 6 equivalent calls inferred from this helper
	pcall(function()
		local jsonEncode = HttpService:JSONEncode(storage)
		SafeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", jsonEncode, defineFastFlag)

		SafeAppStorageService.flush()
	end)
end

local function useMultiItemShoppingFtux()
	return {
		shouldShowTooltipOnCheckoutButton = function(): boolean
			return not FFlagAXDisableMultiItemShoppingFtux and not getStorage().seenTooltipOnCheckoutButton
		end,
		shouldShowClearAllItemsPrompt = function(): boolean
			if FFlagAXDisableMultiItemShoppingFtux then
				return false
			end

			local storage = getStorage()

			return not storage.hideClearAllItemsPrompt
				and (storage.clearAllItemsPromptCount == nil or storage.clearAllItemsPromptCount < defineFastInt)
		end,
		shouldShowWearAvatarReplaceAllItemsPrompt = function(): boolean
			if FFlagAXDisableMultiItemShoppingFtux then
				return false
			end

			local storage = getStorage()

			return not storage.hideWearAvatarReplaceAllItemsPrompt
				and (storage.wearAvatarReplaceAllItemsPromptCount == nil or storage.wearAvatarReplaceAllItemsPromptCount < defineFastInt)
		end,
		setSeenTooltipOnCheckoutButton = function()
			local storage = getStorage()

			storage.seenTooltipOnCheckoutButton = true
			setStorage(storage) -- inferred equivalent call
		end,
		hideClearAllItemsPrompt = function()
			local storage = getStorage()

			storage.hideClearAllItemsPrompt = true
			setStorage(storage) -- inferred equivalent call
		end,
		incrementClearAllItemsPromptCount = function()
			local storage = getStorage()

			storage.clearAllItemsPromptCount = storage.clearAllItemsPromptCount == nil and 1
				or storage.clearAllItemsPromptCount + 1
			setStorage(storage) -- inferred equivalent call
		end,
		hideWearAvatarReplaceAllItemsPrompt = function()
			local storage = getStorage()

			storage.hideWearAvatarReplaceAllItemsPrompt = true
			setStorage(storage) -- inferred equivalent call
		end,
		incrementWearAvatarReplaceAllItemsPromptCount = function()
			local storage = getStorage()

			storage.wearAvatarReplaceAllItemsPromptCount = storage.wearAvatarReplaceAllItemsPromptCount == nil and 1
				or storage.wearAvatarReplaceAllItemsPromptCount + 1
			setStorage(storage) -- inferred equivalent call
		end,
		shouldShowItemReplacedOnAvatarPrompt = function(): boolean
			return not FFlagAXDisableMultiItemShoppingFtux and not getStorage().seenItemReplacedOnAvatarPrompt
		end,
		setSeenItemReplaceOnAvatarPrompt = function()
			local storage = getStorage()

			storage.seenItemReplacedOnAvatarPrompt = true
			setStorage(storage) -- inferred equivalent call
		end
	}
end

return useMultiItemShoppingFtux
