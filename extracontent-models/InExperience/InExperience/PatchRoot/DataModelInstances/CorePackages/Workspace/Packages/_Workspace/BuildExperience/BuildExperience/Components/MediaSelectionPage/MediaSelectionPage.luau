local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local MediaSelector = require(script.Parent.MediaSelector)

require(script.Parent.types)

local function IconThumbnailsSheet(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), View (copy), IconButton (copy), IconName (copy), InputSize (copy), ButtonVariant (copy), FoundationText (copy), MediaSelector (copy)
	return React.createElement(View, {
		tag = "col size-full bg-surface-0"
	}, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "composition-content-header row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-y-medium"
		}, {
			Back = React.createElement(IconButton, {
				LayoutOrder = 1,
				isCircular = true,
				icon = IconName.ArrowLargeLeft,
				onActivated = t1.onClose,
				size = InputSize.Medium,
				variant = ButtonVariant.Utility
			}),
			Title = React.createElement(FoundationText, {
				LayoutOrder = 2,
				Text = "Icon & Thumbnails",
				tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis"
			})
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = "composition-content-body col shrink gap-xlarge size-full padding-large"
		}, {
			MediaSelector = React.createElement(MediaSelector, {
				universeId = t1.universeId,
				onBack = t1.onClose
			})
		})
	})
end

return IconThumbnailsSheet
