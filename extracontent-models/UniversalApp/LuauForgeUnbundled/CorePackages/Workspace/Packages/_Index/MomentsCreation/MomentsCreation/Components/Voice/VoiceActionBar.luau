local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local button = Foundation.Button
local iconButton = Foundation.IconButton
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local v5 = if require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSCompactActionBar") then inputSize.Medium else inputSize.Large

local function VoiceActionBar(props)
	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "row align-y-center gap-small size-full-0 auto-y"
		},
		{
			Primary = React.createElement(view, {
				LayoutOrder = 1,
				tag = "fill auto-y"
			}, {
				ButtonBounds = React.createElement(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						ref = props.primaryRef
					},
					{
						Button = React.createElement(button, {
							fillBehavior = fillBehavior.Fill,
							isDisabled = props.primaryIsDisabled,
							isLoading = props.primaryIsLoading,
							onActivated = props.primaryOnActivated,
							size = v5,
							text = props.primaryText,
							variant = props.primaryVariant,
							width = UDim.new(1, 0)
						})
					}
				)
			}),
			Delete = React.createElement(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					ref = props.deleteRef
				},
				{
					IconButton = React.createElement(iconButton, {
						icon = iconName.TrashCan,
						onActivated = props.onDelete,
						size = v5,
						variant = buttonVariant.Standard
					})
				}
			)
		}
	)
end

return VoiceActionBar
