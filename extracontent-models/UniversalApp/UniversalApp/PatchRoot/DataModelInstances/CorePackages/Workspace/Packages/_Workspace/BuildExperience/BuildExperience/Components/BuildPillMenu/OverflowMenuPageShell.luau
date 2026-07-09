local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local IconButton = Foundation.IconButton
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function OverflowMenuPageShell(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), View (copy), IconButton (copy), IconName (copy), InputSize (copy), ButtonVariant (copy), FoundationText (copy), ScrollView (copy)
	local v13 = t1.testId or "overflow-menu-page"

	return React.createElement(View, {
		tag = "col align-x-center size-full bg-surface-0",
		LayoutOrder = t1.layoutOrder,
		testId = v13
	}, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-small",
			testId = `{ v13 }-header`
		}, {
			Close = React.createElement(IconButton, {
				LayoutOrder = 1,
				isCircular = true,
				icon = t1.closeIcon or IconName.X,
				onActivated = t1.onClose,
				size = InputSize.Medium,
				testId = `{ v13 }-close`,
				variant = ButtonVariant.Utility
			}),
			Title = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "fill text-heading-medium text-align-x-left text-truncate-end content-emphasis",
				Text = t1.title
			})
		}),
		Body = React.createElement(ScrollView, {
			LayoutOrder = 2,
			tag = "fill size-full-0 bg-surface-0",
			testId = `{ v13 }-scroll-view`,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, {
			ContentBody = React.createElement(View, {
				tag = "composition-content-body col size-full-0 auto-y",
				testId = `{ v13 }-content-body`
			}, {
				Content = t1.content
			})
		}),
		Footer = React.createElement(View, {
			LayoutOrder = 3,
			tag = "composition-content-body size-full-0 auto-y",
			testId = `{ v13 }-footer-body`
		}, {
			Footer = t1.footer
		})
	})
end

return OverflowMenuPageShell
