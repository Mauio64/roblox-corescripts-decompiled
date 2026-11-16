local dependencies = require(script.Parent.Parent.Parent.dependencies)
local uiBlox = dependencies.UIBlox
local roact = dependencies.Roact

return function(testElement)
	return roact.createElement(uiBlox.App.Style.AppStyleProvider, {
		style = { themeName = "Dark", fontName = "Gotham" }
	}, { TestElement = testElement })
end
