local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local iconButton = Foundation.IconButton
local text = Foundation.Text
local textArea = Foundation.TextArea
local textInput = Foundation.TextInput
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local function VersionTitleDescriptionPageView(props)
	local v5 = useLocalization({
		descriptionLabel = LocalizationStrings.TITLE_DESCRIPTION_DESCRIPTION_LABEL,
		titleLabel = LocalizationStrings.TITLE_DESCRIPTION_TITLE_LABEL,
		versionTitleDescription = LocalizationStrings.PUBLISH_VERSION_TITLE_DESCRIPTION
	})

	local descriptionLabel = v5.descriptionLabel
	local titleLabel = v5.titleLabel
	local versionTitleDescription = v5.versionTitleDescription

	if not props.isReady then
		return nil
	end

	local testId = props.testId or "version-title-description-page"
	return React.createElement(view, {
		LayoutOrder = props.layoutOrder,
		tag = {
			["composition-layout-detail"] = true,
			["col align-x-center size-full bg-surface-0"] = true
		},
		testId = testId
	}, {
		Header = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "composition-content-header row align-y-center gap-small size-full-0 auto-y padding-y-medium",
				testId = `{testId}-header`
			},
			{
				Back = React.createElement(iconButton, {
					LayoutOrder = 1,
					icon = iconName.ArrowLargeLeft,
					isCircular = true,
					onActivated = props.onBack,
					size = inputSize.Medium,
					variant = buttonVariant.Utility,
					testId = `{testId}-back`
				}),
				Title = React.createElement(text, {
					LayoutOrder = 2,
					Text = versionTitleDescription,
					tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis",
					testId = `{testId}-title`
				})
			}
		),
		Content = React.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "composition-content-body col gap-xlarge size-full-0 auto-y padding-y-large",
				testId = `{testId}-content-body`
			},
			{
				TitleInput = React.createElement(textInput, {
					LayoutOrder = 1,
					label = titleLabel,
					text = props.titleText,
					width = UDim.new(1, 0),
					onChanged = props.onTitleChanged,
					onFocusLost = props.onFocusLost,
					testId = `{testId}-title-input`
				}),
				DescriptionInput = React.createElement(textArea, {
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
