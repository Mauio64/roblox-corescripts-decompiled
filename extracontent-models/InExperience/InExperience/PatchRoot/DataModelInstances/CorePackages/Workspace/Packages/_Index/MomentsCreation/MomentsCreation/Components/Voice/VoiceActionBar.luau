local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Button = Foundation.Button
local IconButton = Foundation.IconButton
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local FFlagMomentsTTSCompactActionBar = require(MomentsCreation.Flags.FFlagMomentsTTSCompactActionBar)
local size

if FFlagMomentsTTSCompactActionBar then
	size = InputSize.Medium
else
	size = InputSize.Large
end

local function VoiceActionBar(props)
	return React.createElement(
		View,
		{ LayoutOrder = props.layoutOrder, tag = "row align-y-center gap-small size-full-0 auto-y" },
		{
			Primary = React.createElement(View, { LayoutOrder = 1, tag = "fill auto-y" }, {
				ButtonBounds = React.createElement(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						ref = props.primaryRef
					},
					{
						Button = React.createElement(Button, {
							fillBehavior = FillBehavior.Fill,
							isDisabled = props.primaryIsDisabled,
							isLoading = props.primaryIsLoading,
							onActivated = props.primaryOnActivated,
							size = size,
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
					IconButton = React.createElement(IconButton, {
						icon = IconName.TrashCan,
						onActivated = props.onDelete,
						size = size,
						variant = ButtonVariant.Standard
					})
				}
			)
		}
	)
end

return VoiceActionBar
