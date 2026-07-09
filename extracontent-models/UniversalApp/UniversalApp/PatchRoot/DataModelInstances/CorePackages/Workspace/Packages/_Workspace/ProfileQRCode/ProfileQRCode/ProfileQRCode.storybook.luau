local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local Roact = require(ProfileQRCodeParent.Dev.Roact)
local UIBlox = require(ProfileQRCodeParent.UIBlox)
local Dash = require(ProfileQRCodeParent.Dash)
local mockLocale = require(ProfileQRCodeParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale
local RobloxAppUIBloxConfig = require(ProfileQRCodeParent.Dev.RobloxAppUIBloxConfig)
local Analytics = require(ProfileQRCode.Analytics)

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
	name = "ProfileQRCode",
	storyRoot = ProfileQRCode,
	roact = Roact,
	mapDefinition = function(p1) -- line: 43
		-- upvalues: Dash (copy), t2 (copy)
		local v13 = Dash.join(t2, p1.controls)

		return Dash.join(p1, {
			controls = v13
		})
	end,
	mapStory = function(p2) -- line: 47
		-- upvalues: Roact (copy), Analytics (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy)
		return function(p3) -- line: 48
			-- upvalues: Roact (copy), Analytics (copy), AppStyleProvider (copy), t1 (copy), mockLocale (copy), p2 (copy)
			return Roact.createElement(Analytics.Context.Provider, {
				value = {
					fireEvent = function() -- line: 50
					end
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
