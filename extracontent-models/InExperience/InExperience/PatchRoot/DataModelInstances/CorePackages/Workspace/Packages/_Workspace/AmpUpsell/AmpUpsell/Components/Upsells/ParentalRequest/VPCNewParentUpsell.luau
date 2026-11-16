local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local LinkButton = UIBlox.App.Button.LinkButton
local TextField = UIBlox.App.Input.TextField
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Cryo = require(parent.Cryo)
local useOnScreenKeyboardHeight = require(AmpUpsell.Common.useOnScreenKeyboardHeight)

local GetFFlagEnableVPCUpsellFoundationDialogHardening = require(AmpUpsell.Flags.GetFFlagEnableVPCUpsellFoundationDialogHardening)
local GetShouldUseFoundationUIVPCUpsell = require(AmpUpsell.Flags.GetShouldUseFoundationUIVPCUpsell)

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local Text = Foundation.Text

local udim = UDim2.new(1, 0, 0, 0)

local function selectScreenSize(p)
	return p.ScreenSize
end

local function VPCNewParentUpsell(props)
	local onCollectEmailAndSendRequest = props.onCollectEmailAndSendRequest
	local onCancel = props.onCancel
	local screenSize = useSelector(selectScreenSize)
	local onTextChange = props.onTextChange
	local canSendRequest = props.canSendRequest
	local textInput = props.textInput
	local errorText = props.errorText
	local openPrivacyPolicyLink = props.openPrivacyPolicyLink
	local isChildSubjectToParentalControls = props.isChildSubjectToParentalControls
	local v = useOnScreenKeyboardHeight()
	local disablePortal

	if props.disablePortal then
		disablePortal = props.disablePortal
	else
		disablePortal = false
	end

	local v2

	if props.isInExperienceEntry then
		v2 = props.isInExperienceEntry
	else
		v2 = false
	end

	local shouldUseFoundationUIVPCUpsell = GetShouldUseFoundationUIVPCUpsell(v2)

	local v3 = useStyle()
	local v4 = useLocalization(Cryo.Dictionary.join(props.messageStrings, {
		directionsTextSubjectToParentalControls = {
			"Feature.Parents.Description.EnterParentEmailV4",
			lineBreak = "\n\n"
		},
		directionsTextNotSubjectToParentalControls = {
			"Feature.Parents.Description.EnterParentEmailWithoutParentalControl",
			lineBreak = "\n\n"
		},
		privacyPolicyFooter = {
			"Feature.Parents.Description.ParentalEmailFooter",
			linkStart = "",
			linkEnd = ""
		}
	}))

	local titleText = v4.titleText
	local buttonText = v4.buttonText
	local text

	if isChildSubjectToParentalControls then
		if shouldUseFoundationUIVPCUpsell then
			text = string.format("%s\n\n%s\n", v4.childInstructions, v4.parentInstructionsPC)
		else
			text = string.format("%s\n", v4.directionsTextSubjectToParentalControls)
		end
	elseif shouldUseFoundationUIVPCUpsell then
		text = string.format("%s\n\n%s\n", v4.childInstructions, v4.parentInstructionsNoPC)
	else
		text = string.format("%s\n", v4.directionsTextNotSubjectToParentalControls)
	end

	local textFieldHeaderText = v4.textFieldHeaderText

	if not shouldUseFoundationUIVPCUpsell then
		return React.createElement(InteractiveAlert, {
			title = titleText,
			screenSize = screenSize,
			position = v > 0 and UDim2.new(0.5, 0, 1, -v * 0.8) or UDim2.fromScale(0.5, 0.5),
			anchorPoint = v > 0 and Vector2.new(0.5, 1) or nil,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = function()
								onCollectEmailAndSendRequest(textInput)
							end,
							text = buttonText,
							isDisabled = not canSendRequest
						}
					}
				}
			},
			onCloseClicked = onCancel,
			bottomPadding = 0,
			middleContent = function()
				return React.createElement(
					"Frame",
					{ AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 },
					{
						UIListLayout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Top
						}),
						HeaderText = React.createElement(StyledTextLabel, {
							text = text,
							fontStyle = v3.Font.CaptionHeader,
							colorStyle = v3.Theme.TextDefault,
							textXAlignment = Enum.TextXAlignment.Left,
							textYAlignment = Enum.TextYAlignment.Top,
							textWrapped = true,
							automaticSize = Enum.AutomaticSize.XY,
							layoutOrder = 1
						}),
						TextboxFrame = React.createElement(
							"Frame",
							{
								AutomaticSize = Enum.AutomaticSize.XY,
								BackgroundTransparency = 1,
								LayoutOrder = 2
							},
							{
								UIListLayout = React.createElement("UIListLayout", {
									SortOrder = Enum.SortOrder.LayoutOrder,
									FillDirection = Enum.FillDirection.Vertical,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									VerticalAlignment = Enum.VerticalAlignment.Top,
									Padding = UDim.new(0, 10)
								}),
								TextFieldHeader = React.createElement(StyledTextLabel, {
									text = textFieldHeaderText,
									fontStyle = v3.Font.Header2,
									colorStyle = v3.Theme.TextDefault,
									textWrapped = true,
									automaticSize = Enum.AutomaticSize.XY,
									layoutOrder = 0
								}),
								TextField = React.createElement(TextField, {
									text = textInput,
									placeholder = v4.emailPlaceholder,
									required = true,
									hint = errorText,
									error = errorText ~= "",
									onChange = onTextChange,
									width = UDim.new(1, 0),
									layoutOrder = 1
								})
							}
						),
						DisclaimerFrame = React.createElement(
							"Frame",
							{
								AutomaticSize = Enum.AutomaticSize.XY,
								BackgroundTransparency = 1,
								LayoutOrder = 3
							},
							{
								UIListLayout = React.createElement("UIListLayout", {
									SortOrder = Enum.SortOrder.LayoutOrder,
									FillDirection = Enum.FillDirection.Vertical,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									VerticalAlignment = Enum.VerticalAlignment.Top
								}),
								Disclaimer = React.createElement(StyledTextLabel, {
									text = v4.privacyPolicyFooter,
									fontStyle = v3.Font.Footer,
									colorStyle = v3.Theme.TextDefault,
									textXAlignment = Enum.TextXAlignment.Left,
									textWrapped = true,
									automaticSize = Enum.AutomaticSize.XY,
									layoutOrder = 1
								}),
								PrivacyPolicy = React.createElement(LinkButton, {
									text = v4.privacyLinkText,
									layoutOrder = 2,
									fontStyle = "Footer",
									underlineAlwaysEnabled = false,
									onActivated = openPrivacyPolicyLink
								})
							}
						)
					}
				)
			end
		})
	end

	if GetFFlagEnableVPCUpsellFoundationDialogHardening() then
		return React.createElement(
			Dialog.Root,
			{
				size = DialogSize.Large,
				onClose = onCancel,
				disablePortal = disablePortal,
				hasBackdrop = true
			},
			{
				DialogTitle = React.createElement(Dialog.Title, { text = titleText }),
				DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
					Frame = React.createElement(
						"Frame",
						{
							Size = udim,
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1
						},
						{
							UIListLayout = React.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								VerticalAlignment = Enum.VerticalAlignment.Top
							}),
							HeaderText = React.createElement(Dialog.Text, {
								Text = text,
								LayoutOrder = 1
							}),
							TextboxFrame = React.createElement(
								"Frame",
								{
									Size = udim,
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									LayoutOrder = 2
								},
								{
									UIListLayout = React.createElement("UIListLayout", {
										SortOrder = Enum.SortOrder.LayoutOrder,
										FillDirection = Enum.FillDirection.Vertical,
										HorizontalAlignment = Enum.HorizontalAlignment.Left,
										VerticalAlignment = Enum.VerticalAlignment.Top,
										Padding = UDim.new(0, 10)
									}),
									TextFieldHeader = React.createElement(Text, {
										Text = textFieldHeaderText,
										tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left",
										LayoutOrder = 0
									}),
									TextField = React.createElement(TextField, {
										text = textInput,
										placeholder = v4.emailPlaceholder,
										required = true,
										hint = errorText,
										error = errorText ~= "",
										onChange = onTextChange,
										width = UDim.new(1, 0),
										layoutOrder = 1
									})
								}
							),
							DisclaimerFrame = React.createElement(
								"Frame",
								{
									Size = udim,
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									LayoutOrder = 3
								},
								{
									UIListLayout = React.createElement("UIListLayout", {
										SortOrder = Enum.SortOrder.LayoutOrder,
										FillDirection = Enum.FillDirection.Vertical,
										HorizontalAlignment = Enum.HorizontalAlignment.Center,
										VerticalAlignment = Enum.VerticalAlignment.Top
									}),
									Disclaimer = React.createElement(Text, {
										Text = v4.privacyPolicyFooter,
										tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-left",
										LayoutOrder = 1
									}),
									PrivacyPolicy = React.createElement(LinkButton, {
										text = v4.privacyLinkText,
										layoutOrder = 2,
										fontStyle = "Footer",
										underlineAlwaysEnabled = false,
										onActivated = openPrivacyPolicyLink
									})
								}
							)
						}
					)
				}),
				DialogActions = React.createElement(Dialog.Actions, {
					LayoutOrder = 3,
					actions = {
						{
							text = buttonText,
							variant = ButtonVariant.Standard,
							onActivated = function()
								onCollectEmailAndSendRequest(textInput)
							end,
							isDisabled = not canSendRequest
						}
					}
				})
			}
		)
	end

	return React.createElement(
		Dialog.Root,
		{ size = DialogSize.Large, onClose = onCancel, disablePortal = disablePortal },
		{
			DialogTitle = React.createElement(Dialog.Title, { text = titleText }),
			DialogContent = React.createElement(Dialog.Content, { LayoutOrder = 2 }, {
				Frame = React.createElement(
					"Frame",
					{ AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 },
					{
						UIListLayout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Top
						}),
						HeaderText = React.createElement(StyledTextLabel, {
							text = text,
							fontStyle = v3.Font.CaptionHeader,
							colorStyle = v3.Theme.TextDefault,
							textXAlignment = Enum.TextXAlignment.Left,
							textYAlignment = Enum.TextYAlignment.Top,
							textWrapped = true,
							automaticSize = Enum.AutomaticSize.XY,
							layoutOrder = 1,
							lineHeight = 1
						}),
						TextboxFrame = React.createElement(
							"Frame",
							{
								AutomaticSize = Enum.AutomaticSize.XY,
								BackgroundTransparency = 1,
								LayoutOrder = 2
							},
							{
								UIListLayout = React.createElement("UIListLayout", {
									SortOrder = Enum.SortOrder.LayoutOrder,
									FillDirection = Enum.FillDirection.Vertical,
									HorizontalAlignment = Enum.HorizontalAlignment.Left,
									VerticalAlignment = Enum.VerticalAlignment.Top,
									Padding = UDim.new(0, 10)
								}),
								TextFieldHeader = React.createElement(StyledTextLabel, {
									text = textFieldHeaderText,
									fontStyle = v3.Font.Header2,
									colorStyle = v3.Theme.TextDefault,
									textWrapped = true,
									automaticSize = Enum.AutomaticSize.XY,
									layoutOrder = 0
								}),
								TextField = React.createElement(TextField, {
									text = textInput,
									placeholder = v4.emailPlaceholder,
									required = true,
									hint = errorText,
									error = errorText ~= "",
									onChange = onTextChange,
									width = UDim.new(1, 0),
									layoutOrder = 1
								})
							}
						),
						DisclaimerFrame = React.createElement(
							"Frame",
							{
								AutomaticSize = Enum.AutomaticSize.XY,
								BackgroundTransparency = 1,
								LayoutOrder = 3
							},
							{
								UIListLayout = React.createElement("UIListLayout", {
									SortOrder = Enum.SortOrder.LayoutOrder,
									FillDirection = Enum.FillDirection.Vertical,
									HorizontalAlignment = Enum.HorizontalAlignment.Center,
									VerticalAlignment = Enum.VerticalAlignment.Top
								}),
								Disclaimer = React.createElement(StyledTextLabel, {
									text = v4.privacyPolicyFooter,
									fontStyle = v3.Font.Footer,
									colorStyle = v3.Theme.TextDefault,
									textXAlignment = Enum.TextXAlignment.Left,
									textWrapped = true,
									automaticSize = Enum.AutomaticSize.XY,
									layoutOrder = 1,
									lineHeight = 1
								}),
								PrivacyPolicy = React.createElement(LinkButton, {
									text = v4.privacyLinkText,
									layoutOrder = 2,
									fontStyle = "Footer",
									underlineAlwaysEnabled = false,
									onActivated = openPrivacyPolicyLink
								})
							}
						)
					}
				)
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = buttonText,
						variant = ButtonVariant.Standard,
						onActivated = function()
							onCollectEmailAndSendRequest(textInput)
						end,
						isDisabled = not canSendRequest
					}
				}
			})
		}
	)
end

return VPCNewParentUpsell
