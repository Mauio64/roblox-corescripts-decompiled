local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags")
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXSortsBodyTabRecExposureLogging = AvatarExperienceFlags.FFlagAXSortsBodyTabRecExposureLogging

local fFlagAXEnableTaxonomyM20ExposureLoggingClothing = AvatarExperienceFlags.FFlagAXEnableTaxonomyM20ExposureLoggingClothing

local fFlagAXEnableTaxonomyM21ExposureLoggingClothing = AvatarExperienceFlags.FFlagAXEnableTaxonomyM21ExposureLoggingClothing
local fStringAXSortsBodyTabRecLayerName = AvatarExperienceFlags.FStringAXSortsBodyTabRecLayerName
local fStringAXTaxonomyM20ExperimentLayerName = AvatarExperienceFlags.FStringAXTaxonomyM20ExperimentLayerName
local fStringAXTaxonomyM21ExperimentLayerName = AvatarExperienceFlags.FStringAXTaxonomyM21ExperimentLayerName

local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/IxpServiceWrapper").IXPServiceWrapper

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local catalogCategories = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceModel").Enums.CatalogCategories
local catalogSDUICategoryIds = AvatarExperienceCommon.Enums.CatalogSDUICategoryIds
local catalogCategoryKeys = AvatarExperienceCommon.Enums.CatalogCategoryKeys

local function logEditorTaxonomyExposureIfApplicable(p2)
	if
		fFlagAXEnableTaxonomyM20ExposureLoggingClothing
		or fFlagAXEnableTaxonomyM21ExposureLoggingClothing
	then
		local v5

		if fFlagAXMigrateAllTabToSduiDev then
			v5 = catalogCategoryKeys.Clothing
		elseif fFlagAXCatalogCategoriesSDUI then
			v5 = catalogSDUICategoryIds.Clothing:rawValue()
		else
			v5 = catalogCategories.Clothing:rawValue()
		end

		if p2 == v5 then
			if fFlagAXEnableTaxonomyM20ExposureLoggingClothing then
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXTaxonomyM20ExperimentLayerName)
			end

			if fFlagAXEnableTaxonomyM21ExposureLoggingClothing then
				ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXTaxonomyM21ExperimentLayerName)
			end
		end
	end

	if fFlagAXSortsBodyTabRecExposureLogging then
		local v5

		if fFlagAXMigrateAllTabToSduiDev then
			v5 = catalogCategoryKeys.Body
		elseif fFlagAXCatalogCategoriesSDUI then
			v5 = catalogSDUICategoryIds.Body:rawValue()
		else
			v5 = catalogCategories.Body:rawValue()
		end

		if p2 == v5 then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(fStringAXSortsBodyTabRecLayerName)
		end
	end
end

return logEditorTaxonomyExposureIfApplicable
