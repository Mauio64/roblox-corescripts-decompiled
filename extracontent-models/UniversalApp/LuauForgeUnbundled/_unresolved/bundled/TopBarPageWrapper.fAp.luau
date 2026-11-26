local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/fAn")
local module2 = require("@luauforge/bundled/fAo")

local function TopBarPageWrapper(p2)
	local topBarSlot = p2.topBarSlot
	local clone = table.clone(p2)
	clone.topBarSlot = nil

	if topBarSlot then
		return React.createElement(React.Fragment, nil, {
			TopBar = topBarSlot,
			TopBarPageContent = React.createElement(module, clone)
		})
	end

	return React.createElement(module2, clone)
end

return TopBarPageWrapper
