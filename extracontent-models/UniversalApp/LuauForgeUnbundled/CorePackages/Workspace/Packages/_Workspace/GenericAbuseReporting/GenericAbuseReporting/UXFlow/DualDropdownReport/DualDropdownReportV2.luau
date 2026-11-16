local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")
local DsaIllegalContentReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/DsaIllegalContentReporting")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local genericReportLink = DsaIllegalContentReporting.GenericReportLink
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local inputLabel = Foundation.InputLabel
local inputSize = Foundation.Enums.InputSize
local isShowGenericIllegalContentReportingLink = DsaIllegalContentReporting.isShowGenericIllegalContentReportingLink
local optionSelectorGroup = Foundation.OptionSelectorGroup
local sheet = Foundation.Sheet
local text = Foundation.Text
local textArea = Foundation.TextArea
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

local SideModalDropdownButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/SideModalDropdownButton")

local function DualDropdownReportV2(data)
	local v5 = useTokens()
	local state, setState = React.useState(true)
	local state2, setState2 = React.useState("None")
	local useState = React.useState
	local v6 = if data.preselected then data.preselected.problem or nil else nil
	local state3, setState3 = useState(v6)
	local useState2 = React.useState
	local v7 = if data.preselected then data.preselected.surface or nil else nil
	local state4, setState4 = useState2(v7)
	local state5, setState5 = React.useState("")

	local state6, setState6 = React.useState("None")

	local v8 = useLocalization({
		problemHeading = "Feature.ReportAbuse.Label.WhatWasWrong",
		surfaceHeading = "Feature.ReportAbuse.Label.WhereDidItHappen",
		selectOnePrompt = "Feature.ReportAbuse.Label.PleaseSelectOne",
		commentHeading = "Feature.ReportAbuse.Label.TellUsWhatHappenedNoOptional",
		textAreaPlaceholder = "Feature.SettingsHub.Label.ReportComment",
		submitButton = "Feature.ReportAbuse.Label.Report",
		continueButton = "Feature.ReportAbuse.Action.Continue",
		titleIpInfringement = "Feature.ReportAbuse.Title.SelectInSceneContinueYourReport"
	})

	local v9 = React.useCallback(function(p2)
		setState5(p2)
	end, {})

	local v10 = React.useCallback(function()
		setState2("Problem")
	end, {})

	local v11 = React.useCallback(function()
		setState2("Surface")
	end, {})

	local v12 = React.useCallback(function()
		setState(false)
		task.wait(0.3)
		data.onClose()
	end, { data.onClose })

	local v13 = React.useCallback(function()
		setState2("None")
	end, {})

	local v14 = React.useCallback(function(p2)
		if state2 == "Problem" then
			setState3((Dash.find(data.problems, function(p3): boolean
				return p3.value == p2
			end)))
		else
			setState4((Dash.find(data.surfaces, function(p3): boolean
				return p3.value == p2
			end)))
		end

		v13()
	end, { state2, data.problems, data.surfaces, v13 })

	local v15 = state3 and state3.value == "ip infringement"

	local v16 = React.useCallback(function()
		local v17 = state3 == nil and "" or state3.value
		local v18 = state4 == nil and "" or state4.value

		if v17 == "" and v18 == "" then
			setState6("Both")
			return
		end

		if v17 == "" then
			setState6("Problem")
			return
		end

		if v18 == "" and not v15 then
			setState6("Surface")
			return
		end

		setState6("None")
		v12()
		data.onSubmit(v17, v18, state5)
	end, { state3, state4, state5, v12, data.onSubmit, v15 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local root = sheet.Root

	local createElement3 = React.createElement
	local header = sheet.Header

	local createElement4 = React.createElement

	local v22 = {
		Icon = React.createElement(iconButton, {
			variant = buttonVariant.Utility,
			icon = iconName.X,
			onActivated = v12,
			LayoutOrder = 1
		}),
		Title = 0
	}

	local createElement5 = React.createElement
	local v25 = if v15 then v8.titleIpInfringement else data.title
	v22.Title = createElement5(text, {
		Text = v25,
		RichText = true,
		tag = "auto-xy text-wrap text-heading-small text-align-x-left",
		LayoutOrder = 2
	})
	local children2 = {
		Header = createElement3(
			header,
			{ hasCloseAffordance = false },
			createElement4(view, {
				tag = "size-full-0 auto-y row gap-medium align-y-center"
			}, v22)
		),
		Content = 0,
		Actions = 0
	}

	local createElement6 = React.createElement
	local content = sheet.Content
	local v27 = {
		ProblemFrame = React.createElement(
			view,
			{ tag = "size-full-0 auto-y col gap-small", LayoutOrder = 1 },
			{
				ProblemHeading = React.createElement(inputLabel, {
					Text = v8.problemHeading,
					size = inputSize.Small,
					LayoutOrder = 1
				}),
				ProblemDropdownButton = React.createElement(SideModalDropdownButton, {
					text = state3 and state3.label or v8.chooseOne,
					onActivated = v10,
					isDropdownError = state6 == "Problem" or state6 == "Both",
					layoutOrder = 2
				}),
				ProblemSubtext = React.createElement(text, {
					Text = (state6 == "Problem" or state6 == "Both") and v8.selectOnePrompt or "",
					RichText = true,
					textStyle = v5.Color.System.Alert,
					tag = "auto-xy text-wrap text-align-x-left text-body-small",
					LayoutOrder = 3
				})
			}
		),
		ProblemSurface = 0,
		TextArea = 0
	}

	local v28 = if not v15 then React.createElement(
		view,
		{ tag = "size-full-0 auto-y col gap-small", LayoutOrder = 2 },
		{
			SurfaceHeading = React.createElement(inputLabel, {
				Text = v8.surfaceHeading,
				size = inputSize.Small,
				LayoutOrder = 1
			}),
			SurfaceDropdownButton = React.createElement(SideModalDropdownButton, {
				text = state4 and state4.label or v8.chooseOne,
				onActivated = v11,
				isDropdownError = state6 == "Surface" or state6 == "Both",
				layoutOrder = 2
			}),
			SurfaceSubtext = React.createElement(text, {
				Text = (state6 == "Surface" or state6 == "Both") and v8.selectOnePrompt or "",
				RichText = true,
				textStyle = v5.Color.System.Alert,
				tag = "auto-xy text-wrap text-align-x-left text-body-small",
				LayoutOrder = 3
			})
		}
	) else nil
	v27.ProblemSurface = v28

	local v29 = if not v15 then React.createElement(textArea, {
		label = v8.commentHeading,
		text = state5,
		placeholder = v8.textAreaPlaceholder,
		isRequired = false,
		onChanged = v9,
		width = UDim.new(1, 0),
		LayoutOrder = 3
	}) else nil
	v27.TextArea = v29
	children2.Content = createElement6(content, nil, v27)

	local createElement7 = React.createElement
	local actions = sheet.Actions
	local createElement8 = React.createElement

	local createElement9 = React.createElement
	local v37 = if v15 then v8.continueButton else v8.submitButton
	local v34 = {
		SubmitButton = createElement9(button, {
			text = v37,
			onActivated = v16,
			variant = buttonVariant.Emphasis,
			width = UDim.new(1, 0),
			LayoutOrder = 0
		}),
		GenericReportLink = 0
	}

	local v38 = if isShowGenericIllegalContentReportingLink() then React.createElement(genericReportLink, {}) else nil
	v34.GenericReportLink = v38
	children2.Actions = createElement7(actions, nil, {
		ActionsFrame = createElement8(view, {
			tag = "size-full-0 auto-xy col gap-small"
		}, v34)
	})
	local children = {
		MainSheet = createElement2(root, { isOpen = state, onClose = v12 }, children2),
		OptionSheet = 0
	}

	local createElement10 = React.createElement
	local root2 = sheet.Root
	local v39 = {
		isOpen = state2 ~= "None",
		onClose = v13
	}

	local v40 = {
		Header = React.createElement(
			sheet.Header,
			{ hasCloseAffordance = false },
			React.createElement(view, {
				tag = "auto-xy row gap-medium align-y-center"
			}, {
				Icon = React.createElement(iconButton, {
					variant = buttonVariant.Utility,
					icon = iconName.ChevronLargeLeft,
					onActivated = v13,
					LayoutOrder = 1
				}),
				Title = React.createElement(text, {
					Text = state2 == "Problem" and v8.problemHeading or v8.surfaceHeading,
					RichText = true,
					tag = "auto-xy text-align-x-left text-wrap text-heading-small text-align-x-left",
					LayoutOrder = 2
				})
			})
		),
		Content = 0
	}

	local createElement11 = React.createElement
	local content2 = sheet.Content
	local v42 = {
		Padding = React.createElement(view, {
			tag = "padding-top-xxsmall",
			LayoutOrder = 1
		}),
		OptionsList = 0
	}

	local createElement12 = React.createElement
	local root3 = optionSelectorGroup.Root

	local v44 = if state2 == "Problem" and state3 ~= nil then state3.value else (state2 ~= "Surface" or state4 == nil) and "" or state4.value
	v42.OptionsList = createElement12(
		root3,
		{ value = v44, onValueChanged = v14, LayoutOrder = 2 },
		Dash.map(data[state2 == "Problem" and "problems" or "surfaces"], function(props)
			return React.createElement(optionSelectorGroup.Item, {
				key = props.value,
				value = props.value,
				label = props.label,
				description = props.description,
				size = inputSize.Small
			})
		end)
	)
	v40.Content = createElement11(content2, nil, v42)
	children.OptionSheet = createElement10(root2, v39, v40)
	return createElement(fragment, nil, children)
end

return React.memo(DualDropdownReportV2)
