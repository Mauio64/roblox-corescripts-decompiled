local parent = script:FindFirstAncestor("AppChat").Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local useCursor = Foundation.Hooks.useCursor

local v = {
	Size36x36 = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-border-36x36.png",
	Size48x48 = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-border-48x48.png"
}

local function CircleMask(props)
	local overlaySize = props.overlaySize or "Size36x36"
	local image = v[overlaySize]
	local selectionImageObject = useCursor()

	return React.createElement("ImageButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = props.circleInteriorBackgroundColor3,
		BackgroundTransparency = props.circleInteriorBackgroundTransparency,
		BorderSizePixel = 0,
		Image = "",
		SelectionImageObject = selectionImageObject,
		AutoButtonColor = false,
		ClipsDescendants = true,
		[React.Event.Activated] = props.onActivated,
		Selectable = props.selectable,
		LayoutOrder = props.LayoutOrder
	}, {
		imageMask = React.createElement("ImageLabel", {
			Image = image,
			ImageColor3 = props.circleColor3,
			ImageTransparency = props.circleTransparency,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2
		}, props.renderAboveMask)
	}, props.children)
end

return CircleMask
