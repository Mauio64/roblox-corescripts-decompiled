local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local AvatarExperienceFlags = require(Parent.AvatarExperienceFlags)
local SafeAppStorageService = AvatarExperienceCommon.Lib.SafeAppStorageService
local FFlagAXMakeupReleaseFTUX = AvatarExperienceFlags.FFlagAXMakeupReleaseFTUX
local FFlagAXMISEnableMultiShopping = AvatarExperienceFlags.FFlagAXMISEnableMultiShopping
local v8 = game:DefineFastFlag("AXCatalogMakeupFtuxUseMemStorage", false)
local FFlagAXMakeupLayeringTooltipFTUX = AvatarExperienceFlags.FFlagAXMakeupLayeringTooltipFTUX
local FFlagAXSkipMakeupFTUX = AvatarExperienceFlags.FFlagAXSkipMakeupFTUX
local v11 = game:DefineFastInt("AXMakeupLayeringTooltipMaxSeenCount", 2)
local v12 = game:DefineFastInt("AXMakeupMax6LayersPromptMaxSeenCount", 3)
local u13 = not FFlagAXMakeupLayeringTooltipFTUX and nil

local function getStorage() -- line: 30
	-- upvalues: SafeAppStorageService (copy), v8 (copy), HttpService (copy)
	local u17 = SafeAppStorageService.getItem("AXCatalogMakeupFTUX", v8)

	if not u17 or u17 == "" then
		u17 = "{}"
	end

	local t1 = {}

	pcall(function() -- line: 37
		-- upvalues: t1 (ref), HttpService (copy), u17 (ref)
		t1 = HttpService:JSONDecode(u17)
	end)

	return t1
end
local function setStorage(t2: {[any]: any}) -- line: 45
	-- upvalues: HttpService (copy), SafeAppStorageService (copy), v8 (copy)
	pcall(function() -- line: 46
		-- upvalues: HttpService (copy), t2 (copy), SafeAppStorageService (copy), v8 (copy)
		local json = HttpService:JSONEncode(t2)

		SafeAppStorageService.setItem("AXCatalogMakeupFTUX", json, v8)
		SafeAppStorageService.flush()
	end)
end
local function useMakeupFtux() -- line: 53
	-- upvalues: FFlagAXMISEnableMultiShopping (copy), getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v8 (copy), FFlagAXSkipMakeupFTUX (copy), v12 (copy), FFlagAXMakeupLayeringTooltipFTUX (copy), u13 (ref), v11 (copy), FFlagAXMakeupReleaseFTUX (copy)
	local v20 = if not FFlagAXMakeupLayeringTooltipFTUX then nil else function() -- line: 90
		-- upvalues: FFlagAXSkipMakeupFTUX (copy), u13 (ref), getStorage (copy), v11 (copy)
		if FFlagAXSkipMakeupFTUX then
			return false
		end

		if u13 then
			return false
		end

		return (getStorage().makeupLayeringTooltipSeenCount or 0) < v11
	end
	local v21 = if not FFlagAXMakeupLayeringTooltipFTUX then nil else function() -- line: 106
		-- upvalues: u13 (ref), getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v8 (copy)
		u13 = true

		local v28 = getStorage()

		v28.makeupLayeringTooltipSeenCount = (v28.makeupLayeringTooltipSeenCount or 0) + 1
		pcall(function() -- line: 46
			-- upvalues: HttpService (copy), v28 (copy), SafeAppStorageService (copy), v8 (copy)
			local json = HttpService:JSONEncode(v28)

			SafeAppStorageService.setItem("AXCatalogMakeupFTUX", json, v8)
			SafeAppStorageService.flush()
		end)
	end
	local v22 = if not FFlagAXMakeupReleaseFTUX then nil else function() -- line: 117
		-- upvalues: FFlagAXSkipMakeupFTUX (copy), getStorage (copy)
		if FFlagAXSkipMakeupFTUX then
			return false
		end

		return not getStorage().shownMakeupReleasePrompt
	end
	local v23 = if not FFlagAXMakeupReleaseFTUX then nil else function() -- line: 128
		-- upvalues: getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v8 (copy)
		local v29 = getStorage()

		v29.shownMakeupReleasePrompt = true
		pcall(function() -- line: 46
			-- upvalues: HttpService (copy), v29 (copy), SafeAppStorageService (copy), v8 (copy)
			local json = HttpService:JSONEncode(v29)

			SafeAppStorageService.setItem("AXCatalogMakeupFTUX", json, v8)
			SafeAppStorageService.flush()
		end)
	end

	return {
		shouldShowMakeupMax6LayersPrompt = function() -- line: 66
			-- upvalues: FFlagAXSkipMakeupFTUX (copy), getStorage (copy), FFlagAXMISEnableMultiShopping (copy), v12 (copy)
			if FFlagAXSkipMakeupFTUX then
				return false
			end

			local v26 = getStorage()

			return not v26.hideMakeupMax6LayersPrompt and (not FFlagAXMISEnableMultiShopping or (v26.seenMakeupMax6LayersCount == nil or v26.seenMakeupMax6LayersCount < v12))
		end,
		hideMakeupMax6LayersPrompt = function() -- line: 82
			-- upvalues: getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v8 (copy)
			local v27 = getStorage()

			v27.hideMakeupMax6LayersPrompt = true
			pcall(function() -- line: 46
				-- upvalues: HttpService (copy), v27 (copy), SafeAppStorageService (copy), v8 (copy)
				local json = HttpService:JSONEncode(v27)

				SafeAppStorageService.setItem("AXCatalogMakeupFTUX", json, v8)
				SafeAppStorageService.flush()
			end)
		end,
		shouldShowMakeupLayeringTooltip = v20,
		markMakeupLayeringTooltipSeen = v21,
		shouldShowMakeupReleasePrompt = v22,
		setShownMakeupReleasePrompt = v23,
		incrementSeenMakeupMax6LayersPrompt = function() -- line: 54
			-- upvalues: FFlagAXMISEnableMultiShopping (copy), getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v8 (copy)
			if not FFlagAXMISEnableMultiShopping then
				return
			end

			local v25 = getStorage()

			v25.seenMakeupMax6LayersCount = if v25.seenMakeupMax6LayersCount ~= nil then v25.seenMakeupMax6LayersCount + 1 else 1
			pcall(function() -- line: 46
				-- upvalues: HttpService (copy), v25 (copy), SafeAppStorageService (copy), v8 (copy)
				local json = HttpService:JSONEncode(v25)

				SafeAppStorageService.setItem("AXCatalogMakeupFTUX", json, v8)
				SafeAppStorageService.flush()
			end)
		end
	}
end

return useMakeupFtux
