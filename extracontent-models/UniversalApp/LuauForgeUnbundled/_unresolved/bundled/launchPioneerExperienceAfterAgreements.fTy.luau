local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies
local launchPioneerExperience = require("@luauforge/bundled/fDJ").launchPioneerExperience

local function launchPioneerExperienceAfterAgreements(callback, p2, p3)
	local function launch()
		launchPioneerExperience()
	end

	if not getAppFeaturePolicies().getCheckUserAgreementsUpdatedOnLogin() then
		launchPioneerExperience()

		return
	end

	local fetchUpdatedUserAgreements = require("@luauforge/bundled/fOd").FetchUpdatedUserAgreements
	local module = require("@luauforge/bundled/edP")
	local module2 = require("@luauforge/bundled/edO")

	fetchUpdatedUserAgreements(p2, p3):andThen(function(list)
		if list and #list > 0 then
			callback(module(
				module2.UserAgreementsUpdatedPopup,
				{ agreements = list, agreementAccepted = launch },
				{ DisableBackButtonClose = true }
			))
		else
			launchPioneerExperience()
		end
	end, function()
		launchPioneerExperience()
	end)
end

return launchPioneerExperienceAfterAgreements
