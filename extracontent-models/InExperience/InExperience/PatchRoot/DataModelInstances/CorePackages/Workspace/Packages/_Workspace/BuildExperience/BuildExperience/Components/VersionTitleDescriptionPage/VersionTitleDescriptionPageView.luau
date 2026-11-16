local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local TextArea = Foundation.TextArea
local TextInput = Foundation.TextInput
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function VersionTitleDescriptionPageView(props)
	local v = useLocalization({
		descriptionLabel = LocalizationStrings.TITLE_DESCRIPTION_DESCRIPTION_LABEL,
		titleLabel = LocalizationStrings.TITLE_DESCRIPTION_TITLE_LABEL,
		versionTitleDescription = LocalizationStrings.PUBLISH_VERSION_TITLE_DESCRIPTION
	})

	local descriptionLabel = v.descriptionLabel
	local titleLabel = v.titleLabel
	local versionTitleDescription = v.versionTitleDescription

	if not props.isReady then
		return nil
	end

	local testId = props.testId or "version-title-description-page"
	return React.createElement(View, {
		LayoutOrder = props.layoutOrder,
		tag = {
			["composition-layout-detail"] = true,
			["col align-x-center size-full bg-surface-0"] = true
		},
		testId = testId
	}, {
		Header = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-medium",
				testId = `{testId}-header`
			},
			{
				Back = React.createElement(IconButton, {
					LayoutOrder = 1,
					icon = IconName.ArrowLargeLeft,
					isCircular = true,
					onActivated = props.onBack,
					size = InputSize.Medium,
					variant = ButtonVariant.Utility,
					testId = `{testId}-back`
				}),
				Title = React.createElement(Text, {
					LayoutOrder = 2,
					Text = versionTitleDescription,
					tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
					testId = `{testId}-title`
				})
			}
		),
		Content = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "composition-content-body col gap-xlarge size-full-0 auto-y padding-y-large",
				testId = `{testId}-content-body`
			},
			{
				TitleInput = React.createElement(TextInput, {
					LayoutOrder = 1,
					label = titleLabel,
					text = props.titleText,
					width = UDim.new(1, 0),
					onChanged = props.onTitleChanged,
					onFocusLost = props.onFocusLost,
					testId = `{testId}-title-input`
				}),
				DescriptionInput = React.createElement(TextArea, {
					LayoutOrder = 2,
					label = descriptionLabel,
					text = props.descriptionText,
					width = UDim.new(1, 0),
					numLines = 4,
					onChanged = props.onDescriptionChanged,
					onFocusLost = props.onFocusLost,
					testId = `{testId}-description-input`
				})
			}
		)
	})
end

return VersionTitleDescriptionPageView
