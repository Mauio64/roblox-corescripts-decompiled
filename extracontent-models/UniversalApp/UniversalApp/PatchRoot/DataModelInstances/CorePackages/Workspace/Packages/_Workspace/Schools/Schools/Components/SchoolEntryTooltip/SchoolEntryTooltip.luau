local Schools = script:FindFirstAncestor("Schools")
local SchoolsParent = Schools.Parent
local React = require(SchoolsParent.React)
local Foundation = require(SchoolsParent.Foundation)
local Popover = Foundation.Popover
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local EnumsRadius = Foundation.Enums.Radius
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(SchoolsParent.Localization).Hooks.useLocalization
local Constants = require(Schools.Common.Constants)

require(Schools.Common.Enums)

local function SchoolEntryTooltip(t1: {[any]: any}) -- line: 27
	-- upvalues: useTokens (copy), Constants (copy), useLocalization (copy), React (copy), Popover (copy), PopoverSide (copy), PopoverAlign (copy), EnumsRadius (copy), View (copy), FoundationText (copy)
	local v16 = useTokens()
	local v17 = Constants[t1.variant]
	local v18 = useLocalization({
		title = v17.TITLE,
		body = v17.BODY
	})

	return React.createElement(Popover.Root, {
		isOpen = true
	}, {
		Anchor = React.createElement(Popover.Anchor, {
			anchorRef = t1.anchorRef
		}),
		Content = React.createElement(Popover.Content, {
			hasArrow = true,
			side = PopoverSide.Bottom,
			align = PopoverAlign.Center,
			radius = EnumsRadius.Small,
			backgroundStyle = v16.Color.System.Contrast
		}, {
			Layout = React.createElement(View, {
				tag = "col gap-xsmall auto-xy padding-x-small padding-y-small"
			}, {
				Title = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-caption-medium text-align-x-left content-inverse-emphasis",
					Text = v18.title
				}),
				Body = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-body-small text-wrap text-align-x-left content-inverse-default",
					Text = v18.body,
					sizeConstraint = {
						MaxSize = Vector2.new(280, 1e999)
					}
				})
			})
		})
	})
end

return SchoolEntryTooltip
