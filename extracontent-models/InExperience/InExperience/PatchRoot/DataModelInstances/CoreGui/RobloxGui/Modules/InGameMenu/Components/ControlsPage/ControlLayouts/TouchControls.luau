local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.InGameMenuDependencies).Roact
local KeyboardControls = require(script.Parent.KeyboardControls)

local function TouchControls(p1) -- line: 8
	-- upvalues: Roact (copy), KeyboardControls (copy)
	return Roact.createElement(KeyboardControls, p1)
end

return TouchControls
