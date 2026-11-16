local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent
local React = require(parent.React)
require(parent.Foundation)
local v = require(parent.SduiSharedUtilities)
v = v.SduiLoadTimer
local Constants = require(script.Parent.Constants)
local CatalogSduiEntryPoint = require(script.Parent.CatalogSduiEntryPoint)

local MarketplaceCategoryMenuSkeleton = require(AvatarExperienceCatalog.Components.MarketplaceCategoryMenuSkeleton.MarketplaceCategoryMenuSkeleton)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMarketplaceLoadingSkeleton = AvatarExperienceFlags.FFlagAXMarketplaceLoadingSkeleton

local function CatalogSduiCategoryMenuEntryPoint(props)
	local loadingSlot

	if FFlagAXMarketplaceLoadingSkeleton then
		loadingSlot = React.createElement(MarketplaceCategoryMenuSkeleton)
	end

	return React.createElement(CatalogSduiEntryPoint, {
		context = props.context,
		identifier = Constants.CatalogCategoryMenuIdentifier,
		appPage = props.appPage,
		loadTimer = props.loadTimer,
		Size = props.Size,
		Position = props.Position,
		shouldDisplayError = props.shouldDisplayError,
		shouldDisplayLoading = FFlagAXMarketplaceLoadingSkeleton and true or false,
		loadingSlot = loadingSlot
	})
end

return CatalogSduiCategoryMenuEntryPoint
