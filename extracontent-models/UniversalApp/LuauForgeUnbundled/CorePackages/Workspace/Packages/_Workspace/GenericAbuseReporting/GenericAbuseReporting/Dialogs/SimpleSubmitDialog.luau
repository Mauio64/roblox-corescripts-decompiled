local DsaIllegalContentReporting = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/DsaIllegalContentReporting")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/FocusNavigationUtils")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ReactFocusNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/SharedFlags")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Localization").Hooks.useLocalization
local useLocalizedStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/LocalizationKeys/useLocalizedStrings")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/CommentTextField")
local Frame = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/Frame")
local UIListLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/UIListLayout")
local ReasonDropdown = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/ReasonDropdown")
local MODAL_POSITION_OFFSET = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Common/MODAL_POSITION_OFFSET")

local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local closeButtonIcon = UIBlox.App.Dialog.Enum.CloseButtonIcon
local buttonType = UIBlox.App.Button.Enum.ButtonType
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local scrollView = Foundation.ScrollView
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local text = Foundation.Text

local genericReportLink = DsaIllegalContentReporting.GenericReportLink
local showGenericIllegalContentReportingLink = DsaIllegalContentReporting.isShowGenericIllegalContentReportingLink()
local takeItDownReportLink = DsaIllegalContentReporting.TakeItDownReportLink
local getTakeItDownReportLinkVisibility = DsaIllegalContentReporting.getTakeItDownReportLinkVisibility

local useAnalyticsDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/useAnalyticsDispatch")
local OnFormCommentUpdated = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/Actions/OnFormCommentUpdated")
local OnFormReasonSelected = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Analytics/Actions/OnFormReasonSelected")

local createNextOrder = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ReactUtils").createNextOrder
local fFlagAddAbuseReportOffsetForLandscape = SharedFlags.FFlagAddAbuseReportOffsetForLandscape
local fFlagAddTakeItDownReportLinkToSurfaces = SharedFlags.FFlagAddTakeItDownReportLinkToSurfaces

local function getScreenSizeOffset(p2): number
	if not fFlagAddAbuseReportOffsetForLandscape then
		return 100
	end

	if p2.X > p2.Y then
		return 180
	end

	return 100
end

local function getContentRightPadding(p2, p3): number
	if p2.Y > p3.Y then
		return 16
	end

	return 1
end

local function SubmitDialog(props)
	local v5 = useAnalyticsDispatch()
	local v6 = ReactFocusNavigation.useFocusGuiObject()
	local v7 = FocusNavigationUtils.useLastInputMode()
	local v8 = useTokens()
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState("")
	local state3, setState3 = React.useState("")
	local state4, setState4 = React.useState("")
	local ref = React.useRef(nil)
	local state5, setState5 = React.useState(Vector2.zero)
	local state6, setState6 = React.useState(Vector2.zero)
	local state7, setState7 = React.useState(0)
	local state8, setState8 = React.useState(0)
	local ref2 = React.useRef(nil)
	local state9, setState9 = React.useState(0)
	local ref3 = React.useRef(nil)
	local state10, setState10 = React.useState(0)
	local state11, setState11 = React.useState(96)

	local v9 = useLayerCollector()
	local absoluteSize = v9.absoluteSize

	React.useEffect(function()
		setState11((math.max(96, state5.Y - (state9 - state8) - state7 - 20)))
	end, { state5.Y, state9, state8, state7 })

	React.useEffect(function()
		if ref2.current then
			setState7(ref2.current.AbsoluteSize.Y)
			setState9(ref2.current.AbsolutePosition.Y)
		end
	end, { ref2.current, absoluteSize })

	React.useEffect(function()
		if not ref.current then
			setState5(Vector2.zero)

			return
		end

		local scrollingFrame = ref.current:FindFirstChildWhichIsA("ScrollingFrame")

		if scrollingFrame then
			scrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
				setState6(scrollingFrame.AbsoluteWindowSize)
				setState5(scrollingFrame.AbsoluteCanvasSize)
			end)
			scrollingFrame.Selectable = false
		end

		setState8(ref.current.AbsolutePosition.Y)
	end, { ref.current, absoluteSize })

	React.useEffect(function()
		if ref3.current then
			setState10(ref3.current.AbsoluteContentSize.Y)
		end
	end, { ref3.current })

	local v10 = React.useCallback(function()
		if state2 ~= "" then
			props.onSubmit(state2, state4)
		elseif props.reportCategoryDefaultKey == nil then
			setState(true)
		else
			props.onSubmit(props.reportCategoryDefaultKey, state4)
		end
	end, { props.onSubmit, state2, state4, setState })

	local v11 = React.useCallback(function(p2)
		setState2(p2)
		v5(OnFormReasonSelected({ reason_selection = p2 }))

		if v7 == "Focus" and ref2.current then
			local spawnButton = ref2.current:FindFirstChild("SpawnButton", true)

			if spawnButton and spawnButton:IsA("GuiObject") then
				v6(spawnButton)
			end
		end
	end, { v5, v6, v7 })

	local v12 = React.useCallback(function(list)
		setState4(list)
		v5(OnFormCommentUpdated({
			comment_added = #list > 0
		}))
	end, { v5 })

	local v13 = if props.localizationKeys then useLocalization(props.localizationKeys) else useLocalizedStrings()

	local v14 = useLocalization({
		submitDialogReasonSubheading = "Feature.ReportAbuse.Label.WhatWasWrong",
		selectOnePrompt = "Feature.ReportAbuse.Label.PleaseSelectOne",
		submitDialogCommentSubheading = "Feature.ReportAbuse.Label.TellUsWhatHappened",
		submitDialogTextBoxPlaceholder = "Feature.SettingsHub.Label.ReportComment",
		defaultKey = props.reportCategories[1].localizationKey
	})

	local nextOrder = createNextOrder()

	local v15 = React.createElement(ReasonDropdown, {
		options = props.reportCategories,
		screenSize = absoluteSize,
		maxHeight = state11,
		menuItemHeight = 48,
		isDropdownError = state,
		setDropdownError = setState,
		onSelectedAbuseType = v11,
		reportCategoryDefaultKey = props.reportCategoryDefaultKey,
		setDescription = setState3,
		isDisabled = props.isDisabled
	})

	local element = React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = nextOrder()
		},
		{
			Layout = React.createElement(UIListLayout, {
				Padding = UDim.new(0, 7),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			Padding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 15)
			}),
			TextFrame = React.createElement(
				view,
				{
					Size = UDim2.new(1, 0, 0, 48),
					tag = "radius-medium stroke-standard stroke-system-neutral padding-left-small"
				},
				{
					Text = React.createElement(text, {
						Text = v14.defaultKey,
						TextXAlignment = Enum.TextXAlignment.Left,
						tag = "size-full content-muted"
					})
				}
			)
		}
	)

	local v16 = React.useMemo(function()
		return function()
			local createElement = React.createElement

			local v20 = if showGenericIllegalContentReportingLink then React.createElement(genericReportLink, {
				layoutOrder = 2
			}) else nil
			return createElement(
				view,
				{ tag = "size-full-0 auto-y col padding-x-xlarge padding-top-small" },
				{ GenericReportingLink = v20 }
			)
		end
	end, {})
	local v17

	if fFlagAddTakeItDownReportLinkToSurfaces then
		v17 = React.useMemo(function()
			return function()
				local createElement = React.createElement

				local v21 = if showGenericIllegalContentReportingLink then React.createElement(genericReportLink) else nil

				local v22 = if getTakeItDownReportLinkVisibility() then React.createElement(takeItDownReportLink, {
					layoutOrder = 2
				}) else nil
				return createElement(
					view,
					{
						tag = "col gap-medium size-full-0 auto-y padding-x-xlarge padding-top-small"
					},
					{ GenericReportLink = v21, TakeItDownReportLink = v22 }
				)
			end
		end, {})
	end

	local v18 = fFlagAddTakeItDownReportLinkToSurfaces
		and (showGenericIllegalContentReportingLink or getTakeItDownReportLinkVisibility())

	local createElement = React.createElement
	local v20 = {
		screenSize = Vector2.new(
			absoluteSize.X * (props.scaleDialog and props.scaleDialog.X or 1),
			(absoluteSize.Y - v9.insets.top) * (props.scaleDialog and props.scaleDialog.Y or 1)
		),
		position = UDim2.new(0.5, 0, 0, v9.insets.top + MODAL_POSITION_OFFSET),
		anchorPoint = Vector2.new(0.5, 0),
		title = v13.formTitle,
		onCloseClicked = props.onAbandon,
		buttonStackProps = {
			buttons = {
				{
					buttonType = buttonType.PrimaryContextual,
					props = { onActivated = v10, text = v13.formSubmit }
				}
			}
		},
		footerContent = 0,
		closeButtonIcon = 0
	}

	local v21 = if fFlagAddTakeItDownReportLinkToSurfaces then props.footerContent or v18 and v17 or nil else props.footerContent or showGenericIllegalContentReportingLink and v16 or nil
	v20.footerContent = v21

	local v22 = if props.useBackButton then closeButtonIcon.Back else nil
	v20.closeButtonIcon = v22

	local createElement2 = React.createElement
	local v25 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0)
	}

	local createElement3 = React.createElement
	local v28 = {
		Size = UDim2.new(
			1,
			0,
			0,
			(math.min(
				absoluteSize.Y - v9.insets.top - (fFlagAddAbuseReportOffsetForLandscape and absoluteSize.X > absoluteSize.Y and 180 or 100) - (props.footerContent == nil and showGenericIllegalContentReportingLink and 25 or 0),
				state10 + 50 + 50
			))
		),
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromOffset(0, 0),
			scrollBarVisibility = scrollBarVisibility.Always,
			ScrollingDirection = Enum.ScrollingDirection.Y
		},
		ref = ref
	}
	local children = {
		Layout = React.createElement(UIListLayout, {
			Padding = UDim.new(0, 16),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Ref = ref3
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 16),
			PaddingBottom = UDim.new(0, 16),
			PaddingLeft = UDim.new(0, 1),
			PaddingRight = UDim.new(0, state5.Y > state6.Y and 16 or 1)
		}),
		TopCustomComponent = props.topCustomComponent,
		ReportReasonFrame = 0,
		ReportCommentFrame = 0
	}
	local createElement4 = React.createElement
	local v30 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 2,
		LayoutOrder = nextOrder()
	}
	local v31 = {
		Layout = React.createElement(UIListLayout, {
			Padding = UDim.new(0, 14),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		}),
		ReportReasonSubheading = React.createElement(styledTextLabel, {
			text = "1. " .. v14.submitDialogReasonSubheading,
			fontStyle = v8.Typography.TitleLarge,
			colorStyle = v8.Color.Content.Default,
			layoutOrder = nextOrder(),
			automaticSize = Enum.AutomaticSize.XY
		}),
		DropdownPosition = 0,
		ReportReasonSubtext = 0,
		Padding = 0
	}

	local createElement5 = React.createElement
	local v33 = {
		AutomaticSize = Enum.AutomaticSize.None,
		Size = UDim2.new(1, 0, 0, 48),
		ZIndex = 2,
		LayoutOrder = nextOrder(),
		ref = ref2
	}

	if props.isReportCategoryReadonly then
		v15 = element
	end

	v31.DropdownPosition = createElement5(Frame, v33, { ReportReasonPrompt = v15 })
	local v35

	if state then
		v35 = React.createElement(styledTextLabel, {
			text = v14.selectOnePrompt,
			fontStyle = v8.Typography.BodySmall,
			colorStyle = v8.Color.System.Alert,
			layoutOrder = nextOrder(),
			automaticSize = Enum.AutomaticSize.XY
		})
	elseif state3 ~= "" then
		v35 = React.createElement(styledTextLabel, {
			text = state3,
			fontStyle = v8.Typography.BodySmall,
			colorStyle = v8.Color.Content.Default,
			layoutOrder = nextOrder(),
			automaticSize = Enum.AutomaticSize.XY
		})
	end

	v31.ReportReasonSubtext = v35

	local v36 = if state3 ~= "" or not not state then React.createElement("UIPadding", {
		PaddingBottom = UDim.new(0, 10)
	}) else nil
	v31.Padding = v36
	children.ReportReasonFrame = createElement4(Frame, v30, v31)

	children.ReportCommentFrame = React.createElement(
		Frame,
		{
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = nextOrder()
		},
		{
			Layout = React.createElement(UIListLayout, {
				Padding = UDim.new(0, 14),
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			Padding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, 15)
			}),
			ReportCommentSubheading = React.createElement(styledTextLabel, {
				text = "2. " .. v14.submitDialogCommentSubheading,
				fontStyle = v8.Typography.TitleLarge,
				colorStyle = v8.Color.Content.Default,
				layoutOrder = nextOrder(),
				automaticSize = Enum.AutomaticSize.XY
			}),
			CommentTextField = React.createElement(module9, {
				layoutOrder = nextOrder(),
				text = state4,
				placeholderText = v14.submitDialogTextBoxPlaceholder,
				onUpdate = v12
			})
		}
	)
	return createElement(partialPageModal, v20, {
		SubmitContainer = createElement2("Frame", v25, {
			SubmitReportFrame = createElement3(scrollView, v28, children)
		})
	})
end

return SubmitDialog
