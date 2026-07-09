local CorePackages = game:GetService("CorePackages")
local createSignal = require(CorePackages.Packages.Signals).createSignal
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXPrefetchOnlyWithinTTL = AvatarExperienceFlags.FFlagAXPrefetchOnlyWithinTTL
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly

return function() -- line: 29
	-- upvalues: createSignal (copy), FFlagAXCatalogCategoriesSDUI (copy), FFlagAXPrefetchOnlyWithinTTL (copy), FFlagAXMoveAllTabToWidgetOnly (copy)
	local v7, v8 = createSignal(false)
	local v9, v10 = createSignal(false)
	local v11, v12 = createSignal(false)
	local v13 = nil
	local u14 = nil

	if FFlagAXCatalogCategoriesSDUI then
		local v15

		v13, v15 = createSignal(false)
		u14 = v15
	end

	local v16 = nil
	local u17 = nil

	if FFlagAXPrefetchOnlyWithinTTL then
		local v18

		v16, v18 = createSignal(nil)
		u17 = v18
	end

	local v19 = nil
	local u20 = nil

	if FFlagAXMoveAllTabToWidgetOnly then
		local v21

		v19, v21 = createSignal(false)
		u20 = v21
	end

	return {
		getFetchingMarketplace = v7,
		getFetchedMarketplace = v9,
		getFetchingMarketplaceError = v11,
		getCatalogCategoriesError = if not FFlagAXCatalogCategoriesSDUI then nil else v13,
		getFetchedMarketplaceTimestamp = if not FFlagAXPrefetchOnlyWithinTTL then nil else v16,
		getFetchingMarketplaceProcessed = if not FFlagAXMoveAllTabToWidgetOnly then nil else v19,
		setFetchingMarketplaceInProgress = function() -- line: 60
			-- upvalues: v12 (copy), v8 (copy), v10 (copy), FFlagAXMoveAllTabToWidgetOnly (copy), u20 (ref)
			v12(false)
			v8(true)
			v10(false)

			if FFlagAXMoveAllTabToWidgetOnly then
				u20(false)
			end
		end,
		setFetchedMarketplaceCompleted = function() -- line: 68
			-- upvalues: v10 (copy), v8 (copy), v12 (copy), FFlagAXPrefetchOnlyWithinTTL (copy), u17 (ref), FFlagAXMoveAllTabToWidgetOnly (copy), u20 (ref)
			v10(true)
			v8(false)
			v12(false)

			if FFlagAXPrefetchOnlyWithinTTL then
				u17(os.time())
			end

			if FFlagAXMoveAllTabToWidgetOnly then
				u20(true)
			end
		end,
		setFetchingMarketplaceErrorOccured = function() -- line: 79
			-- upvalues: v12 (copy), v10 (copy), v8 (copy), FFlagAXMoveAllTabToWidgetOnly (copy), u20 (ref)
			v12(true)
			v10(false)
			v8(false)

			if FFlagAXMoveAllTabToWidgetOnly then
				u20(true)
			end
		end,
		setCatalogCategoriesErrorOccured = if not FFlagAXCatalogCategoriesSDUI then nil else function() -- line: 88
			-- upvalues: u14 (ref)
			u14(true)
		end,
		setFetchingMarketplaceProcessed = if not FFlagAXMoveAllTabToWidgetOnly then nil else function() -- line: 93
			-- upvalues: u20 (ref), v8 (copy), v10 (copy)
			u20(true)
			v8(false)
			v10(true)
		end,
		resetFetchMarketplaceStore = function() -- line: 99
			-- upvalues: v12 (copy), FFlagAXCatalogCategoriesSDUI (copy), u14 (ref), v10 (copy), v8 (copy), FFlagAXPrefetchOnlyWithinTTL (copy), u17 (ref), FFlagAXMoveAllTabToWidgetOnly (copy), u20 (ref)
			v12(false)

			if FFlagAXCatalogCategoriesSDUI then
				u14(false)
			end

			v10(false)
			v8(false)

			if FFlagAXPrefetchOnlyWithinTTL then
				u17(nil)
			end

			if FFlagAXMoveAllTabToWidgetOnly then
				u20(false)
			end
		end
	}
end
