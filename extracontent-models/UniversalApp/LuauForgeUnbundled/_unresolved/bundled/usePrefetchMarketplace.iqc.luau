local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local axPrefetchMarketplaceIXP = require("@luauforge/bundled/gZJ").AXPrefetchMarketplaceIXP
local module = require("@luauforge/bundled/dPR")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module2 = require("@luauforge/bundled/gZB")
local module3 = require("@luauforge/bundled/haf")
local module4 = require("@luauforge/bundled/hag")
local module5 = require("@luauforge/bundled/iqd")

local module6 = require("@luauforge/bundled/gZG")

local defineFastFlag = game:DefineFastFlag("AXDebugForceIsRecentMarketplaceEnabled", false)
require("@luauforge/bundled/dKT")

local module7 = require("@luauforge/bundled/dPN")
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXStrictCheckForPrefetchMarketplace = AvatarExperienceFlags.FFlagAXStrictCheckForPrefetchMarketplace
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagsAXPrefetchMarketplaceThumbnailsXP = AvatarExperienceFlags.FFlagsAXPrefetchMarketplaceThumbnailsXP

local userIsInTreatment = fFlagAXStrictCheckForPrefetchMarketplace
	and fFlagsAXPrefetchMarketplaceThumbnailsXP.UserIsInTreatment

local module9 = require("@luauforge/bundled/iqe")
local defineFastFlag2 = game:DefineFastFlag("AXAppLaunchedCounterEnabled", false)
local fFlagAXFixPrefetchMarketplaceStartupCrash = AvatarExperienceFlags.FFlagAXFixPrefetchMarketplaceStartupCrash

local function selectIsRecentMarketplaceUser(p2)
	if defineFastFlag then
		return true
	end

	if
		fFlagAXFixPrefetchMarketplaceStartupCrash
		and not (p2.AvatarExperience and p2.AvatarExperience.Catalog and p2.AvatarExperience.Catalog.Metadata)
	then
		return false
	end

	return p2.AvatarExperience.Catalog.Metadata.isRecentMarketplaceUser
end

local function usePrefetchMarketplace()
	local v5

	if axPrefetchMarketplaceIXP.isEnabled() then
		v5 = module.readTestVariable(axPrefetchMarketplaceIXP.EnabledForUser)
	else
		v5 = nil
	end

	local v6 = module5()
	local v7 = useSelector(selectIsRecentMarketplaceUser)

	local v8 = module2()

	local hasFetched = v8.hasFetched
	local isFetching = v8.isFetching
	local fetchMarketplace = v8.fetchMarketplace

	if fFlagAXMigrateAllTabToSduiDev then
		local v9, v10 = module6()
		local v11 = module3({
			categoryId = v9 or module7.DefaultCatalogCategoryId,
			subcategoryId = v10
		})

		if module4() then
			hasFetched = v11.hasFetched
			isFetching = v11.isFetching
			fetchMarketplace = v11.fetchMarketplace
		end
	end

	local ref = if fFlagAXStrictCheckForPrefetchMarketplace then React.useRef(false) else nil
	local ref2, v9

	if userIsInTreatment then
		ref2 = React.useRef(false)
		v9 = module9()
	else
		ref2 = nil
		v9 = nil
	end

	if defineFastFlag2 then
		React.useEffect(function()
			sendAXCounterV2(module7.Counter.PrefetchMarketplace.appLaunched)
		end, {})
	end

	local function fn()
		if fFlagAXStrictCheckForPrefetchMarketplace and ref and ref.current or not v5 or not v7 then
			return
		end

		if hasFetched or isFetching or not v6 then
			return
		end

		sendAXCounterV2(module7.Counter.PrefetchMarketplace.isRecentMarketplaceUser)

		fetchMarketplace()

		if fFlagAXStrictCheckForPrefetchMarketplace and ref then
			ref.current = true
		end
	end

	React.useEffect(fn, {
		hasFetched,
		isFetching,
		v6,
		v5,
		v7,
		if fFlagAXMigrateAllTabToSduiDev then fetchMarketplace else nil
	})

	if userIsInTreatment then
		React.useEffect(function()
			if ref2.current or ref and not ref.current or not hasFetched then
				return
			end

			if v9 then
				v9()
				ref2.current = true
			end
		end, { v9, hasFetched })
	end
end

return usePrefetchMarketplace
