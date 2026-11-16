local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")

local parent = ChatUIPrimitives.Parent
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)

local FoundationProvider = Foundation.FoundationProvider
local useStyleSheet = Foundation.Hooks.useStyleSheet

local function StyleLinkPortal(p)
	local styleSheet = useStyleSheet()
	return ReactRoblox.createPortal(React.createElement("StyleLink", { StyleSheet = styleSheet }), p.overlay)
end

return {
	name = ChatUIPrimitives.Name,
	roact = React,
	reactRoblox = ReactRoblox,
	storyRoots = { ChatUIPrimitives },
	mapStory = function(p)
		return function(props)
			local ref = React.useRef(Instance.new("Frame"))
			local focus = props and props.focus

			if focus ~= nil and ref.current.Parent ~= focus then
				ref.current.Parent = focus
			end

			React.useLayoutEffect(function()
				ref.current.Size = UDim2.fromScale(1, 1)
				ref.current.BackgroundTransparency = 1
			end, {})

			local createElement = React.createElement
			local v = {
				colorMode = props and props.theme,
				device = props and props.platform,
				overlayGui = 0
			}
			local overlayGui

			if focus ~= nil then
				overlayGui = ref.current
			end

			v.overlayGui = overlayGui
			local v2 = { Child = React.createElement(p, props), StyleLink = 0 }
			local styleLink

			if focus ~= nil then
				styleLink = React.createElement(StyleLinkPortal, { overlay = ref.current })
			end

			v2.StyleLink = styleLink
			return createElement(FoundationProvider, v, v2)
		end
	end
}
