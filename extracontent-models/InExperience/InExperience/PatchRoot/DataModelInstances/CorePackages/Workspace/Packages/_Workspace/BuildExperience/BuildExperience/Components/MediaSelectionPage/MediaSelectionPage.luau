local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local Foundation = require(BuildExperienceParent.Foundation)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local MediaSelector = require(script.Parent.MediaSelector)

require(script.Parent.types)

local function IconThumbnailsSheet(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), View (copy), IconButton (copy), IconName (copy), InputSize (copy), ButtonVariant (copy), FoundationText (copy), LocalizationStrings (copy), MediaSelector (copy)
	local v15 = React.useRef(nil)
	local v16 = React.useCallback(function() -- line: 29
		-- upvalues: v15 (copy), t1 (copy)
		if v15.current then
			v15.current()

			return
		end

		t1.onClose()
	end, { t1.onClose })

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
				onActivated = v16,
				size = InputSize.Medium,
				variant = ButtonVariant.Utility
			}),
			Title = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
				Text = LocalizationStrings.MEDIA_SELECTION_TITLE
			})
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = "composition-content-body col shrink gap-xlarge size-full padding-large"
		}, {
			MediaSelector = React.createElement(MediaSelector, {
				universeId = t1.universeId,
				onBack = t1.onClose,
				backHandlerRef = v15
			})
		})
	})
end

return IconThumbnailsSheet
