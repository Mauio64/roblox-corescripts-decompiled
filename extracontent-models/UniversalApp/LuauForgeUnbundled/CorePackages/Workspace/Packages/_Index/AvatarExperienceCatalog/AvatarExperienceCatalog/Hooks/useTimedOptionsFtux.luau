local HttpService = game:GetService("HttpService")

local safeAppStorageService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon").Lib.SafeAppStorageService

local defineFastFlag = game:DefineFastFlag("AXTimedOptionsFtuxUseMemStorage", false)
local defineFastFlag2 = game:DefineFastFlag("AXDisableTimedOptionsFtux", false)

local function getStorage()
	local item = safeAppStorageService.getItem("AXSlotBasedEditorCustomizeFtux", defineFastFlag)
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
		safeAppStorageService.setItem("AXSlotBasedEditorCustomizeFtux", jsonEncode, defineFastFlag)
		safeAppStorageService.flush()
	end)
end

local function useTimedOptionsFtux()
	return {
		shouldShow2OptionToolTipOnBuyActionBar = function(): boolean
			if defineFastFlag2 then
				return false
			end

			return not getStorage().hide2OptionToolTipOnBuyActionBar
		end,
		hide2OptionToolTipOnBuyActionBar = function()
			local storage = getStorage()

			storage.hide2OptionToolTipOnBuyActionBar = true
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXSlotBasedEditorCustomizeFtux", jsonEncode, defineFastFlag)
				safeAppStorageService.flush()
			end)
		end,
		shouldShow2OptionToolTipInCheckoutPage = function(): boolean
			if defineFastFlag2 then
				return false
			end

			return not getStorage().hide2OptionToolTipInCheckoutPage
		end,
		hide2OptionToolTipInCheckoutPage = function()
			local storage = getStorage()

			storage.hide2OptionToolTipInCheckoutPage = true
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXSlotBasedEditorCustomizeFtux", jsonEncode, defineFastFlag)
				safeAppStorageService.flush()
			end)
		end,
		shouldShow2OptionOfferPillTooltip = function(): boolean
			if defineFastFlag2 then
				return false
			end

			return not getStorage().hide2OptionOfferPillTooltip
		end,
		hide2OptionOfferPillTooltip = function()
			local storage = getStorage()

			storage.hide2OptionOfferPillTooltip = true
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXSlotBasedEditorCustomizeFtux", jsonEncode, defineFastFlag)
				safeAppStorageService.flush()
			end)
		end
	}
end

return useTimedOptionsFtux
