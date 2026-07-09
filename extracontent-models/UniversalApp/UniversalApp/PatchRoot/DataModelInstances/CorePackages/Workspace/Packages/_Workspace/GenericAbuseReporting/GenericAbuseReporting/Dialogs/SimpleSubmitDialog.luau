local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local DsaIllegalContentReporting = require(GenericAbuseReportingParent.DsaIllegalContentReporting)
local FocusNavigationUtils = require(GenericAbuseReportingParent.FocusNavigationUtils)
local React = require(GenericAbuseReportingParent.React)
local ReactFocusNavigation = require(GenericAbuseReportingParent.ReactFocusNavigation)
local SharedFlags = require(GenericAbuseReportingParent.SharedFlags)
local UIBlox = require(GenericAbuseReportingParent.UIBlox)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local useLocalization = require(GenericAbuseReportingParent.Localization).Hooks.useLocalization
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
local FoundationText = Foundation.Text
local GenericReportLink = DsaIllegalContentReporting.GenericReportLink
local v28 = DsaIllegalContentReporting.isShowGenericIllegalContentReportingLink()
local TakeItDownReportLink = DsaIllegalContentReporting.TakeItDownReportLink
local getTakeItDownReportLinkVisibility = DsaIllegalContentReporting.getTakeItDownReportLinkVisibility
local useAnalyticsDispatch = require(GenericAbuseReporting.Analytics.useAnalyticsDispatch)
local OnFormCommentUpdated = require(GenericAbuseReporting.Analytics.Actions.OnFormCommentUpdated)
local OnFormReasonSelected = require(GenericAbuseReporting.Analytics.Actions.OnFormReasonSelected)
local createNextOrder = require(GenericAbuseReportingParent.ReactUtils).createNextOrder
local FFlagChatLineReportingFocusFixesEnabled = SharedFlags.FFlagChatLineReportingFocusFixesEnabled
local FFlagAddAbuseReportOffsetForLandscape = SharedFlags.FFlagAddAbuseReportOffsetForLandscape
local FFlagAddTakeItDownReportLinkToSurfaces = SharedFlags.FFlagAddTakeItDownReportLinkToSurfaces

local function getScreenSizeOffset(vector2: Vector2) -- line: 72
	-- upvalues: FFlagAddAbuseReportOffsetForLandscape (copy)
	if FFlagAddAbuseReportOffsetForLandscape then
		if vector2.X > vector2.Y then
			return 180
		end

		return 100
	end

	return 100
end
local function getContentRightPadding(vector2: Vector2, vector2_2: Vector2) -- line: 81
	if vector2.Y > vector2_2.Y then
		return 16
	end

	return 1
end
local function SubmitDialog(t1: {[any]: any}) -- line: 85
	-- upvalues: useAnalyticsDispatch (copy), ReactFocusNavigation (copy), FocusNavigationUtils (copy), useTokens (copy), React (copy), useLayerCollector (copy), FFlagChatLineReportingFocusFixesEnabled (copy), OnFormReasonSelected (copy), OnFormCommentUpdated (copy), useLocalization (copy), useLocalizedStrings (copy), createNextOrder (copy), ReasonDropdown (copy), UIListLayout (copy), View (copy), FoundationText (copy), v28 (copy), GenericReportLink (copy), FFlagAddTakeItDownReportLinkToSurfaces (copy), getTakeItDownReportLinkVisibility (copy), TakeItDownReportLink (copy), PartialPageModal (copy), MODAL_POSITION_OFFSET (copy), ButtonType (copy), CloseButtonIcon (copy), ScrollView (copy), FFlagAddAbuseReportOffsetForLandscape (copy), ScrollBarVisibility (copy), Frame (copy), StyledTextLabel (copy), CommentTextField (copy)
	local v45 = useAnalyticsDispatch()
	local v46 = ReactFocusNavigation.useFocusGuiObject()
	local v47 = FocusNavigationUtils.useLastInputMode()
	local v48 = useTokens()
	local v49, v50 = React.useState(false)
	local v51, v52 = React.useState("")
	local v53, v54 = React.useState("")
	local v55, v56 = React.useState("")
	local v57 = React.useRef(nil)
	local v58, v59 = React.useState(Vector2.zero)
	local v60, v61 = React.useState(Vector2.zero)
	local v62, v63 = React.useState(0)
	local v64, v65 = React.useState(0)
	local v66 = React.useRef(nil)
	local v67, v68 = React.useState(0)
	local v69 = React.useRef(nil)
	local v70, v71 = React.useState(0)
	local v72, v73 = React.useState(96)
	local v74 = useLayerCollector()
	local absoluteSize = v74.absoluteSize

	React.useEffect(function() -- line: 108
		-- upvalues: v73 (copy), v58 (copy), v67 (copy), v64 (copy), v62 (copy)
		v73((math.max(96, v58.Y - (v67 - v64) - v62 - 20)))
	end, {
		v58.Y,
		v67,
		v64,
		v62
	})
	React.useEffect(function() -- line: 117
		-- upvalues: v66 (copy), v63 (copy), v68 (copy)
		if v66.current then
			v63(v66.current.AbsoluteSize.Y)
			v68(v66.current.AbsolutePosition.Y)
		end
	end, {
		v66.current,
		absoluteSize
	})
	React.useEffect(function() -- line: 124
		-- upvalues: v57 (copy), v61 (copy), v59 (copy), FFlagChatLineReportingFocusFixesEnabled (copy), v65 (copy)
		if v57.current then
			local ScrollingFrame = v57.current:FindFirstChildWhichIsA("ScrollingFrame")

			if ScrollingFrame then
				ScrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 128
					-- upvalues: v61 (copy), ScrollingFrame (copy), v59 (copy)
					v61(ScrollingFrame.AbsoluteWindowSize)
					v59(ScrollingFrame.AbsoluteCanvasSize)
				end)

				if FFlagChatLineReportingFocusFixesEnabled then
					ScrollingFrame.Selectable = false
				end
			end

			v65(v57.current.AbsolutePosition.Y)

			return
		end

		v59(Vector2.zero)
	end, {
		v57.current,
		absoluteSize
	})
	React.useEffect(function() -- line: 142
		-- upvalues: v69 (copy), v71 (copy)
		if v69.current then
			v71(v69.current.AbsoluteContentSize.Y)
		end
	end, { v69.current })

	local v76 = React.useCallback(function() -- line: 148
		-- upvalues: v51 (copy), t1 (copy), v55 (copy), v50 (copy)
		if v51 ~= "" then
			t1.onSubmit(v51, v55)

			return
		end

		if t1.reportCategoryDefaultKey ~= nil then
			t1.onSubmit(t1.reportCategoryDefaultKey, v55)

			return
		end

		v50(true)
	end, {
		t1.onSubmit,
		v51,
		v55,
		v50
	})
	local v77 = React.useCallback(function(p1) -- line: 161
		-- upvalues: v52 (copy), v45 (copy), OnFormReasonSelected (copy), FFlagChatLineReportingFocusFixesEnabled (copy), v47 (copy), v66 (copy), v46 (copy)
		v52(p1)
		v45(OnFormReasonSelected({
			reason_selection = p1
		}))

		if FFlagChatLineReportingFocusFixesEnabled and (v47 == "Focus" and v66.current) then
			local SpawnButton = v66.current:FindFirstChild("SpawnButton", true)

			if SpawnButton and SpawnButton:IsA("GuiObject") then
				v46(SpawnButton)
			end
		end
	end, if not FFlagChatLineReportingFocusFixesEnabled then { v45 } else {
		v45,
		v46,
		v47
	})
	local v78 = React.useCallback(function(s1: string) -- line: 183
		-- upvalues: v56 (copy), v45 (copy), OnFormCommentUpdated (copy)
		v56(s1)
		v45(OnFormCommentUpdated({
			comment_added = #s1 > 0
		}))
	end, { v45 })
	local v79 = if not t1.localizationKeys then useLocalizedStrings() else useLocalization(t1.localizationKeys)
	local v80 = useLocalization({
		submitDialogReasonSubheading = "Feature.ReportAbuse.Label.WhatWasWrong",
		selectOnePrompt = "Feature.ReportAbuse.Label.PleaseSelectOne",
		submitDialogCommentSubheading = "Feature.ReportAbuse.Label.TellUsWhatHappened",
		submitDialogTextBoxPlaceholder = "Feature.SettingsHub.Label.ReportComment",
		defaultKey = t1.reportCategories[1].localizationKey
	})
	local v81 = createNextOrder()
	local v82 = React.createElement(ReasonDropdown, {
		menuItemHeight = 48,
		options = t1.reportCategories,
		screenSize = absoluteSize,
		maxHeight = v72,
		isDropdownError = v49,
		setDropdownError = v50,
		onSelectedAbuseType = v77,
		reportCategoryDefaultKey = t1.reportCategoryDefaultKey,
		setDescription = v54,
		isDisabled = t1.isDisabled
	})
	local v83 = React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = v81()
	}, {
		Layout = React.createElement(UIListLayout, {
			Padding = UDim.new(0, 7),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left
		}),
		Padding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 15)
		}),
		TextFrame = React.createElement(View, {
			tag = "radius-medium stroke-standard stroke-system-neutral padding-left-small",
			Size = UDim2.new(1, 0, 0, 48)
		}, {
			Text = React.createElement(FoundationText, {
				tag = "size-full content-muted",
				Text = v80.defaultKey,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		})
	})
	local v84 = React.useMemo(function() -- line: 244
		-- upvalues: React (copy), View (copy), v28 (copy), GenericReportLink (copy)
		return function() -- line: 245
			-- upvalues: React (copy), View (copy), v28 (copy), GenericReportLink (copy)
			return React.createElement(View, {
				tag = "size-full-0 auto-y col padding-x-xlarge padding-top-small"
			}, {
				GenericReportingLink = if not v28 then nil else React.createElement(GenericReportLink, {
					layoutOrder = 2
				})
			})
		end
	end, {})
	local v85 = nil

	if FFlagAddTakeItDownReportLinkToSurfaces then
		v85 = React.useMemo(function() -- line: 260
			-- upvalues: React (copy), View (copy), v28 (copy), GenericReportLink (copy), getTakeItDownReportLinkVisibility (copy), TakeItDownReportLink (copy)
			return function() -- line: 261
				-- upvalues: React (copy), View (copy), v28 (copy), GenericReportLink (copy), getTakeItDownReportLinkVisibility (copy), TakeItDownReportLink (copy)
				return React.createElement(View, {
					tag = "col gap-medium size-full-0 auto-y padding-x-xlarge padding-top-small"
				}, {
					GenericReportLink = if not v28 then nil else React.createElement(GenericReportLink),
					TakeItDownReportLink = if not getTakeItDownReportLinkVisibility() then nil else React.createElement(TakeItDownReportLink, {
						layoutOrder = 2
					})
				})
			end
		end, {})
	end

	local v86 = FFlagAddTakeItDownReportLinkToSurfaces and (v28 or getTakeItDownReportLinkVisibility())

	return React.createElement(PartialPageModal, {
		screenSize = Vector2.new(absoluteSize.X * (t1.scaleDialog and t1.scaleDialog.X or 1), (absoluteSize.Y - v74.insets.top) * (t1.scaleDialog and t1.scaleDialog.Y or 1)),
		position = UDim2.new(0.5, 0, 0, v74.insets.top + MODAL_POSITION_OFFSET),
		anchorPoint = Vector2.new(0.5, 0),
		title = v79.formTitle,
		onCloseClicked = t1.onAbandon,
		buttonStackProps = {
			buttons = {{
				buttonType = ButtonType.PrimaryContextual,
				props = {
					onActivated = v76,
					text = v79.formSubmit
				}
			}}
		},
		footerContent = if not FFlagAddTakeItDownReportLinkToSurfaces then t1.footerContent or (v28 and v84 or nil) else t1.footerContent or (v86 and v85 or nil),
		closeButtonIcon = if not t1.useBackButton then nil else CloseButtonIcon.Back
	}, {
		SubmitContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			SubmitReportFrame = React.createElement(ScrollView, {
				Size = UDim2.new(1, 0, 0, (math.min(absoluteSize.Y - v74.insets.top - (not FFlagAddAbuseReportOffsetForLandscape and 100 or (not (absoluteSize.X > absoluteSize.Y) and 100 or 180)) - ((t1.footerContent ~= nil or not v28) and 0 or 25), v70 + 50 + 50))),
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.fromOffset(0, 0),
					scrollBarVisibility = ScrollBarVisibility.Always,
					ScrollingDirection = Enum.ScrollingDirection.Y
				},
				ref = v57
			}, {
				Layout = React.createElement(UIListLayout, {
					Padding = UDim.new(0, 16),
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Ref = v69
				}),
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 16),
					PaddingBottom = UDim.new(0, 16),
					PaddingLeft = UDim.new(0, 1),
					PaddingRight = UDim.new(0, not (v58.Y > v60.Y) and 1 or 16)
				}),
				TopCustomComponent = t1.topCustomComponent,
				ReportReasonFrame = React.createElement(Frame, {
					ZIndex = 2,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = v81()
				}, {
					Layout = React.createElement(UIListLayout, {
						Padding = UDim.new(0, 14),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left
					}),
					ReportReasonSubheading = React.createElement(StyledTextLabel, {
						text = "1. " .. v80.submitDialogReasonSubheading,
						fontStyle = v48.Typography.TitleLarge,
						colorStyle = v48.Color.Content.Default,
						layoutOrder = v81(),
						automaticSize = Enum.AutomaticSize.XY
					}),
					DropdownPosition = React.createElement(Frame, {
						ZIndex = 2,
						AutomaticSize = Enum.AutomaticSize.None,
						Size = UDim2.new(1, 0, 0, 48),
						LayoutOrder = v81(),
						ref = v66
					}, {
						ReportReasonPrompt = if not t1.isReportCategoryReadonly then v82 else v83
					}),
					ReportReasonSubtext = if not v49 then if v53 == "" then nil else React.createElement(StyledTextLabel, {
						text = v53,
						fontStyle = v48.Typography.BodySmall,
						colorStyle = v48.Color.Content.Default,
						layoutOrder = v81(),
						automaticSize = Enum.AutomaticSize.XY
					}) else React.createElement(StyledTextLabel, {
						text = v80.selectOnePrompt,
						fontStyle = v48.Typography.BodySmall,
						colorStyle = v48.Color.System.Alert,
						layoutOrder = v81(),
						automaticSize = Enum.AutomaticSize.XY
					}),
					Padding = if v53 == "" and not v49 then nil else React.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 10)
					})
				}),
				ReportCommentFrame = React.createElement(Frame, {
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = v81()
				}, {
					Layout = React.createElement(UIListLayout, {
						Padding = UDim.new(0, 14),
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left
					}),
					Padding = React.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 15)
					}),
					ReportCommentSubheading = React.createElement(StyledTextLabel, {
						text = "2. " .. v80.submitDialogCommentSubheading,
						fontStyle = v48.Typography.TitleLarge,
						colorStyle = v48.Color.Content.Default,
						layoutOrder = v81(),
						automaticSize = Enum.AutomaticSize.XY
					}),
					CommentTextField = React.createElement(CommentTextField, {
						layoutOrder = v81(),
						text = v55,
						placeholderText = v80.submitDialogTextBoxPlaceholder,
						onUpdate = v78
					})
				})
			})
		})
	})
end

return SubmitDialog
