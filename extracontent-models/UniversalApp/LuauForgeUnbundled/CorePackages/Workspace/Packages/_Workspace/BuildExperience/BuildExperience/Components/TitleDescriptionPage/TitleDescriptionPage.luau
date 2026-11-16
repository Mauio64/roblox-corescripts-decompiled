local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization
local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local GameConfigurationActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationActions")

local iconButton = Foundation.IconButton
local text = Foundation.Text
local textArea = Foundation.TextArea
local textInput = Foundation.TextInput
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local function TitleDescriptionPage(props)
	local testId = props.testId or "title-description-page"
	local titleText = props.titleText or ""
	local descriptionText = props.descriptionText or ""
	local v5, v6 = React.useBinding(titleText)
	local v7, v8 = React.useBinding(descriptionText)
	local v9 = useLocalization({
		descriptionLabel = LocalizationStrings.TITLE_DESCRIPTION_DESCRIPTION_LABEL,
		title = LocalizationStrings.TITLE_DESCRIPTION_TITLE,
		titleLabel = LocalizationStrings.TITLE_DESCRIPTION_TITLE_LABEL
	})

	local descriptionLabel = v9.descriptionLabel
	local title = v9.title
	local titleLabel = v9.titleLabel

	local v10 = React.useCallback(function()
		local universeId = props.universeId

		if universeId == nil then
			return
		end

		local value = v5:getValue()
		local value2 = v7:getValue()

		if value == titleText and value2 == descriptionText then
			return
		end

		GameConfigurationActions.updateTitleDescription(universeId, value, value2):catch(function(p2)
			warn(`[BuildExperience] Failed to save title and description: {tostring(p2)}`)
		end)
	end, { v7, descriptionText, titleText, props.universeId, v5 })

	React.useEffect(function()
		return v10
	end, { v10 })

	local v11 = React.useCallback(function()
		v10()
		props.onBack()
	end, { props.onBack, v10 })

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
					onActivated = v11,
					size = inputSize.Medium,
					variant = buttonVariant.Utility,
					testId = `{testId}-back`
				}),
				Title = React.createElement(text, {
					LayoutOrder = 2,
					Text = title,
					tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis"
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
					placeholder = props.titlePlaceholder,
					text = v5,
					width = UDim.new(1, 0),
					onChanged = v6,
					onFocusLost = v10,
					testId = `{testId}-title-input`
				}),
				DescriptionInput = React.createElement(textArea, {
					LayoutOrder = 2,
					label = descriptionLabel,
					placeholder = props.descriptionPlaceholder,
					text = v7,
					width = UDim.new(1, 0),
					numLines = 4,
					onChanged = v8,
					onFocusLost = v10,
					testId = `{testId}-description-input`
				})
			}
		)
	})
end

return TitleDescriptionPage
