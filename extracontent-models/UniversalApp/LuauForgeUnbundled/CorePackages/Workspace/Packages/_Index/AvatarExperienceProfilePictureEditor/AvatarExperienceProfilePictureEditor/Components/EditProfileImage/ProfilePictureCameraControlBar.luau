local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Foundation")
local IconOnlyMenu = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceControlBar/IconOnlyMenu")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceControlBar/ControlBarTypes")

local view = Foundation.View
local iconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local function ProfilePictureCameraControlBar(props)
	local v5 = useTokens()
	local v6, v7 = React.useBinding(UDim2.fromOffset(0, 0))

	local onZoomIn = props.onZoomIn
	local onZoomOut = props.onZoomOut
	local onRotateLeft = props.onRotateLeft
	local onRotateRight = props.onRotateRight

	local v8 = React.useMemo(function()
		return {
			{
				type = "icon",
				id = "zoom-in",
				icon = iconName.PlusLarge,
				isActive = false,
				onActivated = onZoomIn
			},
			{
				type = "icon",
				id = "zoom-out",
				icon = iconName.Minus,
				isActive = false,
				onActivated = onZoomOut
			},
			{ type = "divider", id = "zoom-rotate-divider" },
			{
				type = "icon",
				id = "rotate-left",
				icon = iconName.ArrowSpinCounterClockwise,
				isActive = false,
				onActivated = onRotateLeft
			},
			{
				type = "icon",
				id = "rotate-right",
				icon = iconName.ArrowSpinClockwise,
				isActive = false,
				onActivated = onRotateRight
			}
		}
	end, { onZoomIn, onZoomOut, onRotateLeft, onRotateRight })

	return React.createElement(view, {
		tag = "position-top-left auto-xy",
		padding = {
			top = UDim.new(0, props.topOffset or 0),
			left = UDim.new(0, v5.Padding.XLarge)
		},
		ZIndex = props.zIndex,
		testId = "profile-picture-camera-control-bar"
	}, {
		Rail = React.createElement(view, {
			tag = "no-clip",
			Size = v6,
			selectionGroup = {
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			}
		}, {
			Menu = React.createElement(IconOnlyMenu, {
				items = v8,
				activeItemId = "",
				onAbsoluteSizeChanged = function(p2)
					v7(UDim2.fromOffset(p2.AbsoluteSize.X, p2.AbsoluteSize.Y))
				end
			})
		})
	})
end

return ProfilePictureCameraControlBar
