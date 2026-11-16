local UpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UpsellFlow")
local getUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/NativeUpsell/getUpsellFlow")
local ExternalSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/ExternalSettings")
local PlatformInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/PlatformInterface")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/RobloxAppEnums").AppPage
local termsOfUse = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Misc/Constants").TermsOfUse
local AppContext = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/AppContext")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/UniversalAppPolicy").getAppFeaturePolicies

local v5 = { ExternalSettings, PlatformInterface }

local function openTermsOfUse(p2)
	return Thunk.new("openTermsOfUse", v5, function(p3, p4)
		local v6 = p4[ExternalSettings]
		local v7 = p4[PlatformInterface]

		local v8 = getUpsellFlow(v6.getPlatform())

		if getAppFeaturePolicies().getShouldUseDMCCALegalDisclosureInApp() then
			if AppContext.get() == AppContext.Enum.IN_APP then
				p2.navigate(appPage.GenericWebPage, {
					detail = termsOfUse.DMCCAUrl,
					extraProps = { title = "" }
				})
			else
				v7.openTermsOfUseDMCCA()
			end
		elseif v8 == UpsellFlow.Web then
			v7.openTermsOfUse()
		end
	end)
end

return openTermsOfUse
