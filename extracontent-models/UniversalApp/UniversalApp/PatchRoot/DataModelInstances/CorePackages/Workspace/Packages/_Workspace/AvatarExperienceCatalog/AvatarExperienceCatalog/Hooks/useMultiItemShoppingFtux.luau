local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local SafeAppStorageService = require(Parent.AvatarExperienceCommon).Lib.SafeAppStorageService
local FFlagAXDisableMultiItemShoppingFtux = require(Parent.AvatarExperienceFlags).FFlagAXDisableMultiItemShoppingFtux
local v5 = game:DefineFastFlag("AXCatalogMultiItemShoppingFtuxUseMemStorage", false)
local v6 = game:DefineFastInt("AXCatalogMultiItemShoppingFtuxOtherPromptMaxCount", 3)

local function getStorage() -- line: 27
	-- upvalues: SafeAppStorageService (copy), v5 (copy), HttpService (copy)
	local u10 = SafeAppStorageService.getItem("AXCatalogMultiItemShoppingFTUX", v5)

	if not u10 or u10 == "" then
		u10 = "{}"
	end

	local t1 = {}

	pcall(function() -- line: 35
		-- upvalues: t1 (ref), HttpService (copy), u10 (ref)
		t1 = HttpService:JSONDecode(u10)
	end)

	return t1
end
local function setStorage(t2: {[any]: any}) -- line: 43
	-- upvalues: HttpService (copy), SafeAppStorageService (copy), v5 (copy)
	pcall(function() -- line: 44
		-- upvalues: HttpService (copy), t2 (copy), SafeAppStorageService (copy), v5 (copy)
		local json = HttpService:JSONEncode(t2)

		SafeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", json, v5)
		SafeAppStorageService.flush()
	end)
end
local function useMultiItemShoppingFtux() -- line: 55
	-- upvalues: FFlagAXDisableMultiItemShoppingFtux (copy), getStorage (copy), v6 (copy), HttpService (copy), SafeAppStorageService (copy), v5 (copy)
	return {
		shouldShowTooltipOnCheckoutButton = function() -- line: 56
			-- upvalues: FFlagAXDisableMultiItemShoppingFtux (copy), getStorage (copy)
			if FFlagAXDisableMultiItemShoppingFtux then
				return false
			end

			return not getStorage().seenTooltipOnCheckoutButton
		end,
		shouldShowClearAllItemsPrompt = function() -- line: 65
			-- upvalues: FFlagAXDisableMultiItemShoppingFtux (copy), getStorage (copy), v6 (copy)
			if FFlagAXDisableMultiItemShoppingFtux then
				return false
			end

			local v14 = getStorage()

			return not v14.hideClearAllItemsPrompt and (v14.clearAllItemsPromptCount == nil or v14.clearAllItemsPromptCount < v6)
		end,
		shouldShowWearAvatarReplaceAllItemsPrompt = function() -- line: 78
			-- upvalues: FFlagAXDisableMultiItemShoppingFtux (copy), getStorage (copy), v6 (copy)
			if FFlagAXDisableMultiItemShoppingFtux then
				return false
			end

			local v15 = getStorage()

			return not v15.hideWearAvatarReplaceAllItemsPrompt and (v15.wearAvatarReplaceAllItemsPromptCount == nil or v15.wearAvatarReplaceAllItemsPromptCount < v6)
		end,
		setSeenTooltipOnCheckoutButton = function() -- line: 100
			-- upvalues: getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v5 (copy)
			local v16 = getStorage()

			v16.seenTooltipOnCheckoutButton = true
			pcall(function() -- line: 44
				-- upvalues: HttpService (copy), v16 (copy), SafeAppStorageService (copy), v5 (copy)
				local json = HttpService:JSONEncode(v16)

				SafeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", json, v5)
				SafeAppStorageService.flush()
			end)
		end,
		hideClearAllItemsPrompt = function() -- line: 107
			-- upvalues: getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v5 (copy)
			local v17 = getStorage()

			v17.hideClearAllItemsPrompt = true
			pcall(function() -- line: 44
				-- upvalues: HttpService (copy), v17 (copy), SafeAppStorageService (copy), v5 (copy)
				local json = HttpService:JSONEncode(v17)

				SafeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", json, v5)
				SafeAppStorageService.flush()
			end)
		end,
		incrementClearAllItemsPromptCount = function() -- line: 114
			-- upvalues: getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v5 (copy)
			local v18 = getStorage()

			v18.clearAllItemsPromptCount = if v18.clearAllItemsPromptCount ~= nil then v18.clearAllItemsPromptCount + 1 else 1
			pcall(function() -- line: 44
				-- upvalues: HttpService (copy), v18 (copy), SafeAppStorageService (copy), v5 (copy)
				local json = HttpService:JSONEncode(v18)

				SafeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", json, v5)
				SafeAppStorageService.flush()
			end)
		end,
		hideWearAvatarReplaceAllItemsPrompt = function() -- line: 123
			-- upvalues: getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v5 (copy)
			local v19 = getStorage()

			v19.hideWearAvatarReplaceAllItemsPrompt = true
			pcall(function() -- line: 44
				-- upvalues: HttpService (copy), v19 (copy), SafeAppStorageService (copy), v5 (copy)
				local json = HttpService:JSONEncode(v19)

				SafeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", json, v5)
				SafeAppStorageService.flush()
			end)
		end,
		incrementWearAvatarReplaceAllItemsPromptCount = function() -- line: 130
			-- upvalues: getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v5 (copy)
			local v20 = getStorage()

			v20.wearAvatarReplaceAllItemsPromptCount = if v20.wearAvatarReplaceAllItemsPromptCount ~= nil then v20.wearAvatarReplaceAllItemsPromptCount + 1 else 1
			pcall(function() -- line: 44
				-- upvalues: HttpService (copy), v20 (copy), SafeAppStorageService (copy), v5 (copy)
				local json = HttpService:JSONEncode(v20)

				SafeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", json, v5)
				SafeAppStorageService.flush()
			end)
		end,
		shouldShowItemReplacedOnAvatarPrompt = function() -- line: 91
			-- upvalues: FFlagAXDisableMultiItemShoppingFtux (copy), getStorage (copy)
			if FFlagAXDisableMultiItemShoppingFtux then
				return false
			end

			return not getStorage().seenItemReplacedOnAvatarPrompt
		end,
		setSeenItemReplaceOnAvatarPrompt = function() -- line: 139
			-- upvalues: getStorage (copy), HttpService (copy), SafeAppStorageService (copy), v5 (copy)
			local v21 = getStorage()

			v21.seenItemReplacedOnAvatarPrompt = true
			pcall(function() -- line: 44
				-- upvalues: HttpService (copy), v21 (copy), SafeAppStorageService (copy), v5 (copy)
				local json = HttpService:JSONEncode(v21)

				SafeAppStorageService.setItem("AXCatalogMultiItemShoppingFTUX", json, v5)
				SafeAppStorageService.flush()
			end)
		end
	}
end

return useMultiItemShoppingFtux
