local dependencies = require(script.Parent.Parent.Parent.dependencies)
local UIBlox = dependencies.UIBlox
local Roact = dependencies.Roact

return function(p1) -- line: 5
	-- upvalues: Roact (copy), UIBlox (copy)
	return Roact.createElement(UIBlox.App.Style.AppStyleProvider, {
		style = {
			themeName = "Dark",
			fontName = "Gotham"
		}
	}, {
		TestElement = p1
	})
end
