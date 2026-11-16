local parent = script.Parent.Parent
local parent2 = parent.Parent

local UpsellFlow = require(parent.Enums.UpsellFlow)
local getUpsellFlow = require(parent.NativeUpsell.getUpsellFlow)
local ExternalSettings = require(parent.Services.ExternalSettings)
local PlatformInterface = require(parent.Services.PlatformInterface)
local Thunk = require(parent.Thunk)
local RobloxAppEnums = require(parent2.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Constants = require(parent.Misc.Constants)
local TermsOfUse = Constants.TermsOfUse
local AppContext = require(parent.Utils.AppContext)
local UniversalAppPolicy = require(parent2.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

local v = { ExternalSettings, PlatformInterface }

local function openTermsOfUse(p)
	return Thunk.new(script.Name, v, function(_, p2)
		local v2 = p2[ExternalSettings]
		local v3 = p2[PlatformInterface]

		local upsellFlow = getUpsellFlow(v2.getPlatform())

		if getAppFeaturePolicies().getShouldUseDMCCALegalDisclosureInApp() then
			if AppContext.get() == AppContext.Enum.IN_APP then
				p.navigate(AppPage.GenericWebPage, {
					detail = TermsOfUse.DMCCAUrl,
					extraProps = { title = "" }
				})
			else
				v3.openTermsOfUseDMCCA()
			end
		elseif upsellFlow == UpsellFlow.Web then
			v3.openTermsOfUse()
		end
	end)
end

return openTermsOfUse
