local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReportingParent.React)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local UIBlox = require(GenericAbuseReportingParent.UIBlox)
local useLocalization = require(GenericAbuseReportingParent.Localization).Hooks.useLocalization
local useLocalizedStrings = require(GenericAbuseReporting.LocalizationKeys.useLocalizedStrings)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local View = Foundation.View
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local createNextOrder = require(GenericAbuseReportingParent.ReactUtils).createNextOrder
local ButtonList = require(GenericAbuseReporting.Common.ButtonList)
local CommentTextField = require(GenericAbuseReporting.Common.CommentTextField)

require(GenericAbuseReporting.Common.ReasonDropdown)

local ScrollViewGradient = require(GenericAbuseReporting.Common.ScrollViewGradient)
local SideModal = require(GenericAbuseReporting.Common.SideModal)
local SideModalDropdownButton = require(GenericAbuseReporting.Common.SideModalDropdownButton)

local function getContentRightPadding(vector2: Vector2, vector2_2: Vector2) -- line: 43
	if vector2.Y > vector2_2.Y then
		return 16
	end

	return 1
end
local function DualDropdownSubmitDialog(t1: {[any]: any}) -- line: 47
	-- upvalues: useTokens (copy), useLayerCollector (copy), React (copy), useLocalizedStrings (copy), useLocalization (copy), createNextOrder (copy), View (copy), SideModal (copy), ScrollViewGradient (copy), FoundationText (copy), SideModalDropdownButton (copy), CommentTextField (copy), ButtonList (copy)
	local v23 = useTokens()
	local absoluteSize = useLayerCollector().absoluteSize
	local v25, v26 = React.useState(false)
	local v27, v28 = React.useState(false)
	local v29, v30 = React.useState("")
	local v31, v32 = React.useState("")
	local v33, v34 = React.useState("")
	local v35, v36 = React.useState("")
	local v37, v38 = React.useState("")
	local v39, v40 = React.useState(false)
	local v41, v42 = React.useState(false)
	local v43, v44 = React.useState(false)
	local v45, v46 = React.useState("")
	local v47 = React.useRef(nil)
	local v48, v49 = React.useState(Vector2.zero)
	local v50, v51 = React.useState(Vector2.zero)
	local v52 = useLocalizedStrings()
	local v53 = useLocalization({
		submitDialogProblemSubheading = "Feature.ReportAbuse.Label.WhatWasWrong",
		submitDialogSurfaceSubheading = "Feature.ReportAbuse.Label.WhereDidItHappen",
		selectOnePrompt = "Feature.ReportAbuse.Label.PleaseSelectOne",
		submitDialogCommentSubheading = "Feature.ReportAbuse.Label.TellUsWhatHappenedNoOptional",
		submitDialogTextBoxPlaceholder = "Feature.SettingsHub.Label.ReportComment",
		submitDialogOptional = "Feature.ReportAbuse.Label.Optional",
		chooseOne = "Feature.ReportAbuse.Label.ChooseOne"
	})
	local v54 = createNextOrder()

	React.useLayoutEffect(function() -- line: 80
		-- upvalues: v47 (copy), v49 (copy), v51 (copy)
		if v47.current then
			local ScrollingFrame = v47.current:FindFirstChildWhichIsA("ScrollingFrame")

			if ScrollingFrame then
				v49(ScrollingFrame.AbsoluteCanvasSize)
				v51(ScrollingFrame.AbsoluteWindowSize)

				local connection = ScrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- line: 89
					-- upvalues: v49 (copy), ScrollingFrame (copy)
					v49(ScrollingFrame.AbsoluteCanvasSize)
				end)
				local connection2 = ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 94
					-- upvalues: v51 (copy), ScrollingFrame (copy)
					v51(ScrollingFrame.AbsoluteWindowSize)
				end)

				return function() -- line: 97
					-- upvalues: connection (copy), connection2 (copy)
					connection:Disconnect()
					connection2:Disconnect()
				end
			end
		else
			v49(Vector2.zero)
			v51(Vector2.zero)
		end

		return function() -- line: 106
		end
	end, {
		v47.current,
		absoluteSize
	})

	local v55 = React.useCallback(function() -- line: 109
		-- upvalues: t1 (copy), v29 (copy), v35 (copy), v45 (copy)
		t1.onSubmit(v29, v35, v45)
	end, {
		t1.onSubmit,
		v29,
		v35,
		v45
	})
	local v56 = React.useCallback(function() -- line: 113
		-- upvalues: v29 (copy), v35 (copy), v26 (copy), v28 (copy)
		if v29 ~= "" and v35 ~= "" then
			return true
		end

		if v29 == "" then
			v26(true)
		end

		if v35 == "" then
			v28(true)
		end

		return false
	end, {
		v29,
		v35,
		v26,
		v28
	})
	local v57 = React.useCallback(function() -- line: 127
		-- upvalues: v40 (copy), v42 (copy)
		v40(false)
		v42(false)
	end, {
		v40,
		v42
	})

	return React.createElement(View, {
		tag = "size-full auto-xy"
	}, {
		ReportFlowModal = React.createElement(SideModal, {
			screenSize = absoluteSize,
			buttonProps = {
				text = v52.formSubmit,
				onActivated = v55,
				validateState = v56
			},
			footerContent = t1.footerContent,
			onAbandon = t1.onAbandon,
			title = v52.formTitle,
			width = math.min(400, absoluteSize.X - 50),
			height = math.min(500, absoluteSize.Y - 50)
		}, {
			SubmitReportFrame = React.createElement(ScrollViewGradient, {
				gradientHeight = 40,
				Size = UDim2.new(1, 0, 1, 0),
				ref = v47
			}, {
				Layout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 30),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Padding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 10),
					PaddingLeft = UDim.new(0, 1),
					PaddingRight = UDim.new(0, not (v48.Y > v50.Y) and 1 or 16)
				}),
				ReportProblemFrame = React.createElement(View, {
					ZIndex = 3,
					tag = "size-full-0 auto-y col align-x-left",
					LayoutOrder = v54()
				}, {
					ProblemHeading = React.createElement(FoundationText, {
						tag = "auto-xy padding-bottom-medium",
						Text = "1. " .. v53.submitDialogProblemSubheading,
						fontStyle = v23.Typography.TitleLarge,
						textStyle = v23.Color.Content.Emphasis,
						LayoutOrder = v54()
					}),
					ProblemDropdownPosition = React.createElement(View, {
						tag = "col align-x-left",
						Size = UDim2.new(1, 0, 0, 48),
						LayoutOrder = v54()
					}, {
						ProblemDropdown = React.createElement(SideModalDropdownButton, {
							setDropdownError = v26,
							onActivated = function() -- line: 185
								-- upvalues: v40 (copy), v44 (copy)
								v40(true)
								v44(false)
							end,
							title = v53.submitDialogProblemSubheading,
							text = v31 ~= "" and v31 or v53.chooseOne,
							isDropdownError = v25
						}),
						ProblemSubtext = React.createElement(FoundationText, {
							TextWrapped = true,
							tag = "auto-xy padding-top-xxsmall",
							Text = v25 and v53.selectOnePrompt or v33,
							TextXAlignment = Enum.TextXAlignment.Left,
							fontStyle = v23.Typography.BodySmall,
							textStyle = v25 and v23.Color.System.Alert or v23.Color.Content.Muted,
							LayoutOrder = v54()
						})
					})
				}),
				ReportSurfaceFrame = React.createElement(View, {
					tag = "size-full-0 auto-y col align-x-left",
					LayoutOrder = v54()
				}, {
					SurfaceHeading = React.createElement(FoundationText, {
						tag = "auto-xy padding-bottom-medium",
						Text = "2. " .. v53.submitDialogSurfaceSubheading,
						fontStyle = v23.Typography.TitleLarge,
						textStyle = v23.Color.Content.Emphasis,
						LayoutOrder = v54()
					}),
					SurfaceDropdownPosition = React.createElement(View, {
						tag = "col align-x-left",
						Size = UDim2.new(1, 0, 0, 48),
						LayoutOrder = v54()
					}, {
						SurfaceDropdown = React.createElement(SideModalDropdownButton, {
							setDropdownError = v28,
							onActivated = function() -- line: 224
								-- upvalues: v42 (copy), v44 (copy)
								v42(true)
								v44(false)
							end,
							title = v53.submitDialogSurfaceSubheading,
							text = v35 ~= "" and v37 or v53.chooseOne,
							isDropdownError = v27
						}),
						SurfaceSubtext = React.createElement(FoundationText, {
							TextWrapped = true,
							tag = "auto-xy padding-top-xxsmall",
							Text = v27 and v53.selectOnePrompt or "",
							TextXAlignment = Enum.TextXAlignment.Left,
							fontStyle = v23.Typography.BodySmall,
							textStyle = v23.Color.System.Alert,
							LayoutOrder = v54()
						})
					})
				}),
				ReportCommentFrame = React.createElement(View, {
					tag = "size-full-0 auto-y col align-x-left",
					LayoutOrder = v54()
				}, {
					CommentHeading = React.createElement(FoundationText, {
						tag = "auto-xy padding-bottom-medium",
						Text = "3. " .. v53.submitDialogCommentSubheading,
						fontStyle = v23.Typography.TitleLarge,
						textStyle = v23.Color.Content.Emphasis,
						LayoutOrder = v54()
					}),
					CommentTextContainer = React.createElement(View, {
						tag = "size-full-0 auto-y col align-x-left stroke-thick stroke-default radius-medium",
						LayoutOrder = v54()
					}, {
						CommentTextField = React.createElement(CommentTextField, {
							text = v45,
							backgroundColor3 = v23.Color.Surface.Surface_100.Color3,
							placeholderText = v53.submitDialogTextBoxPlaceholder,
							onUpdate = v46,
							layoutOrder = v54()
						})
					}),
					CommentSubtext = React.createElement(FoundationText, {
						TextWrapped = true,
						tag = "auto-xy padding-top-xxsmall",
						Text = v53.submitDialogOptional,
						TextXAlignment = Enum.TextXAlignment.Left,
						fontStyle = v23.Typography.CaptionSmall,
						LayoutOrder = v54()
					})
				})
			})
		}),
		DropdownSideModalBackground = if not v39 and not v41 then nil else React.createElement(View, {
			tag = "size-full"
		}, {
			DropdownSideModalContainer = React.createElement(View, {
				tag = "size-full"
			}, {
				DropdownSideModal = React.createElement(SideModal, {
					screenSize = absoluteSize,
					title = if not v39 then v53.submitDialogSurfaceSubheading else v53.submitDialogProblemSubheading,
					width = math.min(400, absoluteSize.X - 50) - 50,
					height = math.min(500, absoluteSize.Y - 50) - 50,
					onAbandon = v57,
					closeWithAnimation = v43
				}, {
					ScrollView = React.createElement(ScrollViewGradient, {
						gradientHeight = 48,
						Size = UDim2.new(1, 0, 1, 0)
					}, {
						Padding = React.createElement("UIPadding", {
							PaddingRight = UDim.new(0, 16)
						}),
						ButtonList = React.createElement(ButtonList, {
							options = if not v39 then t1.reportSurfaces else t1.reportProblems,
							onSelected = function(s1: string, s2: string) -- line: 304
								-- upvalues: v39 (copy), v30 (copy), v32 (copy), v26 (copy), v44 (copy), v36 (copy), v38 (copy), v28 (copy)
								if v39 then
									v30(s1)
									v32(s2)
									v26(false)
									v44(true)

									return
								end

								v36(s1)
								v38(s2)
								v28(false)
								v44(true)
							end,
							setDescription = if not v39 then nil else v34,
							defaultValue = if not v39 then v35 else v29
						})
					})
				})
			})
		})
	})
end

return DualDropdownSubmitDialog
