local Parent = script:FindFirstAncestor("Schools").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ButtonVariant = Foundation.Enums.ButtonVariant

local function SchoolsPageHeader(t1: {[any]: any}) -- line: 23
	-- upvalues: React (copy), View (copy), IconButton (copy), IconName (copy), IconSize (copy), ButtonVariant (copy), FoundationText (copy)
	return React.createElement(View, {
		tag = "row align-y-center gap-small size-full-0 auto-y padding-x-xlarge padding-y-small bg-surface-0",
		LayoutOrder = t1.layoutOrder,
		testId = t1.testId
	}, {
		BackButton = React.createElement(IconButton, {
			LayoutOrder = 1,
			icon = IconName.ChevronLargeLeft,
			size = IconSize.Medium,
			variant = ButtonVariant.Utility,
			onActivated = t1.onBack
		}),
		Title = React.createElement(FoundationText, {
			tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
			LayoutOrder = 2,
			Text = t1.title
		}),
		Trailing = if not t1.renderTrailing then nil else React.createElement(View, {
			tag = "row align-y-center gap-small auto-xy",
			LayoutOrder = 3
		}, t1.renderTrailing())
	})
end

return SchoolsPageHeader
