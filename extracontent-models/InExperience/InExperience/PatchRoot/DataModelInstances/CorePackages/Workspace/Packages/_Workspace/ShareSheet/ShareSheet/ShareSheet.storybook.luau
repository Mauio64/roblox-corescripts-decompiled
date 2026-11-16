local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local LocalizationService = game:GetService("LocalizationService")

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local RobloxAppLocales = require(parent.RobloxAppLocales)

local LocalizationProvider = Localization.LocalizationProvider
local localization = RobloxAppLocales.Localization

local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device

local v = { Dark = ColorMode.Dark, Light = ColorMode.Light }

local useStyleSheet = Foundation.Hooks.useStyleSheet

local function StyleLinkPortal(p)
	local styleSheet = useStyleSheet()
	return ReactRoblox.createPortal(React.createElement("StyleLink", { StyleSheet = styleSheet }), p.overlay)
end

return {
	name = "ShareSheet",
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
				React.createElement(FoundationProvider, {
					colorMode = v[props.theme] or ColorMode.Dark,
					device = Device[props.platform] or Device.Phone,
					preferences = props.settings,
					scale = props.settings and props.settings.scale,
					overlayGui = ref.current
				}, {
					Story = React.createElement(p, props),
					StyleLink = React.createElement(StyleLinkPortal, { overlay = ref.current })
				})
			})
		end
	end,
	storyRoot = ShareSheet
}
