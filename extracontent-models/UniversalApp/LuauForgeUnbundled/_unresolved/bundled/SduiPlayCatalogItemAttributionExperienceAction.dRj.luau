local itemDetailsSduiHost = require("@luauforge/bundled/dQp").ItemDetailsSduiHost

local sduiActionType = require("@luauforge/bundled/dQa").SduiActionType

local module = require("@luauforge/bundled/dQR")

local playCatalogItemAttributionExperience = sduiActionType.PlayCatalogItemAttributionExperience

local function SduiPlayCatalogItemAttributionExperienceAction(p2, p3, p4, p5)
	local actionParams = module.readActionParams(playCatalogItemAttributionExperience, p2, p4)

	if actionParams == nil then
		return
	end

	local requiredId = module.readRequiredId(
		playCatalogItemAttributionExperience,
		actionParams,
		"universeId",
		p4
	)

	if requiredId == nil then
		return
	end

	local v5 = itemDetailsSduiHost.get(p4.configKey)
	local getCatalogItemAttributionPlay = if v5 then v5.getCatalogItemAttributionPlay else nil

	if getCatalogItemAttributionPlay == nil then
		module.reportFailedToExecute(
			playCatalogItemAttributionExperience,
			p4,
			"No Item Details page that offers this control is mounted for this configKey"
		)

		return
	end

	local catalogItemAttributionPlay = getCatalogItemAttributionPlay()

	if catalogItemAttributionPlay == nil then
		module.reportFailedToExecute(
			playCatalogItemAttributionExperience,
			p4,
			"The mounted Item Details page has not loaded the experience the item was made in"
		)
	elseif catalogItemAttributionPlay.universeId == requiredId then
		catalogItemAttributionPlay.play()
	else
		module.reportFailedToExecute(
			playCatalogItemAttributionExperience,
			p4,
			`The mounted Item Details page loaded universe {catalogItemAttributionPlay.universeId}, not {requiredId}`
		)
	end
end

return SduiPlayCatalogItemAttributionExperienceAction
