local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Parent.Roact)
local AppStyleProvider = require(ParentParent.App.Style.AppStyleProvider)
local FoundationProvider = require(ParentParent.Parent.Foundation).FoundationProvider

require(ParentParent.App.Style.StyleTypes)

return function(p1, p2) -- line: 11
	-- upvalues: Roact (copy), FoundationProvider (copy), AppStyleProvider (copy)
	return Roact.createElement(FoundationProvider, {
		theme = "Dark",
		preferences = if not p2 then nil else {
			reducedMotion = p2.reducedMotion,
			preferredTransparency = p2.preferredTransparency
		}
	}, Roact.createElement(AppStyleProvider, {
		style = {
			themeName = "Dark",
			fontName = "Gotham",
			settings = p2
		}
	}, {
		Content = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0)
		}, p1)
	}))
end
