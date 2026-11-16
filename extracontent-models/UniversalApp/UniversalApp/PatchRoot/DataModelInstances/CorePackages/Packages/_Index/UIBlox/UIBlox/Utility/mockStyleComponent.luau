local parent = script.Parent.Parent
local Roact = require(parent.Parent.Roact)

local AppStyleProvider = require(parent.App.Style.AppStyleProvider)
local Foundation = require(parent.Parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider

require(parent.App.Style.StyleTypes)

return function(p, settings)
	return Roact.createElement(FoundationProvider, {
		theme = "Dark",
		preferences = settings and {
			reducedMotion = settings.reducedMotion,
			preferredTransparency = settings.preferredTransparency
		} or nil
	}, Roact.createElement(AppStyleProvider, {
		style = { themeName = "Dark", fontName = "Gotham", settings = settings }
	}, {
		Content = Roact.createElement("Frame", { Size = UDim2.new(1, 0, 1, 0) }, p)
	}))
end
