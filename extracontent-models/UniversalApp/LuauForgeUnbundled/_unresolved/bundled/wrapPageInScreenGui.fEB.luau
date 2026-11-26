local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local function wrapPageInScreenGui(p2, p3, p4, p5)
	return Roact.createElement(p2, p5)
end

return wrapPageInScreenGui
