local CorePackages = game:GetService("CorePackages")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local SendFeedbackThunk = require(ParentParent.Thunks.SendFeedbackThunk)
local SetFeedbackFlowState = require(ParentParent.Actions.SetFeedbackFlowState)
local SetFeedbackReason = require(ParentParent.Actions.SetFeedbackReason)
local TextEntryField = require(ParentParent.Components.TextEntryField)
local ModalDialog = require(ParentParent.Components.ModalDialog)
local ThemedTextLabel = require(ParentParent.Components.PortedComponents.ThemedTextLabel)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local RadioButtonList = UIBlox.App.InputButton.RadioButtonList
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local withStyle = UIBlox.Core.Style.withStyle
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local GetFFlagEnableFeedbackReportDialogAdjustments = require(RobloxGui.Modules.Flags.GetFFlagEnableFeedbackReportDialogAdjustments)
local GetFFlagEnableSendImageFeedbackToBackend = require(RobloxGui.Modules.Flags.GetFFlagEnableSendImageFeedbackToBackend)
local v27 = game:DefineFastFlag("EnableFeedbackSelectionUpdate", false)
local FFlagTopBarSignalizeScreenSize = require(CorePackages.Workspace.Packages.CoreGuiCommon).Flags.FFlagTopBarSignalizeScreenSize
local v29 = Roact.PureComponent:extend("FeedbackReportDialog")

v29.validateProps = t.strictInterface({
	isReportDialogOpen = t.boolean,
	screenSize = if not FFlagTopBarSignalizeScreenSize then t.Vector2 else nil,
	closeDialog = t.optional(t.callback),
	reportCategory = t.optional(t.string)
})

function v29.init(p1) -- line: 68
	-- upvalues: v27 (copy), ExperienceStateCaptureService (copy), Constants (copy), GetFFlagEnableSendImageFeedbackToBackend (copy), FFlagTopBarSignalizeScreenSize (copy), Display (copy), Signals (copy)
	if v27 then
		p1.state = {
			feedbackText = "",
			feedbackOriginalText = "",
			feedbackIdentifier = "",
			correctTranslationText = "",
			additionalCommentsText = "",
			numFeedbackSubmissionAttempts = 0,
			isGenericSelection = false,
			shouldDisplayFeedbackImage = false,
			feedbackImageUri = ""
		}
	else
		p1.state = {
			feedbackText = "",
			feedbackOriginalText = "",
			feedbackIdentifier = "",
			correctTranslationText = "",
			additionalCommentsText = "",
			numFeedbackSubmissionAttempts = 0,
			shouldDisplayFeedbackImage = false,
			feedbackImageUri = ""
		}
	end

	function p1.calculateFieldHeight(n1: number, n2: number, n3: number) -- line: 95
		if n1 < 180 and n3 then
			return n2 * 5
		end

		return n2 * (n1 / 45 + 2)
	end
	function p1.resetLocalState() -- line: 104
		-- upvalues: v27 (copy), p1 (copy), ExperienceStateCaptureService (copy)
		if v27 then
			p1:setState({
				isGenericSelection = false
			})
		end

		p1:setState({
			shouldDisplayFeedbackImage = false,
			feedbackImageUri = "",
			correctTranslationText = "",
			additionalCommentsText = "",
			feedbackText = "",
			feedbackOriginalText = "",
			feedbackIdentifier = ""
		})
		p1.props.setFeedbackReason(0)
		ExperienceStateCaptureService:ResetHighlight()
	end
	function p1.setInstanceRelatedReportDialogState(p2) -- line: 125
		-- upvalues: p1 (copy), v27 (copy)
		if p2:IsA("TextBox") then
			p1:setState({
				feedbackText = if p2.PlaceholderText ~= "" then p2.PlaceholderText else p2.Text,
				feedbackOriginalText = p2.LocalizationMatchedSourceText,
				feedbackIdentifier = p2.LocalizationMatchIdentifier
			})

			if v27 then
				p1:setState({
					isGenericSelection = false
				})

				return
			end
		elseif p2:IsA("TextLabel") or p2:IsA("TextButton") then
			p1:setState({
				feedbackText = p2.Text,
				feedbackOriginalText = p2.LocalizationMatchedSourceText,
				feedbackIdentifier = p2.LocalizationMatchIdentifier
			})

			if v27 then
				p1:setState({
					isGenericSelection = false
				})

				return
			end
		else
			if p2:IsA("ImageLabel") or p2:IsA("ImageButton") then
				p1:setState({
					shouldDisplayFeedbackImage = true,
					feedbackImageUri = p2.Image
				})

				return
			end

			if p2:IsA("Decal") then
				p1:setState({
					shouldDisplayFeedbackImage = true,
					feedbackImageUri = p2.Texture
				})

				return
			end

			if p2:IsA("MeshPart") then
				if p2.TextureContent.SourceType == Enum.ContentSourceType.Uri then
					p1:setState({
						shouldDisplayFeedbackImage = true,
						feedbackImageUri = p2.TextureID
					})

					return
				end

				if p2.MeshContent.SourceType == Enum.ContentSourceType.Uri then
					p1:setState({
						shouldDisplayFeedbackImage = true,
						feedbackImageUri = p2.MeshId
					})

					return
				end

				local SurfaceAppearance = p2:FindFirstChildOfClass("SurfaceAppearance")

				if SurfaceAppearance and SurfaceAppearance.ColorMap then
					p1:setState({
						shouldDisplayFeedbackImage = true,
						feedbackImageUri = SurfaceAppearance.ColorMap
					})

					return
				end
			elseif v27 then
				p1:setState({
					feedbackIdentifier = "",
					isGenericSelection = true,
					feedbackText = p2.ClassName,
					feedbackOriginalText = p2.ClassName
				})
			end
		end
	end

	ExperienceStateCaptureService.ItemSelectedInCaptureMode:Connect(function(p3) -- line: 193
		-- upvalues: p1 (copy), Constants (copy)
		p1.resetLocalState()
		p1.setInstanceRelatedReportDialogState(p3)
		p1.props.setFeedbackFlowState(Constants.State.CurrentlyLeavingFeedback)
	end)

	function p1.onCorrectTranslationTextChanged(p4) -- line: 200
		-- upvalues: p1 (copy)
		p1:setState({
			correctTranslationText = p4
		})
	end
	function p1.onAdditionalCommentsTextChanged(p5) -- line: 206
		-- upvalues: p1 (copy)
		p1:setState({
			additionalCommentsText = p5
		})
	end
	function p1.onSubmitFeedback() -- line: 212
		-- upvalues: p1 (copy), Constants (copy), GetFFlagEnableSendImageFeedbackToBackend (copy)
		p1:setState({
			numFeedbackSubmissionAttempts = p1.state.numFeedbackSubmissionAttempts + 1
		})

		local ContentTypeText = Constants.ContentType.Text
		local feedbackOriginalText = p1.state.feedbackOriginalText
		local feedbackIdentifier = p1.state.feedbackIdentifier

		if GetFFlagEnableSendImageFeedbackToBackend() and p1.state.shouldDisplayFeedbackImage then
			feedbackOriginalText = string.match(p1.state.feedbackImageUri, "rbxassetid://(%d+)")

			if not feedbackOriginalText then
				p1.props.setFeedbackFlowState(Constants.State.Default)
				p1.resetLocalState()

				return
			end

			feedbackIdentifier = game.GameId .. ":" .. feedbackOriginalText
			ContentTypeText = Constants.ContentType.Image
		end

		p1.props.sendFeedback(ContentTypeText, feedbackOriginalText, p1.state.feedbackText, feedbackIdentifier, p1.state.correctTranslationText, p1.state.additionalCommentsText, p1.props.feedbackReason, p1.state.numFeedbackSubmissionAttempts)
		p1.props.setFeedbackFlowState(Constants.State.Default)
		p1.resetLocalState()
	end
	function p1.onCancel() -- line: 251
		-- upvalues: p1 (copy), Constants (copy)
		p1.props.setFeedbackFlowState(Constants.State.Default)
		p1.resetLocalState()
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		p1.disposeScreenSize = Signals.createEffect(function(p6) -- line: 259
			-- upvalues: p1 (copy), getViewportSize (copy)
			p1:setState({
				screenSize = getViewportSize(p6)
			})
		end)
	end
end
function v29.renderContents(p7, p8) -- line: 267
	-- upvalues: withStyle (copy), GetFFlagEnableFeedbackReportDialogAdjustments (copy), Roact (copy), StyledTextLabel (copy), ThemedTextLabel (copy), v27 (copy), RadioButtonList (copy), TextEntryField (copy)
	return withStyle(function(p9) -- line: 268
		-- upvalues: p8 (copy), GetFFlagEnableFeedbackReportDialogAdjustments (copy), Roact (copy), StyledTextLabel (copy), p7 (copy), ThemedTextLabel (copy), v27 (copy), RadioButtonList (copy), TextEntryField (copy)
		local Theme = p9.Theme
		local p9Font = p9.Font
		local t1 = {
			p8.untranslated,
			p8.accuracyIssue,
			p8.spellingOrGrammarIssue,
			p8.inappropriateOrDerogatory
		}

		if GetFFlagEnableFeedbackReportDialogAdjustments() then
			return Roact.createFragment({
				Layout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				SelectedTextHeader = Roact.createElement(StyledTextLabel, {
					richText = true,
					layoutOrder = 1,
					fluidSizing = true,
					text = if not p7.state.shouldDisplayFeedbackImage then p8.textSelectionHeader else p8.imageSelectionHeader,
					size = UDim2.new(1, 0, 0, 72),
					textTruncate = Enum.TextTruncate.AtEnd,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					fontStyle = p9Font.Header2,
					colorStyle = Theme.TextEmphasis,
					automaticSize = Enum.AutomaticSize.X
				}),
				SelectedTextLabel = if not p7.state.shouldDisplayFeedbackImage then Roact.createElement(ThemedTextLabel, {
					LayoutOrder = 2,
					fontKey = "Body",
					themeKey = "TextDefault",
					TextWrapped = true,
					Size = UDim2.new(1, 0, 0, p7.calculateFieldHeight(string.len(p7.state.feedbackText), 14, false)),
					Text = if not v27 then p7.state.feedbackText or "" else ((if not p7.state.isGenericSelection then p7.state.feedbackText else p8.genericSelectionWrapper)) or "",
					TextXAlignment = Enum.TextXAlignment.Left
				}) else Roact.createElement("ImageLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 72),
					Image = p7.state.feedbackImageUri,
					ScaleType = Enum.ScaleType.Fit
				}),
				TranslationProblemsHeader = Roact.createElement(StyledTextLabel, {
					richText = true,
					layoutOrder = 3,
					fluidSizing = true,
					text = p8.problemDropdownSelectionHeader,
					size = UDim2.new(1, 0, 0, 72),
					textTruncate = Enum.TextTruncate.AtEnd,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					fontStyle = p9Font.Header2,
					colorStyle = Theme.TextEmphasis,
					automaticSize = Enum.AutomaticSize.X
				}),
				TranslationProblemsListFrame = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, 160)
				}, {
					RadioButtonList = Roact.createElement(RadioButtonList, {
						radioButtons = t1,
						onActivated = function(p10) -- line: 348
							-- upvalues: p7 (copy)
							p7.props.setFeedbackReason(p10)
						end,
						currentValue = p7.props.feedbackReason,
						elementSize = UDim2.new(1, 0, 0, 40)
					})
				}),
				CorrectTranslationHeader = Roact.createElement(StyledTextLabel, {
					richText = true,
					layoutOrder = 5,
					fluidSizing = true,
					text = p8.correctTranslationHeader,
					size = UDim2.new(1, 0, 0, 72),
					textTruncate = Enum.TextTruncate.AtEnd,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					fontStyle = p9Font.Header2,
					colorStyle = Theme.TextEmphasis,
					automaticSize = Enum.AutomaticSize.X
				}),
				CorrectTranslationTextEntryField = Roact.createElement(TextEntryField, {
					LayoutOrder = 6,
					enabled = true,
					autoFocusOnEnabled = false,
					text = p7.state.correctTranslationText,
					textChanged = p7.onCorrectTranslationTextChanged,
					maxTextLength = math.max(string.len(p7.state.correctTranslationText), 180),
					PlaceholderText = p8.correctTranslationPlaceholder,
					Size = UDim2.new(1, 0, 0, p7.calculateFieldHeight(string.len(p7.state.correctTranslationText), 14, true))
				}),
				AdditionalCommentsHeader = Roact.createElement(StyledTextLabel, {
					richText = true,
					layoutOrder = 7,
					fluidSizing = true,
					text = p8.additionalCommentsHeader,
					size = UDim2.new(1, 0, 0, 72),
					textTruncate = Enum.TextTruncate.AtEnd,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					fontStyle = p9Font.Header2,
					colorStyle = Theme.TextEmphasis,
					automaticSize = Enum.AutomaticSize.X
				}),
				AdditionalCommentsTextEntryField = Roact.createElement(TextEntryField, {
					LayoutOrder = 8,
					enabled = true,
					maxTextLength = 180,
					autoFocusOnEnabled = false,
					text = p7.state.additionalCommentsText,
					textChanged = p7.onAdditionalCommentsTextChanged,
					PlaceholderText = p8.additionalCommentsPlaceholder,
					Size = UDim2.new(1, 0, 0, 90)
				})
			})
		end

		return Roact.createFragment({
			Layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			SelectedTextHeader = Roact.createElement(StyledTextLabel, {
				richText = true,
				layoutOrder = 1,
				fluidSizing = true,
				text = if not p7.state.shouldDisplayFeedbackImage then p8.textSelectionHeader else p8.imageSelectionHeader,
				size = UDim2.new(1, 0, 0, 72),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				fontStyle = p9Font.Header2,
				colorStyle = Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.X
			}),
			SelectedTextLabel = if not p7.state.shouldDisplayFeedbackImage then Roact.createElement(ThemedTextLabel, {
				LayoutOrder = 2,
				fontKey = "Body",
				themeKey = "TextDefault",
				TextWrapped = true,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 76, 0.5, 0),
				Size = UDim2.new(1, 0, 0, p7.calculateFieldHeight(string.len(p7.state.feedbackText), 18, false)),
				Text = if not v27 then p7.state.feedbackText or "" else ((if not p7.state.isGenericSelection then p7.state.feedbackText else p8.genericSelectionWrapper)) or "",
				TextXAlignment = Enum.TextXAlignment.Left
			}) else Roact.createElement("ImageLabel", {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 72),
				Image = p7.state.feedbackImageUri,
				ScaleType = Enum.ScaleType.Fit
			}),
			CorrectTranslationHeader = Roact.createElement(StyledTextLabel, {
				richText = true,
				layoutOrder = 3,
				fluidSizing = true,
				text = p8.correctTranslationHeader,
				size = UDim2.new(1, 0, 0, 72),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				fontStyle = p9Font.Header2,
				colorStyle = Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.X
			}),
			CorrectTranslationTextEntryField = Roact.createElement(TextEntryField, {
				LayoutOrder = 4,
				enabled = true,
				autoFocusOnEnabled = false,
				text = p7.state.correctTranslationText,
				textChanged = p7.onCorrectTranslationTextChanged,
				maxTextLength = math.max(string.len(p7.state.correctTranslationText), 180),
				PlaceholderText = p8.correctTranslationPlaceholder,
				Size = UDim2.new(1, 0, 0, p7.calculateFieldHeight(string.len(p7.state.correctTranslationText), 18, true))
			}),
			AdditionalCommentsHeader = Roact.createElement(StyledTextLabel, {
				richText = true,
				layoutOrder = 5,
				fluidSizing = true,
				text = p8.additionalCommentsHeader,
				size = UDim2.new(1, 0, 0, 72),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				fontStyle = p9Font.Header2,
				colorStyle = Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.X
			}),
			AdditionalCommentsTextEntryField = Roact.createElement(TextEntryField, {
				LayoutOrder = 6,
				enabled = true,
				maxTextLength = 180,
				autoFocusOnEnabled = false,
				text = p7.state.additionalCommentsText,
				textChanged = p7.onAdditionalCommentsTextChanged,
				PlaceholderText = p8.additionalCommentsPlaceholder,
				Size = UDim2.new(1, 0, 0, 90)
			}),
			TranslationProblemsHeader = Roact.createElement(StyledTextLabel, {
				richText = true,
				layoutOrder = 7,
				fluidSizing = true,
				text = p8.problemDropdownSelectionHeader,
				size = UDim2.new(1, 0, 0, 72),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				fontStyle = p9Font.Header2,
				colorStyle = Theme.TextEmphasis,
				automaticSize = Enum.AutomaticSize.X
			}),
			RadioButtonList = Roact.createElement(RadioButtonList, {
				layoutOrder = 8,
				radioButtons = t1,
				onActivated = function(p11) -- line: 528
					-- upvalues: p7 (copy)
					p7.props.setFeedbackReason(p11)
				end,
				currentValue = p7.props.feedbackReason,
				elementSize = UDim2.new(1, 0, 0, 40)
			})
		})
	end)
end
function v29.render(p12) -- line: 540
	-- upvalues: withLocalization (copy), Roact (copy), ModalDialog (copy), Constants (copy), FFlagTopBarSignalizeScreenSize (copy), GetFFlagEnableFeedbackReportDialogAdjustments (copy), VerticalScrollView (copy), ButtonStack (copy), ButtonType (copy)
	return withLocalization({
		mainHeader = "CoreScripts.Feedback.FeedbackReportDialog.MainHeader",
		cancel = "CoreScripts.Feedback.FeedbackReportDialog.Cancel",
		submitFeedback = "CoreScripts.Feedback.FeedbackReportDialog.SubmitFeedback",
		untranslated = "CoreScripts.Feedback.FeedbackReportDialog.ProblemOption.Untranslated",
		accuracyIssue = "CoreScripts.Feedback.FeedbackReportDialog.ProblemOption.AccuracyIssue",
		spellingOrGrammarIssue = "CoreScripts.Feedback.FeedbackReportDialog.ProblemOption.SpellingOrGrammarIssue",
		inappropriateOrDerogatory = "CoreScripts.Feedback.FeedbackReportDialog.ProblemOption.InappropriateOrDerogatory",
		textSelectionHeader = "CoreScripts.Feedback.FeedbackReportDialog.TextSelectionHeader",
		correctTranslationHeader = "CoreScripts.Feedback.FeedbackReportDialog.CorrectTranslationHeader",
		correctTranslationPlaceholder = "CoreScripts.Feedback.FeedbackReportDialog.CorrectTranslationPlaceholder",
		additionalCommentsHeader = "CoreScripts.Feedback.FeedbackReportDialog.AdditionalCommentsHeader",
		additionalCommentsPlaceholder = "CoreScripts.Feedback.FeedbackReportDialog.AdditionalCommentsPlaceholder",
		problemDropdownSelectionHeader = "CoreScripts.Feedback.FeedbackReportDialog.ProblemDropdownSelectionHeader",
		imageSelectionHeader = "CoreScripts.Feedback.FeedbackReportDialog.ImageSelectionHeader",
		genericSelectionWrapper = {
			"CoreScripts.Feedback.FeedbackReportDialog.CorrectTranslationObjectPlaceholder",
			ObjectType = p12.state.feedbackText
		}
	})(function(p13) -- line: 560
		-- upvalues: Roact (copy), ModalDialog (copy), p12 (copy), Constants (copy), FFlagTopBarSignalizeScreenSize (copy), GetFFlagEnableFeedbackReportDialogAdjustments (copy), VerticalScrollView (copy), ButtonStack (copy), ButtonType (copy)
		return Roact.createElement(ModalDialog, {
			visible = p12.props.feedbackFlowState == Constants.State.CurrentlyLeavingFeedback,
			screenSize = if not FFlagTopBarSignalizeScreenSize then p12.props.screenSize else p12.state.screenSize,
			titleText = p13.mainHeader,
			showCloseButton = not not GetFFlagEnableFeedbackReportDialogAdjustments(),
			contents = Roact.createElement(VerticalScrollView, {
				useAutomaticCanvasSize = false,
				canvasSizeY = if not GetFFlagEnableFeedbackReportDialogAdjustments() then UDim.new(1, 550) else UDim.new(0, 600 + p12.calculateFieldHeight(string.len(p12.state.feedbackText), 14, false) * 2)
			}, Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				Contents = p12:renderContents(p13)
			})),
			actionButtons = Roact.createElement(ButtonStack, {
				buttonHeight = 36,
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = p12.onCancel,
							text = p13.cancel
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							isDisabled = false,
							onActivated = p12.onSubmitFeedback,
							text = p13.submitFeedback
						}
					}
				}
			}),
			onDismiss = p12.onCancel,
			onBackButtonActivated = if not p12.props.canNavigateBack then nil else p12.navigateBack
		})
	end)
end
function v29.willUnmount(p14) -- line: 617
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy)
	if FFlagTopBarSignalizeScreenSize then
		p14.disposeScreenSize()
	end
end

return RoactRodux.connect(function(p15) -- line: 624
	-- upvalues: FFlagTopBarSignalizeScreenSize (copy)
	return {
		screenSize = if not FFlagTopBarSignalizeScreenSize then p15.displayOptions.screenSize else nil,
		feedbackFlowState = p15.feedbackFlowState.feedbackFlowState,
		feedbackReason = p15.feedbackFlowState.feedbackReason
	}
end, function(p16) -- line: 630
	-- upvalues: SendFeedbackThunk (copy), SetFeedbackFlowState (copy), SetFeedbackReason (copy)
	return {
		sendFeedback = function(p17, p18, p19, p20, p21, p22, p23, p24) -- line: 632
			-- upvalues: p16 (copy), SendFeedbackThunk (copy)
			p16(SendFeedbackThunk(p17, p18, p19, p20, p21, p22, p23, p24))
		end,
		setFeedbackFlowState = function(p25) -- line: 655
			-- upvalues: p16 (copy), SetFeedbackFlowState (copy)
			p16(function(p26) -- line: 656
				-- upvalues: SetFeedbackFlowState (copy), p25 (copy)
				p26:dispatch(SetFeedbackFlowState(p25))
			end)
		end,
		setFeedbackReason = function(p27) -- line: 660
			-- upvalues: p16 (copy), SetFeedbackReason (copy)
			p16(function(p28) -- line: 661
				-- upvalues: SetFeedbackReason (copy), p27 (copy)
				p28:dispatch(SetFeedbackReason(p27))
			end)
		end
	}
end)(v29)
