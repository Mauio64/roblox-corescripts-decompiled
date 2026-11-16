local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function TopBar(p)
	local v = useLocalization({ headerText = "Feature.AvatarWorkshop.Heading.AvatarWorkshop" })

	return (React.createElement(
		Foundation.View,
		{ tag = "row align-y-center gap-medium size-full-1200 padding-x-medium" },
		{
			CloseButton = React.createElement(Foundation.Image, {
				tag = "size-600 radius-small",
				Image = "icons/navigation/close",
				onActivated = p.onClose,
				testId = "avatar-workshop-close-button",
				LayoutOrder = 1
			}),
			HeaderText = React.createElement(Foundation.Text, {
				tag = "auto-x text-title-large",
				Text = v.headerText,
				LayoutOrder = 2
			})
		}
	))
end

return TopBar
