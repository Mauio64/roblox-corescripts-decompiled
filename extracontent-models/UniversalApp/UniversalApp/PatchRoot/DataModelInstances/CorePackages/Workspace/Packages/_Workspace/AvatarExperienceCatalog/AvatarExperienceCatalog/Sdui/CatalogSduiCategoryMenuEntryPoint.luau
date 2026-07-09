local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local React = require(AvatarExperienceCatalogParent.React)

require(AvatarExperienceCatalogParent.Foundation)

local _ = require(AvatarExperienceCatalogParent.SduiSharedUtilities).SduiLoadTimer
local Constants = require(script.Parent.Constants)
local CatalogSduiEntryPoint = require(script.Parent.CatalogSduiEntryPoint)
local MarketplaceCategoryMenuSkeleton = require(AvatarExperienceCatalog.Components.MarketplaceCategoryMenuSkeleton.MarketplaceCategoryMenuSkeleton)
local FFlagAXMarketplaceLoadingSkeleton = require(AvatarExperienceCatalogParent.AvatarExperienceFlags).FFlagAXMarketplaceLoadingSkeleton

local function CatalogSduiCategoryMenuEntryPoint(t1: {[any]: any}) -- line: 26
	-- upvalues: FFlagAXMarketplaceLoadingSkeleton (copy), React (copy), MarketplaceCategoryMenuSkeleton (copy), CatalogSduiEntryPoint (copy), Constants (copy)
	local v11 = if not FFlagAXMarketplaceLoadingSkeleton then nil else React.createElement(MarketplaceCategoryMenuSkeleton)

	return React.createElement(CatalogSduiEntryPoint, {
		context = t1.context,
		identifier = Constants.CatalogCategoryMenuIdentifier,
		appPage = t1.appPage,
		loadTimer = t1.loadTimer,
		Size = t1.Size,
		Position = t1.Position,
		shouldDisplayError = t1.shouldDisplayError,
		shouldDisplayLoading = not not FFlagAXMarketplaceLoadingSkeleton,
		loadingSlot = v11
	})
end

return CatalogSduiCategoryMenuEntryPoint
