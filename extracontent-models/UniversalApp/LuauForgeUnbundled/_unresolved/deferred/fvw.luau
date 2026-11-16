local module = require("@luauforge/bundled/dwM")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXEnableTaxonomyM20ExposureLoggingClothing = AvatarExperienceFlags.FFlagAXEnableTaxonomyM20ExposureLoggingClothing

local fFlagAXEnableTaxonomyM21ExposureLoggingClothing = AvatarExperienceFlags.FFlagAXEnableTaxonomyM21ExposureLoggingClothing
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXSortsBodyTabRecExposureLogging = AvatarExperienceFlags.FFlagAXSortsBodyTabRecExposureLogging
local fStringAXSortsBodyTabRecLayerName = AvatarExperienceFlags.FStringAXSortsBodyTabRecLayerName
local fStringAXTaxonomyM20ExperimentLayerName = AvatarExperienceFlags.FStringAXTaxonomyM20ExperimentLayerName
local fStringAXTaxonomyM21ExperimentLayerName = AvatarExperienceFlags.FStringAXTaxonomyM21ExperimentLayerName

local module3 = require("@luauforge/bundled/dPG")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogCategories = require("@luauforge/bundled/dMd").Enums.CatalogCategories
local catalogCategoryKeys = AvatarExperienceCommon.Enums.CatalogCategoryKeys
local catalogSDUICategoryIds = AvatarExperienceCommon.Enums.CatalogSDUICategoryIds

local ixpServiceWrapper = require("@luauforge/bundled/fvx").IXPServiceWrapper

return function(p2, p3, p4)
	return function(p5)
		module.isTypeOrNil(p2, "string", "SetCategoryAndSubcategory thunk expects category")
		module.isTypeOrNil(p3, "string", "SetCategoryAndSubcategory thunk expects subcategory")

		module.isType(p4, "table", "SetCategory thunk expects analytics")

		if fFlagAXEnableTaxonomyM20ExposureLoggingClothing then
			if fFlagAXCatalogCategoriesSDUI then
				local v5

				if fFlagAXMigrateAllTabToSduiDev then
					v5 = catalogCategoryKeys.Clothing
				else
					v5 = catalogSDUICategoryIds.Clothing:rawValue()
				end

				if p2 == v5 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXTaxonomyM20ExperimentLayerName)
				end
			else
				local v5

				if fFlagAXMigrateAllTabToSduiDev then
					v5 = catalogCategoryKeys.Clothing
				else
					v5 = catalogCategories.Clothing:rawValue()
				end

				if p2 == v5 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXTaxonomyM20ExperimentLayerName)
				end
			end
		end

		if fFlagAXEnableTaxonomyM21ExposureLoggingClothing then
			if fFlagAXCatalogCategoriesSDUI then
				local v5

				if fFlagAXMigrateAllTabToSduiDev then
					v5 = catalogCategoryKeys.Clothing
				else
					v5 = catalogSDUICategoryIds.Clothing:rawValue()
				end

				if p2 == v5 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXTaxonomyM21ExperimentLayerName)
				end
			else
				local v5

				if fFlagAXMigrateAllTabToSduiDev then
					v5 = catalogCategoryKeys.Clothing
				else
					v5 = catalogCategories.Clothing:rawValue()
				end

				if p2 == v5 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXTaxonomyM21ExperimentLayerName)
				end
			end
		end

		if fFlagAXSortsBodyTabRecExposureLogging then
			if fFlagAXCatalogCategoriesSDUI then
				local v5

				if fFlagAXMigrateAllTabToSduiDev then
					v5 = catalogCategoryKeys.Body
				else
					v5 = catalogSDUICategoryIds.Body:rawValue()
				end

				if p2 == v5 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXSortsBodyTabRecLayerName)
				end
			else
				local v5

				if fFlagAXMigrateAllTabToSduiDev then
					v5 = catalogCategoryKeys.Body
				else
					v5 = catalogCategories.Body:rawValue()
				end

				if p2 == v5 then
					ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXSortsBodyTabRecLayerName)
				end
			end
		end

		if not module3.getCatalogSelectionStore().changeCategory(p2, p3) then
			mutedError("Failed to select subcategory in SetCategoryAndSubcategory thunk")
		end

		local catalogSelectionStore = module3.getCatalogSelectionStore()
		local selectedCategoryId = catalogSelectionStore.selectedCategoryId(false)
		local selectedSubcategoryId = catalogSelectionStore.selectedSubcategoryId(false)
		p4.clickNavigationTab(selectedCategoryId, selectedSubcategoryId)
	end
end
