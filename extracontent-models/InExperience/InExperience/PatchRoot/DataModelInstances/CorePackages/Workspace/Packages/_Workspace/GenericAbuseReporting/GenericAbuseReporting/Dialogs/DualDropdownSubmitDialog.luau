local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useLocalizedStrings = require(GenericAbuseReporting.LocalizationKeys.useLocalizedStrings)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local View = Foundation.View
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local ReactUtils = require(parent.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder

local ButtonList = require(GenericAbuseReporting.Common.ButtonList)
local CommentTextField = require(GenericAbuseReporting.Common.CommentTextField)
require(GenericAbuseReporting.Common.ReasonDropdown)
local ScrollViewGradient = require(GenericAbuseReporting.Common.ScrollViewGradient)
local SideModal = require(GenericAbuseReporting.Common.SideModal)
local SideModalDropdownButton = require(GenericAbuseReporting.Common.SideModalDropdownButton)

local function getContentRightPadding(state: Vector2, state2: Vector2): number -- 1 equivalent call inferred from this helper
	return if state.Y > state2.Y then 16 else 1
end

local function DualDropdownSubmitDialog(props)
	local v = useTokens()
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

	local v2 = useLocalizedStrings()
	local v3 = useLocalization({
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

	local onActivated = React.useCallback(function()
		props.onSubmit(state3, state6, state11)
	end, { props.onSubmit, state3, state6, state11 })

	local validateState = React.useCallback(function(): boolean
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

	local onAbandon = React.useCallback(function()
		setState8(false)
		setState9(false)
	end, { setState8, setState9 })

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v4 = {
		screenSize = absoluteSize,
		buttonProps = {
			text = v2.formSubmit,
			onActivated = onActivated,
			validateState = validateState
		},
		footerContent = props.footerContent,
		onAbandon = props.onAbandon,
		title = v2.formTitle,
		width = math.min(400, absoluteSize.X - 50),
		height = math.min(500, absoluteSize.Y - 50)
	}

	local createElement3 = React.createElement
	local v5 = { Size = UDim2.new(1, 0, 1, 0), ref = ref, gradientHeight = 40 }

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
			PaddingRight = UDim.new(0, getContentRightPadding(state12, state13)) -- inferred equivalent call
		}),
		ReportProblemFrame = 0,
		ReportSurfaceFrame = 0,
		ReportCommentFrame = 0
	}

	local createElement4 = React.createElement
	local v6 = {
		ZIndex = 3,
		tag = "size-full-0 auto-y col align-x-left",
		LayoutOrder = nextOrder()
	}
	local v7 = {
		ProblemHeading = React.createElement(Text, {
			Text = "1. " .. v3.submitDialogProblemSubheading,
			fontStyle = v.Typography.TitleLarge,
			textStyle = v.Color.Content.Emphasis,
			tag = "auto-xy padding-bottom-medium",
			LayoutOrder = nextOrder()
		}),
		ProblemDropdownPosition = 0
	}

	local createElement5 = React.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 0, 48),
		tag = "col align-x-left",
		LayoutOrder = nextOrder()
	}

	local createElement6 = React.createElement
	local v10 = {
		setDropdownError = setState,
		onActivated = function()
			setState8(true)
			setState10(false)
		end,
		title = v3.submitDialogProblemSubheading,
		text = 0,
		isDropdownError = 0
	}

	if state4 == "" or not state4 then
		state4 = v3.chooseOne
	end

	v10.text = state4
	v10.isDropdownError = state
	local children2 = {
		ProblemDropdown = createElement6(SideModalDropdownButton, v10),
		ProblemSubtext = 0
	}

	local createElement7 = React.createElement
	state5 = state and v3.selectOnePrompt or state5
	children2.ProblemSubtext = createElement7(Text, {
		Text = state5,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		fontStyle = v.Typography.BodySmall,
		textStyle = state and v.Color.System.Alert or v.Color.Content.Muted,
		tag = "auto-xy padding-top-xxsmall",
		LayoutOrder = nextOrder()
	})
	v7.ProblemDropdownPosition = createElement5(View, v9, children2)
	children.ReportProblemFrame = createElement4(View, v6, v7)

	local createElement8 = React.createElement
	local v11 = { tag = "size-full-0 auto-y col align-x-left", LayoutOrder = nextOrder() }
	local v12 = {
		SurfaceHeading = React.createElement(Text, {
			Text = "2. " .. v3.submitDialogSurfaceSubheading,
			fontStyle = v.Typography.TitleLarge,
			textStyle = v.Color.Content.Emphasis,
			tag = "auto-xy padding-bottom-medium",
			LayoutOrder = nextOrder()
		}),
		SurfaceDropdownPosition = 0
	}

	local createElement9 = React.createElement
	local v13 = {
		Size = UDim2.new(1, 0, 0, 48),
		tag = "col align-x-left",
		LayoutOrder = nextOrder()
	}

	local createElement10 = React.createElement
	local v14 = {
		setDropdownError = setState2,
		onActivated = function()
			setState9(true)
			setState10(false)
		end,
		title = v3.submitDialogSurfaceSubheading,
		text = 0,
		isDropdownError = 0
	}

	if state6 == "" or not state7 then
		state7 = v3.chooseOne
	end

	v14.text = state7
	v14.isDropdownError = state2
	v12.SurfaceDropdownPosition = createElement9(View, v13, {
		SurfaceDropdown = createElement10(SideModalDropdownButton, v14),
		SurfaceSubtext = React.createElement(Text, {
			Text = state2 and v3.selectOnePrompt or "",
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			fontStyle = v.Typography.BodySmall,
			textStyle = v.Color.System.Alert,
			tag = "auto-xy padding-top-xxsmall",
			LayoutOrder = nextOrder()
		})
	})
	children.ReportSurfaceFrame = createElement8(View, v11, v12)

	children.ReportCommentFrame = React.createElement(
		View,
		{ tag = "size-full-0 auto-y col align-x-left", LayoutOrder = nextOrder() },
		{
			CommentHeading = React.createElement(Text, {
				Text = "3. " .. v3.submitDialogCommentSubheading,
				fontStyle = v.Typography.TitleLarge,
				textStyle = v.Color.Content.Emphasis,
				tag = "auto-xy padding-bottom-medium",
				LayoutOrder = nextOrder()
			}),
			CommentTextContainer = React.createElement(
				View,
				{
					tag = "size-full-0 auto-y col align-x-left stroke-thick stroke-default radius-medium",
					LayoutOrder = nextOrder()
				},
				{
					CommentTextField = React.createElement(CommentTextField, {
						text = state11,
						backgroundColor3 = v.Color.Surface.Surface_100.Color3,
						placeholderText = v3.submitDialogTextBoxPlaceholder,
						onUpdate = setState11,
						layoutOrder = nextOrder()
					})
				}
			),
			CommentSubtext = React.createElement(Text, {
				Text = v3.submitDialogOptional,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				fontStyle = v.Typography.CaptionSmall,
				tag = "auto-xy padding-top-xxsmall",
				LayoutOrder = nextOrder()
			})
		}
	)
	local v8 = {
		ReportFlowModal = createElement2(SideModal, v4, {
			SubmitReportFrame = createElement3(ScrollViewGradient, v5, children)
		}),
		DropdownSideModalBackground = 0
	}
	local dropdownSideModalBackground

	if state8 or state9 then
		local createElement11 = React.createElement

		local createElement12 = React.createElement

		local createElement13 = React.createElement
		local title

		if state8 then
			title = v3.submitDialogProblemSubheading
		else
			title = v3.submitDialogSurfaceSubheading
		end

		local v15 = {
			screenSize = absoluteSize,
			title = title,
			width = math.min(400, absoluteSize.X - 50) - 50,
			height = math.min(500, absoluteSize.Y - 50) - 50,
			onAbandon = onAbandon,
			closeWithAnimation = state10
		}

		local createElement14 = React.createElement
		local v16 = { Size = UDim2.new(1, 0, 1, 0), gradientHeight = 48 }

		local v17 = {
			Padding = React.createElement("UIPadding", { PaddingRight = UDim.new(0, 16) }),
			ButtonList = 0
		}

		local createElement15 = React.createElement
		local options

		if state8 then
			options = props.reportProblems
		else
			options = props.reportSurfaces
		end

		local v18 = {
			options = options,
			onSelected = function(p: string, p2: string)
				if state8 then
					setState3(p)
					setState4(p2)
					setState(false)
				else
					setState6(p)
					setState7(p2)
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

		v18.setDescription = setState5
		local defaultValue = if state8 then state3 else state6
		v18.defaultValue = defaultValue
		v17.ButtonList = createElement15(ButtonList, v18)
		dropdownSideModalBackground = createElement11(View, { tag = "size-full" }, {
			DropdownSideModalContainer = createElement12(View, { tag = "size-full" }, {
				DropdownSideModal = createElement13(SideModal, v15, {
					ScrollView = createElement14(ScrollViewGradient, v16, v17)
				})
			})
		})
	end

	v8.DropdownSideModalBackground = dropdownSideModalBackground
	return createElement(View, { tag = "size-full auto-xy" }, v8)
end

return DualDropdownSubmitDialog
