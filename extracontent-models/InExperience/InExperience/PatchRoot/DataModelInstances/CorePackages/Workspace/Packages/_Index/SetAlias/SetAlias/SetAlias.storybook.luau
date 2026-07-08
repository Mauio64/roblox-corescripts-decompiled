local SetAlias = script:FindFirstAncestor("SetAlias")
local SetAliasParent = SetAlias.Parent
local dependencies = require(SetAlias.dependencies)
local Roact = dependencies.Roact
local Dash = dependencies.Dash
local UIBlox = dependencies.UIBlox
local RobloxAppUIBloxConfig = require(SetAliasParent.Dev.RobloxAppUIBloxConfig)
local mockLocale = require(SetAliasParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale

UIBlox.init(RobloxAppUIBloxConfig)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
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
local t2 = {
	language = "en-us"
}

return {
	name = "SetAlias",
	storyRoot = SetAlias,
	roact = Roact,
	mapDefinition = function(p1) -- line: 40
		-- upvalues: Dash (copy), t2 (copy)
		local v13 = Dash.join(t2, p1.controls or {})

		return Dash.join(p1, {
			controls = v13
		})
	end,
	mapStory = function(p2) -- line: 44
		-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy)
		return function(p3) -- line: 45
			-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy), p2 (copy)
			return Roact.createElement(AppStyleProvider, {
				style = p3 and t1[p3.theme] or t1.Default
			}, {
				Child = mockLocale(p2, p3)
			})
		end
	end
}
