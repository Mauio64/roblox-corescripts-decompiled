local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local UIBlox = require(scriptParentParent.UIBlox)

UIBlox.init(require(scriptParentParent.Dev.RobloxAppUIBloxConfig))

local dependencies = require(scriptParent.dependencies)
local Roact = dependencies.Roact
local llama = dependencies.llama
local mockLocale = require(scriptParentParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

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
	name = "ContactImporter",
	storyRoot = scriptParent,
	roact = Roact,
	mapDefinition = function(p1) -- line: 44
		-- upvalues: llama (copy), t2 (copy)
		local v12 = llama.Dictionary.join(t2, p1.controls or {})

		return llama.Dictionary.join(p1, {
			controls = v12
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
