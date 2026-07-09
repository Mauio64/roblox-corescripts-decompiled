local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local ApplyNavigateIntoAvatarExperience = require(Modules.AvatarExperience.Common.Actions.ApplyNavigateIntoAvatarExperience)
local CompleteExternalNavigation = require(Modules.AvatarExperience.Common.Actions.CompleteExternalNavigation)
local NavigatedToDeepLinkCatalogFilter = require(Modules.AvatarExperience.Catalog.Actions.NavigatedToDeepLinkCatalogFilter)
local EquippedDeepLinkCatalogItem = require(Modules.AvatarExperience.Catalog.Actions.EquippedDeepLinkCatalogItem)
local NavigatedToDeepLinkAvatarEditor = require(Modules.AvatarExperience.AvatarEditor.Actions.NavigatedToDeepLinkAvatarEditor)
local t1 = {
	params = nil,
	requestId = 0,
	completedRequestId = 0,
	screen = AvatarScreen.None
}

return Rodux.createReducer(t1, {
	[ApplyNavigateIntoAvatarExperience.name] = function(p1, p2) -- line: 32
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			screen = p2.screen,
			params = p2.params,
			requestId = p1.requestId + 1
		})
	end,
	[CompleteExternalNavigation.name] = function(p3, p4) -- line: 40
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			completedRequestId = p4.requestId
		})
	end,
	[NavigatedToDeepLinkCatalogFilter.name] = function(p5, _) -- line: 45
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			params = Cryo.Dictionary.join(p5.params or {}, {
				creatorName = Cryo.None,
				minPrice = Cryo.None,
				maxPrice = Cryo.None,
				salesTypeFilter = Cryo.None,
				includeNotForSale = Cryo.None,
				sortType = Cryo.None,
				sortAggregation = Cryo.None,
				category = Cryo.None,
				subcategory = Cryo.None,
				taxonomy = Cryo.None,
				keyword = Cryo.None,
				topics = Cryo.None,
				wearTimeFilter = Cryo.None
			})
		})
	end,
	[EquippedDeepLinkCatalogItem.name] = function(p7, p8) -- line: 74
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p7, {
			params = Cryo.Dictionary.join(p7.params or {}, {
				itemId = p8.itemId,
				itemType = p8.itemType,
				wasItemEquipped = p8.wasItemEquipped or false,
				fetchItemFailed = p8.fetchItemFailed or false
			})
		})
	end,
	[NavigatedToDeepLinkAvatarEditor.name] = function(p9, _) -- line: 84
		-- upvalues: Cryo (copy), AvatarScreen (copy)
		return Cryo.Dictionary.join(p9, {
			params = Cryo.Dictionary.join(p9.params or {}, {
				category = Cryo.None,
				subcategory = Cryo.None,
				opaquePage = AvatarScreen.AvatarEditor
			})
		})
	end
})
