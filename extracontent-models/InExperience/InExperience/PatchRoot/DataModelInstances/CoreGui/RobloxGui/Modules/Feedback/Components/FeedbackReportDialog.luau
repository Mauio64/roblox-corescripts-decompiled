local CorePackages = game:GetService("CorePackages")
local ExperienceStateCaptureService = game:GetService("ExperienceStateCaptureService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local VerticalScrollView = UIBlox.App.Container.VerticalScrollView
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local ReactUtils = require(CorePackages.Packages.ReactUtils)

local parent = script.Parent.Parent

local Constants = require(parent.Resources.Constants)

local SendFeedbackThunk = require(parent.Thunks.SendFeedbackThunk)
local GetSourceLanguageThunk = require(parent.Thunks.GetSourceLanguageThunk)

local SetFeedbackFlowState = require(parent.Actions.SetFeedbackFlowState)
local SetFeedbackReason = require(parent.Actions.SetFeedbackReason)

local TextEntryField = require(parent.Components.TextEntryField)
local ModalDialog = require(parent.Components.ModalDialog)
local ThemedTextLabel = require(parent.Components.PortedComponents.ThemedTextLabel)
local buildImageFeedbackFields = require(parent.Components.buildImageFeedbackFields)

local Localization = require(CorePackages.Workspace.Packages.Localization)
local withLocalization = Localization.withLocalization

local RadioButtonList = UIBlox.App.InputButton.RadioButtonList
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local withStyle = UIBlox.Core.Style.withStyle

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local GetFFlagEnableSendImageFeedbackToBackend = require(RobloxGui.Modules.Flags.GetFFlagEnableSendImageFeedbackToBackend)

local GetFFlagEnableFeedbackShowSourceTextAndOtherUXImprovements = require(RobloxGui.Modules.Flags.GetFFlagEnableFeedbackShowSourceTextAndOtherUXImprovements)
local defineFastFlag = game:DefineFastFlag("EnableFeedbackSelectionUpdate", false)
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeScreenSize = CoreGuiCommon.Flags.FFlagTopBarSignalizeScreenSize

local function getContentAssetUri(p) -- 2 equivalent calls inferred from this helper
	if p == nil or p.SourceType ~= Enum.ContentSourceType.Uri then
		return ""
	end

	return p.Uri
end

local extended = Roact.PureComponent:extend("FeedbackReportDialog")

local strictInterface = t.strictInterface
local v = { isReportDialogOpen = t.boolean, screenSize = 0, closeDialog = 0, reportCategory = 0 }
local screenSize

if not FFlagTopBarSignalizeScreenSize then
	screenSize = t.Vector2
end

v.screenSize = screenSize
v.closeDialog = t.optional(t.callback)
v.reportCategory = t.optional(t.string)
extended.validateProps = strictInterface(v)

function extended:init()
	if defineFastFlag then
		self.state = {
			feedbackText = "",
			feedbackOriginalText = "",
			feedbackIdentifier = "",
			correctTranslationText = "",
			additionalCommentsText = "",
			numFeedbackSubmissionAttempts = 0,
			isGenericSelection = false,
			shouldDisplayFeedbackImage = false,
			feedbackImageUri = "",
			feedbackTranslatedImageUri = ""
		}
	else
		self.state = {
			feedbackText = "",
			feedbackOriginalText = "",
			feedbackIdentifier = "",
			correctTranslationText = "",
			additionalCommentsText = "",
			numFeedbackSubmissionAttempts = 0,
			shouldDisplayFeedbackImage = false,
			feedbackImageUri = "",
			feedbackTranslatedImageUri = ""
		}
	end

	function self.calculateFieldHeight(p: number, p2: number, p3: number)
		if p < 180 and p3 then
			return p2 * 5
		end

		return p2 * (p / 45 + 2)
	end

	function self.resetLocalState()
		if defineFastFlag then
			self:setState({ isGenericSelection = false })
		end

		self:setState({
			shouldDisplayFeedbackImage = false,
			feedbackImageUri = "",
			feedbackTranslatedImageUri = "",
			correctTranslationText = "",
			additionalCommentsText = "",
			feedbackText = "",
			feedbackOriginalText = "",
			feedbackIdentifier = ""
		})

		self.props.setFeedbackReason(0)
		ExperienceStateCaptureService:ResetHighlight()
	end

	function self.setInstanceRelatedReportDialogState(instance)
		if instance:IsA("TextBox") then
			local feedbackText

			if instance.PlaceholderText == "" then
				feedbackText = instance.Text
			else
				feedbackText = instance.PlaceholderText
			end

			self:setState({
				feedbackText = feedbackText,
				feedbackOriginalText = instance.LocalizationMatchedSourceText,
				feedbackIdentifier = instance.LocalizationMatchIdentifier
			})

			if defineFastFlag then
				self:setState({ isGenericSelection = false })
			end
		elseif instance:IsA("TextLabel") or instance:IsA("TextButton") then
			self:setState({
				feedbackText = instance.Text,
				feedbackOriginalText = instance.LocalizationMatchedSourceText,
				feedbackIdentifier = instance.LocalizationMatchIdentifier
			})

			if defineFastFlag then
				self:setState({ isGenericSelection = false })
			end
		elseif instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
			local v2 = {
				shouldDisplayFeedbackImage = true,
				feedbackImageUri = instance.Image,
				feedbackTranslatedImageUri = 0
			}
			local feedbackTranslatedImageUri

			if GetFFlagEnableSendImageFeedbackToBackend() then
				feedbackTranslatedImageUri = getContentAssetUri(instance.LocalizedImageContent) -- inferred equivalent call
			else
				feedbackTranslatedImageUri = ""
			end

			v2.feedbackTranslatedImageUri = feedbackTranslatedImageUri
			self:setState(v2)
		elseif instance:IsA("Decal") then
			local v2 = {
				shouldDisplayFeedbackImage = true,
				feedbackImageUri = instance.Texture,
				feedbackTranslatedImageUri = 0
			}
			local feedbackTranslatedImageUri

			if GetFFlagEnableSendImageFeedbackToBackend() then
				feedbackTranslatedImageUri = getContentAssetUri(instance.LocalizedTextureContent) -- inferred equivalent call
			else
				feedbackTranslatedImageUri = ""
			end

			v2.feedbackTranslatedImageUri = feedbackTranslatedImageUri
			self:setState(v2)
		elseif instance:IsA("MeshPart") then
			if instance.TextureContent.SourceType == Enum.ContentSourceType.Uri then
				self:setState({
					shouldDisplayFeedbackImage = true,
					feedbackImageUri = instance.TextureID
				})
				return
			end

			if instance.MeshContent.SourceType == Enum.ContentSourceType.Uri then
				self:setState({
					shouldDisplayFeedbackImage = true,
					feedbackImageUri = instance.MeshId
				})
				return
			end

			local surfaceAppearance = instance:FindFirstChildOfClass("SurfaceAppearance")

			if surfaceAppearance and surfaceAppearance.ColorMap then
				self:setState({
					shouldDisplayFeedbackImage = true,
					feedbackImageUri = surfaceAppearance.ColorMap
				})
			end
		elseif defineFastFlag then
			self:setState({
				feedbackText = instance.ClassName,
				feedbackOriginalText = instance.ClassName,
				feedbackIdentifier = "",
				isGenericSelection = true
			})
		end
	end

	ExperienceStateCaptureService.ItemSelectedInCaptureMode:Connect(function(p)
		self.resetLocalState()
		self.setInstanceRelatedReportDialogState(p)
		self.props.setFeedbackFlowState(Constants.State.CurrentlyLeavingFeedback)
	end)

	function self.onCorrectTranslationTextChanged(correctTranslationText)
		self:setState({ correctTranslationText = correctTranslationText })
	end

	function self.onAdditionalCommentsTextChanged(additionalCommentsText)
		self:setState({ additionalCommentsText = additionalCommentsText })
	end

	function self.onSubmitFeedback()
		self:setState({
			numFeedbackSubmissionAttempts = self.state.numFeedbackSubmissionAttempts + 1
		})

		local v2 = Constants.ContentType.Text
		local v3 = self.state.feedbackOriginalText
		local v4 = self.state.feedbackText
		local v5 = self.state.feedbackIdentifier

		if GetFFlagEnableSendImageFeedbackToBackend() and self.state.shouldDisplayFeedbackImage then
			local imageFeedbackFields = buildImageFeedbackFields(
				game.GameId,
				self.state.feedbackImageUri,
				self.state.feedbackTranslatedImageUri
			)

			if imageFeedbackFields then
				v3 = imageFeedbackFields.source
				v2 = Constants.ContentType.Image
				v5 = imageFeedbackFields.identifier
				v4 = imageFeedbackFields.translation
			else
				self.props.setFeedbackFlowState(Constants.State.Default)
				self.resetLocalState()
				return
			end
		end

		self.props.sendFeedback(
			v2,
			v3,
			v4,
			v5,
			self.state.correctTranslationText,
			self.state.additionalCommentsText,
			self.props.feedbackReason,
			self.state.numFeedbackSubmissionAttempts
		)

		self.props.setFeedbackFlowState(Constants.State.Default)
		self.resetLocalState()
	end

	function self.onCancel()
		self.props.setFeedbackFlowState(Constants.State.Default)
		self.resetLocalState()
	end

	if FFlagTopBarSignalizeScreenSize then
		local getViewportSize = Display.GetDisplayStore(false).getViewportSize

		self.disposeScreenSize = Signals.createEffect(function(p)
			self:setState({ screenSize = getViewportSize(p) })
		end)
	end
end

function extended:renderContents(data)
	return withStyle(function(p)
		local theme = p.Theme
		local font = p.Font

		local v2 = not (self.state.shouldDisplayFeedbackImage or self.state.isGenericSelection)

		if v2 then
			if self.state.feedbackOriginalText == nil then
				v2 = false
			else
				v2 = self.state.feedbackOriginalText ~= ""
			end
		end

		local imageQualities = {
			data.untranslated,
			data.accuracyIssue,
			data.spellingOrGrammarIssue,
			data.inappropriateOrDerogatory
		}

		if GetFFlagEnableSendImageFeedbackToBackend() and self.state.shouldDisplayFeedbackImage then
			table.insert(imageQualities, data.imageQuality)
		end

		local v3

		if GetFFlagEnableFeedbackShowSourceTextAndOtherUXImprovements() then
			local nextOrder = ReactUtils.createNextOrder()
			v3 = {
				SelectedTextHeader = nextOrder(),
				SelectedTextLabel = nextOrder(),
				OriginalTextHeader = nextOrder(),
				OriginalTextLabel = nextOrder(),
				CorrectTranslationHeader = nextOrder(),
				CorrectTranslationTextEntryField = nextOrder(),
				TranslationProblemsHeader = nextOrder(),
				TranslationProblemsListFrame = nextOrder(),
				AdditionalCommentsHeader = nextOrder(),
				AdditionalCommentsTextEntryField = nextOrder()
			}
		else
			v3 = {
				SelectedTextHeader = 1,
				SelectedTextLabel = 2,
				TranslationProblemsHeader = 3,
				TranslationProblemsListFrame = 4,
				CorrectTranslationHeader = 5,
				CorrectTranslationTextEntryField = 6,
				AdditionalCommentsHeader = 7,
				AdditionalCommentsTextEntryField = 8
			}
		end

		local createFragment = Roact.createFragment
		local children = {
			Layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			SelectedTextHeader = 0,
			SelectedTextLabel = 0,
			OriginalTextHeader = 0,
			OriginalTextLabel = 0,
			CorrectTranslationHeader = 0,
			CorrectTranslationTextEntryField = 0,
			TranslationProblemsHeader = 0,
			TranslationProblemsListFrame = 0,
			AdditionalCommentsHeader = 0,
			AdditionalCommentsTextEntryField = 0
		}

		local createElement = Roact.createElement
		local text

		if self.state.shouldDisplayFeedbackImage then
			text = data.imageSelectionHeader
		else
			text = data.textSelectionHeader
		end

		children.SelectedTextHeader = createElement(StyledTextLabel, {
			text = text,
			size = UDim2.new(1, 0, 0, 72),
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Center,
			fontStyle = font.Header2,
			colorStyle = theme.TextEmphasis,
			richText = true,
			layoutOrder = v3.SelectedTextHeader,
			fluidSizing = true,
			automaticSize = Enum.AutomaticSize.X
		})
		local selectedTextLabel

		if self.state.shouldDisplayFeedbackImage then
			local createElement2 = Roact.createElement
			local v4 = {
				LayoutOrder = v3.SelectedTextLabel,
				Size = UDim2.new(1, 0, 0, 72),
				Image = 0,
				ScaleType = 0,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}
			local image

			if self.state.feedbackTranslatedImageUri == nil or self.state.feedbackTranslatedImageUri == "" then
				image = self.state.feedbackImageUri
			else
				image = self.state.feedbackTranslatedImageUri
			end

			v4.Image = image

			v4.ScaleType = Enum.ScaleType.Fit
			selectedTextLabel = createElement2("ImageLabel", v4)
		else
			local createElement2 = Roact.createElement
			local v4 = {
				LayoutOrder = v3.SelectedTextLabel,
				fontKey = "Body",
				themeKey = "TextDefault",
				Size = UDim2.new(1, 0, 0, self.calculateFieldHeight(string.len(self.state.feedbackText), 14, false)),
				Text = 0,
				TextWrapped = true,
				TextXAlignment = 0
			}
			local text2

			if defineFastFlag then
				local v5

				if self.state.isGenericSelection then
					v5 = data.genericSelectionWrapper
				else
					v5 = self.state.feedbackText
				end

				text2 = v5 or ""
			else
				text2 = self.state.feedbackText or ""
			end

			v4.Text = text2

			v4.TextXAlignment = Enum.TextXAlignment.Left
			selectedTextLabel = createElement2(ThemedTextLabel, v4)
		end

		children.SelectedTextLabel = selectedTextLabel
		local originalTextHeader

		if GetFFlagEnableFeedbackShowSourceTextAndOtherUXImprovements() and v2 then
			originalTextHeader = Roact.createElement(StyledTextLabel, {
				text = data.originalTextHeader,
				size = UDim2.new(1, 0, 0, 72),
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				fontStyle = font.Header2,
				colorStyle = theme.TextEmphasis,
				richText = true,
				layoutOrder = v3.OriginalTextHeader,
				fluidSizing = true,
				automaticSize = Enum.AutomaticSize.X
			})
		end

		children.OriginalTextHeader = originalTextHeader
		local originalTextLabel

		if GetFFlagEnableFeedbackShowSourceTextAndOtherUXImprovements() and v2 then
			originalTextLabel = Roact.createElement(ThemedTextLabel, {
				LayoutOrder = v3.OriginalTextLabel,
				fontKey = "Body",
				themeKey = "TextDefault",
				Size = UDim2.new(
					1,
					0,
					0,
					self.calculateFieldHeight(string.len(self.state.feedbackOriginalText), 14, false)
				),
				Text = self.state.feedbackOriginalText or "",
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		end

		children.OriginalTextLabel = originalTextLabel

		children.CorrectTranslationHeader = Roact.createElement(StyledTextLabel, {
			text = data.correctTranslationHeader,
			size = UDim2.new(1, 0, 0, 72),
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Center,
			fontStyle = font.Header2,
			colorStyle = theme.TextEmphasis,
			richText = true,
			layoutOrder = v3.CorrectTranslationHeader,
			fluidSizing = true,
			automaticSize = Enum.AutomaticSize.X
		})

		children.CorrectTranslationTextEntryField = Roact.createElement(TextEntryField, {
			LayoutOrder = v3.CorrectTranslationTextEntryField,
			enabled = true,
			text = self.state.correctTranslationText,
			textChanged = self.onCorrectTranslationTextChanged,
			maxTextLength = math.max(string.len(self.state.correctTranslationText), 180),
			autoFocusOnEnabled = false,
			PlaceholderText = data.correctTranslationPlaceholder,
			Size = UDim2.new(
				1,
				0,
				0,
				self.calculateFieldHeight(string.len(self.state.correctTranslationText), 14, true)
			)
		})

		children.TranslationProblemsHeader = Roact.createElement(StyledTextLabel, {
			text = data.problemDropdownSelectionHeader,
			size = UDim2.new(1, 0, 0, 72),
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Center,
			fontStyle = font.Header2,
			colorStyle = theme.TextEmphasis,
			richText = true,
			layoutOrder = v3.TranslationProblemsHeader,
			fluidSizing = true,
			automaticSize = Enum.AutomaticSize.X
		})

		children.TranslationProblemsListFrame = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, #imageQualities * 40),
			BackgroundTransparency = 1,
			LayoutOrder = v3.TranslationProblemsListFrame
		}, {
			RadioButtonList = Roact.createElement(RadioButtonList, {
				radioButtons = imageQualities,
				onActivated = function(p2)
					self.props.setFeedbackReason(p2)
				end,
				currentValue = self.props.feedbackReason,
				elementSize = UDim2.new(1, 0, 0, 40)
			})
		})

		children.AdditionalCommentsHeader = Roact.createElement(StyledTextLabel, {
			text = data.additionalCommentsHeader,
			size = UDim2.new(1, 0, 0, 72),
			textTruncate = Enum.TextTruncate.AtEnd,
			textXAlignment = Enum.TextXAlignment.Left,
			textYAlignment = Enum.TextYAlignment.Center,
			fontStyle = font.Header2,
			colorStyle = theme.TextEmphasis,
			richText = true,
			layoutOrder = v3.AdditionalCommentsHeader,
			fluidSizing = true,
			automaticSize = Enum.AutomaticSize.X
		})

		children.AdditionalCommentsTextEntryField = Roact.createElement(TextEntryField, {
			LayoutOrder = v3.AdditionalCommentsTextEntryField,
			enabled = true,
			text = self.state.additionalCommentsText,
			textChanged = self.onAdditionalCommentsTextChanged,
			maxTextLength = 180,
			autoFocusOnEnabled = false,
			PlaceholderText = data.additionalCommentsPlaceholder,
			Size = UDim2.new(1, 0, 0, 90)
		})
		return createFragment(children)
	end)
end

function extended:render()
	local v2 = {
		mainHeader = "CoreScripts.Feedback.FeedbackReportDialog.MainHeader",
		cancel = "CoreScripts.Feedback.FeedbackReportDialog.Cancel",
		submitFeedback = "CoreScripts.Feedback.FeedbackReportDialog.SubmitFeedback",
		untranslated = "CoreScripts.Feedback.FeedbackReportDialog.ProblemOption.Untranslated",
		accuracyIssue = "CoreScripts.Feedback.FeedbackReportDialog.ProblemOption.AccuracyIssue",
		spellingOrGrammarIssue = "CoreScripts.Feedback.FeedbackReportDialog.ProblemOption.SpellingOrGrammarIssue",
		inappropriateOrDerogatory = "CoreScripts.Feedback.FeedbackReportDialog.ProblemOption.InappropriateOrDerogatory",
		imageQuality = "CoreScripts.Feedback.FeedbackReportDialog.ProblemOption.ImageQuality",
		textSelectionHeader = "CoreScripts.Feedback.FeedbackReportDialog.TextSelectionHeader",
		correctTranslationHeader = "CoreScripts.Feedback.FeedbackReportDialog.CorrectTranslationHeader",
		correctTranslationPlaceholder = "CoreScripts.Feedback.FeedbackReportDialog.CorrectTranslationPlaceholder",
		additionalCommentsHeader = "CoreScripts.Feedback.FeedbackReportDialog.AdditionalCommentsHeader",
		additionalCommentsPlaceholder = "CoreScripts.Feedback.FeedbackReportDialog.AdditionalCommentsPlaceholder",
		problemDropdownSelectionHeader = "CoreScripts.Feedback.FeedbackReportDialog.ProblemDropdownSelectionHeader",
		genericSelectionWrapper = {
			"CoreScripts.Feedback.FeedbackReportDialog.CorrectTranslationObjectPlaceholder",
			ObjectType = self.state.feedbackText
		},
		imageSelectionHeader = "CoreScripts.Feedback.FeedbackReportDialog.ImageSelectionHeader"
	}

	if GetFFlagEnableFeedbackShowSourceTextAndOtherUXImprovements() then
		v2.originalTextHeader = {
			"CoreScripts.Feedback.FeedbackReportDialog.OriginalTextHeader",
			SourceLanguage = self.props.sourceLanguageName
		}
	end

	return withLocalization(v2)(function(props)
		local createElement = Roact.createElement
		local children = {
			visible = self.props.feedbackFlowState == Constants.State.CurrentlyLeavingFeedback,
			screenSize = 0,
			titleText = 0,
			showCloseButton = true,
			contents = 0,
			actionButtons = 0,
			onDismiss = 0,
			onBackButtonActivated = 0
		}
		local screenSize2

		if FFlagTopBarSignalizeScreenSize then
			screenSize2 = self.state.screenSize
		else
			screenSize2 = self.props.screenSize
		end

		children.screenSize = screenSize2
		children.titleText = props.mainHeader

		local createElement2 = Roact.createElement
		local canvasSizeY

		if GetFFlagEnableFeedbackShowSourceTextAndOtherUXImprovements() then
			canvasSizeY = UDim.new(
				0,
				600 + self.calculateFieldHeight(string.len(self.state.feedbackText), 14, false) * 2 + 72 + self.calculateFieldHeight(
					string.len(self.state.feedbackOriginalText),
					14,
					false
				) + (GetFFlagEnableSendImageFeedbackToBackend() and self.state.shouldDisplayFeedbackImage and 40 or 0)
			)
		else
			canvasSizeY = UDim.new(
				0,
				600 + self.calculateFieldHeight(string.len(self.state.feedbackText), 14, false) * 2 + (GetFFlagEnableSendImageFeedbackToBackend() and self.state.shouldDisplayFeedbackImage and 40 or 0)
			)
		end

		children.contents = createElement2(
			VerticalScrollView,
			{ useAutomaticCanvasSize = false, canvasSizeY = canvasSizeY },
			Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 24),
					PaddingRight = UDim.new(0, 24)
				}),
				Contents = self:renderContents(props)
			})
		)

		local createElement3 = Roact.createElement

		local v3 = {
			buttonType = ButtonType.Secondary,
			props = { onActivated = self.onCancel, text = props.cancel }
		}

		local v4 = { buttonType = ButtonType.PrimarySystem, props = 0 }
		local isDisabled

		if GetFFlagEnableFeedbackShowSourceTextAndOtherUXImprovements() then
			isDisabled = self.state.correctTranslationText:match("%S") == nil
		else
			isDisabled = false
		end

		v4.props = {
			isDisabled = isDisabled,
			onActivated = self.onSubmitFeedback,
			text = props.submitFeedback
		}
		children.actionButtons = createElement3(ButtonStack, {
			buttonHeight = 36,
			buttons = { v3, v4 }
		})

		children.onDismiss = self.onCancel
		local onBackButtonActivated

		if self.props.canNavigateBack then
			onBackButtonActivated = self.navigateBack
		end

		children.onBackButtonActivated = onBackButtonActivated
		return createElement(ModalDialog, children)
	end)
end

function extended.didMount(p)
	if GetFFlagEnableFeedbackShowSourceTextAndOtherUXImprovements() and p.props.sourceLanguageName == "" then
		p.props.getSourceLanguageName()
	end
end

function extended.willUnmount(p)
	if FFlagTopBarSignalizeScreenSize then
		p.disposeScreenSize()
	end
end

return RoactRodux.connect(function(data)
	local screenSize2

	if not FFlagTopBarSignalizeScreenSize then
		screenSize2 = data.displayOptions.screenSize
	end

	local v2 = {
		screenSize = screenSize2,
		feedbackFlowState = data.feedbackFlowState.feedbackFlowState,
		feedbackReason = data.feedbackFlowState.feedbackReason,
		sourceLanguageName = 0
	}
	local sourceLanguageName

	if GetFFlagEnableFeedbackShowSourceTextAndOtherUXImprovements() then
		sourceLanguageName = data.common.sourceLanguageName
	end

	v2.sourceLanguageName = sourceLanguageName
	return v2
end, function(callback)
	return {
		sendFeedback = function(p, p2, p3, p4, p5, p6, p7, p8)
			callback(SendFeedbackThunk(p, p2, p3, p4, p5, p6, p7, p8))
		end,
		setFeedbackFlowState = function(p)
			callback(function(object)
				object:dispatch(SetFeedbackFlowState(p))
			end)
		end,
		setFeedbackReason = function(p)
			callback(function(object)
				object:dispatch(SetFeedbackReason(p))
			end)
		end,
		getSourceLanguageName = function()
			if GetFFlagEnableFeedbackShowSourceTextAndOtherUXImprovements() then
				callback(GetSourceLanguageThunk())
			end
		end
	}
end)(extended)
