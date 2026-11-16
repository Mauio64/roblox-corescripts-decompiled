local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/bundled/edB")
local module2 = require("@luauforge/bundled/edC")

if require("@luauforge/bundled/edD")() then
	return function(p2)
		return module2({ localizedText = p2.Text })(function(p3)
			return Roact.createElement("TextButton", Cryo.Dictionary.join(p2, {
				Text = p3.localizedText
			}))
		end)
	end
end

return module.connect({ "Text" })("TextButton")
