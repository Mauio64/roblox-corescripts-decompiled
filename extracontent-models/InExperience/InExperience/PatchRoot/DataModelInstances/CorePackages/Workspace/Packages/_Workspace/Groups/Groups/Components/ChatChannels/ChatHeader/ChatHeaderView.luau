local parent = script:FindFirstAncestor("Groups").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local Button = Foundation.Button
local IconButton = Foundation.IconButton
local Menu = Foundation.Menu
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function ChatHeaderView(props)
	local createElement = React.createElement
	local v = {
		tag = "row align-y-center gap-small size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	}
	local v2 = {
		HeaderSlot = React.createElement(View, { tag = "row fill size-0-0 auto-y", LayoutOrder = 1 }, {
			Header = React.createElement(
				View,
				{
					tag = "row align-y-center shrink gap-medium size-0-0 auto-xy padding-small radius-medium",
					onActivated = props.onClick,
					testId = `{props.testId}--header`
				},
				{
					Icon = React.createElement(Image, {
						Image = props.icon,
						ScaleType = Enum.ScaleType.Crop,
						tag = {
							["size-1000-1000"] = true,
							["radius-circle"] = props.isUserIcon,
							["radius-medium"] = not props.isUserIcon
						},
						LayoutOrder = 1,
						testId = `{props.testId}--icon`
					}),
					Details = React.createElement(
						View,
						{ tag = "col flex-x-fill shrink size-0-0 auto-xy", LayoutOrder = 2 },
						{
							Title = React.createElement(Text, {
								Text = props.title,
								tag = "auto-xy text-title-medium text-no-wrap text-align-x-left text-truncate-end content-default",
								LayoutOrder = 1
							}),
							Subtitle = React.createElement(Text, {
								Text = props.subtitle,
								tag = "auto-xy text-body-medium text-no-wrap text-align-x-left text-truncate-end content-muted",
								LayoutOrder = 2
							})
						}
					)
				}
			)
		}),
		CTA = 0,
		Overflow = 0
	}
	local cta

	if props.ctaButton then
		cta = React.createElement(Button, {
			text = props.ctaButton.title,
			onActivated = props.ctaButton.action,
			variant = props.ctaButton.type,
			size = InputSize.Small,
			LayoutOrder = 2,
			testId = `{props.testId}--cta`
		})
	end

	v2.CTA = cta
	local overflow

	if #props.menuItems > 0 then
		overflow = React.createElement(Menu, {
			items = props.menuItems,
			isOpen = props.isMenuOpen,
			onPressedOutside = props.onCloseMenu,
			side = Foundation.Enums.PopoverSide.Bottom,
			align = Foundation.Enums.PopoverAlign.End,
			selectionGroup = {
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			},
			ref = props.menuRef,
			LayoutOrder = 3,
			testId = `{props.testId}--menu`
		}, {
			Trigger = React.createElement(IconButton, {
				icon = Foundation.Enums.IconName.ThreeDotsHorizontal,
				variant = ButtonVariant.Utility,
				size = InputSize.Small,
				onActivated = props.onToggleMenu,
				testId = `{props.testId}--overflow`
			})
		})
	end

	v2.Overflow = overflow
	return createElement(View, v, v2)
end

return ChatHeaderView
