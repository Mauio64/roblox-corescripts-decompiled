local AvatarExperienceServerDrivenUi = script:FindFirstAncestor("AvatarExperienceServerDrivenUi")
local AvatarExperienceServerDrivenUiParent = AvatarExperienceServerDrivenUi.Parent
local SduiCoreSystem = require(AvatarExperienceServerDrivenUiParent.SduiCoreSystem)
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry
local SduiComponentType = SduiCoreSystem.SduiComponentType
local FFlagSduiCatalogVirtualizedFeed = require(AvatarExperienceServerDrivenUiParent.SharedFlags).FFlagSduiCatalogVirtualizedFeed
local FFlagSduiCatalogCategoryMenu = require(AvatarExperienceServerDrivenUiParent.SharedFlags).FFlagSduiCatalogCategoryMenu
local FFlagSduiMarketplaceCatalogSortSupport = require(AvatarExperienceServerDrivenUiParent.SharedFlags).FFlagSduiMarketplaceCatalogSortSupport

local function registerAvatarExperienceUiComponents() -- line: 13
	-- upvalues: SduiComponentType (copy), FFlagSduiCatalogCategoryMenu (copy), AvatarExperienceServerDrivenUi (copy), FFlagSduiCatalogVirtualizedFeed (copy), FFlagSduiMarketplaceCatalogSortSupport (copy), getSduiComponentRegistry (copy)
	local t1 = {
		[SduiComponentType.CatalogCategoryMenu] = if not FFlagSduiCatalogCategoryMenu then nil else {
			getLazyComponent = function() -- line: 17
				-- upvalues: AvatarExperienceServerDrivenUi (copy)
				return require(AvatarExperienceServerDrivenUi.UiComponents.SduiCatalogCategoryMenu)
			end
		},
		[SduiComponentType.CatalogVirtualizedFeed] = if not FFlagSduiCatalogVirtualizedFeed then nil else {
			getLazyComponent = function() -- line: 24
				-- upvalues: AvatarExperienceServerDrivenUi (copy)
				return require(AvatarExperienceServerDrivenUi.UiComponents.SduiCatalogVirtualizedFeed)
			end
		},
		[SduiComponentType.CatalogItemGroup] = if not FFlagSduiMarketplaceCatalogSortSupport then nil else {
			getLazyComponent = function() -- line: 31
				-- upvalues: AvatarExperienceServerDrivenUi (copy)
				return require(AvatarExperienceServerDrivenUi.UiComponents.SduiCatalogItemGroup)
			end
		},
		[SduiComponentType.CatalogItemCarousel] = if not FFlagSduiMarketplaceCatalogSortSupport then nil else {
			getLazyComponent = function() -- line: 38
				-- upvalues: AvatarExperienceServerDrivenUi (copy)
				return require(AvatarExperienceServerDrivenUi.UiComponents.SduiCatalogItemCarousel)
			end
		}
	}

	getSduiComponentRegistry().registerComponentDefinitions(t1)
end

return registerAvatarExperienceUiComponents
