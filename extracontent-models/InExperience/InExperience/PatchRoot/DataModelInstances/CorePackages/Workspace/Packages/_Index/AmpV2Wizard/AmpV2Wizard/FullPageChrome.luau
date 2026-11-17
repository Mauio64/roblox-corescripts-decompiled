local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Divider = Foundation.Divider
local HeaderBar = Foundation.HeaderBar
local IconName = Foundation.Enums.IconName

local FFlagAmpV2WizardFullPageHeaderAlign = require(AmpV2Wizard.FFlagAmpV2WizardFullPageHeaderAlign)

local function FullPageChrome(props)
	local onBack = props.onBack
	local onClose = props.onClose
	local title = props.title

	local createElement = React.createElement
	local root = HeaderBar.Root
	local leading2

	if not (onBack == nil and (title == nil or title == "")) then
		local createElement2 = React.createElement
		local leading = HeaderBar.Leading
		local actions

		if onBack ~= nil then
			actions = React.createElement(HeaderBar.Actions, {
				actions = {
					{ id = "back", icon = IconName.ChevronLargeLeft, onActivated = onBack }
				}
			})
		end

		local title2

		if not (title == nil or title == "") then
			title2 = React.createElement(Text, {
				Text = title,
				tag = "auto-xy text-heading-medium content-emphasis",
				LayoutOrder = 2
			})
		end

		leading2 = createElement2(leading, nil, { Actions = actions, Title = title2 })
	end

	local trailing

	if onClose ~= nil then
		trailing = React.createElement(HeaderBar.Trailing, nil, {
			Actions = React.createElement(HeaderBar.Actions, {
				actions = {
					{ id = "close", icon = IconName.X, onActivated = onClose }
				}
			})
		})
	end

	local element = createElement(root, { LayoutOrder = 1 }, {
		Leading = leading2,
		Trailing = trailing
	})

	if FFlagAmpV2WizardFullPageHeaderAlign then
		return React.createElement(
			View,
			{
				tag = "col align-x-center size-full bg-surface-0",
				testId = "amp-v2-wizard-full-page"
			},
			{
				Column = React.createElement(View, {
					tag = "col fill size-full-0",
					testId = "amp-v2-wizard-full-page-column",
					sizeConstraint = { MaxSize = Vector2.new(480, 1e999) }
				}, {
					Header = React.createElement(
						View,
						{
							tag = "size-full-0 auto-y padding-x-small",
							LayoutOrder = 1,
							testId = "amp-v2-wizard-full-page-header"
						},
						{ Bar = element }
					),
					Content = React.createElement(
						View,
						{
							tag = "col fill size-full-0",
							LayoutOrder = 2,
							testId = "amp-v2-wizard-full-page-content"
						},
						props.children
					)
				})
			}
		)
	end

	return React.createElement(
		View,
		{ tag = "col align-x-center size-full bg-surface-0", testId = "amp-v2-wizard-full-page" },
		{
			Header = element,
			HeaderDivider = React.createElement(Divider, { LayoutOrder = 2 }),
			Content = React.createElement(View, {
				tag = "col fill size-full-0",
				LayoutOrder = 3,
				sizeConstraint = { MaxSize = Vector2.new(480, 1e999) }
			}, props.children)
		}
	)
end

return FullPageChrome
