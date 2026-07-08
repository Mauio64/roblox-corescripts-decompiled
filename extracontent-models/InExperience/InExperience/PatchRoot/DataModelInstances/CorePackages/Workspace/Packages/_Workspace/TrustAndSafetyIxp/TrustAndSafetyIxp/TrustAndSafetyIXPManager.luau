local TrustAndSafetyIxp = script:FindFirstAncestor("TrustAndSafetyIxp")
local TrustAndSafetyIxpParent = TrustAndSafetyIxp.Parent
local GetFFlagReportAnythingAnnotationIXP = require(TrustAndSafetyIxpParent.SharedFlags).GetFFlagReportAnythingAnnotationIXP
local GetFStringReportAnythingAnnotationIXPLayerName = require(TrustAndSafetyIxpParent.SharedFlags).GetFStringReportAnythingAnnotationIXPLayerName
local GetFFlagForceReportAnythingAnnotationEnabled = require(TrustAndSafetyIxp.Flags.GetFFlagForceReportAnythingAnnotationEnabled)
local IXPServiceWrapper = require(TrustAndSafetyIxpParent.IxpServiceWrapper).IXPServiceWrapper
local v7 = require(TrustAndSafetyIxpParent.CoreScriptsInitializer).CoreLogger:new(script.Name)
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 19
	-- upvalues: IXPServiceWrapper (copy), t1 (copy)
	local t2 = {
		_initialized = false,
		_ixpInitialized = false,
		_optionalScreenshotEnabled = false,
		_reportAnythingExperienceEnabled = false,
		_reportAnythingAvatarEnabled = false,
		_ixpServiceWrapper = p1 or IXPServiceWrapper,
		_callbacks = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.getReportAnythingExperienceEnabled(p2) -- line: 33
	-- upvalues: GetFFlagForceReportAnythingAnnotationEnabled (copy)
	if GetFFlagForceReportAnythingAnnotationEnabled() then
		return true
	end

	return p2._reportAnythingExperienceEnabled or p2._optionalScreenshotEnabled
end
function t1.getReportAnythingAvatarEnabled(p3) -- line: 40
	-- upvalues: GetFFlagForceReportAnythingAnnotationEnabled (copy)
	if GetFFlagForceReportAnythingAnnotationEnabled() then
		return true
	end

	return p3._reportAnythingAvatarEnabled or p3._optionalScreenshotEnabled
end
function t1.waitForInitialization(p4, p5) -- line: 47
	if p4._ixpInitialized then
		p5()

		return
	end

	table.insert(p4._callbacks, p5)
end
function t1.initialize(p6) -- line: 55
	-- upvalues: GetFFlagReportAnythingAnnotationIXP (copy), GetFStringReportAnythingAnnotationIXPLayerName (copy), v7 (copy)
	if p6._initialized then
		return
	end

	p6._initialized = true

	local function invokeCallbacks() -- line: 61
		-- upvalues: p6 (copy)
		for _, v in ipairs(p6._callbacks) do
			v()
		end

		p6._callbacks = {}
	end

	if not GetFFlagReportAnythingAnnotationIXP() then
		p6._ixpInitialized = true
		invokeCallbacks()

		return
	end

	task.spawn(function() -- line: 74
		-- upvalues: p6 (copy), GetFStringReportAnythingAnnotationIXPLayerName (copy), v7 (copy), invokeCallbacks (copy)
		p6._ixpServiceWrapper:WaitForInitialization()

		local LayerData = p6._ixpServiceWrapper:GetLayerData(GetFStringReportAnythingAnnotationIXPLayerName())

		if LayerData then
			p6._optionalScreenshotEnabled = LayerData.OptionalScreenshotEnabled or false
			p6._reportAnythingExperienceEnabled = LayerData.OptionalScreenshotExperience or false
			p6._reportAnythingAvatarEnabled = LayerData.OptionalScreenshotAvatar or false
		end

		v7:debug("RA Optional Screenshot enabled (Avatar and/or Experience) or Select In Scene enabled? Both Avatar and Exp: {}, Exp: {}, Avatar: {}, Select in Scene: {}. Invoking {} callbacks.", p6._optionalScreenshotEnabled, p6._reportAnythingExperienceEnabled, p6._reportAnythingAvatarEnabled, p6._selectInSceneEnabled, #p6._callbacks)
		p6._ixpInitialized = true
		invokeCallbacks()
	end)
end

t1.default = t1.new()

return t1
