local parent = script.Parent.Parent
local parent2 = parent.Parent

local Foundation = require(parent2.Foundation)
local React = require(parent2.React)

local Icon = Foundation.Icon
local View = Foundation.View

local useCallback = React.useCallback
local useScreenSize = require(parent.Hooks.useScreenSize)
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens

local CaptureItem = require(parent.Components.CaptureItem)
require(parent.Types)

local vector2 = Vector2.new(700, 500)

return function(props)
	local v = useTokens()

	local v2 = useScreenSize()
	local state, setState = useState(v2)

	local onAbsoluteSizeChanged = useCallback(function(p)
		setState(p.AbsoluteSize)
		props.onAbsoluteSizeChangedCallback(p)
	end, { props.onAbsoluteSizeChangedCallback })

	local y = v2.Y
	local x = v2.X
	local v3 = props.enableLargeScreenMode

	if v3 then
		if state.X > vector2.X then
			v3 = state.Y > vector2.Y
		else
			v3 = false
		end
	end

	local v4 = y < x
	local v5 = props.children == nil and 1 or 0.6

	local createElement = React.createElement
	local v6 = {
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "size-full-full bg-over-media-0"
	}

	local createElement2 = React.createElement
	local size

	if v3 then
		size = UDim2.fromOffset(math.min(state.X, vector2.X), (math.min(state.Y, vector2.Y)))
	else
		size = UDim2.fromScale(1, 1)
	end

	local v7 = {
		Size = size,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = {
			["anchor-center-center bg-surface-200 position-center-center"] = true,
			["radius-large"] = v3
		}
	}

	local createElement3 = React.createElement

	local v8 = {
		BackButtonContainer = React.createElement(View, {
			tag = "auto-xy bg-action-subtle",
			ZIndex = 2
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v.Padding.Large),
				PaddingLeft = UDim.new(0, v.Padding.XXLarge),
				PaddingRight = UDim.new(0, v.Padding.Large),
				PaddingTop = UDim.new(0, v.Padding.XXLarge)
			}),
			BackButton = React.createElement(View, {
				onActivated = props.onCloseCallback,
				tag = { ["auto-xy bg-over-media-300 padding-medium radius-circle"] = true }
			}, {
				BackIcon = React.createElement(Icon, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					IconSize = Foundation.Enums.IconSize.Small,
					name = v3 and "icons/navigation/close" or "icons/actions/cycleLeft",
					Position = UDim2.fromScale(0.5, 0.5),
					style = v.Color.ActionEmphasis.Foreground,
					ZIndex = 2
				})
			})
		}),
		CaptureContainer = 0,
		ComposerBody = 0
	}

	local createElement4 = React.createElement
	local size2

	if v4 then
		size2 = UDim2.new(v5, not v3 and 0 or v.Padding.Large, 1, 0)
	else
		size2 = UDim2.fromScale(1, v5)
	end

	v8.CaptureContainer = createElement4(View, {
		Size = size2,
		tag = {
			["bg-surface-100 clip"] = true,
			["padding-right-large"] = v3 and props.children ~= nil,
			["radius-large"] = v3
		},
		ZIndex = 1
	}, {
		CapturePreviewFrame = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "anchor-center-center bg-action-subtle position-center-center size-full-full"
			},
			{
				CapturePreview = React.createElement(CaptureItem, {
					capture = props.capture,
					isVideoPlaying = true,
					onActivated = function() end,
					scaleType = Enum.ScaleType.Fit
				})
			}
		)
	})

	v8.ComposerBody = props.children
	return createElement(View, v6, {
		ComposerScreenContainer = createElement2(View, v7, {
			ComposerContainer = createElement3(View, {
				tag = {
					["anchor-center-center bg-action-subtle position-center-center size-full-full"] = true,
					["padding-right-large"] = v3
				}
			}, v8)
		})
	})
end
