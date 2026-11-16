local dependencies = require(script.Parent.dependencies)
local roact = dependencies.Roact
local appStyleProvider = dependencies.UIBlox.App.Style.AppStyleProvider
local v = {
	Default = { themeName = "Light", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

local function StoryMiddleware(p)
	return function(p2)
		return roact.createElement(appStyleProvider, {
			style = p2 and v[p2.theme] or v.Default
		}, { Child = roact.createElement(p, p2) })
	end
end

return StoryMiddleware
