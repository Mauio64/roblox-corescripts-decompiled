local Groups = script:FindFirstAncestor("Groups")
local parent = Groups.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.Dev.ReactRoblox)
local UIBlox = require(parent.UIBlox)
local Rodux = require(parent.Dev.Rodux)
local RoactRodux = require(parent.Dev.RoactRodux)

local Style = require(parent.Style)
local DesignTokenProvider = Style.DesignTokenProvider
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider

local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal

UIBlox.init(require(parent.Dev.RobloxAppUIBloxConfig))
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local function createStore()
	local reducer = Rodux.createReducer({}, {})
	return Rodux.Store.new(reducer, nil, { Rodux.thunkMiddleware })
end

local v = {
	Default = { themeName = "Dark", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

local localization = {
	Format = function(_, p: string)
		return p
	end,
	GetLocale = function(): string
		return "en-us"
	end,
	changed = Signal.new()
}

return {
	name = Groups and Groups.Name or "Groups",
	storyRoot = Groups,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(p2)
			local style = p2 and v[p2.theme] or v.Default
			local themeName = style.themeName

			return React.createElement(LocalizationProvider, { localization = localization }, {
				FoundationProvider = React.createElement(
					FoundationProvider,
					{ device = "Desktop", colorMode = themeName },
					{
						AppStyleProvider = React.createElement(AppStyleProvider, { style = style }, {
							StoreProvider = React.createElement(RoactRodux.StoreProvider, {
								store = createStore()
							}, {
								DesignTokenProvider = React.createElement(DesignTokenProvider, {
									tokenMappers = {}
								}, {
									Child = React.createElement(p, p2)
								})
							})
						})
					}
				)
			})
		end
	end
}
