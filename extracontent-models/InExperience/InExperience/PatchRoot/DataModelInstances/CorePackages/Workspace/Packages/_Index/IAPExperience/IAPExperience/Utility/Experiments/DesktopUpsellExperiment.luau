local ParentParent = script.Parent.Parent.Parent.Parent
local IXPServiceWrapper = require(ParentParent.IXPServiceWrapper).IXPServiceWrapper
local v3 = game:DefineFastFlag("NewUpsellModalExperimentForDesktopV2", false)
local v4 = game:DefineFastString("DesktopUpsellIXPLayer", "Payments.Optimization.InExperienceUpsell.Desktop.UI")
local t1 = {
	Control = 0,
	OpenRobuxStore = 1,
	OpenPaymentsPage = 2
}

return {
	variants = t1,
	getVariant = function() -- line: 14
		-- upvalues: v3 (copy), t1 (copy), IXPServiceWrapper (copy), v4 (copy)
		if not v3 then
			return t1.Control
		end

		local LayerData = IXPServiceWrapper:GetLayerData(v4)

		if not LayerData or LayerData.newUpsellModalVariant == nil then
			return t1.Control
		end

		return LayerData.newUpsellModalVariant
	end,
	logExposure = function() -- line: 29
		-- upvalues: v3 (copy), IXPServiceWrapper (copy), v4 (copy)
		if not v3 then
			return
		end

		IXPServiceWrapper:LogUserLayerExposure(v4)
	end,
	shouldShowNewModal = function() -- line: 37
		-- upvalues: v3 (copy), IXPServiceWrapper (copy), v4 (copy), t1 (copy)
		if v3 then
			IXPServiceWrapper:LogUserLayerExposure(v4)
		end

		local Control

		if not v3 then
			Control = t1.Control
		else
			local LayerData = IXPServiceWrapper:GetLayerData(v4)

			Control = if not not LayerData and LayerData.newUpsellModalVariant ~= nil then LayerData.newUpsellModalVariant else t1.Control
		end

		return Control ~= t1.Control
	end
}
