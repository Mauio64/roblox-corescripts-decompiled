local Parent = script:FindFirstAncestor("NotApprovedPage").Parent
local Localization = require(Parent.RobloxAppLocales).Localization
local LocalizationService = game:GetService("LocalizationService")
local v4 = Localization.new(LocalizationService.RobloxLocaleId)
local INTERVENTION_TYPES = require(Parent.NotApprovedPageShared).Constants.INTERVENTION_TYPES

local function determinePunishmentDescription(s1: string, s2: string, t1: {[any]: any}) -- line: 23
	-- upvalues: INTERVENTION_TYPES (copy), v4 (copy)
	if s2 == INTERVENTION_TYPES.Deleted then
		return v4:Format("Feature.NotApproved.Description.BrokeRulesBanned")
	end

	if #t1 > 0 then
		if s1 and s1 ~= "" then
			return v4:Format("Feature.NotApproved.Description.BrokeRulesTypePolicy.V2", {
				type = s1,
				policy = string.lower(table.concat(t1, ", "))
			})
		end

		return v4:Format("Feature.NotApproved.Description.BrokeRulesPolicy.V2", {
			policy = string.lower(table.concat(t1, ", "))
		})
	end

	if s1 and s1 ~= "" then
		return v4:Format("Feature.NotApproved.Description.BrokeRulesType", {
			type = s1
		})
	end

	return v4:Format("Feature.NotApproved.Description.BrokeRulesGeneric")
end

return determinePunishmentDescription
