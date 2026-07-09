local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXEnableTaxonomyM20ExposureLoggingClothing = AvatarExperienceFlags.FFlagAXEnableTaxonomyM20ExposureLoggingClothing
local FFlagAXEnableTaxonomyM21ExposureLoggingClothing = AvatarExperienceFlags.FFlagAXEnableTaxonomyM21ExposureLoggingClothing
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local mutedError = require(Modules.LuaApp.mutedError)
local CatalogCategories = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.CatalogCategories
local CatalogSDUICategoryIds = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.CatalogSDUICategoryIds
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local v14 = game:DefineFastString("AXTaxonomyM20ExperimentLayerName", AppUserLayers.AvatarExperienceUAMarketplaceView)
local v15 = game:DefineFastString("AXTaxonomyM21ExperimentLayerName", AppUserLayers.AvatarExperienceUAMarketplaceView)
local v16 = game:DefineFastString("AXSortsBodyTabRecLayerName", "AvatarMarketplace.SortsBodyTabRecommendation")
local v17 = game:DefineFastFlag("AXSortsBodyTabRecExposureLogging", true)

return function(p1, p2, p3) -- line: 33
	-- upvalues: ArgCheck (copy), FFlagAXEnableTaxonomyM20ExposureLoggingClothing (copy), FFlagAXCatalogCategoriesSDUI (copy), CatalogSDUICategoryIds (copy), IXPServiceWrapper (copy), v14 (copy), CatalogCategories (copy), FFlagAXEnableTaxonomyM21ExposureLoggingClothing (copy), v15 (copy), v17 (copy), v16 (copy), GetCatalogCategoriesStore (copy), mutedError (copy)
	return function(_) -- line: 34
		-- upvalues: ArgCheck (copy), p1 (copy), p2 (copy), p3 (copy), FFlagAXEnableTaxonomyM20ExposureLoggingClothing (copy), FFlagAXCatalogCategoriesSDUI (copy), CatalogSDUICategoryIds (copy), IXPServiceWrapper (copy), v14 (copy), CatalogCategories (copy), FFlagAXEnableTaxonomyM21ExposureLoggingClothing (copy), v15 (copy), v17 (copy), v16 (copy), GetCatalogCategoriesStore (copy), mutedError (copy)
		ArgCheck.isTypeOrNil(p1, "string", "SetCategoryAndSubcategory thunk expects category")
		ArgCheck.isTypeOrNil(p2, "string", "SetCategoryAndSubcategory thunk expects subcategory")
		ArgCheck.isType(p3, "table", "SetCategory thunk expects analytics")

		if FFlagAXEnableTaxonomyM20ExposureLoggingClothing then
			if FFlagAXCatalogCategoriesSDUI then
				if p1 == CatalogSDUICategoryIds.Clothing:rawValue() then
					IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v14)
				end
			elseif p1 == CatalogCategories.Clothing:rawValue() then
				IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v14)
			end
		end

		if FFlagAXEnableTaxonomyM21ExposureLoggingClothing then
			if FFlagAXCatalogCategoriesSDUI then
				if p1 == CatalogSDUICategoryIds.Clothing:rawValue() then
					IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v15)
				end
			elseif p1 == CatalogCategories.Clothing:rawValue() then
				IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v15)
			end
		end

		if v17 then
			if FFlagAXCatalogCategoriesSDUI then
				if p1 == CatalogSDUICategoryIds.Body:rawValue() then
					IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v16)
				end
			elseif p1 == CatalogCategories.Body:rawValue() then
				IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v16)
			end
		end

		if not GetCatalogCategoriesStore.getCatalogSelectionStore().changeCategory(p1, p2) then
			mutedError("Failed to select subcategory in SetCategoryAndSubcategory thunk")
		end

		local v22 = GetCatalogCategoriesStore.getCatalogSelectionStore()
		local v23 = v22.selectedCategoryId(false)
		local v24 = v22.selectedSubcategoryId(false)

		p3.clickNavigationTab(v23, v24)
	end
end
