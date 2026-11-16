local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")

local icon = Foundation.Icon
local view = Foundation.View

local useCallback = React.useCallback
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Hooks/useScreenSize")
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens

local CaptureItem = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Components/CaptureItem")
require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Types")

local vector2 = Vector2.new(700, 500)

return function(props)
	local v5 = useTokens()

	local v6 = useScreenSize()
	local state, setState = useState(v6)

	local v7 = useCallback(function(p2)
		setState(p2.AbsoluteSize)
		props.onAbsoluteSizeChangedCallback(p2)
	end, { props.onAbsoluteSizeChangedCallback })

	local y = v6.Y
	local x = v6.X
	local v8 = props.enableLargeScreenMode

	if v8 then
		v8 = state.X > vector2.X and state.Y > vector2.Y
	end

	local v9 = y < x
	local v10 = props.children == nil and 1 or 0.6

	local createElement = React.createElement
	local v12 = {
		onAbsoluteSizeChanged = v7,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "size-full-full bg-over-media-0"
	}

	local createElement2 = React.createElement

	local v16 = if v8 then UDim2.fromOffset(math.min(state.X, vector2.X), (math.min(state.Y, vector2.Y))) else UDim2.fromScale(1, 1)
	local v15 = {
		Size = v16,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = {
			["anchor-center-center bg-surface-200 position-center-center"] = true,
			["radius-large"] = v8
		}
	}

	local createElement3 = React.createElement

	local v20 = {
		BackButtonContainer = React.createElement(
			view,
			{ tag = "auto-xy bg-action-subtle", ZIndex = 2 },
			{
				Padding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, v5.Padding.Large),
					PaddingLeft = UDim.new(0, v5.Padding.XXLarge),
					PaddingRight = UDim.new(0, v5.Padding.Large),
					PaddingTop = UDim.new(0, v5.Padding.XXLarge)
				}),
				BackButton = React.createElement(view, {
					onActivated = props.onCloseCallback,
					tag = {
						["auto-xy bg-over-media-300 padding-medium radius-circle"] = true
					}
				}, {
					BackIcon = React.createElement(icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						IconSize = Foundation.Enums.IconSize.Small,
						name = v8 and "icons/navigation/close" or "icons/actions/cycleLeft",
						Position = UDim2.fromScale(0.5, 0.5),
						style = v5.Color.ActionEmphasis.Foreground,
						ZIndex = 2
					})
				})
			}
		),
		CaptureContainer = 0,
		ComposerBody = 0
	}

	local createElement4 = React.createElement

	local v23 = if v9 then UDim2.new(v10, not v8 and 0 or v5.Padding.Large, 1, 0) else UDim2.fromScale(1, v10)
	v20.CaptureContainer = createElement4(view, {
		Size = v23,
		tag = {
			["bg-surface-100 clip"] = true,
			["padding-right-large"] = v8 and props.children ~= nil,
			["radius-large"] = v8
		},
		ZIndex = 1
	}, {
		CapturePreviewFrame = React.createElement(
			view,
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

	v20.ComposerBody = props.children
	return createElement(view, v12, {
		ComposerScreenContainer = createElement2(view, v15, {
			ComposerContainer = createElement3(view, {
				tag = {
					["anchor-center-center bg-action-subtle position-center-center size-full-full"] = true,
					["padding-right-large"] = v8
				}
			}, v20)
		})
	})
end
