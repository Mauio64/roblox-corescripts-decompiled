local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local TextArea = Foundation.TextArea
local TextInput = Foundation.TextInput
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function VersionTitleDescriptionPageView(t1: {[any]: any}) -- line: 30
	-- upvalues: React (copy), View (copy), IconButton (copy), IconName (copy), InputSize (copy), ButtonVariant (copy), FoundationText (copy), LocalizationStrings (copy), TextInput (copy), TextArea (copy)
	if not t1.isReady then
		return nil
	end

	local v16 = t1.testId or "version-title-description-page"

	return React.createElement(View, {
		tag = "col align-x-center size-full bg-surface-0",
		LayoutOrder = t1.layoutOrder,
		testId = v16
	}, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-medium",
			testId = `{ v16 }-header`
		}, {
			Back = React.createElement(IconButton, {
				LayoutOrder = 1,
				isCircular = true,
				icon = IconName.ArrowLargeLeft,
				onActivated = t1.onBack,
				size = InputSize.Medium,
				variant = ButtonVariant.Utility,
				testId = `{ v16 }-back`
			}),
			Title = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
				Text = LocalizationStrings.PUBLISH_VERSION_TITLE_DESCRIPTION,
				testId = `{ v16 }-title`
			})
		}),
		Content = React.createElement(View, {
			LayoutOrder = 2,
			tag = "composition-content-body col gap-xlarge size-full-0 auto-y padding-y-large",
			testId = `{ v16 }-content-body`
		}, {
			TitleInput = React.createElement(TextInput, {
				LayoutOrder = 1,
				label = LocalizationStrings.TITLE_DESCRIPTION_TITLE_LABEL,
				text = t1.titleText,
				width = UDim.new(1, 0),
				onChanged = t1.onTitleChanged,
				onFocusLost = t1.onFocusLost,
				testId = `{ v16 }-title-input`
			}),
			DescriptionInput = React.createElement(TextArea, {
				LayoutOrder = 2,
				numLines = 4,
				label = LocalizationStrings.TITLE_DESCRIPTION_DESCRIPTION_LABEL,
				text = t1.descriptionText,
				width = UDim.new(1, 0),
				onChanged = t1.onDescriptionChanged,
				onFocusLost = t1.onFocusLost,
				testId = `{ v16 }-description-input`
			})
		})
	})
end

return VersionTitleDescriptionPageView
