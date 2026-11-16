local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactUtils").Hooks.RoactRodux.useSelector
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local linkButton = UIBlox.App.Button.LinkButton
local textField = UIBlox.App.Input.TextField
local buttonType = UIBlox.App.Button.Enum.ButtonType
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Cryo")
local useOnScreenKeyboardHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/useOnScreenKeyboardHeight")

local GetFFlagEnableVPCUpsellFoundationDialogHardening = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetFFlagEnableVPCUpsellFoundationDialogHardening")
local GetShouldUseFoundationUIVPCUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Flags/GetShouldUseFoundationUIVPCUpsell")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Foundation")
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local buttonVariant = Foundation.Enums.ButtonVariant
local text = Foundation.Text

local udim = UDim2.new(1, 0, 0, 0)

local function selectScreenSize(p2)
	return p2.ScreenSize
end

local function VPCNewParentUpsell(props)
	local onCollectEmailAndSendRequest = props.onCollectEmailAndSendRequest
	local onCancel = props.onCancel
	local v5 = useSelector(selectScreenSize)
	local onTextChange = props.onTextChange
	local canSendRequest = props.canSendRequest
	local textInput = props.textInput
	local errorText = props.errorText
	local openPrivacyPolicyLink = props.openPrivacyPolicyLink
	local isChildSubjectToParentalControls = props.isChildSubjectToParentalControls
	local v6 = useOnScreenKeyboardHeight()
	local v7 = if props.disablePortal then props.disablePortal else false
	local v8 = if props.isInExperienceEntry then props.isInExperienceEntry else false
	local v9 = GetShouldUseFoundationUIVPCUpsell(v8)

	local v10 = useStyle()
	local v11 = useLocalization(Cryo.Dictionary.join(props.messageStrings, {
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

	local titleText = v11.titleText
	local buttonText = v11.buttonText
	local v12

	if isChildSubjectToParentalControls then
		if v9 then
			v12 = string.format("%s\n\n%s\n", v11.childInstructions, v11.parentInstructionsPC)
		else
			v12 = string.format("%s\n", v11.directionsTextSubjectToParentalControls)
		end
	elseif v9 then
		v12 = string.format("%s\n\n%s\n", v11.childInstructions, v11.parentInstructionsNoPC)
	else
		v12 = string.format("%s\n", v11.directionsTextNotSubjectToParentalControls)
	end

	local textFieldHeaderText = v11.textFieldHeaderText

	if not v9 then
		return React.createElement(interactiveAlert, {
			title = titleText,
			screenSize = v5,
			position = v6 > 0 and UDim2.new(0.5, 0, 1, -v6 * 0.8) or UDim2.fromScale(0.5, 0.5),
			anchorPoint = v6 > 0 and Vector2.new(0.5, 1) or nil,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = buttonType.PrimarySystem,
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
					{
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1
					},
					{
						UIListLayout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Top
						}),
						HeaderText = React.createElement(styledTextLabel, {
							text = v12,
							fontStyle = v10.Font.CaptionHeader,
							colorStyle = v10.Theme.TextDefault,
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
								TextFieldHeader = React.createElement(styledTextLabel, {
									text = textFieldHeaderText,
									fontStyle = v10.Font.Header2,
									colorStyle = v10.Theme.TextDefault,
									textWrapped = true,
									automaticSize = Enum.AutomaticSize.XY,
									layoutOrder = 0
								}),
								TextField = React.createElement(textField, {
									text = textInput,
									placeholder = v11.emailPlaceholder,
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
								Disclaimer = React.createElement(styledTextLabel, {
									text = v11.privacyPolicyFooter,
									fontStyle = v10.Font.Footer,
									colorStyle = v10.Theme.TextDefault,
									textXAlignment = Enum.TextXAlignment.Left,
									textWrapped = true,
									automaticSize = Enum.AutomaticSize.XY,
									layoutOrder = 1
								}),
								PrivacyPolicy = React.createElement(linkButton, {
									text = v11.privacyLinkText,
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
			dialog.Root,
			{
				size = dialogSize.Large,
				onClose = onCancel,
				disablePortal = v7,
				hasBackdrop = true
			},
			{
				DialogTitle = React.createElement(dialog.Title, { text = titleText }),
				DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
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
							HeaderText = React.createElement(dialog.Text, {
								Text = v12,
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
									TextFieldHeader = React.createElement(text, {
										Text = textFieldHeaderText,
										tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left",
										LayoutOrder = 0
									}),
									TextField = React.createElement(textField, {
										text = textInput,
										placeholder = v11.emailPlaceholder,
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
									Disclaimer = React.createElement(text, {
										Text = v11.privacyPolicyFooter,
										tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-left",
										LayoutOrder = 1
									}),
									PrivacyPolicy = React.createElement(linkButton, {
										text = v11.privacyLinkText,
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
				DialogActions = React.createElement(dialog.Actions, {
					LayoutOrder = 3,
					actions = {
						{
							text = buttonText,
							variant = buttonVariant.Standard,
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
		dialog.Root,
		{ size = dialogSize.Large, onClose = onCancel, disablePortal = v7 },
		{
			DialogTitle = React.createElement(dialog.Title, { text = titleText }),
			DialogContent = React.createElement(dialog.Content, { LayoutOrder = 2 }, {
				Frame = React.createElement(
					"Frame",
					{
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1
					},
					{
						UIListLayout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Top
						}),
						HeaderText = React.createElement(styledTextLabel, {
							text = v12,
							fontStyle = v10.Font.CaptionHeader,
							colorStyle = v10.Theme.TextDefault,
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
								TextFieldHeader = React.createElement(styledTextLabel, {
									text = textFieldHeaderText,
									fontStyle = v10.Font.Header2,
									colorStyle = v10.Theme.TextDefault,
									textWrapped = true,
									automaticSize = Enum.AutomaticSize.XY,
									layoutOrder = 0
								}),
								TextField = React.createElement(textField, {
									text = textInput,
									placeholder = v11.emailPlaceholder,
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
								Disclaimer = React.createElement(styledTextLabel, {
									text = v11.privacyPolicyFooter,
									fontStyle = v10.Font.Footer,
									colorStyle = v10.Theme.TextDefault,
									textXAlignment = Enum.TextXAlignment.Left,
									textWrapped = true,
									automaticSize = Enum.AutomaticSize.XY,
									layoutOrder = 1,
									lineHeight = 1
								}),
								PrivacyPolicy = React.createElement(linkButton, {
									text = v11.privacyLinkText,
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
			DialogActions = React.createElement(dialog.Actions, {
				LayoutOrder = 3,
				actions = {
					{
						text = buttonText,
						variant = buttonVariant.Standard,
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
