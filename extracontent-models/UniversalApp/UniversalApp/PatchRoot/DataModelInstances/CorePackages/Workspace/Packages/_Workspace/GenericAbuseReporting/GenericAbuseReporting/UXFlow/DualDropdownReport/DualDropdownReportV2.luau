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
local FFlagReportIPInfringement = require(GenericAbuseReportingParent.SharedFlags).FFlagReportIPInfringement

local function DualDropdownReportV2(t1: {[any]: any}) -- line: 48
	-- upvalues: useTokens (copy), React (copy), useLocalization (copy), Dash (copy), FFlagReportIPInfringement (copy), Sheet (copy), View (copy), IconButton (copy), ButtonVariant (copy), IconName (copy), FoundationText (copy), InputLabel (copy), InputSize (copy), SideModalDropdownButton (copy), TextArea (copy), Button (copy), isShowGenericIllegalContentReportingLink (copy), GenericReportLink (copy), OptionSelectorGroup (copy)
	local v27 = useTokens()
	local v28, v29 = React.useState(true)
	local v30, v31 = React.useState("None")
	local v32, v33 = React.useState(t1.preselected and t1.preselected.problem or nil)
	local v34, v35 = React.useState(t1.preselected and t1.preselected.surface or nil)
	local v36, v37 = React.useState("")
	local v38, v39 = React.useState("None")
	local v40 = useLocalization({
		problemHeading = "Feature.ReportAbuse.Label.WhatWasWrong",
		surfaceHeading = "Feature.ReportAbuse.Label.WhereDidItHappen",
		selectOnePrompt = "Feature.ReportAbuse.Label.PleaseSelectOne",
		commentHeading = "Feature.ReportAbuse.Label.TellUsWhatHappenedNoOptional",
		textAreaPlaceholder = "Feature.SettingsHub.Label.ReportComment",
		submitButton = "Feature.ReportAbuse.Action.Submit",
		continueButton = "Feature.ReportAbuse.Action.Continue",
		titleIpInfringement = "Feature.ReportAbuse.Title.SelectInSceneContinueYourReport"
	})
	local v41 = React.useCallback(function(p1) -- line: 69
		-- upvalues: v37 (copy)
		v37(p1)
	end, {})
	local v42 = React.useCallback(function() -- line: 73
		-- upvalues: v31 (copy)
		v31("Problem")
	end, {})
	local v43 = React.useCallback(function() -- line: 77
		-- upvalues: v31 (copy)
		v31("Surface")
	end, {})
	local v44 = React.useCallback(function() -- line: 81
		-- upvalues: v29 (copy), t1 (copy)
		v29(false)
		task.wait(0.3)
		t1.onClose()
	end, { t1.onClose })
	local v45 = React.useCallback(function() -- line: 87
		-- upvalues: v31 (copy)
		v31("None")
	end, {})
	local v46 = React.useCallback(function(s1: string) -- line: 91
		-- upvalues: v30 (copy), Dash (copy), t1 (copy), v33 (copy), v35 (copy), v45 (copy)
		if v30 == "Problem" then
			local v51 = Dash.find(t1.problems, function(t2: {[any]: any}) -- line: 93
				-- upvalues: s1 (copy)
				return t2.value == s1
			end)

			v33(v51)
		else
			local v52 = Dash.find(t1.surfaces, function(t3: {[any]: any}) -- line: 98
				-- upvalues: s1 (copy)
				return t3.value == s1
			end)

			v35(v52)
		end

		v45()
	end, {
		v30,
		t1.problems,
		t1.surfaces,
		v45
	})
	local v47 = FFlagReportIPInfringement and (v32 and v32.value == "ip infringement")
	local v48 = React.useCallback(function() -- line: 110
		-- upvalues: v32 (copy), v34 (copy), v39 (copy), v47 (copy), v44 (copy), t1 (copy), v36 (copy)
		local v53 = v32 == nil and "" or v32.value
		local v54 = v34 == nil and "" or v34.value

		if v53 == "" and v54 == "" then
			v39("Both")

			return
		end

		if v53 == "" then
			v39("Problem")

			return
		end

		if v54 == "" and not v47 then
			v39("Surface")

			return
		end

		v39("None")
		v44()
		t1.onSubmit(v53, v54, v36)
	end, {
		v32,
		v34,
		v36,
		v44,
		t1.onSubmit,
		v47
	})

	return React.createElement(React.Fragment, nil, {
		MainSheet = React.createElement(Sheet.Root, {
			isOpen = v28,
			onClose = v44
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
					onActivated = v44
				}),
				Title = React.createElement(FoundationText, {
					RichText = true,
					tag = "auto-xy text-wrap text-heading-small text-align-x-left",
					LayoutOrder = 2,
					Text = if not v47 then t1.title else v40.titleIpInfringement
				})
			})),
			Content = React.createElement(Sheet.Content, nil, {
				ProblemFrame = React.createElement(View, {
					tag = "size-full-0 auto-y col gap-small",
					LayoutOrder = 1
				}, {
					ProblemHeading = React.createElement(InputLabel, {
						LayoutOrder = 1,
						Text = v40.problemHeading,
						size = InputSize.Small
					}),
					ProblemDropdownButton = React.createElement(SideModalDropdownButton, {
						layoutOrder = 2,
						text = v32 and v32.label or v40.chooseOne,
						onActivated = v42,
						isDropdownError = v38 == "Problem" or v38 == "Both"
					}),
					ProblemSubtext = React.createElement(FoundationText, {
						RichText = true,
						tag = "auto-xy text-wrap text-align-x-left text-body-small",
						LayoutOrder = 3,
						Text = not (v38 ~= "Problem" and v38 ~= "Both") and v40.selectOnePrompt or "",
						textStyle = v27.Color.System.Alert
					})
				}),
				ProblemSurface = if not v47 then React.createElement(View, {
					tag = "size-full-0 auto-y col gap-small",
					LayoutOrder = 2
				}, {
					SurfaceHeading = React.createElement(InputLabel, {
						LayoutOrder = 1,
						Text = v40.surfaceHeading,
						size = InputSize.Small
					}),
					SurfaceDropdownButton = React.createElement(SideModalDropdownButton, {
						layoutOrder = 2,
						text = v34 and v34.label or v40.chooseOne,
						onActivated = v43,
						isDropdownError = v38 == "Surface" or v38 == "Both"
					}),
					SurfaceSubtext = React.createElement(FoundationText, {
						RichText = true,
						tag = "auto-xy text-wrap text-align-x-left text-body-small",
						LayoutOrder = 3,
						Text = not (v38 ~= "Surface" and v38 ~= "Both") and v40.selectOnePrompt or "",
						textStyle = v27.Color.System.Alert
					})
				}) else nil,
				TextArea = if not v47 then React.createElement(TextArea, {
					isRequired = false,
					LayoutOrder = 3,
					label = v40.commentHeading,
					text = v36,
					placeholder = v40.textAreaPlaceholder,
					onChanged = v41,
					width = UDim.new(1, 0)
				}) else nil
			}),
			Actions = React.createElement(Sheet.Actions, nil, {
				ActionsFrame = React.createElement(View, {
					tag = "size-full-0 auto-xy col gap-small"
				}, {
					SubmitButton = React.createElement(Button, {
						LayoutOrder = 0,
						text = if not v47 then v40.submitButton else v40.continueButton,
						onActivated = v48,
						variant = ButtonVariant.Emphasis,
						width = UDim.new(1, 0)
					}),
					GenericReportLink = if not isShowGenericIllegalContentReportingLink() then nil else React.createElement(GenericReportLink, {})
				})
			})
		}),
		OptionSheet = React.createElement(Sheet.Root, {
			isOpen = v30 ~= "None",
			onClose = v45
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
					onActivated = v45
				}),
				Title = React.createElement(FoundationText, {
					RichText = true,
					tag = "auto-xy text-align-x-left text-wrap text-heading-small text-align-x-left",
					LayoutOrder = 2,
					Text = v30 == "Problem" and v40.problemHeading or v40.surfaceHeading
				})
			})),
			Content = React.createElement(Sheet.Content, nil, {
				Padding = React.createElement(View, {
					tag = "padding-top-xxsmall",
					LayoutOrder = 1
				}),
				OptionsList = React.createElement(OptionSelectorGroup.Root, {
					LayoutOrder = 2,
					value = if v30 ~= "Problem" or v32 == nil then (v30 ~= "Surface" or v34 == nil) and "" or v34.value else v32.value,
					onValueChanged = v46
				}, Dash.map(t1[v30 ~= "Problem" and "surfaces" or "problems"], function(t4: {[any]: any}) -- line: 283
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
