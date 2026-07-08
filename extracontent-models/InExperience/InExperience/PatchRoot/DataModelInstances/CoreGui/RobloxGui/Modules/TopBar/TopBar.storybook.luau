local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

UIBlox.init(require(CorePackages.Workspace.Packages.RobloxAppUIBloxConfig))

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

Roact.setGlobalConfig({
	elementTracing = true,
	propValidation = true
})

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

return {
	roact = Roact,
	mapStory = function(p1) -- line: 30
		-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy)
		return function(p2) -- line: 31
			-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), p1 (copy)
			return Roact.createElement(AppStyleProvider, {
				style = p2 and t1[p2.theme] or t1.Default
			}, {
				Child = Roact.createElement(p1, p2)
			})
		end
	end
}
