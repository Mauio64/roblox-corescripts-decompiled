local AvatarExperienceServerDrivenUi = script:FindFirstAncestor("AvatarExperienceServerDrivenUi")
local AvatarExperienceServerDrivenUiParent = AvatarExperienceServerDrivenUi.Parent
local FFlagSduiMarketplaceCatalogActions = require(AvatarExperienceServerDrivenUiParent.SharedFlags).FFlagSduiMarketplaceCatalogActions
local SduiCoreSystem = require(AvatarExperienceServerDrivenUiParent.SduiCoreSystem)
local SduiActionType = SduiCoreSystem.SduiActionType
local getSduiActionHandlerRegistry = SduiCoreSystem.getSduiActionHandlerRegistry

local function registerAvatarExperienceActions() -- line: 21
	-- upvalues: SduiActionType (copy), FFlagSduiMarketplaceCatalogActions (copy), AvatarExperienceServerDrivenUi (copy), getSduiActionHandlerRegistry (copy)
	local t1 = {
		[SduiActionType.OpenMarketplaceCatalogFilters] = if not FFlagSduiMarketplaceCatalogActions then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 25
				-- upvalues: AvatarExperienceServerDrivenUi (copy)
				return require(AvatarExperienceServerDrivenUi.Actions.SduiOpenMarketplaceCatalogFiltersAction)
			end
		},
		[SduiActionType.SelectMarketplaceCatalogCategory] = if not FFlagSduiMarketplaceCatalogActions then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 33
				-- upvalues: AvatarExperienceServerDrivenUi (copy)
				return require(AvatarExperienceServerDrivenUi.Actions.SduiSelectMarketplaceCatalogCategoryAction)
			end
		},
		[SduiActionType.SelectMarketplaceCatalogSubcategory] = if not FFlagSduiMarketplaceCatalogActions then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 41
				-- upvalues: AvatarExperienceServerDrivenUi (copy)
				return require(AvatarExperienceServerDrivenUi.Actions.SduiSelectMarketplaceCatalogSubcategoryAction)
			end
		},
		[SduiActionType.OpenMarketplaceCatalogSeeAll] = if not FFlagSduiMarketplaceCatalogActions then nil else {
			skipUnifiedLogging = true,
			lazyHandler = function() -- line: 49
				-- upvalues: AvatarExperienceServerDrivenUi (copy)
				return require(AvatarExperienceServerDrivenUi.Actions.SduiOpenMarketplaceCatalogSeeAllAction)
			end
		}
	}

	getSduiActionHandlerRegistry().registerActionHandlerConfigs(t1)
end

return registerAvatarExperienceActions
