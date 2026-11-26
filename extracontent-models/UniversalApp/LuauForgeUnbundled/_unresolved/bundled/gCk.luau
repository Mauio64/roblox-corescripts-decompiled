local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local module = require("@luauforge/bundled/egY")
local module2 = require("@luauforge/bundled/egZ")

if require("@luauforge/bundled/eha")() then
	return function(p2)
		return module2({ localizedText = p2.Text })(function(p3)
			return Roact.createElement("TextLabel", Cryo.Dictionary.join(p2, {
				Text = p3.localizedText
			}))
		end)
	end
end

return module.connect({ "Text" })("TextLabel")
