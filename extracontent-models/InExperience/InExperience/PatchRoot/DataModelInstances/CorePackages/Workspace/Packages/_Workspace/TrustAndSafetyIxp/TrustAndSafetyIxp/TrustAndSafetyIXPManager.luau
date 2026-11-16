local TrustAndSafetyIxp = script:FindFirstAncestor("TrustAndSafetyIxp")
local parent = TrustAndSafetyIxp.Parent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagReportAnythingAnnotationIXP = SharedFlags.GetFFlagReportAnythingAnnotationIXP

local SharedFlags2 = require(parent.SharedFlags)
local GetFStringReportAnythingAnnotationIXPLayerName = SharedFlags2.GetFStringReportAnythingAnnotationIXPLayerName

local GetFFlagForceReportAnythingAnnotationEnabled = require(TrustAndSafetyIxp.Flags.GetFFlagForceReportAnythingAnnotationEnabled)
local IxpServiceWrapper = require(parent.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local CoreScriptsInitializer = require(parent.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)

local TrustAndSafetyIXPManager = {}
TrustAndSafetyIXPManager.__index = TrustAndSafetyIXPManager

function TrustAndSafetyIXPManager.new(p)
	local v2 = {
		_ixpServiceWrapper = p or IXPServiceWrapper,
		_initialized = false,
		_ixpInitialized = false,
		_optionalScreenshotEnabled = false,
		_reportAnythingExperienceEnabled = false,
		_reportAnythingAvatarEnabled = false,
		_callbacks = {}
	}

	setmetatable(v2, TrustAndSafetyIXPManager)
	return v2
end

function TrustAndSafetyIXPManager:getReportAnythingExperienceEnabled()
	if GetFFlagForceReportAnythingAnnotationEnabled() then
		return true
	end

	return self._reportAnythingExperienceEnabled or self._optionalScreenshotEnabled
end

function TrustAndSafetyIXPManager:getReportAnythingAvatarEnabled()
	if GetFFlagForceReportAnythingAnnotationEnabled() then
		return true
	end

	return self._reportAnythingAvatarEnabled or self._optionalScreenshotEnabled
end

function TrustAndSafetyIXPManager:waitForInitialization(callback)
	if self._ixpInitialized then
		callback()
	else
		table.insert(self._callbacks, callback)
	end
end

function TrustAndSafetyIXPManager:initialize()
	if self._initialized then
		return
	end

	self._initialized = true

	local function invokeCallbacks()
		for _, callback in ipairs(self._callbacks) do
			callback()
		end

		self._callbacks = {}
	end

	if GetFFlagReportAnythingAnnotationIXP() then
		task.spawn(function()
			self._ixpServiceWrapper:WaitForInitialization()
			local layerData = self._ixpServiceWrapper:GetLayerData(GetFStringReportAnythingAnnotationIXPLayerName())

			if layerData then
				self._optionalScreenshotEnabled = layerData.OptionalScreenshotEnabled or false
				self._reportAnythingExperienceEnabled = layerData.OptionalScreenshotExperience or false
				self._reportAnythingAvatarEnabled = layerData.OptionalScreenshotAvatar or false
			end

			v:debug(
				"RA Optional Screenshot enabled (Avatar and/or Experience) or Select In Scene enabled? Both Avatar and Exp: {}, Exp: {}, Avatar: {}, Select in Scene: {}. Invoking {} callbacks.",
				self._optionalScreenshotEnabled,
				self._reportAnythingExperienceEnabled,
				self._reportAnythingAvatarEnabled,
				self._selectInSceneEnabled,
				#self._callbacks
			)

			self._ixpInitialized = true
			invokeCallbacks()
		end)
		return
	end

	self._ixpInitialized = true
	invokeCallbacks()
end

TrustAndSafetyIXPManager.default = TrustAndSafetyIXPManager.new()
return TrustAndSafetyIXPManager
