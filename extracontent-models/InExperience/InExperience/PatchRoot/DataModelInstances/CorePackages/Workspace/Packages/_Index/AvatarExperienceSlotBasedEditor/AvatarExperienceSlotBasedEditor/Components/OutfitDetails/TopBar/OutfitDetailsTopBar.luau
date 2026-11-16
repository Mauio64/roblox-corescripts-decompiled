local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function OutfitDetailsTopBar(props)
	return React.createElement(
		Foundation.View,
		{ tag = "col size-full-0 auto-y bg-surface-0", LayoutOrder = props.LayoutOrder },
		{
			StatusBarSpacer = React.createElement(Foundation.View, {
				Size = UDim2.new(1, 0, 0, props.statusBarHeight),
				BackgroundTransparency = 1,
				LayoutOrder = 1
			}),
			ButtonRow = React.createElement(
				Foundation.View,
				{ tag = "row align-y-center size-full-0 auto-y padding-medium", LayoutOrder = 2 },
				{
					CloseButton = React.createElement(Foundation.IconButton, {
						testId = "OutfitDetailsExitButton",
						LayoutOrder = 1,
						size = InputSize.Small,
						icon = Foundation.Enums.IconName.X,
						isCircular = true,
						variant = ButtonVariant.Standard,
						onActivated = props.onClose
					})
				}
			)
		}
	)
end

return OutfitDetailsTopBar
