local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact

local KeyboardControls = require(script.Parent.KeyboardControls)

local function TouchControls(p)
	return Roact.createElement(KeyboardControls, p)
end

return TouchControls
