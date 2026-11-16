local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local DsaIllegalContentReporting = require(parent.DsaIllegalContentReporting)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local SharedFlags = require(parent.SharedFlags)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useLocalizedStrings = require(GenericAbuseReporting.LocalizationKeys.useLocalizedStrings)
local CommentTextField = require(GenericAbuseReporting.Common.CommentTextField)
local Frame = require(GenericAbuseReporting.Common.Frame)
local UIListLayout = require(GenericAbuseReporting.Common.UIListLayout)
local ReasonDropdown = require(GenericAbuseReporting.Common.ReasonDropdown)
local MODAL_POSITION_OFFSET = require(GenericAbuseReporting.Common.MODAL_POSITION_OFFSET)

local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local CloseButtonIcon = UIBlox.App.Dialog.Enum.CloseButtonIcon
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local Text = Foundation.Text

local GenericReportLink = DsaIllegalContentReporting.GenericReportLink
local showGenericIllegalContentReportingLink = DsaIllegalContentReporting.isShowGenericIllegalContentReportingLink()
local TakeItDownReportLink = DsaIllegalContentReporting.TakeItDownReportLink
local getTakeItDownReportLinkVisibility = DsaIllegalContentReporting.getTakeItDownReportLinkVisibility

local useAnalyticsDispatch = require(GenericAbuseReporting.Analytics.useAnalyticsDispatch)
local OnFormCommentUpdated = require(GenericAbuseReporting.Analytics.Actions.OnFormCommentUpdated)
local OnFormReasonSelected = require(GenericAbuseReporting.Analytics.Actions.OnFormReasonSelected)

local ReactUtils = require(parent.ReactUtils)
local createNextOrder = ReactUtils.createNextOrder
local FFlagAddAbuseReportOffsetForLandscape = SharedFlags.FFlagAddAbuseReportOffsetForLandscape
local FFlagAddTakeItDownReportLinkToSurfaces = SharedFlags.FFlagAddTakeItDownReportLinkToSurfaces

local function getScreenSizeOffset(absoluteSize: Vector2): number -- 1 equivalent call inferred from this helper
	if not FFlagAddAbuseReportOffsetForLandscape then
		return 100
	end

	return if absoluteSize.X > absoluteSize.Y then 180 else 100
end

local function getContentRightPadding(state: Vector2, state2: Vector2): number -- 1 equivalent call inferred from this helper
	return if state.Y > state2.Y then 16 else 1
end

local function SubmitDialog(props)
	local v = useAnalyticsDispatch()
	local v2 = ReactFocusNavigation.useFocusGuiObject()
	local v3 = FocusNavigationUtils.useLastInputMode()
	local v4 = useTokens()
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

	local v5 = useLayerCollector()
	local absoluteSize = v5.absoluteSize

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

	local onActivated = React.useCallback(function()
		if state2 ~= "" then
			props.onSubmit(state2, state4)
		elseif props.reportCategoryDefaultKey == nil then
			setState(true)
		else
			props.onSubmit(props.reportCategoryDefaultKey, state4)
		end
	end, { props.onSubmit, state2, state4, setState })

	local onSelectedAbuseType = React.useCallback(function(reason_selection)
		setState2(reason_selection)
		v(OnFormReasonSelected({ reason_selection = reason_selection }))

		if v3 == "Focus" and ref2.current then
			local spawnButton = ref2.current:FindFirstChild("SpawnButton", true)

			if spawnButton and spawnButton:IsA("GuiObject") then
				v2(spawnButton)
			end
		end
	end, { v, v2, v3 })

	local onUpdate = React.useCallback(function(list: string)
		setState4(list)
		v(OnFormCommentUpdated({
			comment_added = #list > 0
		}))
	end, { v })
	local v6

	if props.localizationKeys then
		v6 = useLocalization(props.localizationKeys)
	else
		v6 = useLocalizedStrings()
	end

	local v7 = useLocalization({
		submitDialogReasonSubheading = "Feature.ReportAbuse.Label.WhatWasWrong",
		selectOnePrompt = "Feature.ReportAbuse.Label.PleaseSelectOne",
		submitDialogCommentSubheading = "Feature.ReportAbuse.Label.TellUsWhatHappened",
		submitDialogTextBoxPlaceholder = "Feature.SettingsHub.Label.ReportComment",
		defaultKey = props.reportCategories[1].localizationKey
	})

	local nextOrder = createNextOrder()

	local reportReasonPrompt = React.createElement(ReasonDropdown, {
		options = props.reportCategories,
		screenSize = absoluteSize,
		maxHeight = state11,
		menuItemHeight = 48,
		isDropdownError = state,
		setDropdownError = setState,
		onSelectedAbuseType = onSelectedAbuseType,
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
			Padding = React.createElement("UIPadding", { PaddingBottom = UDim.new(0, 15) }),
			TextFrame = React.createElement(
				View,
				{
					Size = UDim2.new(1, 0, 0, 48),
					tag = "radius-medium stroke-standard stroke-system-neutral padding-left-small"
				},
				{
					Text = React.createElement(Text, {
						Text = v7.defaultKey,
						TextXAlignment = Enum.TextXAlignment.Left,
						tag = "size-full content-muted"
					})
				}
			)
		}
	)

	local v8 = React.useMemo(function()
		return function()
			local createElement = React.createElement
			local genericReportingLink

			if showGenericIllegalContentReportingLink then
				genericReportingLink = React.createElement(GenericReportLink, { layoutOrder = 2 })
			end

			return createElement(View, {
				tag = "size-full-0 auto-y col padding-x-xlarge padding-top-small"
			}, {
				GenericReportingLink = genericReportingLink
			})
		end
	end, {})
	local v9

	if FFlagAddTakeItDownReportLinkToSurfaces then
		v9 = React.useMemo(function()
			return function()
				local createElement = React.createElement
				local genericReportLink

				if showGenericIllegalContentReportingLink then
					genericReportLink = React.createElement(GenericReportLink)
				end

				local takeItDownReportLink

				if getTakeItDownReportLinkVisibility() then
					takeItDownReportLink = React.createElement(TakeItDownReportLink, {
						layoutOrder = 2
					})
				end

				return createElement(
					View,
					{ tag = "col gap-medium size-full-0 auto-y padding-x-xlarge padding-top-small" },
					{
						GenericReportLink = genericReportLink,
						TakeItDownReportLink = takeItDownReportLink
					}
				)
			end
		end, {})
	end

	local v10 = FFlagAddTakeItDownReportLinkToSurfaces
		and (showGenericIllegalContentReportingLink or getTakeItDownReportLinkVisibility())

	local createElement = React.createElement
	local v11 = {
		screenSize = Vector2.new(
			absoluteSize.X * (props.scaleDialog and props.scaleDialog.X or 1),
			(absoluteSize.Y - v5.insets.top) * (props.scaleDialog and props.scaleDialog.Y or 1)
		),
		position = UDim2.new(0.5, 0, 0, v5.insets.top + MODAL_POSITION_OFFSET),
		anchorPoint = Vector2.new(0.5, 0),
		title = v6.formTitle,
		onCloseClicked = props.onAbandon,
		buttonStackProps = {
			buttons = {
				{
					buttonType = ButtonType.PrimaryContextual,
					props = { onActivated = onActivated, text = v6.formSubmit }
				}
			}
		},
		footerContent = 0,
		closeButtonIcon = 0
	}
	local footerContent

	if FFlagAddTakeItDownReportLinkToSurfaces then
		footerContent = props.footerContent or v10 and v9 or nil
	else
		footerContent = props.footerContent or showGenericIllegalContentReportingLink and v8 or nil
	end

	v11.footerContent = footerContent
	local closeButtonIcon

	if props.useBackButton then
		closeButtonIcon = CloseButtonIcon.Back
	end

	v11.closeButtonIcon = closeButtonIcon

	local createElement2 = React.createElement
	local v12 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0)
	}

	local createElement3 = React.createElement
	local v13 = {
		Size = UDim2.new(
			1,
			0,
			0,
			(math.min(
				absoluteSize.Y - v5.insets.top - getScreenSizeOffset(absoluteSize) - (props.footerContent == nil and showGenericIllegalContentReportingLink and 25 or 0), -- inferred equivalent call
				state10 + 50 + 50
			))
		),
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromOffset(0, 0),
			scrollBarVisibility = ScrollBarVisibility.Always,
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
			PaddingRight = UDim.new(0, getContentRightPadding(state5, state6)) -- inferred equivalent call
		}),
		TopCustomComponent = props.topCustomComponent,
		ReportReasonFrame = 0,
		ReportCommentFrame = 0
	}
	local createElement4 = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 2,
		LayoutOrder = nextOrder()
	}
	local v15 = {
		Layout = React.createElement(UIListLayout, {
			Padding = UDim.new(0, 14),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		}),
		ReportReasonSubheading = React.createElement(StyledTextLabel, {
			text = "1. " .. v7.submitDialogReasonSubheading,
			fontStyle = v4.Typography.TitleLarge,
			colorStyle = v4.Color.Content.Default,
			layoutOrder = nextOrder(),
			automaticSize = Enum.AutomaticSize.XY
		}),
		DropdownPosition = 0,
		ReportReasonSubtext = 0,
		Padding = 0
	}

	local createElement5 = React.createElement
	local v16 = {
		AutomaticSize = Enum.AutomaticSize.None,
		Size = UDim2.new(1, 0, 0, 48),
		ZIndex = 2,
		LayoutOrder = nextOrder(),
		ref = ref2
	}

	if props.isReportCategoryReadonly then
		reportReasonPrompt = element
	end

	v15.DropdownPosition = createElement5(Frame, v16, { ReportReasonPrompt = reportReasonPrompt })
	local reportReasonSubtext

	if state then
		reportReasonSubtext = React.createElement(StyledTextLabel, {
			text = v7.selectOnePrompt,
			fontStyle = v4.Typography.BodySmall,
			colorStyle = v4.Color.System.Alert,
			layoutOrder = nextOrder(),
			automaticSize = Enum.AutomaticSize.XY
		})
	elseif state3 ~= "" then
		reportReasonSubtext = React.createElement(StyledTextLabel, {
			text = state3,
			fontStyle = v4.Typography.BodySmall,
			colorStyle = v4.Color.Content.Default,
			layoutOrder = nextOrder(),
			automaticSize = Enum.AutomaticSize.XY
		})
	end

	v15.ReportReasonSubtext = reportReasonSubtext
	local padding

	if not (state3 == "" and not state) then
		padding = React.createElement("UIPadding", { PaddingBottom = UDim.new(0, 10) })
	end

	v15.Padding = padding
	children.ReportReasonFrame = createElement4(Frame, v14, v15)

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
			Padding = React.createElement("UIPadding", { PaddingBottom = UDim.new(0, 15) }),
			ReportCommentSubheading = React.createElement(StyledTextLabel, {
				text = "2. " .. v7.submitDialogCommentSubheading,
				fontStyle = v4.Typography.TitleLarge,
				colorStyle = v4.Color.Content.Default,
				layoutOrder = nextOrder(),
				automaticSize = Enum.AutomaticSize.XY
			}),
			CommentTextField = React.createElement(CommentTextField, {
				layoutOrder = nextOrder(),
				text = state4,
				placeholderText = v7.submitDialogTextBoxPlaceholder,
				onUpdate = onUpdate
			})
		}
	)
	return createElement(PartialPageModal, v11, {
		SubmitContainer = createElement2("Frame", v12, {
			SubmitReportFrame = createElement3(ScrollView, v13, children)
		})
	})
end

return SubmitDialog
