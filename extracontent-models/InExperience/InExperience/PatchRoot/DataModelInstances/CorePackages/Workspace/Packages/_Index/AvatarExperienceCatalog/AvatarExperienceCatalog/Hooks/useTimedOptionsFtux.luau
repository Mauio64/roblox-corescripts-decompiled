local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)

local SafeAppStorageService = AvatarExperienceCommon.Lib.SafeAppStorageService

local defineFastFlag = game:DefineFastFlag("AXTimedOptionsFtuxUseMemStorage", false)
local defineFastFlag2 = game:DefineFastFlag("AXDisableTimedOptionsFtux", false)

local function getStorage()
	local item = SafeAppStorageService.getItem("AXSlotBasedEditorCustomizeFtux", defineFastFlag)
	local v = (not item or item == "") and "{}" or item
	local storage = {}
	pcall(function()
		storage = HttpService:JSONDecode(v)
	end)

	return storage
end

local function setStorage(storage) -- 3 equivalent calls inferred from this helper
	pcall(function()
		local jsonEncode = HttpService:JSONEncode(storage)
		SafeAppStorageService.setItem("AXSlotBasedEditorCustomizeFtux", jsonEncode, defineFastFlag)
		SafeAppStorageService.flush()
	end)
end

local function useTimedOptionsFtux()
	return {
		shouldShow2OptionToolTipOnBuyActionBar = function(): boolean
			return not defineFastFlag2 and not getStorage().hide2OptionToolTipOnBuyActionBar
		end,
		hide2OptionToolTipOnBuyActionBar = function()
			local storage = getStorage()

			storage.hide2OptionToolTipOnBuyActionBar = true
			setStorage(storage) -- inferred equivalent call
		end,
		shouldShow2OptionToolTipInCheckoutPage = function(): boolean
			return not defineFastFlag2 and not getStorage().hide2OptionToolTipInCheckoutPage
		end,
		hide2OptionToolTipInCheckoutPage = function()
			local storage = getStorage()

			storage.hide2OptionToolTipInCheckoutPage = true
			setStorage(storage) -- inferred equivalent call
		end,
		shouldShow2OptionOfferPillTooltip = function(): boolean
			return not defineFastFlag2 and not getStorage().hide2OptionOfferPillTooltip
		end,
		hide2OptionOfferPillTooltip = function()
			local storage = getStorage()

			storage.hide2OptionOfferPillTooltip = true
			setStorage(storage) -- inferred equivalent call
		end
	}
end

return useTimedOptionsFtux
