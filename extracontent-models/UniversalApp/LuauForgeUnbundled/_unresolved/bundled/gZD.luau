local CorePackages = game:GetService("CorePackages")
local Signals = require(CorePackages.Packages.Signals)
local createSignal = Signals.createSignal

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXPrefetchOnlyWithinTTL = AvatarExperienceFlags.FFlagAXPrefetchOnlyWithinTTL
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

local fFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly

return function()
	local signal, v5 = createSignal(false)
	local signal2, v6 = createSignal(false)
	local signal3, v7 = createSignal(false)
	local v8, v9

	if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then
		v8, v9 = createSignal(false)
	else
		v9 = nil
	end

	local v10, v11

	if fFlagAXPrefetchOnlyWithinTTL then
		v10, v11 = createSignal(nil)
	else
		v11 = nil
	end

	local v12, v13

	if fFlagAXMoveAllTabToWidgetOnly then
		v12, v13 = createSignal(false)
	else
		v13 = nil
	end

	if not (fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev) then
		v8 = nil
	end

	if not fFlagAXPrefetchOnlyWithinTTL then
		v10 = nil
	end

	if not fFlagAXMoveAllTabToWidgetOnly then
		v12 = nil
	end

	return {
		getFetchingMarketplace = signal,
		getFetchedMarketplace = signal2,
		getFetchingMarketplaceError = signal3,
		getCatalogCategoriesError = v8,
		getFetchedMarketplaceTimestamp = v10,
		getFetchingMarketplaceProcessed = v12,
		setFetchingMarketplaceInProgress = function()
			v7(false)
			v5(true)
			v6(false)

			if fFlagAXMoveAllTabToWidgetOnly then
				v13(false)
			end
		end,
		setFetchedMarketplaceCompleted = function()
			v6(true)
			v5(false)
			v7(false)

			if fFlagAXPrefetchOnlyWithinTTL then
				v11(os.time())
			end

			if fFlagAXMoveAllTabToWidgetOnly then
				v13(true)
			end
		end,
		setFetchingMarketplaceErrorOccured = function()
			v7(true)
			v6(false)
			v5(false)

			if fFlagAXMoveAllTabToWidgetOnly then
				v13(true)
			end
		end,
		setCatalogCategoriesErrorOccured = (fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev) and function()
			v9(true)
		end or nil,
		setFetchingMarketplaceProcessed = fFlagAXMoveAllTabToWidgetOnly and function()
			v13(true)
			v5(false)
			v6(true)
		end or nil,
		resetFetchMarketplaceStore = function()
			v7(false)

			if fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev then
				v9(false)
			end

			v6(false)
			v5(false)

			if fFlagAXPrefetchOnlyWithinTTL then
				v11(nil)
			end

			if fFlagAXMoveAllTabToWidgetOnly then
				v13(false)
			end
		end
	}
end
