local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)

local SafeAppStorageService = AvatarExperienceCommon.Lib.SafeAppStorageService

local FFlagAXMakeupReleaseFTUX = AvatarExperienceFlags.FFlagAXMakeupReleaseFTUX
local defineFastFlag = game:DefineFastFlag("AXCatalogMakeupFtuxUseMemStorage", false)
local FFlagAXMakeupLayeringTooltipFTUX = AvatarExperienceFlags.FFlagAXMakeupLayeringTooltipFTUX
local FFlagAXSkipMakeupFTUX = AvatarExperienceFlags.FFlagAXSkipMakeupFTUX

local defineFastInt = game:DefineFastInt("AXMakeupLayeringTooltipMaxSeenCount", 2)
local defineFastInt2 = game:DefineFastInt("AXMakeupMax6LayersPromptMaxSeenCount", 3)
local flag

if FFlagAXMakeupLayeringTooltipFTUX then
	flag = false
else
	flag = nil
end

local function getStorage()
	local item = SafeAppStorageService.getItem("AXCatalogMakeupFTUX", defineFastFlag)
	local v = (not item or item == "") and "{}" or item
	local storage = {}
	pcall(function()
		storage = HttpService:JSONDecode(v)
	end)

	return storage
end

local function setStorage(storage) -- 4 equivalent calls inferred from this helper
	pcall(function()
		local jsonEncode = HttpService:JSONEncode(storage)
		SafeAppStorageService.setItem("AXCatalogMakeupFTUX", jsonEncode, defineFastFlag)
		SafeAppStorageService.flush()
	end)
end

local function useMakeupFtux()
	local function fn()
		local storage = getStorage()

		storage.seenMakeupMax6LayersCount = storage.seenMakeupMax6LayersCount == nil and 1
			or storage.seenMakeupMax6LayersCount + 1
		setStorage(storage) -- inferred equivalent call
	end

	return {
		shouldShowMakeupMax6LayersPrompt = function(): boolean
			if FFlagAXSkipMakeupFTUX then
				return false
			end

			local storage = getStorage()

			return not storage.hideMakeupMax6LayersPrompt
				and (storage.seenMakeupMax6LayersCount == nil or storage.seenMakeupMax6LayersCount < defineFastInt2)
		end,
		hideMakeupMax6LayersPrompt = function()
			local storage = getStorage()

			storage.hideMakeupMax6LayersPrompt = true
			setStorage(storage) -- inferred equivalent call
		end,
		shouldShowMakeupLayeringTooltip = FFlagAXMakeupLayeringTooltipFTUX and function(): boolean
			if FFlagAXSkipMakeupFTUX then
				return false
			end

			return not flag and (getStorage().makeupLayeringTooltipSeenCount or 0) < defineFastInt
		end or nil,
		markMakeupLayeringTooltipSeen = FFlagAXMakeupLayeringTooltipFTUX and function()
			flag = true

			local storage = getStorage()
			storage.makeupLayeringTooltipSeenCount = (storage.makeupLayeringTooltipSeenCount or 0) + 1
			setStorage(storage) -- inferred equivalent call
		end or nil,
		shouldShowMakeupReleasePrompt = FFlagAXMakeupReleaseFTUX and function(): boolean
			return not FFlagAXSkipMakeupFTUX and not getStorage().shownMakeupReleasePrompt
		end or nil,
		setShownMakeupReleasePrompt = FFlagAXMakeupReleaseFTUX and function()
			local storage = getStorage()

			storage.shownMakeupReleasePrompt = true
			setStorage(storage) -- inferred equivalent call
		end or nil,
		incrementSeenMakeupMax6LayersPrompt = fn
	}
end

return useMakeupFtux
