local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local LocalizationService = game:GetService("LocalizationService")
local Foundation = require(BuildExperienceParent.Foundation)
local Localization = require(BuildExperienceParent.Localization)
local React = require(BuildExperienceParent.React)
local ReactRoblox = require(BuildExperienceParent.ReactRoblox)
local RobloxAppLocales = require(BuildExperienceParent.RobloxAppLocales)
local FoundationProvider = Foundation.FoundationProvider
local LocalizationProvider = Localization.LocalizationProvider
local Device = Foundation.Enums.Device
local Theme = Foundation.Enums.Theme
local Localization2 = RobloxAppLocales.Localization
local useStyleSheet = Foundation.Hooks.useStyleSheet
local t1 = {
	Light = Theme.Light,
	Dark = Theme.Dark
}
local t2 = {
	Console = Device.Console,
	Desktop = Device.Desktop
}

local function StyleLinkPortal(t3: {[any]: any}) -- line: 29
	-- upvalues: useStyleSheet (copy), ReactRoblox (copy), React (copy)
	local v19 = useStyleSheet()

	return ReactRoblox.createPortal(React.createElement("StyleLink", {
		StyleSheet = v19
	}), t3.overlay)
end

return {
	name = BuildExperience.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 39
		-- upvalues: React (copy), Localization2 (copy), LocalizationService (copy), LocalizationProvider (copy), FoundationProvider (copy), t1 (copy), t2 (copy), StyleLinkPortal (copy)
		return function(p2) -- line: 40
			-- upvalues: React (copy), Localization2 (copy), LocalizationService (copy), LocalizationProvider (copy), FoundationProvider (copy), t1 (copy), t2 (copy), p1 (copy), StyleLinkPortal (copy)
			local v22 = React.useRef(Instance.new("Frame"))

			if v22.current.Parent ~= p2.focus then
				v22.current.Parent = p2.focus
			end

			React.useLayoutEffect(function() -- line: 46
				-- upvalues: v22 (copy)
				v22.current.Size = UDim2.fromScale(1, 1)
				v22.current.BackgroundTransparency = 1
			end, {})

			local v23 = React.useMemo(function() -- line: 51
				-- upvalues: Localization2 (copy), LocalizationService (copy)
				return Localization2.new(LocalizationService.RobloxLocaleId)
			end, {})

			return React.createElement(LocalizationProvider, {
				localization = v23
			}, {
				FoundationProvider = React.createElement(FoundationProvider, {
					theme = t1[p2.theme],
					device = t2[p2.platform],
					preferences = p2.settings,
					overlayGui = v22.current
				}, {
					Story = React.createElement(p1, p2),
					StyleLink = React.createElement(StyleLinkPortal, {
						overlay = v22.current
					})
				})
			})
		end
	end,
	storyRoots = { BuildExperience }
}
