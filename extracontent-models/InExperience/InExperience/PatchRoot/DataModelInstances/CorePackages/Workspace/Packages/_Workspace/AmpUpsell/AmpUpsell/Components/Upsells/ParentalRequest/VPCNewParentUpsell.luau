local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local useSelector = require(AmpUpsellParent.RoactUtils).Hooks.RoactRodux.useSelector
local UIBlox = require(AmpUpsellParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local LinkButton = UIBlox.App.Button.LinkButton
local TextField = UIBlox.App.Input.TextField
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local Cryo = require(AmpUpsellParent.Cryo)
local useOnScreenKeyboardHeight = require(AmpUpsell.Common.useOnScreenKeyboardHeight)
local GetFFlagEnableVPCUpsellFoundationDialogHardening = require(AmpUpsell.Flags.GetFFlagEnableVPCUpsellFoundationDialogHardening)
local GetShouldUseFoundationUIVPCUpsell = require(AmpUpsell.Flags.GetShouldUseFoundationUIVPCUpsell)
local Foundation = require(AmpUpsellParent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local FoundationText = Foundation.Text
local uDim2 = UDim2.new(1, 0, 0, 0)

local function selectScreenSize(p1) -- line: 44
	return p1.ScreenSize
end
local function VPCNewParentUpsell(t1: {[any]: any}) -- line: 48
	-- upvalues: useSelector (copy), selectScreenSize (copy), useOnScreenKeyboardHeight (copy), GetShouldUseFoundationUIVPCUpsell (copy), useStyle (copy), useLocalization (copy), Cryo (copy), GetFFlagEnableVPCUpsellFoundationDialogHardening (copy), React (copy), Dialog (copy), DialogSize (copy), uDim2 (copy), FoundationText (copy), TextField (copy), LinkButton (copy), ButtonVariant (copy), StyledTextLabel (copy), InteractiveAlert (copy), ButtonType (copy)
	local onCollectEmailAndSendRequest = t1.onCollectEmailAndSendRequest
	local onCancel = t1.onCancel
	local v29 = useSelector(selectScreenSize)
	local onTextChange = t1.onTextChange
	local canSendRequest = t1.canSendRequest
	local textInput = t1.textInput
	local errorText = t1.errorText
	local openPrivacyPolicyLink = t1.openPrivacyPolicyLink
	local isChildSubjectToParentalControls = t1.isChildSubjectToParentalControls
	local v36 = useOnScreenKeyboardHeight()
	local v37 = not not t1.disablePortal and t1.disablePortal
	local v38 = not not t1.isInExperienceEntry and t1.isInExperienceEntry
	local v39 = GetShouldUseFoundationUIVPCUpsell(v38)
	local v40 = useStyle()
	local v41 = useLocalization(Cryo.Dictionary.join(t1.messageStrings, {
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
	local titleText = v41.titleText
	local buttonText = v41.buttonText
	local u44 = if not isChildSubjectToParentalControls then if not v39 then string.format("%s\n", v41.directionsTextNotSubjectToParentalControls) else string.format("%s\n\n%s\n", v41.childInstructions, v41.parentInstructionsNoPC) else if not v39 then string.format("%s\n", v41.directionsTextSubjectToParentalControls) else string.format("%s\n\n%s\n", v41.childInstructions, v41.parentInstructionsPC)
	local textFieldHeaderText = v41.textFieldHeaderText

	if v39 then
		if GetFFlagEnableVPCUpsellFoundationDialogHardening() then
			return React.createElement(Dialog.Root, {
				hasBackdrop = true,
				size = DialogSize.Large,
				onClose = onCancel,
				disablePortal = v37
			}, {
				DialogTitle = React.createElement(Dialog.Title, {
					text = titleText
				}),
				DialogContent = React.createElement(Dialog.Content, {
					LayoutOrder = 2
				}, {
					Frame = React.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = uDim2,
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Top
						}),
						HeaderText = React.createElement(Dialog.Text, {
							LayoutOrder = 1,
							Text = u44
						}),
						TextboxFrame = React.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Size = uDim2,
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							UIListLayout = React.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								VerticalAlignment = Enum.VerticalAlignment.Top,
								Padding = UDim.new(0, 10)
							}),
							TextFieldHeader = React.createElement(FoundationText, {
								tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left",
								LayoutOrder = 0,
								Text = textFieldHeaderText
							}),
							TextField = React.createElement(TextField, {
								required = true,
								layoutOrder = 1,
								text = textInput,
								placeholder = v41.emailPlaceholder,
								hint = errorText,
								error = errorText ~= "",
								onChange = onTextChange,
								width = UDim.new(1, 0)
							})
						}),
						DisclaimerFrame = React.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							Size = uDim2,
							AutomaticSize = Enum.AutomaticSize.Y
						}, {
							UIListLayout = React.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								VerticalAlignment = Enum.VerticalAlignment.Top
							}),
							Disclaimer = React.createElement(FoundationText, {
								tag = "size-full-0 auto-y text-caption-medium text-wrap text-align-x-left",
								LayoutOrder = 1,
								Text = v41.privacyPolicyFooter
							}),
							PrivacyPolicy = React.createElement(LinkButton, {
								layoutOrder = 2,
								fontStyle = "Footer",
								underlineAlwaysEnabled = false,
								text = v41.privacyLinkText,
								onActivated = openPrivacyPolicyLink
							})
						})
					})
				}),
				DialogActions = React.createElement(Dialog.Actions, {
					LayoutOrder = 3,
					actions = {{
						text = buttonText,
						variant = ButtonVariant.Standard,
						onActivated = function() -- line: 187
							-- upvalues: onCollectEmailAndSendRequest (copy), textInput (copy)
							onCollectEmailAndSendRequest(textInput)
						end,
						isDisabled = not canSendRequest
					}}
				})
			})
		end

		return React.createElement(Dialog.Root, {
			size = DialogSize.Large,
			onClose = onCancel,
			disablePortal = v37
		}, {
			DialogTitle = React.createElement(Dialog.Title, {
				text = titleText
			}),
			DialogContent = React.createElement(Dialog.Content, {
				LayoutOrder = 2
			}, {
				Frame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Top
					}),
					HeaderText = React.createElement(StyledTextLabel, {
						textWrapped = true,
						layoutOrder = 1,
						lineHeight = 1,
						text = u44,
						fontStyle = v40.Font.CaptionHeader,
						colorStyle = v40.Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Left,
						textYAlignment = Enum.TextYAlignment.Top,
						automaticSize = Enum.AutomaticSize.XY
					}),
					TextboxFrame = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						AutomaticSize = Enum.AutomaticSize.XY
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Top,
							Padding = UDim.new(0, 10)
						}),
						TextFieldHeader = React.createElement(StyledTextLabel, {
							textWrapped = true,
							layoutOrder = 0,
							text = textFieldHeaderText,
							fontStyle = v40.Font.Header2,
							colorStyle = v40.Theme.TextDefault,
							automaticSize = Enum.AutomaticSize.XY
						}),
						TextField = React.createElement(TextField, {
							required = true,
							layoutOrder = 1,
							text = textInput,
							placeholder = v41.emailPlaceholder,
							hint = errorText,
							error = errorText ~= "",
							onChange = onTextChange,
							width = UDim.new(1, 0)
						})
					}),
					DisclaimerFrame = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						AutomaticSize = Enum.AutomaticSize.XY
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Top
						}),
						Disclaimer = React.createElement(StyledTextLabel, {
							textWrapped = true,
							layoutOrder = 1,
							lineHeight = 1,
							text = v41.privacyPolicyFooter,
							fontStyle = v40.Font.Footer,
							colorStyle = v40.Theme.TextDefault,
							textXAlignment = Enum.TextXAlignment.Left,
							automaticSize = Enum.AutomaticSize.XY
						}),
						PrivacyPolicy = React.createElement(LinkButton, {
							layoutOrder = 2,
							fontStyle = "Footer",
							underlineAlwaysEnabled = false,
							text = v41.privacyLinkText,
							onActivated = openPrivacyPolicyLink
						})
					})
				})
			}),
			DialogActions = React.createElement(Dialog.Actions, {
				LayoutOrder = 3,
				actions = {{
					text = buttonText,
					variant = ButtonVariant.Standard,
					onActivated = function() -- line: 301
						-- upvalues: onCollectEmailAndSendRequest (copy), textInput (copy)
						onCollectEmailAndSendRequest(textInput)
					end,
					isDisabled = not canSendRequest
				}}
			})
		})
	end

	return React.createElement(InteractiveAlert, {
		bottomPadding = 0,
		title = titleText,
		screenSize = v29,
		position = v36 > 0 and UDim2.new(0.5, 0, 1, -v36 * 0.8) or UDim2.fromScale(0.5, 0.5),
		anchorPoint = v36 > 0 and Vector2.new(0.5, 1) or nil,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = function() -- line: 321
						-- upvalues: onCollectEmailAndSendRequest (copy), textInput (copy)
						onCollectEmailAndSendRequest(textInput)
					end,
					text = buttonText,
					isDisabled = not canSendRequest
				}
			}}
		},
		onCloseClicked = onCancel,
		middleContent = function() -- line: 332
			-- upvalues: React (copy), StyledTextLabel (copy), u44 (ref), v40 (copy), textFieldHeaderText (copy), TextField (copy), textInput (copy), v41 (copy), errorText (copy), onTextChange (copy), LinkButton (copy), openPrivacyPolicyLink (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				HeaderText = React.createElement(StyledTextLabel, {
					textWrapped = true,
					layoutOrder = 1,
					text = u44,
					fontStyle = v40.Font.CaptionHeader,
					colorStyle = v40.Theme.TextDefault,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Top,
					automaticSize = Enum.AutomaticSize.XY
				}),
				TextboxFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						Padding = UDim.new(0, 10)
					}),
					TextFieldHeader = React.createElement(StyledTextLabel, {
						textWrapped = true,
						layoutOrder = 0,
						text = textFieldHeaderText,
						fontStyle = v40.Font.Header2,
						colorStyle = v40.Theme.TextDefault,
						automaticSize = Enum.AutomaticSize.XY
					}),
					TextField = React.createElement(TextField, {
						required = true,
						layoutOrder = 1,
						text = textInput,
						placeholder = v41.emailPlaceholder,
						hint = errorText,
						error = errorText ~= "",
						onChange = onTextChange,
						width = UDim.new(1, 0)
					})
				}),
				DisclaimerFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Top
					}),
					Disclaimer = React.createElement(StyledTextLabel, {
						textWrapped = true,
						layoutOrder = 1,
						text = v41.privacyPolicyFooter,
						fontStyle = v40.Font.Footer,
						colorStyle = v40.Theme.TextDefault,
						textXAlignment = Enum.TextXAlignment.Left,
						automaticSize = Enum.AutomaticSize.XY
					}),
					PrivacyPolicy = React.createElement(LinkButton, {
						layoutOrder = 2,
						fontStyle = "Footer",
						underlineAlwaysEnabled = false,
						text = v41.privacyLinkText,
						onActivated = openPrivacyPolicyLink
					})
				})
			})
		end
	})
end

return VPCNewParentUpsell
