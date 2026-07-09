local PlayerContextualMenu = script:FindFirstAncestor("PlayerContextualMenu")
local PlayerContextualMenuParent = PlayerContextualMenu.Parent
local Dash = require(PlayerContextualMenuParent.Dash)
local Roact = require(PlayerContextualMenuParent.Dev.Roact)
local SocialTestHelpers = require(PlayerContextualMenuParent.Dev.SocialTestHelpers)
local UIBlox = require(PlayerContextualMenuParent.UIBlox)
local RobloxAppUIBloxConfig = require(PlayerContextualMenuParent.Dev.RobloxAppUIBloxConfig)
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
	name = "PlayerContextualMenu",
	storyRoot = PlayerContextualMenu,
	roact = Roact,
	mapDefinition = function(p1) -- line: 47
		-- upvalues: Dash (copy), t2 (copy)
		local v13 = Dash.join(t2, p1.controls)

		return Dash.join(p1, {
			controls = v13
		})
	end,
	mapStory = function(p2) -- line: 51
		-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy)
		return function(p3) -- line: 52
			-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy), p2 (copy)
			return Roact.createElement(AppStyleProvider, {
				style = p3 and t1[p3.theme] or t1.Default
			}, {
				Child = mockLocale(p2, p3)
			})
		end
	end
}
