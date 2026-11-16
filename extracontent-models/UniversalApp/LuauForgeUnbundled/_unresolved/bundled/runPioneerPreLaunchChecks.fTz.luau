local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies
local fetchUpdatedUserAgreements = require("@luauforge/bundled/fOd").FetchUpdatedUserAgreements
local launchPioneerExperience = require("@luauforge/bundled/fDJ").launchPioneerExperience

local module = require("@luauforge/bundled/fTA")
local Models = require("@game/CorePackages/Packages/_Index/RoduxUsers/RoduxUsers/Models")
local module3 = require("@luauforge/bundled/edP")
local module4 = require("@luauforge/bundled/edO")

local function fetchPendingAgreements(p2, p3)
	if getAppFeaturePolicies().getCheckUserAgreementsUpdatedOnLogin() then
		return fetchUpdatedUserAgreements(p2, p3):andThen(function(options)
			return options or {}
		end):catch(function()
			return {}
		end)
	end

	return Promise.resolve({})
end

local function runPioneerPreLaunchChecks(callback, p2, p3, p4)
	local module5 = require("@luauforge/bundled/fTx")
	local function launch()
		module5(p2, Models.fromLocalStorage().userId)
		launchPioneerExperience()
	end

	local v5 = module(p2)
	local v6 = fetchPendingAgreements(p2, p3)

	v5:andThen(function(p5)
		if p5.isPlayable then
			v6:andThen(function(list)
				if #list > 0 then
					callback(module3(
						module4.UserAgreementsUpdatedPopup,
						{ agreements = list, agreementAccepted = launch },
						{ DisableBackButtonClose = true }
					))
					return
				end

				module5(p2, Models.fromLocalStorage().userId)
				launchPioneerExperience()
			end)
		else
			p4.onBlocked(p5.playabilityStatus or "UnplayableOtherReason")
		end
	end, function()
		p4.onComplianceError()
	end)
end

return runPioneerPreLaunchChecks
