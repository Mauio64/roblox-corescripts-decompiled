local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local ScreenshotFlowStepHandler = require(script.Parent.ScreenshotFlowStepHandler)

local extended = React.PureComponent:extend("ScreenshotFlowStepHandlerContainer")

local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

function extended.render(p)
	return React.createElement(CoreScriptsRootProvider, {}, {
		FocusNavigationCoreScriptsWrapper = React.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay,
				isIsolated = true,
				isAutoFocusRoot = true
			},
			{
				ScreenshotFlowStepHandlerContainer = React.createElement(ScreenshotFlowStepHandler, p.props)
			}
		)
	})
end

return extended
