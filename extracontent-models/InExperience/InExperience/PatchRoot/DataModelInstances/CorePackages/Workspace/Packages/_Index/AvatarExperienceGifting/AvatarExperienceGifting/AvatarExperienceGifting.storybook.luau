local AvatarExperienceGifting = script:FindFirstAncestor("AvatarExperienceGifting")
local parent = AvatarExperienceGifting.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ReactRoblox = require(parent.Dev.ReactRoblox)

local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local useStyleSheet = Foundation.Hooks.useStyleSheet

local v = { Default = Theme.Dark, Light = Theme.Light, Dark = Theme.Dark }

local v2 = { Default = Device.Desktop, Desktop = Device.Desktop, Console = Device.Console }

local function StyleLinkPortal(p)
	local styleSheet = useStyleSheet()
	return ReactRoblox.createPortal(React.createElement("StyleLink", { StyleSheet = styleSheet }), p.overlay)
end

return {
	name = AvatarExperienceGifting.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p)
		return function(props)
			local ref = React.useRef(Instance.new("Frame"))

			if ref.current.Parent ~= props.focus then
				ref.current.Parent = props.focus
			end

			React.useLayoutEffect(function()
				ref.current.Name = "AvatarExperienceGiftingOverlay"
				ref.current.Size = UDim2.fromScale(1, 1)
				ref.current.BackgroundTransparency = 1
			end, {})

			return React.createElement(FoundationProvider, {
				theme = props and v[props.theme] or v.Default,
				device = props and v2[props.platform] or v2.Default,
				preferences = props and props.settings,
				overlayGui = ref.current
			}, {
				Story = React.createElement(p, props),
				StyleLink = React.createElement(StyleLinkPortal, { overlay = ref.current })
			})
		end
	end,
	storyRoots = { AvatarExperienceGifting }
}
