local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local NavigationEvents = require(CorePackages.Packages.RoactNavigation).NavigationEvents
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXBackendDrivenCatalogLayers = AvatarExperienceFlags.FFlagAXBackendDrivenCatalogLayers
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local Constants = require(Modules.AvatarExperience.Common.Constants)
local v10 = game:DefineFastFlag("AXCatalogBELayerExposureCounter", false)
local FFlagBasedExposureLoggingCatalogPage = AvatarExperienceFlags.FFlagBasedExposureLoggingCatalogPage
local FFlagAXLegacyIXPExposureLogging = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXLegacyIXPExposureLogging
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper

local function OnFocusExperimentExposureLogger(t1: {[any]: any}) -- line: 33
	-- upvalues: React (copy), NavigationEvents (copy), FFlagAXLegacyIXPExposureLogging (copy), IxpUtils (copy), FFlagAXBackendDrivenCatalogLayers (copy), v10 (copy), sendAXCounterV2 (copy), Constants (copy), FFlagBasedExposureLoggingCatalogPage (copy), IXPServiceWrapper (copy)
	return React.createElement(NavigationEvents, {
		onDidFocus = function() -- line: 35
			-- upvalues: t1 (copy), FFlagAXLegacyIXPExposureLogging (copy), IxpUtils (copy), FFlagAXBackendDrivenCatalogLayers (copy), v10 (copy), sendAXCounterV2 (copy), Constants (copy), FFlagBasedExposureLoggingCatalogPage (copy), IXPServiceWrapper (copy)
			for _, v17 in t1.ixpTests do
				if v17 ~= nil and v17.isEnabled() then
					if FFlagAXLegacyIXPExposureLogging then
						if v17.logExposureEnabled and v17.logExposureEnabled() then
							IxpUtils.logExperimentExposure(v17)
						end
					else
						IxpUtils.logExperimentExposure(v17)
					end
				end
			end

			if FFlagAXBackendDrivenCatalogLayers and t1.layers and #t1.layers > 0 then
				if v10 then
					sendAXCounterV2(Constants.Counter.LayerExposure.CatalogView)
				end

				for _, v19 in t1.layers do
					IxpUtils.logLayerExposure(v19)
				end
			end

			if FFlagBasedExposureLoggingCatalogPage and t1.flagIXPTestLayers then
				for _, v21 in t1.flagIXPTestLayers do
					if v21 then
						IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v21)
					end
				end
			end
		end
	})
end

return OnFocusExperimentExposureLogger
