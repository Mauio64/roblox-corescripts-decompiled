local Parent = script:FindFirstAncestor("TenFootUiGlobalNav").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local getIconSize = UIBlox.App.ImageSet.getIconSize
local useCursor = UIBlox.App.SelectionCursor.useCursor

local function getContentStyle(p1, p2) -- line: 13
	-- upvalues: ControlState (copy)
	local t1 = {
		Color = p2.Theme.IconEmphasis.Color,
		Transparency = p2.Theme.IconEmphasis.Transparency
	}

	if p1 == ControlState.Disabled or p1 == ControlState.Pressed then
		t1.Transparency = 0.5 * t1.Transparency + 0.5
	end

	return t1
end
local function GlobalNavOption(t2: {[any]: any}) -- line: 33
	-- upvalues: useStyle (copy), useCursor (copy), React (copy), ControlState (copy), getContentStyle (copy), getIconSize (copy), IconSize (copy), Interactable (copy), ImageSetLabel (copy)
	local v17 = useStyle()
	local v18 = useCursor(UDim.new(0.5, 0), 0)
	local v19, v20 = React.useState(ControlState.Initialize)
	local v21 = getContentStyle(v19, v17)
	local v22 = getIconSize(IconSize.Medium, v17)
	local Size_300 = v17.Tokens.Size.Size_300
	local Size_100 = v17.Tokens.Size.Size_100
	local v25 = v22 + 2 * Size_300
	local v26 = v22 + 2 * Size_100

	return React.createElement(Interactable, {
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.fromOffset(v25, v26),
		onStateChanged = v20,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		[React.Event.Activated] = t2.onActivated,
		SelectionImageObject = v18
	}, React.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(v22, v22),
		Image = t2.icon,
		ImageColor3 = v21.Color,
		ImageTransparency = v21.Transparency
	}))
end

return GlobalNavOption
