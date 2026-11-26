local HttpService = game:GetService("HttpService")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")

local safeAppStorageService = AvatarExperienceCommon.Lib.SafeAppStorageService

local fFlagAXMakeupReleaseFTUX = AvatarExperienceFlags.FFlagAXMakeupReleaseFTUX
local defineFastFlag = game:DefineFastFlag("AXCatalogMakeupFtuxUseMemStorage", false)
local fFlagAXMakeupLayeringTooltipFTUX = AvatarExperienceFlags.FFlagAXMakeupLayeringTooltipFTUX
local fFlagAXSkipMakeupFTUX = AvatarExperienceFlags.FFlagAXSkipMakeupFTUX

local defineFastInt = game:DefineFastInt("AXMakeupLayeringTooltipMaxSeenCount", 2)
local defineFastInt2 = game:DefineFastInt("AXMakeupMax6LayersPromptMaxSeenCount", 3)
local flag = if fFlagAXMakeupLayeringTooltipFTUX then false else nil

local function getStorage()
	local item = safeAppStorageService.getItem("AXCatalogMakeupFTUX", defineFastFlag)
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
		safeAppStorageService.setItem("AXCatalogMakeupFTUX", jsonEncode, defineFastFlag)
		safeAppStorageService.flush()
	end)
end

local function useMakeupFtux()
	local function fn()
		local storage = getStorage()

		storage.seenMakeupMax6LayersCount = storage.seenMakeupMax6LayersCount == nil and 1
			or storage.seenMakeupMax6LayersCount + 1
		pcall(function()
			local jsonEncode = HttpService:JSONEncode(storage)
			safeAppStorageService.setItem("AXCatalogMakeupFTUX", jsonEncode, defineFastFlag)
			safeAppStorageService.flush()
		end)
	end

	return {
		shouldShowMakeupMax6LayersPrompt = function(): boolean
			if fFlagAXSkipMakeupFTUX then
				return false
			end

			local storage = getStorage()

			return not storage.hideMakeupMax6LayersPrompt
				and (storage.seenMakeupMax6LayersCount == nil or storage.seenMakeupMax6LayersCount < defineFastInt2)
		end,
		hideMakeupMax6LayersPrompt = function()
			local storage = getStorage()

			storage.hideMakeupMax6LayersPrompt = true
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXCatalogMakeupFTUX", jsonEncode, defineFastFlag)
				safeAppStorageService.flush()
			end)
		end,
		shouldShowMakeupLayeringTooltip = fFlagAXMakeupLayeringTooltipFTUX and function(): boolean
			if fFlagAXSkipMakeupFTUX or flag then
				return false
			end

			return (getStorage().makeupLayeringTooltipSeenCount or 0) < defineFastInt
		end or nil,
		markMakeupLayeringTooltipSeen = fFlagAXMakeupLayeringTooltipFTUX and function()
			flag = true

			local storage = getStorage()
			storage.makeupLayeringTooltipSeenCount = (storage.makeupLayeringTooltipSeenCount or 0) + 1
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXCatalogMakeupFTUX", jsonEncode, defineFastFlag)
				safeAppStorageService.flush()
			end)
		end or nil,
		shouldShowMakeupReleasePrompt = fFlagAXMakeupReleaseFTUX and function(): boolean
			if fFlagAXSkipMakeupFTUX then
				return false
			end

			return not getStorage().shownMakeupReleasePrompt
		end or nil,
		setShownMakeupReleasePrompt = fFlagAXMakeupReleaseFTUX and function()
			local storage = getStorage()

			storage.shownMakeupReleasePrompt = true
			pcall(function()
				local jsonEncode = HttpService:JSONEncode(storage)
				safeAppStorageService.setItem("AXCatalogMakeupFTUX", jsonEncode, defineFastFlag)
				safeAppStorageService.flush()
			end)
		end or nil,
		incrementSeenMakeupMax6LayersPrompt = fn
	}
end

return useMakeupFtux
