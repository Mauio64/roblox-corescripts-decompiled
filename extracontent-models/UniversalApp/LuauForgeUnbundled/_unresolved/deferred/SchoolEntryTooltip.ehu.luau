local module = require("@luauforge/deferred/egU")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local popover = Foundation.Popover
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local radius = Foundation.Enums.Radius
local text = Foundation.Text
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization

local module3 = require("@luauforge/deferred/eha")
require("@luauforge/deferred/egW")

local function SchoolEntryTooltip(p2)
	local v5 = useTokens()
	local v6 = module3[p2.variant]
	local v7 = useLocalization({ title = v6.TITLE, body = v6.BODY })

	return module.createElement(popover.Root, { isOpen = true }, {
		Anchor = module.createElement(popover.Anchor, { anchorRef = p2.anchorRef }),
		Content = module.createElement(popover.Content, {
			hasArrow = true,
			side = popoverSide.Bottom,
			align = popoverAlign.Center,
			radius = radius.Small,
			backgroundStyle = v5.Color.System.Contrast
		}, {
			Layout = module.createElement(
				view,
				{ tag = "col gap-xsmall auto-xy padding-x-small padding-y-small" },
				{
					Title = module.createElement(text, {
						LayoutOrder = 1,
						Text = v7.title,
						tag = "auto-xy text-caption-medium text-align-x-left content-inverse-emphasis"
					}),
					Body = module.createElement(text, {
						LayoutOrder = 2,
						Text = v7.body,
						tag = "auto-xy text-body-small text-wrap text-align-x-left content-inverse-default",
						sizeConstraint = { MaxSize = Vector2.new(280, 1e999) }
					})
				}
			)
		})
	})
end

return SchoolEntryTooltip
