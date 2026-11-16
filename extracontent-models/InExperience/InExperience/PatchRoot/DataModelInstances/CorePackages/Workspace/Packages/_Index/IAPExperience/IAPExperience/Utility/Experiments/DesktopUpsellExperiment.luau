local parent = script.Parent.Parent.Parent.Parent
local IXPServiceWrapper = require(parent.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper

local defineFastFlag = game:DefineFastFlag("NewUpsellModalExperimentForDesktopV2", false)

local defineFastString = game:DefineFastString(
	"DesktopUpsellIXPLayer",
	"Payments.Optimization.InExperienceUpsell.Desktop.UI"
)

local variants = { Control = 0, OpenRobuxStore = 1, OpenPaymentsPage = 2 }

local function getVariant() -- 1 equivalent call inferred from this helper
	if not defineFastFlag then
		return variants.Control
	end

	local layerData = ixpServiceWrapper:GetLayerData(defineFastString)

	if layerData and layerData.newUpsellModalVariant ~= nil then
		return layerData.newUpsellModalVariant
	end

	return variants.Control
end

local function logExposure() -- 1 equivalent call inferred from this helper
	if not defineFastFlag then
		return
	end

	ixpServiceWrapper:LogUserLayerExposure(defineFastString)
end

return {
	variants = variants,
	getVariant = getVariant,
	logExposure = logExposure,
	shouldShowNewModal = function(): boolean
		logExposure() -- inferred equivalent call
		return getVariant() ~= variants.Control -- inferred equivalent call
	end
}
