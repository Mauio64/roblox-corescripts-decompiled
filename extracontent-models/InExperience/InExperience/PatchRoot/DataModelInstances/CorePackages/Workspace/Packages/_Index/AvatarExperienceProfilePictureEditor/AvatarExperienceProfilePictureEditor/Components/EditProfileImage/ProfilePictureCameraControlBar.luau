local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local IconOnlyMenu = require(parent.AvatarExperienceControlBar.IconOnlyMenu)
require(parent.AvatarExperienceControlBar.ControlBarTypes)

local View = Foundation.View
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local function ProfilePictureCameraControlBar(props)
	local v = useTokens()
	local size, v2 = React.useBinding(UDim2.fromOffset(0, 0))

	local onZoomIn = props.onZoomIn
	local onZoomOut = props.onZoomOut
	local onRotateLeft = props.onRotateLeft
	local onRotateRight = props.onRotateRight

	local items = React.useMemo(function()
		return {
			{
				type = "icon",
				id = "zoom-in",
				icon = IconName.PlusLarge,
				isActive = false,
				onActivated = onZoomIn
			},
			{
				type = "icon",
				id = "zoom-out",
				icon = IconName.Minus,
				isActive = false,
				onActivated = onZoomOut
			},
			{ type = "divider", id = "zoom-rotate-divider" },
			{
				type = "icon",
				id = "rotate-left",
				icon = IconName.ArrowSpinCounterClockwise,
				isActive = false,
				onActivated = onRotateLeft
			},
			{
				type = "icon",
				id = "rotate-right",
				icon = IconName.ArrowSpinClockwise,
				isActive = false,
				onActivated = onRotateRight
			}
		}
	end, { onZoomIn, onZoomOut, onRotateLeft, onRotateRight })

	return React.createElement(View, {
		tag = "position-top-left auto-xy",
		padding = {
			top = UDim.new(0, props.topOffset or 0),
			left = UDim.new(0, v.Padding.XLarge)
		},
		ZIndex = props.zIndex,
		testId = "profile-picture-camera-control-bar"
	}, {
		Rail = React.createElement(View, {
			tag = "no-clip",
			Size = size,
			selectionGroup = {
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			}
		}, {
			Menu = React.createElement(IconOnlyMenu, {
				items = items,
				activeItemId = "",
				onAbsoluteSizeChanged = function(p)
					v2(UDim2.fromOffset(p.AbsoluteSize.X, p.AbsoluteSize.Y))
				end
			})
		})
	})
end

return ProfilePictureCameraControlBar
