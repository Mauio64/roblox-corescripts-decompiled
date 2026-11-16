local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/fNP")

local function withTheme_DEPRECATED(p2)
	local function ComponentWithTheme(p3)
		return Roact.createElement(module.Consumer, {
			render = function(p4)
				return Roact.createElement(p2, Cryo.Dictionary.join(p3, {
					appTheme = p4
				}))
			end
		})
	end

	return ComponentWithTheme
end

return withTheme_DEPRECATED
