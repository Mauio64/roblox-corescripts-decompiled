local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local module = require("@luauforge/bundled/dzE")

return function(p2, p3)
	local joined = p2 or { viewState = peekViewState.Closed }

	if p3.type == module.name then
		joined = Cryo.Dictionary.join(joined, { viewState = p3.viewState })
	end

	return joined
end
