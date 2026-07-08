local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ScreenshotFlowStepHandler = require(script.Parent.ScreenshotFlowStepHandler)
local v4 = React.PureComponent:extend("ScreenshotFlowStepHandlerContainer")
local CoreScriptsRootProvider = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon).CoreScriptsRootProvider
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

function v4.render(p1) -- line: 16
	-- upvalues: React (copy), CoreScriptsRootProvider (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), ScreenshotFlowStepHandler (copy)
	return React.createElement(CoreScriptsRootProvider, {}, {
		FocusNavigationCoreScriptsWrapper = React.createElement(FocusRoot, {
			isIsolated = true,
			isAutoFocusRoot = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.CentralOverlay
		}, {
			ScreenshotFlowStepHandlerContainer = React.createElement(ScreenshotFlowStepHandler, p1.props)
		})
	})
end

return v4
