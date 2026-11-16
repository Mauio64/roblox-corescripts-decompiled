local itemDetailsSduiHost = require("@luauforge/bundled/dQp").ItemDetailsSduiHost

local sduiActionType = require("@luauforge/bundled/dQa").SduiActionType

local module = require("@luauforge/bundled/dQR")

local openCatalogItemExperiences = sduiActionType.OpenCatalogItemExperiences

local function SduiOpenCatalogItemExperiencesAction(p2, p3, p4, p5)
	local actionParams = module.readActionParams(openCatalogItemExperiences, p2, p4)

	if actionParams == nil then
		return
	end

	local requiredId = module.readRequiredId(
		openCatalogItemExperiences,
		actionParams,
		"collectibleItemId",
		p4
	)

	if requiredId == nil then
		return
	end

	local v5 = itemDetailsSduiHost.get(p4.configKey)
	local openCatalogItemExperiences2 = if v5 then v5.openCatalogItemExperiences else nil

	if openCatalogItemExperiences2 == nil then
		module.reportFailedToExecute(
			openCatalogItemExperiences,
			p4,
			"No Item Details page that offers this control is mounted for this configKey"
		)
	elseif not openCatalogItemExperiences2({
		collectibleItemId = requiredId,
		isLimited = actionParams.isLimited == true
	}) then
		module.reportFailedToExecute(
			openCatalogItemExperiences,
			p4,
			`No experiences are known for collectible item {requiredId}`
		)
	end
end

return SduiOpenCatalogItemExperiencesAction
