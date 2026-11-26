local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation")
local sduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SduiSharedUtilities").SduiLoadTimer
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/Constants")
local CatalogSduiEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Sdui/CatalogSduiEntryPoint")

local MarketplaceCategoryMenuSkeleton = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/MarketplaceCategoryMenuSkeleton/MarketplaceCategoryMenuSkeleton")

local fFlagAXMarketplaceLoadingSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXMarketplaceLoadingSkeleton

local function CatalogSduiCategoryMenuEntryPoint(props)
	local v5 = if fFlagAXMarketplaceLoadingSkeleton then React.createElement(MarketplaceCategoryMenuSkeleton) else nil

	return React.createElement(CatalogSduiEntryPoint, {
		context = props.context,
		identifier = Constants.CatalogCategoryMenuIdentifier,
		appPage = props.appPage,
		loadTimer = props.loadTimer,
		Size = props.Size,
		Position = props.Position,
		shouldDisplayError = props.shouldDisplayError,
		shouldDisplayLoading = fFlagAXMarketplaceLoadingSkeleton and true or false,
		loadingSlot = v5
	})
end

return CatalogSduiCategoryMenuEntryPoint
