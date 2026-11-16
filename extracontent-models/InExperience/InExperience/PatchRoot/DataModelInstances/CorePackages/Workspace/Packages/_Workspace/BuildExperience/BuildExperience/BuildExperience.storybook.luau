local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local LocalizationService = game:GetService("LocalizationService")

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local RobloxAppLocales = require(parent.RobloxAppLocales)

local FoundationProvider = Foundation.FoundationProvider
local LocalizationProvider = Localization.LocalizationProvider
local Device = Foundation.Enums.Device
local ColorMode = Foundation.Enums.ColorMode
local localization = RobloxAppLocales.Localization
local useStyleSheet = Foundation.Hooks.useStyleSheet

local v = { Light = ColorMode.Light, Dark = ColorMode.Dark }

local v2 = { Console = Device.Console, Desktop = Device.Desktop }

local function StyleLinkPortal(p)
	local styleSheet = useStyleSheet()
	return ReactRoblox.createPortal(React.createElement("StyleLink", { StyleSheet = styleSheet }), p.overlay)
end

return {
	name = BuildExperience.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			local ref = React.useRef(Instance.new("Frame"))

			if ref.current.Parent ~= props.focus then
				ref.current.Parent = props.focus
			end

			React.useLayoutEffect(function()
				ref.current.Size = UDim2.fromScale(1, 1)
				ref.current.BackgroundTransparency = 1
			end, {})

			local localization2 = React.useMemo(function()
				return localization.new(LocalizationService.RobloxLocaleId)
			end, {})

			return React.createElement(LocalizationProvider, { localization = localization2 }, {
				FoundationProvider = React.createElement(
					FoundationProvider,
					{
						colorMode = v[props.theme],
						device = v2[props.platform],
						preferences = props.settings,
						overlayGui = ref.current
					},
					{
						Story = React.createElement(p, props),
						StyleLink = React.createElement(StyleLinkPortal, { overlay = ref.current })
					}
				)
			})
		end
	end,
	storyRoots = { BuildExperience }
}
