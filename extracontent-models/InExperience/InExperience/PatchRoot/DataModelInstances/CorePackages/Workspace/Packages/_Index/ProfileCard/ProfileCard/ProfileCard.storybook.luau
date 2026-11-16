local LocalizationService = game:GetService("LocalizationService")

local ProfileCard = script:FindFirstAncestor("ProfileCard")
local parent = ProfileCard.Parent

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local React = require(parent.React)
local ReactRoblox = require(parent.Dev.ReactRoblox)
local RobloxAppLocales = require(parent.Dev.RobloxAppLocales)
local localization = RobloxAppLocales.Localization
local UIBlox = require(parent.UIBlox)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

UIBlox.init(require(parent.Dev.RobloxAppUIBloxConfig))

local AppFeaturePolicies = UniversalAppPolicy.AppFeaturePolicies
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local RoactAppPolicy = UniversalAppPolicy.RoactAppPolicy

local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device
local FoundationProvider = Foundation.FoundationProvider

local v = { Default = ColorMode.Dark, Dark = ColorMode.Dark, Light = ColorMode.Light }

local function isControlEnabled(controls, list: string): boolean
	if controls == nil then
		return false
	end

	if controls[list] == true then
		return true
	end

	for k, item in controls do
		if type(k) == "string" and string.sub(k, 1, #list) == list and item == true then
			return true
		end
	end

	return false
end

return {
	name = "ProfileCard",
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			local localization2 = React.useMemo(function()
				return localization.new(LocalizationService.RobloxLocaleId)
			end, {})

			local v2 = v[props.theme] or v.Default
			local controlEnabled = isControlEnabled(props.controls, "showUncheckedBadge")

			return React.createElement(LocalizationProvider, { localization = localization2 }, {
				Policy = React.createElement(RoactAppPolicy.Provider, {
					key = tostring(controlEnabled),
					policy = { AppFeaturePolicies },
					policyData = { ShowUncheckedBadge = controlEnabled }
				}, {
					Foundation = React.createElement(FoundationProvider, {
						colorMode = v2,
						device = Device[props.platform] or Device.Desktop,
						preferences = props.settings,
						scale = props.settings and props.settings.scale
					}, {
						AppStyle = React.createElement(AppStyleProvider, {
							style = { themeName = v2, fontName = "Gotham" }
						}, { Story = React.createElement(p, props) })
					})
				})
			})
		end
	end,
	storyRoots = { ProfileCard }
}
