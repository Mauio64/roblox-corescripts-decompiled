local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local Dash = require(scriptParentParent.Dash)
local Roact = require(scriptParentParent.Roact)
local SocialTestHelpers = require(scriptParentParent.Dev.SocialTestHelpers)
local UIBlox = require(scriptParentParent.UIBlox)
local RobloxAppUIBloxConfig = require(scriptParentParent.Dev.RobloxAppUIBloxConfig)
local CapturesContext = require(scriptParent.Context.CapturesContext)
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale

UIBlox.init(RobloxAppUIBloxConfig)

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

Roact.setGlobalConfig({
	elementTracing = true
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
local t2 = {
	language = "en-us"
}

return {
	name = "CapturesInExperience",
	storyRoot = scriptParent,
	roact = Roact,
	mapDefinition = function(p1) -- line: 45
		-- upvalues: Dash (copy), t2 (copy)
		local v14 = Dash.join(t2, p1.controls)

		return Dash.join(p1, {
			controls = v14
		})
	end,
	mapStory = function(p2) -- line: 49
		-- upvalues: Roact (copy), CapturesContext (copy), Dash (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy)
		return function(p3) -- line: 50
			-- upvalues: Roact (copy), CapturesContext (copy), Dash (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy), p2 (copy)
			return Roact.createElement(CapturesContext.Provider, {
				value = {
					fireAnalyticsEvent = Dash.noop
				}
			}, {
				Element = Roact.createElement(AppStyleProvider, {
					style = p3 and t1[p3.theme] or t1.Default
				}, {
					Child = mockLocale(p2, p3)
				})
			})
		end
	end
}
