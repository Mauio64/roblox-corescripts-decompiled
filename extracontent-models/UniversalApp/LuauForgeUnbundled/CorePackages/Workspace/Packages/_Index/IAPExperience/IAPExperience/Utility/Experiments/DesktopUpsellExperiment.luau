local ixpServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/IxpServiceWrapper").IXPServiceWrapper

local defineFastFlag = game:DefineFastFlag("NewUpsellModalExperimentForDesktopV2", false)

local defineFastString = game:DefineFastString(
	"DesktopUpsellIXPLayer",
	"Payments.Optimization.InExperienceUpsell.Desktop.UI"
)

local v5 = { Control = 0, OpenRobuxStore = 1, OpenPaymentsPage = 2 }

return {
	variants = v5,
	getVariant = function()
		if not defineFastFlag then
			return v5.Control
		end

		local layerData = ixpServiceWrapper:GetLayerData(defineFastString)

		if layerData and layerData.newUpsellModalVariant ~= nil then
			return layerData.newUpsellModalVariant
		end

		return v5.Control
	end,
	logExposure = function()
		if not defineFastFlag then
			return
		end

		ixpServiceWrapper:LogUserLayerExposure(defineFastString)
	end,
	shouldShowNewModal = function(): boolean
		if defineFastFlag then
			ixpServiceWrapper:LogUserLayerExposure(defineFastString)
		end

		local v6

		if defineFastFlag then
			local layerData = ixpServiceWrapper:GetLayerData(defineFastString)

			if layerData and layerData.newUpsellModalVariant ~= nil then
				v6 = layerData.newUpsellModalVariant
			else
				v6 = v5.Control
			end
		else
			v6 = v5.Control
		end

		return v6 ~= v5.Control
	end
}
