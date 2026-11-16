local LocalizationService = game:GetService("LocalizationService")

local constants = require("@luauforge/deferred/fUP").Constants
local localization = require("@luauforge/deferred/fVe").Localization
local module = require("@luauforge/deferred/fVo")
require("@luauforge/deferred/fUR")

local INTERVENTION_TYPES = constants.INTERVENTION_TYPES

local v5 = localization.new(LocalizationService.RobloxLocaleId)

local function determinePunishmentDescription(data)
	if data.isKidsTreatment then
		if data.interventionType == INTERVENTION_TYPES.Warning then
			return v5:Format("Feature.NotApproved.Description.WarningDescription.Kids")
		end

		if data.interventionType == INTERVENTION_TYPES.Banned then
			if DateTime.fromIsoDate(data.endDate) then
				return v5:Format("Feature.NotApproved.Description.SuspendedUntil", {
					date = module(data.endDate, data.translations, "LL"),
					time = module(data.endDate, data.translations, "LT")
				})
			end
		elseif data.interventionType == INTERVENTION_TYPES.Deleted then
			return v5:Format("Feature.NotApproved.Description.BannedDescription.Kids")
		end
	end

	if data.interventionType == INTERVENTION_TYPES.Deleted then
		return v5:Format("Feature.NotApproved.Description.BrokeRulesBanned")
	end

	if #data.violationReasons > 0 then
		if data.violationType and data.violationType ~= "" then
			return v5:Format("Feature.NotApproved.Description.BrokeRulesTypePolicy.V2", {
				type = data.violationType,
				policy = string.lower(table.concat(data.violationReasons, ", "))
			})
		end

		return v5:Format("Feature.NotApproved.Description.BrokeRulesPolicy.V2", {
			policy = string.lower(table.concat(data.violationReasons, ", "))
		})
	elseif data.violationType and data.violationType ~= "" then
		return v5:Format("Feature.NotApproved.Description.BrokeRulesType", {
			type = data.violationType
		})
	else
		return v5:Format("Feature.NotApproved.Description.BrokeRulesGeneric")
	end
end

return determinePunishmentDescription
