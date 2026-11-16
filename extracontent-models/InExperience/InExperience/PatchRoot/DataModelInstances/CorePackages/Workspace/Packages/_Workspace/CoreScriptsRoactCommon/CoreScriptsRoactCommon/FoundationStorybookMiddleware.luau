local parent = script:FindFirstAncestor("CoreScriptsRoactCommon").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local FoundationProvider = Foundation.FoundationProvider

local v = {
	Default = Foundation.Enums.ColorMode.Dark,
	Light = Foundation.Enums.ColorMode.Light,
	Dark = Foundation.Enums.ColorMode.Dark
}

local v2 = { Default = "Desktop", Desktop = "Desktop", Console = "Console" }

local useStyleSheet = Foundation.Hooks.useStyleSheet

local function StyleLinkPortal(p)
	if useStyleSheet() and p.overlay then
		return ReactRoblox.createPortal(nil, p.overlay)
	end

	return nil
end

local function useCreateOverlay(props)
	local ref = React.useRef(Instance.new("Frame"))

	if ref.current.Parent ~= props.focus then
		ref.current.Parent = props.focus
	end

	React.useEffect(function()
		ref.current.Size = UDim2.fromScale(1, 1)
		ref.current.BackgroundTransparency = 1

		return function()
			ref.current:Destroy()
		end
	end, {})

	return ref.current
end

local function FoundationStorybookMiddleware(p)
	return function(props)
		local v3 = useCreateOverlay(props)
		local colorMode = v[props.theme]
		return React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1
			},
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 10),
					PaddingBottom = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 10),
					PaddingRight = UDim.new(0, 10)
				}),
				FoundationContext = React.createElement(FoundationProvider, {
					colorMode = colorMode,
					device = v2[props.platform],
					preferences = props.settings,
					scale = props.settings and props.settings.scale,
					overlayGui = v3
				}, {
					Child = React.createElement(p, props),
					StyleLink = React.createElement(StyleLinkPortal, { overlay = v3 })
				})
			}
		)
	end
end

return FoundationStorybookMiddleware
