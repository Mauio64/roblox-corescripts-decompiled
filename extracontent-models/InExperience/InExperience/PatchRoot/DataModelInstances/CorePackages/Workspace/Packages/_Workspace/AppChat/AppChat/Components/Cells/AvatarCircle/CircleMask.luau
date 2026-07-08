local Parent = script:FindFirstAncestor("AppChat").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local useCursor = Foundation.Hooks.useCursor
local t1 = {
	Size36x36 = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-border-36x36.png",
	Size48x48 = "rbxasset://textures/ui/LuaChat/graphic/gr-profile-border-48x48.png"
}

local function CircleMask(t2: {[any]: any}) -- line: 28
	-- upvalues: t1 (copy), useCursor (copy), React (copy)
	local v8 = t1[t2.overlaySize or "Size36x36"]
	local v9 = useCursor()

	return React.createElement("ImageButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = t2.circleInteriorBackgroundColor3,
		BackgroundTransparency = t2.circleInteriorBackgroundTransparency,
		BorderSizePixel = 0,
		Image = "",
		SelectionImageObject = v9,
		AutoButtonColor = false,
		ClipsDescendants = true,
		[React.Event.Activated] = t2.onActivated,
		Selectable = t2.selectable,
		LayoutOrder = t2.LayoutOrder
	}, {
		imageMask = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
			Image = v8,
			ImageColor3 = t2.circleColor3,
			ImageTransparency = t2.circleTransparency,
			Size = UDim2.fromScale(1, 1)
		}, t2.renderAboveMask)
	}, t2.children)
end

return CircleMask
