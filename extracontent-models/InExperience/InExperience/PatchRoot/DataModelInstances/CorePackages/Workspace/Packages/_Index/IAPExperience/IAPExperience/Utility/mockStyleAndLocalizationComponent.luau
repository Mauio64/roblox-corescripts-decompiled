local parent = script.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local UIBlox = require(parent2.UIBlox)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Constants = UIBlox.App.Style.Constants
local Foundation = require(parent2.Foundation)
local Dark = Foundation.Enums.ColorMode.Dark
local Gotham = Constants.FontName.Gotham

local LocaleProvider = require(parent.Locale.LocaleProvider)

return function(p)
	return Roact.createElement(LocaleProvider, {
		locale = "en-us",
		render = function()
			return Roact.createElement(AppStyleProvider, {
				style = { themeName = Dark, fontName = Gotham }
			}, { Roact.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0) }, p) })
		end
	})
end
