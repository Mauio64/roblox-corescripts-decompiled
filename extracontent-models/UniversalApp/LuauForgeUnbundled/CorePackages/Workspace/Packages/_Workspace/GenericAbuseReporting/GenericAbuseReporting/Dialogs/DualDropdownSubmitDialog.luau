local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UIBlox")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Localization").Hooks.useLocalization
local useLocalizedStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/LocalizationKeys/useLocalizedStrings")
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local view = Foundation.View
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local createNextOrder = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ReactUtils").createNextOrder

local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/ButtonList")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/CommentTextField")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/ReasonDropdown")
local ScrollViewGradient = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/ScrollViewGradient")
local SideModal = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/SideModal")
local SideModalDropdownButton = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/SideModalDropdownButton")

local function getContentRightPadding(p2, p3): number
	if p2.Y > p3.Y then
		return 16
	end

	return 1
end

local function DualDropdownSubmitDialog(props)
	local v5 = useTokens()
	local absoluteSize = useLayerCollector().absoluteSize
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState("")
	local state4, setState4 = React.useState("")
	local state5, setState5 = React.useState("")
	local state6, setState6 = React.useState("")
	local state7, setState7 = React.useState("")
	local state8, setState8 = React.useState(false)
	local state9, setState9 = React.useState(false)
	local state10, setState10 = React.useState(false)
	local state11, setState11 = React.useState("")

	local ref = React.useRef(nil)
	local state12, setState12 = React.useState(Vector2.zero)
	local state13, setState13 = React.useState(Vector2.zero)

	local v6 = useLocalizedStrings()
	local v7 = useLocalization({
		submitDialogProblemSubheading = "Feature.ReportAbuse.Label.WhatWasWrong",
		submitDialogSurfaceSubheading = "Feature.ReportAbuse.Label.WhereDidItHappen",
		selectOnePrompt = "Feature.ReportAbuse.Label.PleaseSelectOne",
		submitDialogCommentSubheading = "Feature.ReportAbuse.Label.TellUsWhatHappenedNoOptional",
		submitDialogTextBoxPlaceholder = "Feature.SettingsHub.Label.ReportComment",
		submitDialogOptional = "Feature.ReportAbuse.Label.Optional",
		chooseOne = "Feature.ReportAbuse.Label.ChooseOne"
	})

	local nextOrder = createNextOrder()

	React.useLayoutEffect(function()
		if ref.current then
			local scrollingFrame = ref.current:FindFirstChildWhichIsA("ScrollingFrame")

			if scrollingFrame then
				setState12(scrollingFrame.AbsoluteCanvasSize)
				setState13(scrollingFrame.AbsoluteWindowSize)

				local absoluteCanvasSizeChangedConnection = scrollingFrame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
					setState12(scrollingFrame.AbsoluteCanvasSize)
				end)

				local absoluteWindowSizeChangedConnection = scrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
					setState13(scrollingFrame.AbsoluteWindowSize)
				end)
				return function()
					absoluteCanvasSizeChangedConnection:Disconnect()
					absoluteWindowSizeChangedConnection:Disconnect()
				end
			end
		else
			setState12(Vector2.zero)
			setState13(Vector2.zero)
		end

		return function() end
	end, { ref.current, absoluteSize })

	local v8 = React.useCallback(function()
		props.onSubmit(state3, state6, state11)
	end, { props.onSubmit, state3, state6, state11 })

	local v9 = React.useCallback(function(): boolean
		if state3 ~= "" and state6 ~= "" then
			return true
		end

		if state3 == "" then
			setState(true)
		end

		if state6 == "" then
			setState2(true)
		end

		return false
	end, { state3, state6, setState, setState2 })

	local v10 = React.useCallback(function()
		setState8(false)
		setState9(false)
	end, { setState8, setState9 })

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v15 = {
		screenSize = absoluteSize,
		buttonProps = { text = v6.formSubmit, onActivated = v8, validateState = v9 },
		footerContent = props.footerContent,
		onAbandon = props.onAbandon,
		title = v6.formTitle,
		width = math.min(400, absoluteSize.X - 50),
		height = math.min(500, absoluteSize.Y - 50)
	}

	local createElement3 = React.createElement
	local v18 = { Size = UDim2.new(1, 0, 1, 0), ref = ref, gradientHeight = 40 }
	local children = {
		Layout = React.createElement("UIListLayout", {
			Padding = UDim.new(0, 30),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 1),
			PaddingRight = UDim.new(0, state12.Y > state13.Y and 16 or 1)
		}),
		ReportProblemFrame = 0,
		ReportSurfaceFrame = 0,
		ReportCommentFrame = 0
	}

	local createElement4 = React.createElement
	local v20 = {
		ZIndex = 3,
		tag = "size-full-0 auto-y col align-x-left",
		LayoutOrder = nextOrder()
	}
	local v21 = {
		ProblemHeading = React.createElement(text, {
			Text = "1. " .. v7.submitDialogProblemSubheading,
			fontStyle = v5.Typography.TitleLarge,
			textStyle = v5.Color.Content.Emphasis,
			tag = "auto-xy padding-bottom-medium",
			LayoutOrder = nextOrder()
		}),
		ProblemDropdownPosition = 0
	}

	local createElement5 = React.createElement
	local v23 = {
		Size = UDim2.new(1, 0, 0, 48),
		tag = "col align-x-left",
		LayoutOrder = nextOrder()
	}

	local createElement6 = React.createElement
	local v25 = {
		setDropdownError = setState,
		onActivated = function()
			setState8(true)
			setState10(false)
		end,
		title = v7.submitDialogProblemSubheading,
		text = 0,
		isDropdownError = 0
	}

	if state4 == "" or not state4 then
		state4 = v7.chooseOne
	end

	v25.text = state4
	v25.isDropdownError = state
	local children2 = {
		ProblemDropdown = createElement6(SideModalDropdownButton, v25),
		ProblemSubtext = 0
	}

	local createElement7 = React.createElement
	state5 = state and v7.selectOnePrompt or state5
	children2.ProblemSubtext = createElement7(text, {
		Text = state5,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		fontStyle = v5.Typography.BodySmall,
		textStyle = state and v5.Color.System.Alert or v5.Color.Content.Muted,
		tag = "auto-xy padding-top-xxsmall",
		LayoutOrder = nextOrder()
	})
	v21.ProblemDropdownPosition = createElement5(view, v23, children2)
	children.ReportProblemFrame = createElement4(view, v20, v21)

	local createElement8 = React.createElement
	local v29 = {
		tag = "size-full-0 auto-y col align-x-left",
		LayoutOrder = nextOrder()
	}
	local v30 = {
		SurfaceHeading = React.createElement(text, {
			Text = "2. " .. v7.submitDialogSurfaceSubheading,
			fontStyle = v5.Typography.TitleLarge,
			textStyle = v5.Color.Content.Emphasis,
			tag = "auto-xy padding-bottom-medium",
			LayoutOrder = nextOrder()
		}),
		SurfaceDropdownPosition = 0
	}

	local createElement9 = React.createElement
	local v32 = {
		Size = UDim2.new(1, 0, 0, 48),
		tag = "col align-x-left",
		LayoutOrder = nextOrder()
	}

	local createElement10 = React.createElement
	local v34 = {
		setDropdownError = setState2,
		onActivated = function()
			setState9(true)
			setState10(false)
		end,
		title = v7.submitDialogSurfaceSubheading,
		text = 0,
		isDropdownError = 0
	}

	if state6 == "" or not state7 then
		state7 = v7.chooseOne
	end

	v34.text = state7
	v34.isDropdownError = state2
	v30.SurfaceDropdownPosition = createElement9(view, v32, {
		SurfaceDropdown = createElement10(SideModalDropdownButton, v34),
		SurfaceSubtext = React.createElement(text, {
			Text = state2 and v7.selectOnePrompt or "",
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			fontStyle = v5.Typography.BodySmall,
			textStyle = v5.Color.System.Alert,
			tag = "auto-xy padding-top-xxsmall",
			LayoutOrder = nextOrder()
		})
	})
	children.ReportSurfaceFrame = createElement8(view, v29, v30)

	children.ReportCommentFrame = React.createElement(
		view,
		{ tag = "size-full-0 auto-y col align-x-left", LayoutOrder = nextOrder() },
		{
			CommentHeading = React.createElement(text, {
				Text = "3. " .. v7.submitDialogCommentSubheading,
				fontStyle = v5.Typography.TitleLarge,
				textStyle = v5.Color.Content.Emphasis,
				tag = "auto-xy padding-bottom-medium",
				LayoutOrder = nextOrder()
			}),
			CommentTextContainer = React.createElement(
				view,
				{
					tag = "size-full-0 auto-y col align-x-left stroke-thick stroke-default radius-medium",
					LayoutOrder = nextOrder()
				},
				{
					CommentTextField = React.createElement(module6, {
						text = state11,
						backgroundColor3 = v5.Color.Surface.Surface_100.Color3,
						placeholderText = v7.submitDialogTextBoxPlaceholder,
						onUpdate = setState11,
						layoutOrder = nextOrder()
					})
				}
			),
			CommentSubtext = React.createElement(text, {
				Text = v7.submitDialogOptional,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				fontStyle = v5.Typography.CaptionSmall,
				tag = "auto-xy padding-top-xxsmall",
				LayoutOrder = nextOrder()
			})
		}
	)
	local v13 = {
		ReportFlowModal = createElement2(SideModal, v15, {
			SubmitReportFrame = createElement3(ScrollViewGradient, v18, children)
		}),
		DropdownSideModalBackground = 0
	}
	local v35

	if state8 or state9 then
		local createElement11 = React.createElement

		local createElement12 = React.createElement

		local createElement13 = React.createElement

		local v44 = if state8 then v7.submitDialogProblemSubheading else v7.submitDialogSurfaceSubheading
		local v43 = {
			screenSize = absoluteSize,
			title = v44,
			width = math.min(400, absoluteSize.X - 50) - 50,
			height = math.min(500, absoluteSize.Y - 50) - 50,
			onAbandon = v10,
			closeWithAnimation = state10
		}

		local createElement14 = React.createElement
		local v47 = { Size = UDim2.new(1, 0, 1, 0), gradientHeight = 48 }

		local v48 = {
			Padding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, 16)
			}),
			ButtonList = 0
		}

		local createElement15 = React.createElement
		local v51 = if state8 then props.reportProblems else props.reportSurfaces
		local v50 = {
			options = v51,
			onSelected = function(p2, p3)
				if state8 then
					setState3(p2)
					setState4(p3)
					setState(false)
				else
					setState6(p2)
					setState7(p3)
					setState2(false)
				end

				setState10(true)
			end,
			setDescription = 0,
			defaultValue = 0
		}

		if not state8 then
			setState5 = nil
		end

		v50.setDescription = setState5
		v50.defaultValue = if state8 then state3 else state6
		v48.ButtonList = createElement15(module5, v50)
		v35 = createElement11(view, { tag = "size-full" }, {
			DropdownSideModalContainer = createElement12(view, { tag = "size-full" }, {
				DropdownSideModal = createElement13(SideModal, v43, {
					ScrollView = createElement14(ScrollViewGradient, v47, v48)
				})
			})
		})
	end

	v13.DropdownSideModalBackground = v35
	return createElement(view, { tag = "size-full auto-xy" }, v13)
end

return DualDropdownSubmitDialog
