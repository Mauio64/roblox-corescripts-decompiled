local Reactions = script:FindFirstAncestor("Reactions")

local parent = Reactions.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local success, result = pcall(function()
	return require(parent.Dev.ReactRoblox)
end)

if not success then
	local packages = script:FindFirstAncestor("Packages")
	result = require(packages.ReactRoblox)
end

local ColorMode = Foundation.Enums.ColorMode
local Device = Foundation.Enums.Device
local FoundationProvider = Foundation.FoundationProvider
local useStyleSheet = Foundation.Hooks.useStyleSheet

local function StyleLinkPortal(p)
	local styleSheet = useStyleSheet()
	return result.createPortal(React.createElement("StyleLink", { StyleSheet = styleSheet }), p.overlay)
end

return {
	name = Reactions.Name,
	roact = React,
	reactRoblox = result,
	mapStory = function(p)
		return function(props)
			local ref = React.useRef(nil)

			if ref.current == nil then
				local foundationOverlay = Instance.new("Frame")
				foundationOverlay.Name = "FoundationOverlay"
				foundationOverlay.Size = UDim2.fromScale(1, 1)
				foundationOverlay.BackgroundTransparency = 1
				foundationOverlay.ZIndex = 1000
				ref.current = foundationOverlay
			end

			local current = ref.current

			if current.Parent ~= props.focus then
				current.Parent = props.focus
			end

			React.useEffect(function()
				return function()
					current:Destroy()
				end
			end, { current })

			return React.createElement(FoundationProvider, {
				colorMode = ColorMode[props.theme] or ColorMode.Dark,
				device = Device[props.platform] or Device.Desktop,
				overlayGui = current
			}, {
				Story = React.createElement(p, props),
				StyleLink = React.createElement(StyleLinkPortal, { overlay = current })
			})
		end
	end,
	storyRoots = { Reactions }
}
