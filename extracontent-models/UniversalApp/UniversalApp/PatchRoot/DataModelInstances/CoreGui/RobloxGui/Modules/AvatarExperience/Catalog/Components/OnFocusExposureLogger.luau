local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local NavigationEvents = require(CorePackages.Packages.RoactNavigation).NavigationEvents
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)

local function OnFocusExposureLogger(t1: {[any]: any}) -- line: 21
	-- upvalues: IxpUtils (copy), React (copy), NavigationEvents (copy)
	local v7 = IxpUtils.useLogExposureOnce(t1.ixpTest)

	if not t1.ixpTest.isEnabled() then
		return nil
	end

	return React.createElement(NavigationEvents, {
		onDidFocus = v7
	})
end

return OnFocusExposureLogger
