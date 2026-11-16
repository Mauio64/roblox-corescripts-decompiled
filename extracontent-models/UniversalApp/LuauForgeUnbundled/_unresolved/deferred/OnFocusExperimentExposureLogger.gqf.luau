local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local navigationEvents = RoactNavigation.NavigationEvents
local module = require("@luauforge/bundled/dMB")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXBackendDrivenCatalogLayers = AvatarExperienceFlags.FFlagAXBackendDrivenCatalogLayers
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2
local module3 = require("@luauforge/bundled/dMx")
local defineFastFlag = game:DefineFastFlag("AXCatalogBELayerExposureCounter", false)
local fFlagBasedExposureLoggingCatalogPage = AvatarExperienceFlags.FFlagBasedExposureLoggingCatalogPage

local fFlagAXLegacyIXPExposureLogging = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXLegacyIXPExposureLogging
local ixpServiceWrapper = require("@luauforge/bundled/fvx").IXPServiceWrapper

local function OnFocusExperimentExposureLogger(props)
	return React.createElement(navigationEvents, {
		onDidFocus = function()
			for k, ixpTest in props.ixpTests do
				if not (ixpTest ~= nil and ixpTest.isEnabled()) then
					continue
				end

				if fFlagAXLegacyIXPExposureLogging then
					if ixpTest.logExposureEnabled and ixpTest.logExposureEnabled() then
						module.logExperimentExposure(ixpTest)
					end
				else
					module.logExperimentExposure(ixpTest)
				end
			end

			if fFlagAXBackendDrivenCatalogLayers and props.layers and #props.layers > 0 then
				if defineFastFlag then
					sendAXCounterV2(module3.Counter.LayerExposure.CatalogView)
				end

				for k, layer in props.layers do
					module.logLayerExposure(layer)
				end
			end

			if fFlagBasedExposureLoggingCatalogPage and props.flagIXPTestLayers then
				for k, flagIXPTestLayer in props.flagIXPTestLayers do
					if flagIXPTestLayer then
						ixpServiceWrapper:LogFlagLinkedUserLayerExposure(flagIXPTestLayer)
					end
				end
			end
		end
	})
end

return OnFocusExperimentExposureLogger
