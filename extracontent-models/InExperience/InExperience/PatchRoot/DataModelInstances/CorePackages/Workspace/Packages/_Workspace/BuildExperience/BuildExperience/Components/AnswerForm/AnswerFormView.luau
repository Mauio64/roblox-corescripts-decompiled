local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local FFlagBuildExperienceAnswerForm = require(BuildExperience.Flags.FFlagBuildExperienceAnswerForm)
local v

if FFlagBuildExperienceAnswerForm then
	local AppBlox = require(parent.AppBlox)
	v = AppBlox.Composer
else
	v = Foundation.TextInput
end

local List = Foundation.List
local View = Foundation.View
local Text = Foundation.Text
local Divider = Foundation.Divider
local IconButton = Foundation.IconButton

local function AnswerFormView(props)
	local v2

	if FFlagBuildExperienceAnswerForm then
		v2 = Foundation.Hooks.useTokens()
	end

	local isReadOnly = props.isReadOnly == true
	local isSubmitting = props.isSubmitting or isReadOnly
	local children = {}

	for k, option in props.options do
		local trailing

		if props.isMultiSelect then
			trailing = React.createElement(Foundation.Checkbox, {
				label = "",
				isChecked = option.isSelected,
				isDisabled = isSubmitting,
				onActivated = option.onActivated,
				Selectable = false
			})
		end

		local element = React.createElement(List.Item, {
			title = option.title,
			description = option.description,
			LayoutOrder = k,
			testId = `AnswerForm.Option.{option.id}`,
			trailing = trailing
		})

		local id = option.id
		local createElement = React.createElement
		local v3 = {
			LayoutOrder = k,
			tag = {
				["size-full-0 auto-y radius-medium"] = true,
				col = FFlagBuildExperienceAnswerForm
			},
			onActivated = option.onActivated,
			isDisabled = isSubmitting,
			selection = {
				Selectable = not isSubmitting
			}
		}

		if FFlagBuildExperienceAnswerForm then
			element = React.createElement(
				View,
				{ LayoutOrder = 1, tag = "size-full-0 auto-y padding-x-large" },
				element
			)
		end

		local divider

		if FFlagBuildExperienceAnswerForm then
			divider = React.createElement(Divider, {
				LayoutOrder = 2,
				testId = `AnswerForm.OptionDivider.{option.id}`
			})
		end

		children[id] = createElement(View, v3, { Item = element, Divider = divider })
	end

	local v3 = React.createElement(IconButton, {
		LayoutOrder = 2,
		icon = Foundation.Enums.IconName.X,
		size = Foundation.Enums.InputSize.Small,
		variant = Foundation.Enums.ButtonVariant.Utility,
		isDisabled = isReadOnly,
		onActivated = props.onStop,
		testId = "AnswerForm.Close"
	})

	local createElement = React.createElement
	local v4 = {
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
	local size

	if FFlagBuildExperienceAnswerForm then
		size = Foundation.Enums.InputSize.Medium
	else
		size = Foundation.Enums.InputSize.Large
	end

	v4.size = size

	v4.variant = Foundation.Enums.InputVariant.Utility
	local v5 = createElement(v, v4)

	if props.isCustom then
		if FFlagBuildExperienceAnswerForm then
			v5 = React.createElement(View, {
				LayoutOrder = #props.options + 1,
				padding = {
					top = UDim.new(0, v2.Size.Size_150),
					bottom = UDim.new(0, v2.Size.Size_150)
				},
				tag = "size-full-0 auto-y",
				testId = "AnswerForm.CustomRow"
			}, { Input = v5 })
		end
	else
		v5 = React.createElement(View, {
			LayoutOrder = #props.options + 1,
			tag = "size-full-0 auto-y padding-large",
			onActivated = props.onCustomActivated,
			isDisabled = isSubmitting,
			testId = "AnswerForm.Custom"
		}, {
			Label = React.createElement(Text, {
				Text = props.customLabel,
				tag = {
					["size-full-0 auto-y text-wrap text-align-x-left"] = true,
					["text-body-medium content-default"] = FFlagBuildExperienceAnswerForm,
					["text-title-small content-emphasis"] = not FFlagBuildExperienceAnswerForm
				}
			})
		})
	end

	children.Custom = v5
	local createElement2 = React.createElement
	local v6 = {
		LayoutOrder = props.LayoutOrder,
		tag = "col size-full-0 auto-y stroke-standard stroke-default radius-large bg-surface-0",
		testId = "AnswerForm"
	}

	local createElement3 = React.createElement

	local v7 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "fill auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		}),
		Close = 0
	}

	if FFlagBuildExperienceAnswerForm then
		v3 = React.createElement(
			View,
			{
				LayoutOrder = 2,
				Size = UDim2.fromOffset(v2.Size.Size_600, v2.Size.Size_800),
				testId = "AnswerForm.CloseSlot"
			},
			{
				Button = React.createElement(
					View,
					{
						Size = UDim2.fromOffset(v2.Size.Size_800, v2.Size.Size_800),
						tag = "position-center-center anchor-center-center"
					},
					{ Button = v3 }
				)
			}
		)
	end

	v7.Close = v3
	local children2 = {
		Header = createElement3(
			View,
			{
				LayoutOrder = 1,
				testId = "AnswerForm.Header",
				tag = "row align-y-center gap-small size-full-0 auto-y padding-x-large padding-y-small"
			},
			v7
		),
		HeaderDivider = React.createElement(Divider, { LayoutOrder = 2 }),
		Body = React.createElement(
			View,
			{ LayoutOrder = 3, tag = "col size-full-0 auto-y", testId = "AnswerForm.Body" },
			{
				Options = React.createElement(List.Root, {
					LayoutOrder = 1,
					hasDivider = not FFlagBuildExperienceAnswerForm and {
						hasDivider = true,
						isInset = false
					} or false,
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
	local err

	if props.errorText ~= nil then
		err = React.createElement(Text, {
			LayoutOrder = 4,
			Text = props.errorText,
			tag = "size-full-0 auto-y padding-x-large text-body-small text-wrap text-align-x-left content-alert",
			testId = "AnswerForm.Error"
		})
	end

	children2.Error = err

	children2.FooterDivider = React.createElement(Divider, { LayoutOrder = 5 })
	local createElement4 = React.createElement

	local v8 = {
		Progress = React.createElement(Text, {
			Text = props.progressText,
			tag = "position-center-center anchor-center-center auto-xy text-body-medium content-default"
		}),
		Forward = 0
	}
	local forward

	if props.showForward then
		local createElement5 = React.createElement
		local v9 = {
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
		local variant

		if props.isForwardDisabled then
			variant = Foundation.Enums.ButtonVariant.Standard
		else
			variant = Foundation.Enums.ButtonVariant.Emphasis
		end

		v9.variant = variant

		v9.Position = UDim2.new(1, -props.footerInset, 0.5, 0)
		v9.AnchorPoint = Vector2.new(1, 0.5)
		v9.isDisabled = props.isForwardDisabled
		v9.onActivated = props.onForward
		forward = createElement5(IconButton, v9)
	end

	v8.Forward = forward
	children2.Footer = createElement4(
		View,
		{ LayoutOrder = 6, testId = "AnswerForm.Actions", tag = "size-full-1600" },
		v8
	)
	return createElement2(View, v6, children2)
end

return AnswerFormView
