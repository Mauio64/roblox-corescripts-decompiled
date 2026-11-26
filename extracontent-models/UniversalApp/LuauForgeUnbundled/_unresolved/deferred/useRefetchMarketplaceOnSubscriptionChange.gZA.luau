local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/deferred/gTn")
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local module3 = require("@luauforge/bundled/fDf")

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module6 = require("@luauforge/bundled/fHh")

local module7 = require("@luauforge/bundled/fCd")
local module8 = require("@luauforge/bundled/dQt")

local fFlagAXSubscriptionRefetchEvictStores = AvatarExperienceFlags.FFlagAXSubscriptionRefetchEvictStores

local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local module9 = require("@luauforge/bundled/dSW")
local module10 = require("@luauforge/bundled/gZB")
local module11 = require("@luauforge/bundled/haf")
local module12 = require("@luauforge/bundled/hag")

local module13 = require("@luauforge/bundled/gZG")

local module14 = require("@luauforge/bundled/dPN")

local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

local function fn(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
end

local function fn2(p2)
	return p2.AvatarExperience.AvatarScene.OutfitTryOn
end

local function useRefetchMarketplaceOnSubscriptionChange()
	local v5 = module6.RobloxSubscriptionSignals.get()
	local v6 = useSignalState(v5.getHasRobloxSubscription)

	local opaque = useAvatarRoute().opaque
	local name = if opaque then opaque.name else nil
	local detail = if opaque and opaque.params then opaque.params.detail else nil

	local v7 = useDispatch()
	local v8 = useRoactService(roactNetworking)
	local v9 = useRoactService(module3)

	local v10 = useSelector(fn)
	local v11 = useSelector(fn2)

	local v12 = React.useCallback(function()
		for k, v13 in v10 do
			v7(module7(v8, v9, v13.itemId, v13.itemType, true))
		end

		if v11.LookId then
			v7(module(v8, nil, {}, v11.LookId, nil, nil, true))
		end

		if v11.MakeupLookId then
			v7(module(v8, nil, {}, v11.MakeupLookId, nil, nil, true))
		end
	end, { v10, v8, v9, v11 })

	local catalogSearchSelectionStore = module9.getCatalogSearchSelectionStore()
	local v13 = useSignalState(catalogSearchSelectionStore.selectedCategoryId)
	local v14 = useSignalState(catalogSearchSelectionStore.selectedSubcategoryId)

	local v16 = module10((React.useMemo(function()
		if name ~= avatarScreen.CatalogSearch then
			return nil
		end

		if typeof(detail) == "string" and detail ~= "" then
			return { searchUuid = detail, categoryId = v13, subcategoryId = v14 }
		end

		return nil
	end, { name, detail, v13, v14 })))
	local v17 = v16.fetchMarketplace

	if fFlagAXMigrateAllTabToSduiDev then
		local v18, v19 = module13()
		local fetchMarketplace = module11({
			categoryId = v18 or module14.DefaultCatalogCategoryId,
			subcategoryId = v19
		}).fetchMarketplace
		local v20 = module12()

		local fetchMarketplace2 = v16.fetchMarketplace
		v17 = React.useCallback(function()
			if v20 and fetchMarketplace then
				fetchMarketplace({ forceRefresh = true })
			else
				fetchMarketplace2()
			end
		end, { v20, fetchMarketplace2, fetchMarketplace })
	end

	local ref = React.useRef(nil)

	React.useEffect(function()
		local current = ref.current
		ref.current = v6
		local v18

		if fFlagAXSubscriptionRefetchEvictStores then
			v18 = not (current == nil) and current ~= v6
		else
			v18 = current == false and v6 == true
		end

		if v18 then
			v7(module8())
			v17()
			v12()
		end
	end, { v6, v12 })

	React.useLayoutEffect(function()
		if v5.getGainedRobloxSubscriptionThisSession() then
			v7(module8())
			v17()
		end
	end, {})
end

return useRefetchMarketplaceOnSubscriptionChange
