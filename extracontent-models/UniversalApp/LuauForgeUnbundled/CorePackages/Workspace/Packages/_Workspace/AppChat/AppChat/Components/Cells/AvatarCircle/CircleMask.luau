local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local useCursor = Foundation.Hooks.useCursor

local v5 = {
	Size36x36 = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-border-36x36.png",
	Size48x48 = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-border-48x48.png"
}

local function CircleMask(props)
	local overlaySize = props.overlaySize or "Size36x36"
	local v6 = v5[overlaySize]
	local v7 = useCursor()

	return React.createElement("ImageButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = props.circleInteriorBackgroundColor3,
		BackgroundTransparency = props.circleInteriorBackgroundTransparency,
		BorderSizePixel = 0,
		Image = "",
		SelectionImageObject = v7,
		AutoButtonColor = false,
		ClipsDescendants = true,
		[React.Event.Activated] = props.onActivated,
		Selectable = props.selectable,
		LayoutOrder = props.LayoutOrder
	}, {
		imageMask = React.createElement("ImageLabel", {
			Image = v6,
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
