local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local NavigationEvents = require(CorePackages.Packages.RoactNavigation).NavigationEvents
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)

local function OnFocusLayerExposureLogger(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), NavigationEvents (copy), IxpUtils (copy)
	return React.createElement(NavigationEvents, {
		onDidFocus = function() -- line: 23
			-- upvalues: t1 (copy), IxpUtils (copy)
			for _, v8 in t1.ixpLayers do
				if v8 ~= nil then
					IxpUtils.logLayerExposure(v8)
				end
			end
		end
	})
end

return OnFocusLayerExposureLogger
