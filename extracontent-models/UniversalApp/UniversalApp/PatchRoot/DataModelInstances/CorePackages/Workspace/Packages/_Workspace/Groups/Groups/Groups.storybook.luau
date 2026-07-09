local Groups = script:FindFirstAncestor("Groups")
local GroupsParent = Groups.Parent
local React = require(GroupsParent.React)
local ReactRoblox = require(GroupsParent.Dev.ReactRoblox)
local UIBlox = require(GroupsParent.UIBlox)
local Rodux = require(GroupsParent.Dev.Rodux)
local RoactRodux = require(GroupsParent.Dev.RoactRodux)
local DesignTokenProvider = require(GroupsParent.Style).DesignTokenProvider
local LocalizationProvider = require(GroupsParent.Localization).LocalizationProvider
local FoundationProvider = require(GroupsParent.Foundation).FoundationProvider
local Signal = require(GroupsParent.AppCommonLib).Signal

UIBlox.init(require(GroupsParent.Dev.RobloxAppUIBloxConfig))

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local function createStore() -- line: 27
	-- upvalues: Rodux (copy)
	local v16 = Rodux.createReducer({}, {})

	return Rodux.Store.new(v16, nil, { Rodux.thunkMiddleware })
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
	Format = function(_, s1: string) -- line: 48
		return s1
	end,
	GetLocale = function() -- line: 51
		return "en-us"
	end,
	changed = Signal.new()
}

return {
	name = Groups and Groups.Name or "Groups",
	storyRoot = Groups,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p2) -- line: 62
		-- upvalues: t1 (copy), React (copy), LocalizationProvider (copy), t2 (copy), FoundationProvider (copy), AppStyleProvider (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy)
		return function(p3) -- line: 63
			-- upvalues: t1 (copy), React (copy), LocalizationProvider (copy), t2 (copy), FoundationProvider (copy), AppStyleProvider (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), p2 (copy)
			local v21 = p3 and t1[p3.theme] or t1.Default
			local themeName = v21.themeName

			return React.createElement(LocalizationProvider, {
				localization = t2
			}, {
				FoundationProvider = React.createElement(FoundationProvider, {
					device = "Desktop",
					theme = themeName
				}, {
					AppStyleProvider = React.createElement(AppStyleProvider, {
						style = v21
					}, {
						StoreProvider = React.createElement(RoactRodux.StoreProvider, {
							store = createStore()
						}, {
							DesignTokenProvider = React.createElement(DesignTokenProvider, {
								tokenMappers = {}
							}, {
								Child = React.createElement(p2, p3)
							})
						})
					})
				})
			})
		end
	end
}
