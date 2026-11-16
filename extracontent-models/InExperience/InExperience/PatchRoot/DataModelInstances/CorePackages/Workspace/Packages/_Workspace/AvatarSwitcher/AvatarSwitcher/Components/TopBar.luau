local parent = script:FindFirstAncestor("AvatarSwitcher").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function TopBar(p)
	local v = useLocalization({ headerText = "Feature.AvatarSwitcher.Heading.SwitchAvatar" })

	return (React.createElement(
		Foundation.View,
		{ tag = "size-full-1200 row align-y-center gap-medium padding-x-medium" },
		{
			CloseButton = React.createElement(Foundation.Image, {
				tag = "size-600 radius-small",
				Image = "icons/navigation/close",
				onActivated = p.onClose
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
