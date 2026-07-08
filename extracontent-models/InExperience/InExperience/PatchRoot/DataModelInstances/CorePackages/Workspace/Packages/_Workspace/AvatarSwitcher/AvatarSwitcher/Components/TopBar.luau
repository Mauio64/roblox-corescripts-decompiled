local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization

local function TopBar(t1: {[any]: any}) -- line: 13
	-- upvalues: useLocalization (copy), React (copy), Foundation (copy)
	local v7 = useLocalization({
		headerText = "Feature.AvatarSwitcher.Heading.SwitchAvatar"
	})

	return (React.createElement(Foundation.View, {
		tag = "size-full-1200 row align-y-center gap-medium padding-x-medium"
	}, {
		CloseButton = React.createElement(Foundation.Image, {
			tag = "size-600 radius-small",
			Image = "icons/navigation/close",
			onActivated = t1.onClose
		}),
		HeaderText = React.createElement(Foundation.Text, {
			tag = "auto-x text-title-large",
			LayoutOrder = 2,
			Text = v7.headerText
		})
	}))
end

return TopBar
