local UserInputService = game:GetService("UserInputService")

local UpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Enums/UpsellFlow")
local getUpsellFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/NativeUpsell/getUpsellFlow")
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/UniversalAppPolicy").getAppFeaturePolicies

return function(): boolean
	local v5 = getUpsellFlow((UserInputService:GetPlatform()))

	if getAppFeaturePolicies().getShouldUseDMCCALegalDisclosureInApp() then
		return true
	end

	return v5 == UpsellFlow.Web
end
