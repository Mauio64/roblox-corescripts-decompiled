local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local FFlagAXSortsBodyTabRecExposureLogging = AvatarExperienceFlags.FFlagAXSortsBodyTabRecExposureLogging

local FFlagAXEnableTaxonomyM20ExposureLoggingClothing = AvatarExperienceFlags.FFlagAXEnableTaxonomyM20ExposureLoggingClothing

local FFlagAXEnableTaxonomyM21ExposureLoggingClothing = AvatarExperienceFlags.FFlagAXEnableTaxonomyM21ExposureLoggingClothing
local FStringAXSortsBodyTabRecLayerName = AvatarExperienceFlags.FStringAXSortsBodyTabRecLayerName
local FStringAXTaxonomyM20ExperimentLayerName = AvatarExperienceFlags.FStringAXTaxonomyM20ExperimentLayerName
local FStringAXTaxonomyM21ExperimentLayerName = AvatarExperienceFlags.FStringAXTaxonomyM21ExperimentLayerName

local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper

local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local CatalogCategories = AvatarExperienceModel.Enums.CatalogCategories
local CatalogSDUICategoryIds = AvatarExperienceCommon.Enums.CatalogSDUICategoryIds
local CatalogCategoryKeys = AvatarExperienceCommon.Enums.CatalogCategoryKeys

local function logEditorTaxonomyExposureIfApplicable(p: string?)
	if FFlagAXEnableTaxonomyM20ExposureLoggingClothing or FFlagAXEnableTaxonomyM21ExposureLoggingClothing then
		local v

		if FFlagAXMigrateAllTabToSduiDev then
			v = CatalogCategoryKeys.Clothing
		elseif FFlagAXCatalogCategoriesSDUI then
			v = CatalogSDUICategoryIds.Clothing:rawValue()
		else
			v = CatalogCategories.Clothing:rawValue()
		end

		if p == v then
			if FFlagAXEnableTaxonomyM20ExposureLoggingClothing then
				IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringAXTaxonomyM20ExperimentLayerName)
			end

			if FFlagAXEnableTaxonomyM21ExposureLoggingClothing then
				IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringAXTaxonomyM21ExperimentLayerName)
			end
		end
	end

	if FFlagAXSortsBodyTabRecExposureLogging then
		local v

		if FFlagAXMigrateAllTabToSduiDev then
			v = CatalogCategoryKeys.Body
		elseif FFlagAXCatalogCategoriesSDUI then
			v = CatalogSDUICategoryIds.Body:rawValue()
		else
			v = CatalogCategories.Body:rawValue()
		end

		if p == v then
			IXPServiceWrapper:LogFlagLinkedUserLayerExposure(FStringAXSortsBodyTabRecLayerName)
		end
	end
end

return logEditorTaxonomyExposureIfApplicable
