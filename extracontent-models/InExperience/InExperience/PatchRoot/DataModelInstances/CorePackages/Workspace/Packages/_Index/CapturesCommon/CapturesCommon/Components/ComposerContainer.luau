local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)
local Icon = Foundation.Icon
local View = Foundation.View
local useCallback = React.useCallback
local useScreenSize = require(ParentParent.Hooks.useScreenSize)
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens
local CaptureItem = require(ParentParent.Components.CaptureItem)

require(ParentParent.Types)

local vector2 = Vector2.new(700, 500)

return function(t1: {[any]: any}) -- line: 31
	-- upvalues: useTokens (copy), useScreenSize (copy), useState (copy), useCallback (copy), vector2 (copy), React (copy), View (copy), Foundation (copy), Icon (copy), CaptureItem (copy)
	local v14 = useTokens()
	local v15 = useScreenSize()
	local v16, v17 = useState(v15)
	local v18 = useCallback(function(p1) -- line: 37
		-- upvalues: v17 (copy), t1 (copy)
		v17(p1.AbsoluteSize)
		t1.onAbsoluteSizeChangedCallback(p1)
	end, { t1.onAbsoluteSizeChangedCallback })
	local Y = v15.Y
	local X = v15.X
	local v21 = t1.enableLargeScreenMode and (v16.X > vector2.X and v16.Y > vector2.Y)
	local v22 = Y < X
	local v23 = t1.children ~= nil and 0.6 or 1

	return React.createElement(View, {
		tag = "size-full-full bg-over-media-0",
		onAbsoluteSizeChanged = v18,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		}
	}, {
		ComposerScreenContainer = React.createElement(View, {
			Size = if not v21 then UDim2.fromScale(1, 1) else UDim2.fromOffset(math.min(v16.X, vector2.X), (math.min(v16.Y, vector2.Y))),
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			},
			tag = {
				["anchor-center-center bg-surface-200 position-center-center"] = true,
				["radius-large"] = v21
			}
		}, {
			ComposerContainer = React.createElement(View, {
				tag = {
					["anchor-center-center bg-action-subtle position-center-center size-full-full"] = true,
					["padding-right-large"] = v21
				}
			}, {
				BackButtonContainer = React.createElement(View, {
					tag = "auto-xy bg-action-subtle",
					ZIndex = 2
				}, {
					Padding = React.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, v14.Padding.Large),
						PaddingLeft = UDim.new(0, v14.Padding.XXLarge),
						PaddingRight = UDim.new(0, v14.Padding.Large),
						PaddingTop = UDim.new(0, v14.Padding.XXLarge)
					}),
					BackButton = React.createElement(View, {
						onActivated = t1.onCloseCallback,
						tag = {
							["auto-xy bg-over-media-300 padding-medium radius-circle"] = true
						}
					}, {
						BackIcon = React.createElement(Icon, {
							ZIndex = 2,
							AnchorPoint = Vector2.new(0.5, 0.5),
							IconSize = Foundation.Enums.IconSize.Small,
							name = not v21 and "icons/actions/cycleLeft" or "icons/navigation/close",
							Position = UDim2.fromScale(0.5, 0.5),
							style = v14.Color.ActionEmphasis.Foreground
						})
					})
				}),
				CaptureContainer = React.createElement(View, {
					ZIndex = 1,
					Size = if not v22 then UDim2.fromScale(1, v23) else UDim2.new(v23, not v21 and 0 or v14.Padding.Large, 1, 0),
					tag = {
						["bg-surface-100 clip"] = true,
						["padding-right-large"] = v21 and t1.children ~= nil,
						["radius-large"] = v21
					}
				}, {
					CapturePreviewFrame = React.createElement(View, {
						LayoutOrder = 2,
						tag = "anchor-center-center bg-action-subtle position-center-center size-full-full"
					}, {
						CapturePreview = React.createElement(CaptureItem, {
							isVideoPlaying = true,
							capture = t1.capture,
							onActivated = function() -- line: 120
							end,
							scaleType = Enum.ScaleType.Fit
						})
					})
				}),
				ComposerBody = t1.children
			})
		})
	})
end
