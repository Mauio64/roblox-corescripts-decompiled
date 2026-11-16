local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Cryo = require(parent2.Cryo)
local Foundation = require(parent2.Foundation)
local View = Foundation.View

local FFlagAddNewPlayerListFocusNav = require(parent.Flags.FFlagAddNewPlayerListFocusNav)
local FFlagRemoveNewPlayerListOverlay = require(parent.Flags.FFlagRemoveNewPlayerListOverlay)

local function EntryFrameView(props)
	local createElement = React.createElement

	local v = {
		Size = props.size,
		BackgroundTransparency = not FFlagRemoveNewPlayerListOverlay and 1 or nil,
		AutoButtonColor = 0,
		backgroundStyle = 0,
		Text = 0,
		AutoLocalize = 0,
		Selectable = 0,
		Active = 0,
		onActivated = 0,
		onStateChanged = 0,
		ref = 0
	}
	local autoButtonColor

	if not FFlagRemoveNewPlayerListOverlay then
		autoButtonColor = false
	end

	v.AutoButtonColor = autoButtonColor
	v.backgroundStyle = FFlagRemoveNewPlayerListOverlay
		and {
			Color3 = props.backgroundStyle.Color,
			Transparency = props.backgroundStyle.Transparency
		}
		or nil

	v.Text = not FFlagRemoveNewPlayerListOverlay and "" or nil
	local autoLocalize

	if not FFlagRemoveNewPlayerListOverlay then
		autoLocalize = false
	end

	v.AutoLocalize = autoLocalize
	v.Selectable = not props.isTeamFrame
	local active

	if not FFlagRemoveNewPlayerListOverlay then
		active = not props.isTeamFrame
	end

	v.Active = active

	v.onActivated = props.onActivated
	v.onStateChanged = props.onStateChanged
	local ref

	if FFlagAddNewPlayerListFocusNav then
		ref = props.forwardRef
	else
		ref = props.firstPlayerRef
	end

	v.ref = ref
	local v2

	if FFlagRemoveNewPlayerListOverlay then
		v2 = props.children
	else
		v2 = {
			BackgroundFrame = React.createElement("Frame", {
				ZIndex = 0,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = props.backgroundStyle.Transparency,
				BackgroundColor3 = props.backgroundStyle.Color,
				BorderSizePixel = 0
			}),
			DoubleOverLay = React.createElement("Frame", {
				ZIndex = 1,
				Visible = props.doubleOverlay,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = props.overlayStyle and props.overlayStyle.Transparency,
				BackgroundColor3 = props.overlayStyle and props.overlayStyle.Color,
				BorderSizePixel = 0
			}),
			OverlayFrame = React.createElement("Frame", {
				ZIndex = 2,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = props.overlayStyle and props.overlayStyle.Transparency,
				BackgroundColor3 = props.overlayStyle and props.overlayStyle.Color,
				BorderSizePixel = 0
			}, props.children)
		}
	end

	return createElement(View, v, v2)
end

if not FFlagAddNewPlayerListFocusNav then
	return React.memo(EntryFrameView)
end

local forwardRef = React.forwardRef(function(p, forwardRef)
	return React.createElement(EntryFrameView, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)

return React.memo(forwardRef)
