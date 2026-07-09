local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local function wrapPageInScreenGui(p1, _, _, p4) -- line: 4
	-- upvalues: Roact (copy)
	return Roact.createElement(p1, p4)
end

return wrapPageInScreenGui
