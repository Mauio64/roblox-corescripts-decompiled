local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)
local DsaIllegalContentReporting = require(parent.DsaIllegalContentReporting)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local GenericReportLink = DsaIllegalContentReporting.GenericReportLink
local IconButton = Foundation.IconButton
local IconName = Foundation.Enums.IconName
local InputLabel = Foundation.InputLabel
local InputSize = Foundation.Enums.InputSize
local isShowGenericIllegalContentReportingLink = DsaIllegalContentReporting.isShowGenericIllegalContentReportingLink
local OptionSelectorGroup = Foundation.OptionSelectorGroup
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local TextArea = Foundation.TextArea
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

local SideModalDropdownButton = require(GenericAbuseReporting.Common.SideModalDropdownButton)

local function DualDropdownReportV2(data)
	local v = useTokens()
	local state, setState = React.useState(true)
	local state2, setState2 = React.useState("None")
	local useState = React.useState
	local v2

	if data.preselected then
		v2 = data.preselected.problem or nil
	end

	local state3, setState3 = useState(v2)
	local useState2 = React.useState
	local v3

	if data.preselected then
		v3 = data.preselected.surface or nil
	end

	local state4, setState4 = useState2(v3)
	local state5, setState5 = React.useState("")

	local state6, setState6 = React.useState("None")

	local v4 = useLocalization({
		problemHeading = "Feature.ReportAbuse.Label.WhatWasWrong",
		surfaceHeading = "Feature.ReportAbuse.Label.WhereDidItHappen",
		selectOnePrompt = "Feature.ReportAbuse.Label.PleaseSelectOne",
		commentHeading = "Feature.ReportAbuse.Label.TellUsWhatHappenedNoOptional",
		textAreaPlaceholder = "Feature.SettingsHub.Label.ReportComment",
		submitButton = "Feature.ReportAbuse.Label.Report",
		continueButton = "Feature.ReportAbuse.Action.Continue",
		titleIpInfringement = "Feature.ReportAbuse.Title.SelectInSceneContinueYourReport"
	})

	local onChanged = React.useCallback(function(p)
		setState5(p)
	end, {})

	local onActivated = React.useCallback(function()
		setState2("Problem")
	end, {})

	local onActivated2 = React.useCallback(function()
		setState2("Surface")
	end, {})

	local v5 = React.useCallback(function()
		setState(false)
		task.wait(0.3)
		data.onClose()
	end, { data.onClose })

	local v6 = React.useCallback(function()
		setState2("None")
	end, {})

	local onValueChanged = React.useCallback(function(p: string)
		if state2 == "Problem" then
			setState3((Dash.find(data.problems, function(p2): boolean
				return p2.value == p
			end)))
		else
			setState4((Dash.find(data.surfaces, function(p2): boolean
				return p2.value == p
			end)))
		end

		v6()
	end, { state2, data.problems, data.surfaces, v6 })

	local v7 = state3 and state3.value == "ip infringement"

	local onActivated3 = React.useCallback(function()
		local v8 = state3 == nil and "" or state3.value
		local v9 = state4 == nil and "" or state4.value

		if v8 == "" and v9 == "" then
			setState6("Both")
			return
		end

		if v8 == "" then
			setState6("Problem")
			return
		end

		if v9 == "" and not v7 then
			setState6("Surface")
			return
		end

		setState6("None")
		v5()
		data.onSubmit(v8, v9, state5)
	end, { state3, state4, state5, v5, data.onSubmit, v7 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local root = Sheet.Root

	local createElement3 = React.createElement
	local header = Sheet.Header

	local createElement4 = React.createElement

	local v8 = {
		Icon = React.createElement(IconButton, {
			variant = ButtonVariant.Utility,
			icon = IconName.X,
			onActivated = v5,
			LayoutOrder = 1
		}),
		Title = 0
	}

	local createElement5 = React.createElement
	local text = if v7 then v4.titleIpInfringement else data.title
	v8.Title = createElement5(Text, {
		Text = text,
		RichText = true,
		tag = "auto-xy text-wrap text-heading-small text-align-x-left",
		LayoutOrder = 2
	})
	local children2 = {
		Header = createElement3(
			header,
			{ hasCloseAffordance = false },
			createElement4(View, { tag = "size-full-0 auto-y row gap-medium align-y-center" }, v8)
		),
		Content = 0,
		Actions = 0
	}

	local createElement6 = React.createElement
	local content = Sheet.Content
	local v9 = {
		ProblemFrame = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-small",
			LayoutOrder = 1
		}, {
			ProblemHeading = React.createElement(InputLabel, {
				Text = v4.problemHeading,
				size = InputSize.Small,
				LayoutOrder = 1
			}),
			ProblemDropdownButton = React.createElement(SideModalDropdownButton, {
				text = state3 and state3.label or v4.chooseOne,
				onActivated = onActivated,
				isDropdownError = state6 == "Problem" or state6 == "Both",
				layoutOrder = 2
			}),
			ProblemSubtext = React.createElement(Text, {
				Text = (state6 == "Problem" or state6 == "Both") and v4.selectOnePrompt or "",
				RichText = true,
				textStyle = v.Color.System.Alert,
				tag = "auto-xy text-wrap text-align-x-left text-body-small",
				LayoutOrder = 3
			})
		}),
		ProblemSurface = 0,
		TextArea = 0
	}
	local problemSurface

	if not v7 then
		problemSurface = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-small",
			LayoutOrder = 2
		}, {
			SurfaceHeading = React.createElement(InputLabel, {
				Text = v4.surfaceHeading,
				size = InputSize.Small,
				LayoutOrder = 1
			}),
			SurfaceDropdownButton = React.createElement(SideModalDropdownButton, {
				text = state4 and state4.label or v4.chooseOne,
				onActivated = onActivated2,
				isDropdownError = state6 == "Surface" or state6 == "Both",
				layoutOrder = 2
			}),
			SurfaceSubtext = React.createElement(Text, {
				Text = (state6 == "Surface" or state6 == "Both") and v4.selectOnePrompt or "",
				RichText = true,
				textStyle = v.Color.System.Alert,
				tag = "auto-xy text-wrap text-align-x-left text-body-small",
				LayoutOrder = 3
			})
		})
	end

	v9.ProblemSurface = problemSurface
	local textArea

	if not v7 then
		textArea = React.createElement(TextArea, {
			label = v4.commentHeading,
			text = state5,
			placeholder = v4.textAreaPlaceholder,
			isRequired = false,
			onChanged = onChanged,
			width = UDim.new(1, 0),
			LayoutOrder = 3
		})
	end

	v9.TextArea = textArea
	children2.Content = createElement6(content, nil, v9)

	local createElement7 = React.createElement
	local actions = Sheet.Actions
	local createElement8 = React.createElement

	local createElement9 = React.createElement
	local text2 = if v7 then v4.continueButton else v4.submitButton
	local v10 = {
		SubmitButton = createElement9(Button, {
			text = text2,
			onActivated = onActivated3,
			variant = ButtonVariant.Emphasis,
			width = UDim.new(1, 0),
			LayoutOrder = 0
		}),
		GenericReportLink = 0
	}
	local genericReportLink

	if isShowGenericIllegalContentReportingLink() then
		genericReportLink = React.createElement(GenericReportLink, {})
	end

	v10.GenericReportLink = genericReportLink
	children2.Actions = createElement7(actions, nil, {
		ActionsFrame = createElement8(View, { tag = "size-full-0 auto-xy col gap-small" }, v10)
	})
	local children = {
		MainSheet = createElement2(root, { isOpen = state, onClose = v5 }, children2),
		OptionSheet = 0
	}

	local createElement10 = React.createElement
	local root2 = Sheet.Root
	local v11 = {
		isOpen = state2 ~= "None",
		onClose = v6
	}

	local v12 = {
		Header = React.createElement(
			Sheet.Header,
			{ hasCloseAffordance = false },
			React.createElement(View, { tag = "auto-xy row gap-medium align-y-center" }, {
				Icon = React.createElement(IconButton, {
					variant = ButtonVariant.Utility,
					icon = IconName.ChevronLargeLeft,
					onActivated = v6,
					LayoutOrder = 1
				}),
				Title = React.createElement(Text, {
					Text = state2 == "Problem" and v4.problemHeading or v4.surfaceHeading,
					RichText = true,
					tag = "auto-xy text-align-x-left text-wrap text-heading-small text-align-x-left",
					LayoutOrder = 2
				})
			})
		),
		Content = 0
	}

	local createElement11 = React.createElement
	local content2 = Sheet.Content
	local v13 = {
		Padding = React.createElement(View, { tag = "padding-top-xxsmall", LayoutOrder = 1 }),
		OptionsList = 0
	}

	local createElement12 = React.createElement
	local root3 = OptionSelectorGroup.Root
	local v14

	if state2 == "Problem" and state3 ~= nil then
		v14 = state3.value
	else
		v14 = (state2 ~= "Surface" or state4 == nil) and "" or state4.value
	end

	v13.OptionsList = createElement12(
		root3,
		{ value = v14, onValueChanged = onValueChanged, LayoutOrder = 2 },
		Dash.map(data[state2 == "Problem" and "problems" or "surfaces"], function(props)
			return React.createElement(OptionSelectorGroup.Item, {
				key = props.value,
				value = props.value,
				label = props.label,
				description = props.description,
				size = InputSize.Small
			})
		end)
	)
	v12.Content = createElement11(content2, nil, v13)
	children.OptionSheet = createElement10(root2, v11, v12)
	return createElement(fragment, nil, children)
end

return React.memo(DualDropdownReportV2)
