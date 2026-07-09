local AvatarExperienceHeadRefinement = script:FindFirstAncestor("AvatarExperienceHeadRefinement")
local AvatarExperienceHeadRefinementParent = AvatarExperienceHeadRefinement.Parent
local React = require(AvatarExperienceHeadRefinementParent.React)
local ReactRoblox = require(AvatarExperienceHeadRefinementParent.ReactRoblox)
local UIBlox = require(AvatarExperienceHeadRefinementParent.UIBlox)
local DesignTokenProvider = require(AvatarExperienceHeadRefinementParent.Style).DesignTokenProvider
local LocalizationProvider = require(AvatarExperienceHeadRefinementParent.Localization).LocalizationProvider
local Localization = require(AvatarExperienceHeadRefinementParent.AppLocales).Localization
local RoactRodux = require(AvatarExperienceHeadRefinementParent.RoactRodux)
local Rodux = require(AvatarExperienceHeadRefinementParent.Rodux)

UIBlox.init(require(AvatarExperienceHeadRefinementParent.Dev.RobloxAppUIBloxConfig))

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local function createStore() -- line: 18
	-- upvalues: Rodux (copy)
	local v15 = Rodux.createReducer({}, {})

	return Rodux.Store.new(v15, nil, { Rodux.makeThunkMiddleware({}) })
end

local t1 = {
	Default = {
		themeName = "Dark",
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
	Default = "Desktop",
	Desktop = "Desktop",
	Console = "Console"
}

return {
	name = "AvatarExperienceHeadRefinement",
	storyRoot = AvatarExperienceHeadRefinement,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 51
		-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), AppStyleProvider (copy), t1 (copy), t2 (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy)
		return function(p2) -- line: 52
			-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), AppStyleProvider (copy), t1 (copy), t2 (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), p1 (copy)
			return React.createElement(LocalizationProvider, {
				localization = Localization.new("en-us")
			}, {
				AppStyleProvider = React.createElement(AppStyleProvider, {
					style = p2 and t1[p2.theme] or t1.Default,
					device = p2 and t2[p2.platform] or t2.Default
				}, {
					StoreProvider = React.createElement(RoactRodux.StoreProvider, {
						store = createStore()
					}, {
						DesignTokenProvider = React.createElement(DesignTokenProvider, {
							tokenMappers = {}
						}, {
							Child = React.createElement(p1, p2)
						})
					})
				})
			})
		end
	end
}
