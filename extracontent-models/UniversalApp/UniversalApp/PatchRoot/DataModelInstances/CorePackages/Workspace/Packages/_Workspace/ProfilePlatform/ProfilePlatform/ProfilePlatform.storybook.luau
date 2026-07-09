local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Roact = require(ProfilePlatformParent.Dev.Roact)
local RoactRodux = require(ProfilePlatformParent.RoactRodux)
local Rodux = require(ProfilePlatformParent.Rodux)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local Cryo = require(ProfilePlatformParent.Cryo)
local mockLocale = require(ProfilePlatformParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale
local RobloxAppUIBloxConfig = require(ProfilePlatformParent.Dev.RobloxAppUIBloxConfig)

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

local function v13(p1) -- line: 41
	-- upvalues: Rodux (copy), Cryo (copy)
	return Rodux.Store.new(function() -- line: 42
		-- upvalues: Cryo (copy), p1 (copy)
		return Cryo.Dictionary.join(p1, {
			ScreenSize = Vector2.new(600, 600)
		})
	end, {}, { Rodux.thunkMiddleware })
end

return {
	name = "ProfilePlatform",
	storyRoot = ProfilePlatform,
	roact = Roact,
	roactRodux = RoactRodux,
	mapDefinition = function(p2) -- line: 54
		-- upvalues: Cryo (copy), t2 (copy)
		local v16 = Cryo.Dictionary.join(t2, p2.controls or {})

		return Cryo.Dictionary.join(p2, {
			controls = v16
		})
	end,
	mapStory = function(p3) -- line: 58
		-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), RoactRodux (copy), v13 (copy), mockLocale (copy)
		return function(p4) -- line: 59
			-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), RoactRodux (copy), v13 (copy), mockLocale (copy), p3 (copy)
			local v19 = p4.definition.state or {}

			return Roact.createElement(AppStyleProvider, {
				style = p4 and t1[p4.theme] or t1.Default
			}, {
				storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
					store = v13(v19)
				}, {
					Child = mockLocale(p3, p4)
				})
			})
		end
	end
}
