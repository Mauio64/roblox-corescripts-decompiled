local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local FFlagBuildExperienceAnswerForm = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceAnswerForm")
local v5 = if FFlagBuildExperienceAnswerForm then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AppBlox").Composer else Foundation.TextInput

local list = Foundation.List
local view = Foundation.View
local text = Foundation.Text
local divider = Foundation.Divider
local iconButton = Foundation.IconButton

local function AnswerFormView(props)
	local v6 = if FFlagBuildExperienceAnswerForm then Foundation.Hooks.useTokens() else nil
	local isReadOnly = props.isReadOnly == true
	local isSubmitting = props.isSubmitting or isReadOnly
	local children = {}

	for k, option in props.options do
		local v7

		if props.isMultiSelect then
			v7 = React.createElement(Foundation.Checkbox, {
				label = "",
				isChecked = option.isSelected,
				isDisabled = isSubmitting,
				onActivated = option.onActivated,
				Selectable = false
			})
		end

		local element = React.createElement(list.Item, {
			title = option.title,
			description = option.description,
			LayoutOrder = k,
			testId = `AnswerForm.Option.{option.id}`,
			trailing = v7
		})

		local id = option.id
		local createElement = React.createElement
		local v9 = {
			LayoutOrder = k,
			tag = { ["size-full-0 auto-y radius-medium"] = true, col = FFlagBuildExperienceAnswerForm },
			onActivated = option.onActivated,
			isDisabled = isSubmitting,
			selection = {
				Selectable = not isSubmitting
			}
		}

		if FFlagBuildExperienceAnswerForm then
			element = React.createElement(
				view,
				{ LayoutOrder = 1, tag = "size-full-0 auto-y padding-x-large" },
				element
			)
		end

		local v11 = if FFlagBuildExperienceAnswerForm then React.createElement(divider, {
			LayoutOrder = 2,
			testId = `AnswerForm.OptionDivider.{option.id}`
		}) else nil
		children[id] = createElement(view, v9, { Item = element, Divider = v11 })
	end

	local v7 = React.createElement(iconButton, {
		LayoutOrder = 2,
		icon = Foundation.Enums.IconName.X,
		size = Foundation.Enums.InputSize.Small,
		variant = Foundation.Enums.ButtonVariant.Utility,
		isDisabled = isReadOnly,
		onActivated = props.onStop,
		testId = "AnswerForm.Close"
	})

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = FFlagBuildExperienceAnswerForm and 1 or #props.options + 1,
		label = "",
		text = props.customTextBinding or props.customText,
		placeholder = "",
		onChanged = props.onCustomChanged,
		isDisabled = isSubmitting,
		width = UDim.new(1, 0),
		maxLines = FFlagBuildExperienceAnswerForm and 5 or nil,
		size = 0,
		variant = 0,
		testId = "AnswerForm.CustomInput"
	}

	local v10 = if FFlagBuildExperienceAnswerForm then Foundation.Enums.InputSize.Medium else Foundation.Enums.InputSize.Large
	v9.size = v10

	v9.variant = Foundation.Enums.InputVariant.Utility
	local v11 = createElement(v5, v9)

	if props.isCustom then
		if FFlagBuildExperienceAnswerForm then
			v11 = React.createElement(view, {
				LayoutOrder = #props.options + 1,
				padding = {
					top = UDim.new(0, v6.Size.Size_150),
					bottom = UDim.new(0, v6.Size.Size_150)
				},
				tag = "size-full-0 auto-y",
				testId = "AnswerForm.CustomRow"
			}, { Input = v11 })
		end
	else
		v11 = React.createElement(view, {
			LayoutOrder = #props.options + 1,
			tag = "size-full-0 auto-y padding-large",
			onActivated = props.onCustomActivated,
			isDisabled = isSubmitting,
			testId = "AnswerForm.Custom"
		}, {
			Label = React.createElement(text, {
				Text = props.customLabel,
				tag = {
					["size-full-0 auto-y text-wrap text-align-x-left"] = true,
					["text-body-medium content-default"] = FFlagBuildExperienceAnswerForm,
					["text-title-small content-emphasis"] = not FFlagBuildExperienceAnswerForm
				}
			})
		})
	end

	children.Custom = v11
	local createElement2 = React.createElement
	local v13 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large bg-surface-0",
		testId = "AnswerForm"
	}

	local createElement3 = React.createElement

	local v16 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "fill auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Close = 0
	}

	if FFlagBuildExperienceAnswerForm then
		v7 = React.createElement(
			view,
			{
				LayoutOrder = 2,
				Size = UDim2.fromOffset(v6.Size.Size_600, v6.Size.Size_800),
				testId = "AnswerForm.CloseSlot"
			},
			{
				Button = React.createElement(
					view,
					{
						Size = UDim2.fromOffset(v6.Size.Size_800, v6.Size.Size_800),
						tag = "position-center-center anchor-center-center"
					},
					{ Button = v7 }
				)
			}
		)
	end

	v16.Close = v7
	local children2 = {
		Header = createElement3(
			view,
			{
				LayoutOrder = 1,
				testId = "AnswerForm.Header",
				tag = "row align-y-center gap-small size-full-0 auto-y padding-x-large padding-y-small"
			},
			v16
		),
		HeaderDivider = React.createElement(divider, { LayoutOrder = 2 }),
		Body = React.createElement(
			view,
			{
				LayoutOrder = 3,
				tag = "col size-full-0 auto-y",
				testId = "AnswerForm.Body"
			},
			{
				Options = React.createElement(list.Root, {
					LayoutOrder = 1,
					hasDivider = not FFlagBuildExperienceAnswerForm and { hasDivider = true, isInset = false } or false,
					isContained = {
						isContained = false,
						hasMargin = not FFlagBuildExperienceAnswerForm
					}
				}, children)
			}
		),
		Error = 0,
		FooterDivider = 0,
		Footer = 0
	}

	local v17 = if props.errorText ~= nil then React.createElement(text, {
		LayoutOrder = 4,
		Text = props.errorText,
		tag = "size-full-0 auto-y padding-x-large text-body-small text-wrap text-align-x-left content-alert",
		testId = "AnswerForm.Error"
	}) else nil
	children2.Error = v17

	children2.FooterDivider = React.createElement(divider, { LayoutOrder = 5 })
	local createElement4 = React.createElement

	local v20 = {
		Progress = React.createElement(text, {
			Text = props.progressText,
			tag = "position-center-center anchor-center-center auto-xy text-body-medium content-default"
		}),
		Forward = 0
	}
	local v21

	if props.showForward then
		local createElement5 = React.createElement
		local v23 = {
			icon = {
				name = Foundation.Enums.IconName.ArrowMediumRight,
				variant = Foundation.Enums.IconVariant.Filled
			},
			size = Foundation.Enums.InputSize.Small,
			variant = 0,
			isCircular = true,
			Position = 0,
			AnchorPoint = 0,
			isDisabled = 0,
			onActivated = 0,
			testId = "AnswerForm.Forward"
		}
		local v24 = if props.isForwardDisabled then Foundation.Enums.ButtonVariant.Standard else Foundation.Enums.ButtonVariant.Emphasis
		v23.variant = v24

		v23.Position = UDim2.new(1, -props.footerInset, 0.5, 0)
		v23.AnchorPoint = Vector2.new(1, 0.5)
		v23.isDisabled = props.isForwardDisabled
		v23.onActivated = props.onForward
		v21 = createElement5(iconButton, v23)
	end

	v20.Forward = v21
	children2.Footer = createElement4(
		view,
		{ LayoutOrder = 6, testId = "AnswerForm.Actions", tag = "size-full-1600" },
		v20
	)
	return createElement2(view, v13, children2)
end

return AnswerFormView
