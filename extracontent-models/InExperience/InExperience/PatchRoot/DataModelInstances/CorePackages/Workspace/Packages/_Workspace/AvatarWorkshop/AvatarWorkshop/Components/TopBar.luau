local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function TopBar(props)
	local v = useLocalization({ headerText = props.titleKey })

	local createElement = React.createElement
	local view = Foundation.View
	local backButton

	if props.onBack then
		backButton = React.createElement(Foundation.Image, {
			tag = "size-600 radius-small",
			Image = "icons/navigation/pushBack",
			onActivated = props.onBack,
			testId = "avatar-workshop-back-button",
			LayoutOrder = 1
		})
	end

	local closeButton

	if not props.onBack then
		closeButton = React.createElement(Foundation.Image, {
			tag = "size-600 radius-small",
			Image = "icons/navigation/close",
			onActivated = props.onClose,
			testId = "avatar-workshop-close-button",
			LayoutOrder = 1
		})
	end

	return (createElement(view, {
		tag = "row align-y-center gap-medium size-full-1200 padding-x-medium"
	}, {
		BackButton = backButton,
		CloseButton = closeButton,
		HeaderText = React.createElement(Foundation.Text, {
			tag = "auto-x text-title-large",
			Text = v.headerText,
			LayoutOrder = 2
		})
	}))
end

return TopBar
