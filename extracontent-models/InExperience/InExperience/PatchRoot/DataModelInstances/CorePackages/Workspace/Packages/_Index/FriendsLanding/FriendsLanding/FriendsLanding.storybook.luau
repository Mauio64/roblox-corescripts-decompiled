local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local Logger = require(FriendsLanding.Logger)
local dependencies = require(FriendsLanding.dependencies)
local AppStyleProvider = dependencies.UIBlox.App.Style.AppStyleProvider
local Roact = dependencies.Roact
local UniversalAppPolicy = dependencies.UniversalAppPolicy
local llama = dependencies.llama
local FriendsLandingParent = FriendsLanding.Parent
local mockLocale = require(FriendsLandingParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale
local v10 = dependencies.Lumberyak.Logger.new()

v10:addSink({
	maxLevel = v10.Levels.fromString("info"),
	log = function(_, p2, _) -- line: 25
		print(p2)
	end
})
Logger:setParent(v10)

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
	mapDefinition = function(p4) -- line: 52
		-- upvalues: llama (copy), t2 (copy)
		local v17 = llama.Dictionary.join(t2, p4.controls or {})

		return llama.Dictionary.join(p4, {
			controls = v17
		})
	end,
	roact = Roact,
	mapStory = function(p5) -- line: 57
		-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), UniversalAppPolicy (copy), mockLocale (copy)
		return function(p6) -- line: 58
			-- upvalues: Roact (copy), AppStyleProvider (copy), t1 (copy), UniversalAppPolicy (copy), mockLocale (copy), p5 (copy)
			return Roact.createElement(AppStyleProvider, {
				style = p6 and t1[p6.theme] or t1.Default
			}, { Roact.createElement(UniversalAppPolicy.Provider, {
				policy = { function() -- line: 64
					-- upvalues: p6 (copy)
					return {
						getShowDisplayName = function() -- line: 66
							-- upvalues: p6 (copy)
							return p6.controls.getShowDisplayName
						end
					}
				end }
			}, {
				Child = mockLocale(p5, p6)
			}) })
		end
	end
}
