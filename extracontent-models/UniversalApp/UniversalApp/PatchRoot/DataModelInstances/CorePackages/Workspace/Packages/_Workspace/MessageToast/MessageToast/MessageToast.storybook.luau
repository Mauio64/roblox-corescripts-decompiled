local MessageToast = script:FindFirstAncestor("MessageToast")
local MessageToastParent = MessageToast.Parent
local dependencies = require(MessageToast.dependencies)
local RobloxAppUIBloxConfig = require(MessageToastParent.Dev.RobloxAppUIBloxConfig)
local UIBlox = dependencies.UIBlox

UIBlox.init(RobloxAppUIBloxConfig)

local Roact = dependencies.Roact
local Dash = dependencies.Dash
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local mockLocale = require(MessageToastParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale

Roact.setGlobalConfig({
	propValidation = true,
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
	name = "MessageToast",
	storyRoot = script,
	roact = Roact,
	mapDefinition = function(p1) -- line: 44
		-- upvalues: Dash (copy), t2 (copy)
		local v13 = Dash.join(t2, p1.controls or {})

		return Dash.join(p1, {
			controls = v13
		})
	end,
	mapStory = function(p2) -- line: 48
		-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy)
		return function(p3) -- line: 49
			-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy), p2 (copy)
			return Roact.createElement(AppStyleProvider, {
				style = p3 and t1[p3.theme] or t1.Default
			}, {
				Child = mockLocale(p2, p3)
			})
		end
	end
}
