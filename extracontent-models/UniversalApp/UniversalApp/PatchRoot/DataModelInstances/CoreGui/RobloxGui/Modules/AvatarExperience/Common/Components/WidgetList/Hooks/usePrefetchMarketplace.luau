local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local AXPrefetchMarketplaceIXP = require(CorePackages.Workspace.Packages.AvatarExperienceExperiments).AXPrefetchMarketplaceIXP
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useMarketplaceResultsFetcher = require(script.Parent.useMarketplaceResultsFetcher)
local useMarketplaceResultsFetcherSdui = require(script.Parent.useMarketplaceResultsFetcherSdui)
local useResultsAreSduiEnabled = require(script.Parent.useResultsAreSduiEnabled)
local useIsHomepageReady = require(script.Parent.useIsHomepageReady)
local useGetSelectedCategoryAndSubcategoryId = require(Modules.AvatarExperience.Catalog.Hooks.useGetSelectedCategoryAndSubcategoryId)
local v12 = game:DefineFastFlag("AXDebugForceIsRecentMarketplaceEnabled", false)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXStrictCheckForPrefetchMarketplace = AvatarExperienceFlags.FFlagAXStrictCheckForPrefetchMarketplace
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local FFlagsAXPrefetchMarketplaceThumbnailsXP = AvatarExperienceFlags.FFlagsAXPrefetchMarketplaceThumbnailsXP
local v19 = FFlagAXStrictCheckForPrefetchMarketplace and FFlagsAXPrefetchMarketplaceThumbnailsXP.UserIsInTreatment
local usePrefetchMarketplaceThumbnails = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.usePrefetchMarketplaceThumbnails)
local v21 = game:DefineFastFlag("AXAppLaunchedCounterEnabled", false)
local FFlagAXFixPrefetchMarketplaceStartupCrash = AvatarExperienceFlags.FFlagAXFixPrefetchMarketplaceStartupCrash

local function selectIsRecentMarketplaceUser(p1) -- line: 71
	-- upvalues: v12 (copy), FFlagAXFixPrefetchMarketplaceStartupCrash (copy)
	if v12 then
		return true
	end

	if FFlagAXFixPrefetchMarketplaceStartupCrash and (not p1.AvatarExperience or not p1.AvatarExperience.Catalog or not p1.AvatarExperience.Catalog.Metadata) then
		return false
	end

	return p1.AvatarExperience.Catalog.Metadata.isRecentMarketplaceUser
end
local function usePrefetchMarketplace() -- line: 103
	-- upvalues: AXPrefetchMarketplaceIXP (copy), IxpUtils (copy), useIsHomepageReady (copy), useSelector (copy), selectIsRecentMarketplaceUser (copy), useMarketplaceResultsFetcher (copy), FFlagAXMigrateAllTabToSduiDev (copy), useGetSelectedCategoryAndSubcategoryId (copy), useMarketplaceResultsFetcherSdui (copy), Constants (copy), useResultsAreSduiEnabled (copy), FFlagAXStrictCheckForPrefetchMarketplace (copy), React (copy), v19 (copy), usePrefetchMarketplaceThumbnails (copy), v21 (copy), sendAXCounterV2 (copy)
	local v26 = if not AXPrefetchMarketplaceIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXPrefetchMarketplaceIXP.EnabledForUser)
	local v27 = useIsHomepageReady()
	local v28 = useSelector(selectIsRecentMarketplaceUser)
	local v29 = useMarketplaceResultsFetcher()
	local hasFetched = v29.hasFetched
	local isFetching = v29.isFetching
	local fetchMarketplace = v29.fetchMarketplace

	if FFlagAXMigrateAllTabToSduiDev then
		local v33, _ = useGetSelectedCategoryAndSubcategoryId()
		local v35 = useMarketplaceResultsFetcherSdui({
			categoryId = v33 or Constants.DefaultCatalogCategoryId
		})

		if useResultsAreSduiEnabled() then
			hasFetched = v35.hasFetched
			isFetching = v35.isFetching
			fetchMarketplace = v35.fetchMarketplace
		end
	end

	local v36 = if not FFlagAXStrictCheckForPrefetchMarketplace then nil else React.useRef(false)
	local u37 = nil
	local u38 = nil

	if v19 then
		u38 = React.useRef(false)
		u37 = usePrefetchMarketplaceThumbnails()
	end

	if v21 then
		React.useEffect(function() -- line: 153
			-- upvalues: sendAXCounterV2 (copy), Constants (copy)
			sendAXCounterV2(Constants.Counter.PrefetchMarketplace.appLaunched)
		end, {})
	end

	React.useEffect(function() -- line: 170
		-- upvalues: FFlagAXStrictCheckForPrefetchMarketplace (copy), v36 (copy), v26 (copy), v28 (copy), hasFetched (ref), isFetching (ref), v27 (copy), sendAXCounterV2 (copy), Constants (copy), fetchMarketplace (ref)
		if FFlagAXStrictCheckForPrefetchMarketplace and (v36 and v36.current) then
			return
		end

		if not v26 then
			return
		end

		if not v28 then
			return
		end

		if hasFetched or isFetching then
			return
		end

		if not v27 then
			return
		end

		sendAXCounterV2(Constants.Counter.PrefetchMarketplace.isRecentMarketplaceUser)
		fetchMarketplace()

		if FFlagAXStrictCheckForPrefetchMarketplace and v36 then
			v36.current = true
		end
	end, {
		hasFetched,
		isFetching,
		v27,
		v26,
		v28,
		if not FFlagAXMigrateAllTabToSduiDev then nil else fetchMarketplace
	})

	if v19 then
		React.useEffect(function() -- line: 231
			-- upvalues: u38 (ref), v36 (copy), hasFetched (ref), u37 (ref)
			if u38.current then
				return
			end

			if v36 and not v36.current then
				return
			end

			if not hasFetched then
				return
			end

			if u37 then
				u37()
				u38.current = true
			end
		end, {
			u37,
			hasFetched
		})
	end
end

return usePrefetchMarketplace
