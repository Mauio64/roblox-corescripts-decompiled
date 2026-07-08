local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Cryo = require(ParentParentParent.Cryo)
local View = require(ParentParentParent.Foundation).View
local FFlagAddNewPlayerListFocusNav = require(ParentParent.Flags.FFlagAddNewPlayerListFocusNav)
local FFlagRemoveNewPlayerListOverlay = require(ParentParent.Flags.FFlagRemoveNewPlayerListOverlay)

local function EntryFrameView(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), View (copy), FFlagRemoveNewPlayerListOverlay (copy), FFlagAddNewPlayerListFocusNav (copy)
	return React.createElement(View, {
		Size = t1.size,
		BackgroundTransparency = not FFlagRemoveNewPlayerListOverlay and 1 or nil,
		AutoButtonColor = not not FFlagRemoveNewPlayerListOverlay and nil,
		backgroundStyle = if not FFlagRemoveNewPlayerListOverlay then nil else {
			Color3 = t1.backgroundStyle.Color,
			Transparency = t1.backgroundStyle.Transparency
		},
		Text = not FFlagRemoveNewPlayerListOverlay and "" or nil,
		AutoLocalize = not not FFlagRemoveNewPlayerListOverlay and nil,
		Selectable = not t1.isTeamFrame,
		Active = if not FFlagRemoveNewPlayerListOverlay then not t1.isTeamFrame else nil,
		onActivated = t1.onActivated,
		onStateChanged = t1.onStateChanged,
		ref = if not FFlagAddNewPlayerListFocusNav then t1.firstPlayerRef else t1.forwardRef
	}, if not FFlagRemoveNewPlayerListOverlay then {
		BackgroundFrame = React.createElement("Frame", {
			ZIndex = 0,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = t1.backgroundStyle.Transparency,
			BackgroundColor3 = t1.backgroundStyle.Color
		}),
		DoubleOverLay = React.createElement("Frame", {
			ZIndex = 1,
			BorderSizePixel = 0,
			Visible = t1.doubleOverlay,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = t1.overlayStyle and t1.overlayStyle.Transparency,
			BackgroundColor3 = t1.overlayStyle and t1.overlayStyle.Color
		}),
		OverlayFrame = React.createElement("Frame", {
			ZIndex = 2,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = t1.overlayStyle and t1.overlayStyle.Transparency,
			BackgroundColor3 = t1.overlayStyle and t1.overlayStyle.Color
		}, t1.children)
	} else t1.children)
end

if FFlagAddNewPlayerListFocusNav then
	local v9 = React.forwardRef(function(p1, p2) -- line: 85
		-- upvalues: React (copy), EntryFrameView (copy), Cryo (copy)
		return React.createElement(EntryFrameView, Cryo.Dictionary.join(p1, {
			forwardRef = p2
		}))
	end)

	return React.memo(v9)
end

return React.memo(EntryFrameView)
