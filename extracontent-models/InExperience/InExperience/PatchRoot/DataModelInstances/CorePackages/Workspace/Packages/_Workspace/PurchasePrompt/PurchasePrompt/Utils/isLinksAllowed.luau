local parent = script.Parent.Parent
local parent2 = parent.Parent

local UserInputService = game:GetService("UserInputService")

local UpsellFlow = require(parent.Enums.UpsellFlow)
local getUpsellFlow = require(parent.NativeUpsell.getUpsellFlow)
local UniversalAppPolicy = require(parent2.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies

return function(): boolean
	local upsellFlow = getUpsellFlow((UserInputService:GetPlatform()))

	if getAppFeaturePolicies().getShouldUseDMCCALegalDisclosureInApp() then
		return true
	end

	return upsellFlow == UpsellFlow.Web
end
