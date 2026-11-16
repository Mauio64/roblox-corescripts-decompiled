local module = require("@luauforge/bundled/dPO")

local logEditorTaxonomyExposureIfApplicable = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Utils.logEditorTaxonomyExposureIfApplicable
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").mutedError
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2
local module2 = require("@luauforge/bundled/dMx")

local function applyCatalogCategorySelection(callback, p2, p3, p4)
	if p4.source == "EditorShopForMore" then
		logEditorTaxonomyExposureIfApplicable(p2)
	end

	local v5

	if p4.source == "SduiTap" then
		v5 = module.activeStoreRef(false)

		if not v5 then
			sendAXCounterV2(module2.Counter.Errors.SduiTapActiveStoreMissing)
			v5 = callback()
		end
	else
		v5 = callback()
	end

	if not v5.changeCategory(p2, p3) then
		mutedError(`Failed to select catalog category (source={p4.source})`)
	end

	if p4.analytics then
		local selectedCategoryId = v5.selectedCategoryId(false)
		local selectedSubcategoryId = v5.selectedSubcategoryId(false)
		p4.analytics.clickNavigationTab(selectedCategoryId, selectedSubcategoryId)
	end
end

return applyCatalogCategorySelection
