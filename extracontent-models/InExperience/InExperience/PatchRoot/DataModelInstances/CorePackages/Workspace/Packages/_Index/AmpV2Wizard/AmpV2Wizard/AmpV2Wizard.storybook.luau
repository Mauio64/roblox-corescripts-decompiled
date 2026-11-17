local parent = script:FindFirstAncestor("AmpV2Wizard").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local UIBlox = require(parent.UIBlox)
UIBlox.init(require(parent.Dev.RobloxAppUIBloxConfig))
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy
local UniversalAppPolicy2 = require(parent.UniversalAppPolicy)
local AppFeaturePolicies = UniversalAppPolicy2.AppFeaturePolicies

local Rodux = require(parent.Dev.Rodux)
local RoactRodux = require(parent.Dev.RoactRodux)
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local AppLocales = require(parent.Dev.AppLocales)
local localization = AppLocales.Localization

local FoundationProvider = Foundation.FoundationProvider

local store = Rodux.Store.new(function()
	return { ScreenSize = Vector2.new(390, 844) }
end, { ScreenSize = Vector2.new(390, 844) }, { Rodux.thunkMiddleware })

local enus = localization.new("en-us")

local v = {
	Default = Foundation.Enums.ColorMode.Dark,
	Light = Foundation.Enums.ColorMode.Light,
	Dark = Foundation.Enums.ColorMode.Dark
}

local v2 = {
	Default = "Desktop",
	Desktop = "Desktop",
	Tablet = "Tablet",
	Phone = "Phone",
	Console = "Console"
}

return {
	name = script.Parent.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(p2)
			return React.createElement(RoactAppPolicy.Provider, {
				policy = { AppFeaturePolicies },
				policyData = { hasWebViewSupportForFAE = true }
			}, {
				Store = React.createElement(RoactRodux.StoreProvider, { store = store }, {
					Localization = React.createElement(LocalizationProvider, { localization = enus }, {
						Foundation = React.createElement(FoundationProvider, {
							colorMode = p2 and v[p2.theme] or v.Default,
							device = p2 and v2[p2.platform] or "Desktop"
						}, {
							AppStyle = React.createElement(AppStyleProvider, {
								style = {
									themeName = p2 and v[p2.theme] or v.Default,
									fontName = "Gotham"
								}
							}, { Story = React.createElement(p, p2) })
						})
					})
				})
			})
		end
	end,
	storyRoots = { script.Parent }
}
