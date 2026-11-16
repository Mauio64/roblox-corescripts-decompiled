local module = require("@luauforge/bundled/gvb")

local module2 = require("@luauforge/bundled/gvj")
local view = module2.View
local text = module2.Text
local divider = module2.Divider
local headerBar = module2.HeaderBar
local iconName = module2.Enums.IconName

local module3 = require("@luauforge/bundled/gvs")

local function FullPageChrome(props)
	local onBack = props.onBack
	local onClose = props.onClose
	local title = props.title

	local createElement = module.createElement
	local root = headerBar.Root
	local v7

	if not (onBack == nil and (title == nil or title == "")) then
		local createElement2 = module.createElement
		local leading = headerBar.Leading

		local v10 = if onBack ~= nil then module.createElement(headerBar.Actions, {
			actions = {
				{ id = "back", icon = iconName.ChevronLargeLeft, onActivated = onBack }
			}
		}) else nil

		local v11 = if title ~= nil and title ~= "" then module.createElement(text, {
			Text = title,
			tag = "auto-xy text-heading-medium content-emphasis",
			LayoutOrder = 2
		}) else nil
		v7 = createElement2(leading, nil, { Actions = v10, Title = v11 })
	end

	local v8 = if onClose ~= nil then module.createElement(headerBar.Trailing, nil, {
		Actions = module.createElement(headerBar.Actions, {
			actions = {
				{ id = "close", icon = iconName.X, onActivated = onClose }
			}
		})
	}) else nil
	local element = createElement(root, { LayoutOrder = 1 }, {
		Leading = v7,
		Trailing = v8
	})

	if module3 then
		return module.createElement(
			view,
			{
				tag = "col align-x-center size-full bg-surface-0",
				testId = "amp-v2-wizard-full-page"
			},
			{
				Column = module.createElement(view, {
					tag = "col fill size-full-0",
					testId = "amp-v2-wizard-full-page-column",
					sizeConstraint = { MaxSize = Vector2.new(480, 1e999) }
				}, {
					Header = module.createElement(
						view,
						{
							tag = "size-full-0 auto-y padding-x-small",
							LayoutOrder = 1,
							testId = "amp-v2-wizard-full-page-header"
						},
						{ Bar = element }
					),
					Content = module.createElement(
						view,
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

	return module.createElement(
		view,
		{
			tag = "col align-x-center size-full bg-surface-0",
			testId = "amp-v2-wizard-full-page"
		},
		{
			Header = element,
			HeaderDivider = module.createElement(divider, { LayoutOrder = 2 }),
			Content = module.createElement(view, {
				tag = "col fill size-full-0",
				LayoutOrder = 3,
				sizeConstraint = { MaxSize = Vector2.new(480, 1e999) }
			}, props.children)
		}
	)
end

return FullPageChrome
