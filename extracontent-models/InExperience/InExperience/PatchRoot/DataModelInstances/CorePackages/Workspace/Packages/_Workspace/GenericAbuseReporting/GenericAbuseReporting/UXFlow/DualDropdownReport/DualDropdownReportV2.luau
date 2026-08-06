local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local DsaIllegalContentReporting = require(GenericAbuseReportingParent.DsaIllegalContentReporting)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local Localization = require(GenericAbuseReportingParent.Localization)
local React = require(GenericAbuseReportingParent.React)
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
local FoundationText = Foundation.Text
local TextArea = Foundation.TextArea
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local SideModalDropdownButton = require(GenericAbuseReporting.Common.SideModalDropdownButton)

local function DualDropdownReportV2(t1: {[any]: any}) -- line: 46
	-- upvalues: useTokens (copy), React (copy), useLocalization (copy), Dash (copy), Sheet (copy), View (copy), IconButton (copy), ButtonVariant (copy), IconName (copy), FoundationText (copy), InputLabel (copy), InputSize (copy), SideModalDropdownButton (copy), TextArea (copy), Button (copy), isShowGenericIllegalContentReportingLink (copy), GenericReportLink (copy), OptionSelectorGroup (copy)
	local v26 = useTokens()
	local v27, v28 = React.useState(true)
	local v29, v30 = React.useState("None")
	local v31, v32 = React.useState(t1.preselected and t1.preselected.problem or nil)
	local v33, v34 = React.useState(t1.preselected and t1.preselected.surface or nil)
	local v35, v36 = React.useState("")
	local v37, v38 = React.useState("None")
	local v39 = useLocalization({
		problemHeading = "Feature.ReportAbuse.Label.WhatWasWrong",
		surfaceHeading = "Feature.ReportAbuse.Label.WhereDidItHappen",
		selectOnePrompt = "Feature.ReportAbuse.Label.PleaseSelectOne",
		commentHeading = "Feature.ReportAbuse.Label.TellUsWhatHappenedNoOptional",
		textAreaPlaceholder = "Feature.SettingsHub.Label.ReportComment",
		submitButton = "Feature.ReportAbuse.Action.Submit",
		continueButton = "Feature.ReportAbuse.Action.Continue",
		titleIpInfringement = "Feature.ReportAbuse.Title.SelectInSceneContinueYourReport"
	})
	local v40 = React.useCallback(function(p1) -- line: 67
		-- upvalues: v36 (copy)
		v36(p1)
	end, {})
	local v41 = React.useCallback(function() -- line: 71
		-- upvalues: v30 (copy)
		v30("Problem")
	end, {})
	local v42 = React.useCallback(function() -- line: 75
		-- upvalues: v30 (copy)
		v30("Surface")
	end, {})
	local v43 = React.useCallback(function() -- line: 79
		-- upvalues: v28 (copy), t1 (copy)
		v28(false)
		task.wait(0.3)
		t1.onClose()
	end, { t1.onClose })
	local v44 = React.useCallback(function() -- line: 85
		-- upvalues: v30 (copy)
		v30("None")
	end, {})
	local v45 = React.useCallback(function(s1: string) -- line: 89
		-- upvalues: v29 (copy), Dash (copy), t1 (copy), v32 (copy), v34 (copy), v44 (copy)
		if v29 == "Problem" then
			local v50 = Dash.find(t1.problems, function(t2: {[any]: any}) -- line: 91
				-- upvalues: s1 (copy)
				return t2.value == s1
			end)

			v32(v50)
		else
			local v51 = Dash.find(t1.surfaces, function(t3: {[any]: any}) -- line: 96
				-- upvalues: s1 (copy)
				return t3.value == s1
			end)

			v34(v51)
		end

		v44()
	end, {
		v29,
		t1.problems,
		t1.surfaces,
		v44
	})
	local v46 = v31 and v31.value == "ip infringement"
	local v47 = React.useCallback(function() -- line: 106
		-- upvalues: v31 (copy), v33 (copy), v38 (copy), v46 (copy), v43 (copy), t1 (copy), v35 (copy)
		local v52 = v31 == nil and "" or v31.value
		local v53 = v33 == nil and "" or v33.value

		if v52 == "" and v53 == "" then
			v38("Both")

			return
		end

		if v52 == "" then
			v38("Problem")

			return
		end

		if v53 == "" and not v46 then
			v38("Surface")

			return
		end

		v38("None")
		v43()
		t1.onSubmit(v52, v53, v35)
	end, {
		v31,
		v33,
		v35,
		v43,
		t1.onSubmit,
		v46
	})

	return React.createElement(React.Fragment, nil, {
		MainSheet = React.createElement(Sheet.Root, {
			isOpen = v27,
			onClose = v43
		}, {
			Header = React.createElement(Sheet.Header, {
				hasCloseAffordance = false
			}, React.createElement(View, {
				tag = "size-full-0 auto-y row gap-medium align-y-center"
			}, {
				Icon = React.createElement(IconButton, {
					LayoutOrder = 1,
					variant = ButtonVariant.Utility,
					icon = IconName.X,
					onActivated = v43
				}),
				Title = React.createElement(FoundationText, {
					RichText = true,
					tag = "auto-xy text-wrap text-heading-small text-align-x-left",
					LayoutOrder = 2,
					Text = if not v46 then t1.title else v39.titleIpInfringement
				})
			})),
			Content = React.createElement(Sheet.Content, nil, {
				ProblemFrame = React.createElement(View, {
					tag = "size-full-0 auto-y col gap-small",
					LayoutOrder = 1
				}, {
					ProblemHeading = React.createElement(InputLabel, {
						LayoutOrder = 1,
						Text = v39.problemHeading,
						size = InputSize.Small
					}),
					ProblemDropdownButton = React.createElement(SideModalDropdownButton, {
						layoutOrder = 2,
						text = v31 and v31.label or v39.chooseOne,
						onActivated = v41,
						isDropdownError = v37 == "Problem" or v37 == "Both"
					}),
					ProblemSubtext = React.createElement(FoundationText, {
						RichText = true,
						tag = "auto-xy text-wrap text-align-x-left text-body-small",
						LayoutOrder = 3,
						Text = not (v37 ~= "Problem" and v37 ~= "Both") and v39.selectOnePrompt or "",
						textStyle = v26.Color.System.Alert
					})
				}),
				ProblemSurface = if not v46 then React.createElement(View, {
					tag = "size-full-0 auto-y col gap-small",
					LayoutOrder = 2
				}, {
					SurfaceHeading = React.createElement(InputLabel, {
						LayoutOrder = 1,
						Text = v39.surfaceHeading,
						size = InputSize.Small
					}),
					SurfaceDropdownButton = React.createElement(SideModalDropdownButton, {
						layoutOrder = 2,
						text = v33 and v33.label or v39.chooseOne,
						onActivated = v42,
						isDropdownError = v37 == "Surface" or v37 == "Both"
					}),
					SurfaceSubtext = React.createElement(FoundationText, {
						RichText = true,
						tag = "auto-xy text-wrap text-align-x-left text-body-small",
						LayoutOrder = 3,
						Text = not (v37 ~= "Surface" and v37 ~= "Both") and v39.selectOnePrompt or "",
						textStyle = v26.Color.System.Alert
					})
				}) else nil,
				TextArea = if not v46 then React.createElement(TextArea, {
					isRequired = false,
					LayoutOrder = 3,
					label = v39.commentHeading,
					text = v35,
					placeholder = v39.textAreaPlaceholder,
					onChanged = v40,
					width = UDim.new(1, 0)
				}) else nil
			}),
			Actions = React.createElement(Sheet.Actions, nil, {
				ActionsFrame = React.createElement(View, {
					tag = "size-full-0 auto-xy col gap-small"
				}, {
					SubmitButton = React.createElement(Button, {
						LayoutOrder = 0,
						text = if not v46 then v39.submitButton else v39.continueButton,
						onActivated = v47,
						variant = ButtonVariant.Emphasis,
						width = UDim.new(1, 0)
					}),
					GenericReportLink = if not isShowGenericIllegalContentReportingLink() then nil else React.createElement(GenericReportLink, {})
				})
			})
		}),
		OptionSheet = React.createElement(Sheet.Root, {
			isOpen = v29 ~= "None",
			onClose = v44
		}, {
			Header = React.createElement(Sheet.Header, {
				hasCloseAffordance = false
			}, React.createElement(View, {
				tag = "auto-xy row gap-medium align-y-center"
			}, {
				Icon = React.createElement(IconButton, {
					LayoutOrder = 1,
					variant = ButtonVariant.Utility,
					icon = IconName.ChevronLargeLeft,
					onActivated = v44
				}),
				Title = React.createElement(FoundationText, {
					RichText = true,
					tag = "auto-xy text-align-x-left text-wrap text-heading-small text-align-x-left",
					LayoutOrder = 2,
					Text = v29 == "Problem" and v39.problemHeading or v39.surfaceHeading
				})
			})),
			Content = React.createElement(Sheet.Content, nil, {
				Padding = React.createElement(View, {
					tag = "padding-top-xxsmall",
					LayoutOrder = 1
				}),
				OptionsList = React.createElement(OptionSelectorGroup.Root, {
					LayoutOrder = 2,
					value = if v29 ~= "Problem" or v31 == nil then (v29 ~= "Surface" or v33 == nil) and "" or v33.value else v31.value,
					onValueChanged = v45
				}, Dash.map(t1[v29 ~= "Problem" and "surfaces" or "problems"], function(t4: {[any]: any}) -- line: 279
					-- upvalues: React (copy), OptionSelectorGroup (copy), InputSize (copy)
					return React.createElement(OptionSelectorGroup.Item, {
						key = t4.value,
						value = t4.value,
						label = t4.label,
						description = t4.description,
						size = InputSize.Small
					})
				end))
			})
		})
	})
end

return React.memo(DualDropdownReportV2)
