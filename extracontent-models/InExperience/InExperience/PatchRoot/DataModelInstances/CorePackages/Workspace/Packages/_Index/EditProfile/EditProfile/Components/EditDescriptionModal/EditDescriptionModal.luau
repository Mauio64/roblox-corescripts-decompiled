local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local LuaSocialLibrariesDeps = require(EditProfileParent.LuaSocialLibrariesDeps)
local React = require(EditProfileParent.React)
local UIBlox = require(EditProfileParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local CallbackInputBox = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.CallbackInputBox
local FFlagDescriptionModalThrottleError = require(EditProfile.Flags.FFlagDescriptionModalThrottleError)
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local TextKeys = require(EditProfile.Common.TextKeys)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)

return function(t1: {[any]: any}) -- line: 48
	-- upvalues: React (copy), useLocalization (copy), TextKeys (copy), useStyle (copy), FFlagEditProfileFixFocusNavigation (copy), FocusNavigatorWrapper (copy), InteractiveAlert (copy), ImageSetLabel (copy), Images (copy), CallbackInputBox (copy), FFlagDescriptionModalThrottleError (copy), ButtonType (copy)
	local v18 = React.useRef(nil)
	local v19, v20 = React.useState(t1.initialText)
	local v21 = string.len(v19)
	local v22 = useLocalization({
		cancelButtonText = TextKeys.CancelButtonText,
		saveButtonText = TextKeys.SaveButtonText,
		saySomething = TextKeys.SaySomething,
		pinLocked = TextKeys.PinLocked
	})
	local v23 = useStyle()
	local Font = v23.Font
	local Theme = v23.Theme
	local v26 = Font.BaseSize * Font.Body.RelativeSize

	local function textChanged(s1: string) -- line: 65
		-- upvalues: v18 (copy), v20 (copy)
		if string.len(s1) > 1000 then
			s1 = string.sub(s1, 1, 1000)

			if v18 and v18.current then
				v18.current.Text = s1
			end
		end

		v20(s1)
	end
	local function onSave() -- line: 78
		-- upvalues: t1 (copy), v19 (copy)
		t1.saveOnActivated(v19)
	end

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({
			onClose = t1.cancelOnActivated
		}, { React.createElement(InteractiveAlert, {
			title = t1.title,
			screenSize = t1.screenSize,
			anchorPoint = Vector2.new(0.5, 0),
			position = UDim2.new(0.5, 0, 0, 44),
			middleContent = function() -- line: 90
				-- upvalues: React (copy), Font (copy), t1 (copy), Theme (copy), ImageSetLabel (copy), Images (copy), CallbackInputBox (copy), v26 (copy), v22 (copy), textChanged (copy), v18 (copy), FFlagDescriptionModalThrottleError (copy), v21 (copy)
				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					InputGroup = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 1),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						Description = React.createElement("TextLabel", {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							TextWrapped = true,
							TextSize = 14,
							RichText = true,
							TextXAlignment = Enum.TextXAlignment.Center,
							Font = Font.Body.Font,
							Text = t1.description,
							TextColor3 = Theme.TextDefault.Color,
							AutomaticSize = Enum.AutomaticSize.XY
						}),
						Padding = React.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Size = UDim2.new(1, 0, 0, 24)
						}),
						InputBackground = React.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							Size = UDim2.new(1, 0, 0, 144),
							Image = Images["component_assets/circle_21"],
							ImageColor3 = Theme.UIMuted.Color,
							ImageTransparency = Theme.UIMuted.Transparency,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(8, 8, 9, 9)
						}, {
							InputBorder = React.createElement(ImageSetLabel, {
								BackgroundTransparency = 1,
								LayoutOrder = 1,
								Size = UDim2.new(1, 0, 0, 144),
								Image = Images["component_assets/circle_21_stroke_1"],
								ImageColor3 = Theme.Divider.Color,
								ScaleType = Enum.ScaleType.Slice,
								SliceCenter = Rect.new(8, 8, 9, 9)
							}, {
								Padding = React.createElement("UIPadding", {
									PaddingLeft = UDim.new(0, 12),
									PaddingRight = UDim.new(0, 12),
									PaddingTop = UDim.new(0, 7)
								}),
								Textbox = React.createElement(CallbackInputBox, {
									captureFocusOnMount = true,
									multiLine = true,
									textWrapped = true,
									clearButtonDisabled = true,
									clearButtonSize = 0,
									inputTextXAlignment = Enum.TextXAlignment.Left,
									inputTextYAlignment = Enum.TextYAlignment.Top,
									inputTextColor3 = Theme.TextDefault.Color,
									inputTextTransparency = Theme.TextDefault.Transparency,
									inputTextSize = v26,
									initialInputText = t1.initialText,
									placeholderText = v22.saySomething,
									placeholderTextColor3 = Theme.TextDefault.Color,
									textChangedCallback = textChanged,
									inputBoxRef = v18
								})
							})
						}),
						Counter = React.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 4,
							Size = UDim2.new(1, 0, 0, 22)
						}, {
							ThrottleError = if not FFlagDescriptionModalThrottleError or not t1.throttleError then nil else React.createElement("TextLabel", {
								BackgroundTransparency = 1,
								TextXAlignment = 0,
								Position = UDim2.fromScale(0, 0.4),
								AutomaticSize = Enum.AutomaticSize.XY,
								Font = Font.CaptionBody.Font,
								Text = t1.throttleErrorText,
								TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize * 0.9,
								TextColor3 = Theme.Alert.Color,
								TextTransparency = Theme.Alert.Transparency
							}),
							React.createElement("TextLabel", {
								BackgroundTransparency = 1,
								TextWrapped = true,
								AutomaticSize = Enum.AutomaticSize.XY,
								Font = Font.CaptionBody.Font,
								Text = if not t1.textError then string.format("%d/%d", v21, 1000) else v22.pinLocked,
								TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize,
								TextColor3 = if v21 ~= 1000 and not t1.textError then Theme.TextMuted.Color else Theme.Alert.Color,
								TextTransparency = if v21 ~= 1000 and not t1.textError then Theme.TextMuted.Transparency else Theme.Alert.Transparency,
								AnchorPoint = if not t1.textError then Vector2.new(1, 1) else Vector2.new(0, 1),
								Position = if not t1.textError then UDim2.fromScale(1, 1) else UDim2.fromScale(0, 1)
							}, {
								UISizeConstraint = React.createElement("UISizeConstraint", {
									MaxSize = Vector2.new(1e999, Font.BaseSize * Font.CaptionBody.RelativeSize * 2)
								})
							})
						})
					})
				})
			end,
			buttonStackInfo = {
				buttonHeight = 48,
				marginBetween = 6,
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = t1.cancelOnActivated,
							text = v22.cancelButtonText
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = onSave,
							text = v22.saveButtonText
						}
					}
				},
				forcedFillDirection = Enum.FillDirection.Horizontal
			}
		}) })
	end

	return React.createElement(InteractiveAlert, {
		title = t1.title,
		screenSize = t1.screenSize,
		anchorPoint = Vector2.new(0.5, 0),
		position = UDim2.new(0.5, 0, 0, 44),
		middleContent = function() -- line: 247
			-- upvalues: React (copy), Font (copy), t1 (copy), Theme (copy), ImageSetLabel (copy), Images (copy), CallbackInputBox (copy), v26 (copy), v22 (copy), textChanged (copy), v18 (copy), FFlagDescriptionModalThrottleError (copy), v21 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				InputGroup = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.fromScale(1, 1),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Description = React.createElement("TextLabel", {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						TextWrapped = true,
						TextSize = 14,
						RichText = true,
						TextXAlignment = Enum.TextXAlignment.Center,
						Font = Font.Body.Font,
						Text = t1.description,
						TextColor3 = Theme.TextDefault.Color,
						AutomaticSize = Enum.AutomaticSize.XY
					}),
					Padding = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, 24)
					}),
					InputBackground = React.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, 144),
						Image = Images["component_assets/circle_21"],
						ImageColor3 = Theme.UIMuted.Color,
						ImageTransparency = Theme.UIMuted.Transparency,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(8, 8, 9, 9)
					}, {
						InputBorder = React.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 0, 144),
							Image = Images["component_assets/circle_21_stroke_1"],
							ImageColor3 = Theme.Divider.Color,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(8, 8, 9, 9)
						}, {
							Padding = React.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, 12),
								PaddingRight = UDim.new(0, 12),
								PaddingTop = UDim.new(0, 7)
							}),
							Textbox = React.createElement(CallbackInputBox, {
								captureFocusOnMount = true,
								multiLine = true,
								textWrapped = true,
								clearButtonDisabled = true,
								clearButtonSize = 0,
								inputTextXAlignment = Enum.TextXAlignment.Left,
								inputTextYAlignment = Enum.TextYAlignment.Top,
								inputTextColor3 = Theme.TextDefault.Color,
								inputTextTransparency = Theme.TextDefault.Transparency,
								inputTextSize = v26,
								initialInputText = t1.initialText,
								placeholderText = v22.saySomething,
								placeholderTextColor3 = Theme.TextDefault.Color,
								textChangedCallback = textChanged,
								inputBoxRef = v18
							})
						})
					}),
					Counter = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 4,
						Size = UDim2.new(1, 0, 0, 22)
					}, {
						ThrottleError = if not FFlagDescriptionModalThrottleError or not t1.throttleError then nil else React.createElement("TextLabel", {
							BackgroundTransparency = 1,
							TextXAlignment = 0,
							Position = UDim2.fromScale(0, 0.4),
							AutomaticSize = Enum.AutomaticSize.XY,
							Font = Font.CaptionBody.Font,
							Text = t1.throttleErrorText,
							TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize * 0.9,
							TextColor3 = Theme.Alert.Color,
							TextTransparency = Theme.Alert.Transparency
						}),
						React.createElement("TextLabel", {
							BackgroundTransparency = 1,
							TextWrapped = true,
							AutomaticSize = Enum.AutomaticSize.XY,
							Font = Font.CaptionBody.Font,
							Text = if not t1.textError then string.format("%d/%d", v21, 1000) else v22.pinLocked,
							TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize,
							TextColor3 = if v21 ~= 1000 and not t1.textError then Theme.TextMuted.Color else Theme.Alert.Color,
							TextTransparency = if v21 ~= 1000 and not t1.textError then Theme.TextMuted.Transparency else Theme.Alert.Transparency,
							AnchorPoint = if not t1.textError then Vector2.new(1, 1) else Vector2.new(0, 1),
							Position = if not t1.textError then UDim2.fromScale(1, 1) else UDim2.fromScale(0, 1)
						}, {
							UISizeConstraint = React.createElement("UISizeConstraint", {
								MaxSize = Vector2.new(1e999, Font.BaseSize * Font.CaptionBody.RelativeSize * 2)
							})
						})
					})
				})
			})
		end,
		buttonStackInfo = {
			buttonHeight = 48,
			marginBetween = 6,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = t1.cancelOnActivated,
						text = v22.cancelButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = onSave,
						text = v22.saveButtonText
					}
				}
			},
			forcedFillDirection = Enum.FillDirection.Horizontal
		}
	})
end
