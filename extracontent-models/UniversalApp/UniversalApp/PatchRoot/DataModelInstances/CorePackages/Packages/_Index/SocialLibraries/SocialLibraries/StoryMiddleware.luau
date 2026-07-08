local dependencies = require(script.Parent.dependencies)
local Roact = dependencies.Roact
local AppStyleProvider = dependencies.UIBlox.App.Style.AppStyleProvider
local t1 = {
	Default = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Light = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Dark = {
		themeName = "Dark",
		fontName = "Gotham"
	}
}

local function StoryMiddleware(p1) -- line: 21
	-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy)
	return function(p2) -- line: 22
		-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), p1 (copy)
		return Roact.createElement(AppStyleProvider, {
			style = p2 and t1[p2.theme] or t1.Default
		}, {
			Child = Roact.createElement(p1, p2)
		})
	end
end

return StoryMiddleware
