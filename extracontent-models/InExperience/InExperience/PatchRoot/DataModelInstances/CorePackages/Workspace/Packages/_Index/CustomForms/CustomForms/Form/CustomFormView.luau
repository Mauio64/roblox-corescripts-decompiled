local parent = script:FindFirstAncestor("CustomForms").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)

local CustomFormResultBar = require(script.Parent.CustomFormResultBar)
require(script.Parent.CustomFormSelection)

local function text(text2: string?, layoutOrder: number, testId: string, flag: boolean?)
	if text2 and text2 ~= "" then
		return (React.createElement(Foundation.Text, {
			Text = text2,
			LayoutOrder = layoutOrder,
			testId = testId,
			tag = {
				["size-full-0 auto-y text-body-medium text-align-x-left"] = true,
				["content-alert"] = flag == true,
				["content-default"] = flag ~= true
			}
		}))
	end

	return nil
end

local function renderOption(p, props, props2, k: number)
	if props2.result then
		return React.createElement(CustomFormResultBar, {
			label = props2.label,
			percentage = props2.result.percentage,
			isSelected = props2.isChosen,
			viewerUserId = p.viewerUserId,
			layoutOrder = k,
			testId = `{props2.testId}--result`
		})
	end

	local v = props.rowWidth ~= nil
	local createElement = React.createElement
	local view = Foundation.View
	local size

	if props.rowWidth then
		size = UDim2.fromOffset(props.rowWidth, 0)
	end

	local onActivated

	if p.isEditable then
		onActivated = props2.onActivated
	end

	local v2 = {
		LayoutOrder = k,
		Size = size,
		onActivated = onActivated,
		tag = {
			["row align-y-center auto-y padding-x-medium padding-y-medium"] = true,
			["size-full-0"] = not v,
			["stroke-standard radius-medium"] = true,
			["stroke-emphasis"] = props2.isChosen,
			["stroke-default"] = not props2.isChosen
		},
		testId = props2.testId
	}
	local input

	if props.fieldType == "Radio" then
		input = React.createElement(Foundation.RadioGroup.Item, {
			value = props2.optionId,
			label = props2.label,
			isDisabled = not p.isEditable,
			LayoutOrder = 1
		})
	else
		input = React.createElement(Foundation.Checkbox, {
			label = props2.label,
			isChecked = props2.isChosen,
			isDisabled = not p.isEditable,
			onActivated = props2.onActivated,
			Selectable = false,
			LayoutOrder = 1,
			testId = `{props2.testId}--input`
		})
	end

	return createElement(view, v2, { Input = input })
end

local function renderField(props, props2, k: number)
	local v = {}

	for k2, option in props2.options do
		v[option.optionId] = renderOption(props, props2, option, k2)
	end

	local v2 = {}

	for k2, err in props2.errors do
		v2[`Server{k2}`] = text(err, k2, `{props2.testId}--error-{k2}`, true)
	end

	v2.Required = text(props2.requiredMessage, 0, `{props2.testId}--required`, true)
	local createElement = React.createElement
	local view = Foundation.View
	local v3 = { LayoutOrder = k, tag = "col gap-small size-full-0 auto-y", testId = props2.testId }
	local v4 = {
		Label = text(props2.label, 1, `{props2.testId}--label`),
		Options = 0,
		Errors = 0
	}
	local options

	if props2.fieldType == "Radio" and not props2.showResults then
		options = React.createElement(Foundation.RadioGroup.Root, {
			value = props2.selectedRadio,
			onValueChanged = props2.onRadioChanged,
			Selectable = false,
			LayoutOrder = 2,
			testId = `{props2.testId}--radio`
		}, v)
	else
		options = React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = "col gap-small size-full-0 auto-y"
		}, v)
	end

	v4.Options = options
	local errors

	if next(v2) then
		errors = React.createElement(
			Foundation.View,
			{ LayoutOrder = 3, tag = "col gap-xsmall size-full-0 auto-y" },
			v2
		)
	end

	v4.Errors = errors
	return createElement(view, v3, v4)
end

local function CustomFormView(props)
	local testId = props.testId
	local children = {}

	for k, section in props.sections do
		local v = {}

		for k2, field in section.fields do
			v[field.fieldId] = renderField(props, field, k2)
		end

		children[section.id] = React.createElement(
			Foundation.View,
			{ LayoutOrder = k, tag = "col gap-large size-full-0 auto-y", testId = section.testId },
			{
				Header = text(section.header, 1, `{section.testId}--header`),
				Fields = React.createElement(
					Foundation.View,
					{ LayoutOrder = 2, tag = "col gap-large size-full-0 auto-y" },
					v
				)
			}
		)
	end

	local v = {}

	for k, formError in props.formErrors do
		v[tostring(k)] = text(formError, k, `{testId}--error-{k}`, true)
	end

	v.Invalid = text(props.failureMessage, 0, `{testId}--error`, true)

	local createElement = React.createElement
	local view = Foundation.View
	local v2 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-default radius-medium bg-surface-100",
		testId = testId
	}
	local title

	if props.title and props.title ~= "" then
		title = React.createElement(Foundation.Text, {
			Text = props.title,
			LayoutOrder = 1,
			testId = `{testId}--title`,
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
		})
	end

	local v3 = {
		Title = title,
		Description = text(props.description, 2, `{testId}--description`),
		Sections = React.createElement(
			Foundation.View,
			{
				LayoutOrder = 3,
				tag = "col gap-large size-full-0 auto-y",
				testId = `{testId}--sections`,
				onAbsoluteSizeChanged = props.onSectionsSizeChanged
			},
			children
		),
		Summary = 0,
		DisabledMessage = 0,
		Errors = 0,
		Submit = 0
	}
	local summary

	if props.summary then
		summary = React.createElement(Foundation.Text, {
			Text = props.summary,
			LayoutOrder = 4,
			testId = `{testId}--summary`,
			tag = "size-full-0 auto-y text-label-small text-align-x-right content-default"
		})
	end

	v3.Summary = summary

	v3.DisabledMessage = text(props.disabledMessage, 4, `{testId}--disabled`)
	local errors

	if next(v) then
		errors = React.createElement(Foundation.View, {
			LayoutOrder = 5,
			tag = "col gap-small size-full-0 auto-y"
		}, v)
	end

	v3.Errors = errors
	local submit

	if props.submitLabel and props.submitLabel ~= "" then
		submit = React.createElement(Foundation.Button, {
			ref = props.submitRef,
			text = props.submitLabel,
			isDisabled = not props.isEditable,
			isLoading = props.isSubmitting,
			onActivated = props.onSubmit,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			LayoutOrder = 6,
			testId = `{testId}--submit`
		})
	end

	v3.Submit = submit
	return createElement(view, v2, v3)
end

return CustomFormView
