local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")
local AvatarExperienceSlotBasedEditorParent = AvatarExperienceSlotBasedEditor.Parent
local React = require(AvatarExperienceSlotBasedEditorParent.React)
local ReactRoblox = require(AvatarExperienceSlotBasedEditorParent.ReactRoblox)
local UIBlox = require(AvatarExperienceSlotBasedEditorParent.UIBlox)
local DesignTokenProvider = require(AvatarExperienceSlotBasedEditorParent.Style).DesignTokenProvider
local LocalizationProvider = require(AvatarExperienceSlotBasedEditorParent.Localization).LocalizationProvider
local Localization = require(AvatarExperienceSlotBasedEditorParent.Dev.AppLocales).Localization
local RoactRodux = require(AvatarExperienceSlotBasedEditorParent.RoactRodux)
local Rodux = require(AvatarExperienceSlotBasedEditorParent.Rodux)
local Foundation = require(AvatarExperienceSlotBasedEditorParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device

UIBlox.init(require(AvatarExperienceSlotBasedEditorParent.Dev.RobloxAppUIBloxConfig))

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local function createStore() -- line: 22
	-- upvalues: Rodux (copy)
	local v20 = Rodux.createReducer({}, {})

	return Rodux.Store.new(v20, nil, { Rodux.makeThunkMiddleware({}) })
end

local t1 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}
local t2 = {
	Console = Device.Console,
	Desktop = Device.Desktop
}
local t3 = {
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

return {
	name = "AvatarExperienceSlotBasedEditor",
	storyRoot = AvatarExperienceSlotBasedEditor,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 59
		-- upvalues: t1 (copy), React (copy), LocalizationProvider (copy), Localization (copy), AppStyleProvider (copy), t3 (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), FoundationProvider (copy), t2 (copy)
		return function(p2) -- line: 60
			-- upvalues: t1 (copy), React (copy), LocalizationProvider (copy), Localization (copy), AppStyleProvider (copy), t3 (copy), RoactRodux (copy), createStore (copy), DesignTokenProvider (copy), FoundationProvider (copy), t2 (copy), p1 (copy)
			local v23 = t1[p2.theme]

			return React.createElement(LocalizationProvider, {
				localization = Localization.new("en-us")
			}, {
				AppStyleProvider = React.createElement(AppStyleProvider, {
					style = p2 and t3[p2.theme] or t3.Default
				}, {
					StoreProvider = React.createElement(RoactRodux.StoreProvider, {
						store = createStore()
					}, {
						DesignTokenProvider = React.createElement(DesignTokenProvider, {
							tokenMappers = {}
						}, {
							FoundationProvider = React.createElement(FoundationProvider, {
								theme = v23,
								device = t2[p2.platform],
								preferences = p2.settings
							}, {
								Child = React.createElement(p1, p2)
							})
						})
					})
				})
			})
		end
	end
}
