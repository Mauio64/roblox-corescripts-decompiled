local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CustomForms/Foundation")

local CustomFormResultBar = require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Form/CustomFormResultBar")
require("@game/CorePackages/Workspace/Packages/_Index/CustomForms/CustomForms/Form/CustomFormSelection")

local function text(p2, p3, p4, p5)
	if p2 and p2 ~= "" then
		return (React.createElement(Foundation.Text, {
			Text = p2,
			LayoutOrder = p3,
			testId = p4,
			tag = {
				["size-full-0 auto-y text-body-medium text-align-x-left"] = true,
				["content-alert"] = p5 == true,
				["content-default"] = p5 ~= true
			}
		}))
	end

	return nil
end

local function renderOption(p2, props, props2, k)
	if props2.result then
		return React.createElement(CustomFormResultBar, {
			label = props2.label,
			percentage = props2.result.percentage,
			isSelected = props2.isChosen,
			viewerUserId = p2.viewerUserId,
			layoutOrder = k,
			testId = `{props2.testId}--result`
		})
	end

	local v5 = props.rowWidth ~= nil
	local createElement = React.createElement
	local view = Foundation.View

	local v7 = if props.rowWidth then UDim2.fromOffset(props.rowWidth, 0) else nil
	local v8 = if p2.isEditable then props2.onActivated else nil
	local v6 = {
		LayoutOrder = k,
		Size = v7,
		onActivated = v8,
		tag = {
			["row align-y-center auto-y padding-x-medium padding-y-medium"] = true,
			["size-full-0"] = not v5,
			["stroke-standard radius-medium"] = true,
			["stroke-emphasis"] = props2.isChosen,
			["stroke-default"] = not props2.isChosen
		},
		testId = props2.testId
	}

	local v10 = if props.fieldType == "Radio" then React.createElement(Foundation.RadioGroup.Item, {
		value = props2.optionId,
		label = props2.label,
		isDisabled = not p2.isEditable,
		LayoutOrder = 1
	}) else React.createElement(Foundation.Checkbox, {
		label = props2.label,
		isChecked = props2.isChosen,
		isDisabled = not p2.isEditable,
		onActivated = props2.onActivated,
		Selectable = false,
		LayoutOrder = 1,
		testId = `{props2.testId}--input`
	})
	return createElement(view, v6, { Input = v10 })
end

local function renderField(props, props2, k)
	local v5 = {}

	for k2, option in props2.options do
		v5[option.optionId] = renderOption(props, props2, option, k2)
	end

	local v6 = {}

	for k2, err in props2.errors do
		v6[`Server{k2}`] = text(err, k2, `{props2.testId}--error-{k2}`, true)
	end

	v6.Required = text(props2.requiredMessage, 0, `{props2.testId}--required`, true)
	local createElement = React.createElement
	local view = Foundation.View
	local v7 = {
		LayoutOrder = k,
		tag = "col gap-small size-full-0 auto-y",
		testId = props2.testId
	}
	local v8 = {
		Label = text(props2.label, 1, `{props2.testId}--label`),
		Options = 0,
		Errors = 0
	}
	local v9 = if props2.fieldType == "Radio" and not props2.showResults then React.createElement(Foundation.RadioGroup.Root, {
		value = props2.selectedRadio,
		onValueChanged = props2.onRadioChanged,
		Selectable = false,
		LayoutOrder = 2,
		testId = `{props2.testId}--radio`
	}, v5) else React.createElement(
		Foundation.View,
		{ LayoutOrder = 2, tag = "col gap-small size-full-0 auto-y" },
		v5
	)
	v8.Options = v9

	local v10 = if next(v6) then React.createElement(
		Foundation.View,
		{ LayoutOrder = 3, tag = "col gap-xsmall size-full-0 auto-y" },
		v6
	) else nil
	v8.Errors = v10
	return createElement(view, v7, v8)
end

local function CustomFormView(props)
	local testId = props.testId
	local children = {}

	for k, section in props.sections do
		local v5 = {}

		for k2, field in section.fields do
			v5[field.fieldId] = renderField(props, field, k2)
		end

		children[section.id] = React.createElement(
			Foundation.View,
			{
				LayoutOrder = k,
				tag = "col gap-large size-full-0 auto-y",
				testId = section.testId
			},
			{
				Header = text(section.header, 1, `{section.testId}--header`),
				Fields = React.createElement(
					Foundation.View,
					{ LayoutOrder = 2, tag = "col gap-large size-full-0 auto-y" },
					v5
				)
			}
		)
	end

	local v5 = {}

	for k, formError in props.formErrors do
		v5[tostring(k)] = text(formError, k, `{testId}--error-{k}`, true)
	end

	v5.Invalid = text(props.failureMessage, 0, `{testId}--error`, true)

	local createElement = React.createElement
	local view = Foundation.View
	local v6 = {
		LayoutOrder = props.layoutOrder,
		tag = "col gap-large size-full-0 auto-y padding-large stroke-standard stroke-default radius-medium bg-surface-100",
		testId = testId
	}

	local v8 = if props.title and props.title ~= "" then React.createElement(Foundation.Text, {
		Text = props.title,
		LayoutOrder = 1,
		testId = `{testId}--title`,
		tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
	}) else nil
	local v7 = {
		Title = v8,
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

	local v9 = if props.summary then React.createElement(Foundation.Text, {
		Text = props.summary,
		LayoutOrder = 4,
		testId = `{testId}--summary`,
		tag = "size-full-0 auto-y text-label-small text-align-x-right content-default"
	}) else nil
	v7.Summary = v9

	v7.DisabledMessage = text(props.disabledMessage, 4, `{testId}--disabled`)
	local v10 = if next(v5) then React.createElement(
		Foundation.View,
		{ LayoutOrder = 5, tag = "col gap-small size-full-0 auto-y" },
		v5
	) else nil
	v7.Errors = v10

	local v11 = if props.submitLabel and props.submitLabel ~= "" then React.createElement(Foundation.Button, {
		ref = props.submitRef,
		text = props.submitLabel,
		isDisabled = not props.isEditable,
		isLoading = props.isSubmitting,
		onActivated = props.onSubmit,
		variant = Foundation.Enums.ButtonVariant.Emphasis,
		LayoutOrder = 6,
		testId = `{testId}--submit`
	}) else nil
	v7.Submit = v11
	return createElement(view, v6, v7)
end

return CustomFormView
