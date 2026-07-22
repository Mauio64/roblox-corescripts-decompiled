local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function OutfitDetailsTopBar(t1: {[any]: any}) -- line: 15
	-- upvalues: React (copy), Foundation (copy), InputSize (copy), ButtonVariant (copy)
	return React.createElement(Foundation.View, {
		tag = "col size-full-0 auto-y bg-surface-0",
		LayoutOrder = t1.LayoutOrder
	}, {
		StatusBarSpacer = React.createElement(Foundation.View, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, t1.statusBarHeight)
		}),
		ButtonRow = React.createElement(Foundation.View, {
			tag = "row align-y-center size-full-0 auto-y padding-medium",
			LayoutOrder = 2
		}, {
			CloseButton = React.createElement(Foundation.IconButton, {
				testId = "OutfitDetailsExitButton",
				LayoutOrder = 1,
				isCircular = true,
				size = InputSize.Small,
				icon = Foundation.Enums.IconName.X,
				variant = ButtonVariant.Standard,
				onActivated = t1.onClose
			})
		})
	})
end

return OutfitDetailsTopBar
