local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
local ConfigurationActionTelemetry = require(BuildExperience.Telemetry.ConfigurationActionTelemetry)
local FFlagBuildExperienceActionOutcomeTelemetry = require(BuildExperience.Flags.FFlagBuildExperienceActionOutcomeTelemetry)

local IconButton = Foundation.IconButton
local Text = Foundation.Text
local TextArea = Foundation.TextArea
local TextInput = Foundation.TextInput
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local Action = ConfigurationActionTelemetry.Action
local FailureReason = ConfigurationActionTelemetry.FailureReason

local function isSameText(logged, p: string, p2: string): boolean -- 2 equivalent calls inferred from this helper
	return logged ~= nil and logged.title == p and logged.description == p2
end

local function getSaveParameters(saved, p: string, p2: string) -- 2 equivalent calls inferred from this helper
	return {
		changedFields = ConfigurationActionTelemetry.getChangedFields(p ~= saved.title, p2 ~= saved.description)
	}
end

local function logSaveSuccess(ref, universeId: number, title: string, value: string)
	local current = ref.current

	if current.loggedSuccess and isSameText(current.logged, title, value) then -- inferred equivalent call
		return
	end

	ConfigurationActionTelemetry.sendSuccess(
		Action.ExperienceDetailsSave,
		{ universeId = universeId },
		nil,
		getSaveParameters(current.saved, title, value) -- inferred equivalent call
	)

	local v = { title = title, description = value }
	ref.current = { saved = v, logged = v, loggedSuccess = true }
end

local function logSaveFailure(ref, universeId: number, title: string, value: string, err)
	local current = ref.current

	if isSameText(current.logged, title, value) then -- inferred equivalent call
		return
	end

	ConfigurationActionTelemetry.sendFailure(
		Action.ExperienceDetailsSave,
		{ universeId = universeId },
		{ reason = FailureReason.RequestFailed, error = err },
		nil,
		getSaveParameters(current.saved, title, value) -- inferred equivalent call
	)

	ref.current = {
		saved = current.saved,
		logged = { title = title, description = value },
		loggedSuccess = false
	}
end

local function TitleDescriptionPage(props)
	local testId = props.testId or "title-description-page"
	local titleText = props.titleText or ""
	local descriptionText = props.descriptionText or ""
	local text, onChanged = React.useBinding(titleText)
	local text2, onChanged2 = React.useBinding(descriptionText)
	local v = useLocalization({
		descriptionLabel = LocalizationStrings.TITLE_DESCRIPTION_DESCRIPTION_LABEL,
		title = LocalizationStrings.TITLE_DESCRIPTION_TITLE,
		titleLabel = LocalizationStrings.TITLE_DESCRIPTION_TITLE_LABEL
	})

	local descriptionLabel = v.descriptionLabel
	local title = v.title
	local titleLabel = v.titleLabel
	local ref

	if FFlagBuildExperienceActionOutcomeTelemetry then
		ref = React.useRef({
			saved = { title = titleText, description = descriptionText },
			logged = nil,
			loggedSuccess = false
		})
	else
		ref = nil
	end

	local onFocusLost = React.useCallback(function()
		local universeId = props.universeId

		if universeId == nil then
			return
		end

		local value = text:getValue()
		local value2 = text2:getValue()

		if value == titleText and value2 == descriptionText then
			return
		end

		local v2 = GameConfigurationActions.updateTitleDescription(universeId, value, value2)

		if FFlagBuildExperienceActionOutcomeTelemetry then
			v2 = v2:andThen(function()
				logSaveSuccess(ref, universeId, value, value2)
			end)
		end

		v2:catch(function(err)
			warn(`[BuildExperience] Failed to save title and description: {tostring(err)}`)

			if FFlagBuildExperienceActionOutcomeTelemetry then
				logSaveFailure(ref, universeId, value, value2, err)
			end
		end)
	end, { text2, descriptionText, titleText, props.universeId, text })

	React.useEffect(function()
		return onFocusLost
	end, { onFocusLost })

	local onActivated = React.useCallback(function()
		onFocusLost()
		props.onBack()
	end, { props.onBack, onFocusLost })

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
					onActivated = onActivated,
					size = InputSize.Medium,
					variant = ButtonVariant.Utility,
					testId = `{testId}-back`
				}),
				Title = React.createElement(Text, {
					LayoutOrder = 2,
					Text = title,
					tag = "fill auto-y text-heading-medium text-align-x-left text-truncate-end content-emphasis"
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
					placeholder = props.titlePlaceholder,
					text = text,
					width = UDim.new(1, 0),
					onChanged = onChanged,
					onFocusLost = onFocusLost,
					testId = `{testId}-title-input`
				}),
				DescriptionInput = React.createElement(TextArea, {
					LayoutOrder = 2,
					label = descriptionLabel,
					placeholder = props.descriptionPlaceholder,
					text = text2,
					width = UDim.new(1, 0),
					numLines = 4,
					onChanged = onChanged2,
					onFocusLost = onFocusLost,
					testId = `{testId}-description-input`
				})
			}
		)
	})
end

return TitleDescriptionPage
