local HttpService = game:GetService("HttpService")
local EditProfile = script:FindFirstAncestor("EditProfile")
local EditProfileParent = EditProfile.Parent
local LuaSocialLibrariesDeps = require(EditProfileParent.LuaSocialLibrariesDeps)
local React = require(EditProfileParent.React)
local UIBlox = require(EditProfileParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local CallbackInputBox = LuaSocialLibrariesDeps.SocialLibraries.config({}).Components.CallbackInputBox
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local Constants = require(EditProfile.Common.Constants)
local TextKeys = require(EditProfile.Common.TextKeys)
local LuauPolyfill = require(EditProfileParent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local EditProfileIXP = require(EditProfile.Flags.EditProfileIXP)
local InternationalNamesIXP = require(EditProfile.Flags.InternationalNamesIXP)
local FFlagEditProfileFixFocusNavigation = require(EditProfile.Flags.FFlagEditProfileFixFocusNavigation)
local Analytics = require(EditProfile.Analytics)
local EventNames = Analytics.EventNames
local useAnalytics = Analytics.useAnalytics
local v26 = game:DefineFastFlag("NameNotAvailableErrorEnabled", false)
local useDisplayNameText = require(EditProfile.Hooks.useDisplayNameText)
local FocusNavigatorWrapper = require(EditProfile.Utils.FocusNavigatorWrapper)
local v29 = game:DefineFastInt("EditProfileModalNetworkDelay", 500)

return function(p1) -- line: 61
	-- upvalues: React (copy), useDisplayNameText (copy), useLocalization (copy), TextKeys (copy), EditProfileIXP (copy), useAnalytics (copy), useStyle (copy), setTimeout (copy), v29 (copy), Constants (copy), v26 (copy), InternationalNamesIXP (copy), clearTimeout (copy), EventNames (copy), HttpService (copy), FFlagEditProfileFixFocusNavigation (copy), FocusNavigatorWrapper (copy), InteractiveAlert (copy), ImageSetLabel (copy), Images (copy), CallbackInputBox (copy), IconSize (copy), ButtonType (copy)
	local v31 = React.useRef(nil)
	local v32 = useDisplayNameText()
	local v33, v34 = React.useState(p1.initialText)
	local v35 = utf8.len(v33) or 0
	local v36 = useLocalization({
		cancelButtonText = TextKeys.CancelButtonText,
		saveButtonText = TextKeys.SaveButtonText
	})
	local v37 = if not EditProfileIXP.useIsExperimentEnabled() then nil else useAnalytics()
	local v38 = useStyle()
	local Font = v38.Font
	local Theme = v38.Theme
	local v41 = Font.BaseSize * Font.Body.RelativeSize
	local v42, v43 = React.useState(true)
	local v44, v45 = React.useState(false)
	local v46, v47 = React.useState(v32.displayNameChangeError)
	local v48 = React.useRef(setTimeout(function() -- line: 85
	end, v29))
	local v49 = React.useRef(false)

	local function getErrorMessage(n1: number) -- line: 88
		-- upvalues: Constants (copy), v32 (copy), v26 (copy)
		return ({
			[Constants.DisplayNameValidationErrorCodes.TooShort] = v32.nameTooShortError,
			[Constants.DisplayNameValidationErrorCodes.TooLong] = v32.nameTooLongError,
			[Constants.DisplayNameValidationErrorCodes.InvalidCharacters] = v32.nameUnsupportedCharsError,
			[Constants.DisplayNameValidationErrorCodes.Moderated] = v32.nameInappropriateError,
			[Constants.DisplayNameValidationErrorCodes.Throttled] = v32.nameHasChangedError,
			[Constants.DisplayNameValidationErrorCodes.InvalidCharacterSetCombination] = v32.displayNameChangeMixedCharactersError,
			[Constants.DisplayNameValidationErrorCodes.NameNotAvailable] = if not v26 then nil else v32.nameNotAvailableError
		})[n1] or v32.displayNameChangeError
	end
	local function textChanged(s1: string) -- line: 103
		-- upvalues: p1 (copy), v49 (copy), InternationalNamesIXP (copy), clearTimeout (copy), v48 (copy), v43 (copy), v37 (copy), EventNames (copy), v47 (copy), v32 (copy), v45 (copy), v34 (copy), v35 (copy), v33 (copy), v31 (copy), setTimeout (copy), HttpService (copy), getErrorMessage (copy), v29 (copy)
		if s1 ~= p1.initialText and not v49.current then
			v49.current = true
			InternationalNamesIXP.logExposure()
		end

		clearTimeout(v48.current)
		v43(false)

		local v56 = utf8.len(s1)

		if v56 == nil then
			return
		end

		if v56 < 3 then
			if v37 then
				v37.fireAnalyticsEvent(EventNames.DisplayNameTooShort, {
					displayName = s1
				})
			end

			v47(v32.displayNameTooShortError)
			v45(true)
			v34(s1)

			return
		end

		if v56 > 20 then
			local v57 = if v35 ~= 20 then string.sub(s1, 1, utf8.offset(s1, 21) - 1) else v33

			if v31 and v31.current then
				v31.current.Text = v57
			end

			v34(v57)

			return
		end

		v34(s1)
		v48.current = setTimeout(function() -- line: 151
			-- upvalues: p1 (copy), HttpService (copy), s1 (ref), v45 (copy), v43 (copy), getErrorMessage (copy), v37 (copy), EventNames (copy), v47 (copy)
			p1.validateDisplayName(HttpService:UrlEncode(s1)):andThen(function(_) -- line: 154
				-- upvalues: v45 (copy), v43 (copy)
				v45(false)
				v43(true)
			end):catch(function(p3) -- line: 158
				-- upvalues: HttpService (copy), getErrorMessage (copy), v37 (copy), EventNames (copy), s1 (ref), v47 (copy), v45 (copy)
				local ok, result = pcall(function() -- line: 159
					-- upvalues: HttpService (copy), p3 (copy)
					return HttpService:JSONDecode(p3.Body)
				end)
				local n2 = -1

				if ok then
					n2 = result and (not not result.errors and (not not result.errors[1] and result.errors[1].code)) or -1
				end

				local v63 = getErrorMessage(n2)

				if v37 then
					v37.fireAnalyticsEvent(EventNames.FilteredDisplayName, {
						displayName = s1
					})
				end

				v47(v63)
				v45(true)
			end)
		end, v29)
	end
	local function onSave() -- line: 179
		-- upvalues: v33 (copy), p1 (copy)
		if v33 == p1.initialText then
			p1.cancelOnActivated()

			return
		end

		p1.saveOnActivated(v33)
	end

	if FFlagEditProfileFixFocusNavigation then
		return FocusNavigatorWrapper({
			onClose = p1.cancelOnActivated
		}, { React.createElement(InteractiveAlert, {
			title = p1.title,
			screenSize = p1.screenSize,
			anchorPoint = Vector2.new(0.5, 0),
			position = UDim2.new(0.5, 0, 0, 117),
			middleContent = function() -- line: 196
				-- upvalues: React (copy), Font (copy), p1 (copy), Theme (copy), ImageSetLabel (copy), v41 (copy), Images (copy), v44 (copy), CallbackInputBox (copy), IconSize (copy), textChanged (copy), v31 (copy), v46 (copy), v35 (copy)
				return React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					InputGroup = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 0),
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
							Font = Font.Body.Font,
							Text = p1.description,
							TextColor3 = Theme.TextDefault.Color,
							AutomaticSize = Enum.AutomaticSize.XY,
							TextXAlignment = Enum.TextXAlignment.Center
						}),
						Padding = React.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 2,
							Size = UDim2.new(1, 0, 0, 24)
						}),
						InputBackground = React.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							Size = UDim2.new(1, 0, 0, v41 + 20),
							Image = Images["component_assets/circle_21"],
							ImageColor3 = Theme.UIMuted.Color,
							ImageTransparency = Theme.UIMuted.Transparency,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(8, 8, 9, 9)
						}, {
							InputBorder = React.createElement(ImageSetLabel, {
								BackgroundTransparency = 1,
								LayoutOrder = 1,
								Size = UDim2.new(1, 0, 0, v41 + 20),
								Image = Images["component_assets/circle_21_stroke_1"],
								ImageColor3 = if not v44 then Theme.Divider.Color else Theme.Alert.Color,
								ScaleType = Enum.ScaleType.Slice,
								SliceCenter = Rect.new(8, 8, 9, 9)
							}, {
								Padding = React.createElement("UIPadding", {
									PaddingLeft = UDim.new(0, 12),
									PaddingRight = UDim.new(0, 12)
								}),
								Textbox = React.createElement(CallbackInputBox, {
									captureFocusOnMount = true,
									clearButtonDisabled = false,
									inputTextXAlignment = Enum.TextXAlignment.Left,
									inputTextColor3 = Theme.TextDefault.Color,
									inputTextTransparency = Theme.TextDefault.Transparency,
									inputTextSize = v41,
									initialInputText = p1.initialText,
									placeholderText = p1.initialText,
									placeholderTextColor3 = Theme.TextDefault.Color,
									clearIcon = Images["icons/actions/edit/clear_small"],
									clearIconColor3 = Theme.IconEmphasis.Color,
									clearIconTransparency = Theme.IconEmphasis.Transparency,
									clearButtonSize = IconSize.Small,
									textChangedCallback = textChanged,
									inputBoxRef = v31
								})
							})
						}),
						AdditonalPadding = React.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 4,
							Size = UDim2.new(1, 0, 0, 8)
						}),
						Counter = React.createElement("Frame", {
							BackgroundTransparency = 1,
							LayoutOrder = 5,
							Size = UDim2.fromScale(1, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						}, { React.createElement("TextLabel", {
							BackgroundTransparency = 1,
							TextWrapped = true,
							Font = Font.CaptionBody.Font,
							Text = if not v44 then string.format("%d/%d", v35, 20) else v46,
							TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize,
							TextColor3 = if v35 ~= 20 and not v44 then Theme.TextMuted.Color else Theme.Alert.Color,
							TextTransparency = if v35 ~= 20 and not v44 then Theme.TextMuted.Transparency else Theme.Alert.Transparency,
							AnchorPoint = if not v44 then Vector2.new(1, 0) else nil,
							Position = if not v44 then UDim2.fromScale(1, 0) else nil,
							AutomaticSize = Enum.AutomaticSize.XY,
							TextXAlignment = Enum.TextXAlignment.Left
						}, {
							UISizeConstraint = React.createElement("UISizeConstraint", {
								MaxSize = Vector2.new(1e999, Font.BaseSize * Font.CaptionBody.RelativeSize * 2)
							})
						}) })
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
							onActivated = p1.cancelOnActivated,
							text = v36.cancelButtonText
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = onSave,
							text = v36.saveButtonText,
							isDisabled = not v42
						}
					}
				},
				forcedFillDirection = Enum.FillDirection.Horizontal
			}
		}) })
	end

	return React.createElement(InteractiveAlert, {
		title = p1.title,
		screenSize = p1.screenSize,
		anchorPoint = Vector2.new(0.5, 0),
		position = UDim2.new(0.5, 0, 0, 117),
		middleContent = function() -- line: 349
			-- upvalues: React (copy), Font (copy), p1 (copy), Theme (copy), ImageSetLabel (copy), v41 (copy), Images (copy), v44 (copy), CallbackInputBox (copy), IconSize (copy), textChanged (copy), v31 (copy), v46 (copy), v35 (copy)
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				InputGroup = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.fromScale(1, 0),
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
						Font = Font.Body.Font,
						Text = p1.description,
						TextColor3 = Theme.TextDefault.Color,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextXAlignment = Enum.TextXAlignment.Center
					}),
					Padding = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, 24)
					}),
					InputBackground = React.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, v41 + 20),
						Image = Images["component_assets/circle_21"],
						ImageColor3 = Theme.UIMuted.Color,
						ImageTransparency = Theme.UIMuted.Transparency,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(8, 8, 9, 9)
					}, {
						InputBorder = React.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 0, v41 + 20),
							Image = Images["component_assets/circle_21_stroke_1"],
							ImageColor3 = if not v44 then Theme.Divider.Color else Theme.Alert.Color,
							ScaleType = Enum.ScaleType.Slice,
							SliceCenter = Rect.new(8, 8, 9, 9)
						}, {
							Padding = React.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, 12),
								PaddingRight = UDim.new(0, 12)
							}),
							Textbox = React.createElement(CallbackInputBox, {
								captureFocusOnMount = true,
								clearButtonDisabled = false,
								inputTextXAlignment = Enum.TextXAlignment.Left,
								inputTextColor3 = Theme.TextDefault.Color,
								inputTextTransparency = Theme.TextDefault.Transparency,
								inputTextSize = v41,
								initialInputText = p1.initialText,
								placeholderText = p1.initialText,
								placeholderTextColor3 = Theme.TextDefault.Color,
								clearIcon = Images["icons/actions/edit/clear_small"],
								clearIconColor3 = Theme.IconEmphasis.Color,
								clearIconTransparency = Theme.IconEmphasis.Transparency,
								clearButtonSize = IconSize.Small,
								textChangedCallback = textChanged,
								inputBoxRef = v31
							})
						})
					}),
					AdditonalPadding = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 4,
						Size = UDim2.new(1, 0, 0, 8)
					}),
					Counter = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 5,
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, { React.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Font = Font.CaptionBody.Font,
						Text = if not v44 then string.format("%d/%d", v35, 20) else v46,
						TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize,
						TextColor3 = if v35 ~= 20 and not v44 then Theme.TextMuted.Color else Theme.Alert.Color,
						TextTransparency = if v35 ~= 20 and not v44 then Theme.TextMuted.Transparency else Theme.Alert.Transparency,
						AnchorPoint = if not v44 then Vector2.new(1, 0) else nil,
						Position = if not v44 then UDim2.fromScale(1, 0) else nil,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextXAlignment = Enum.TextXAlignment.Left
					}, {
						UISizeConstraint = React.createElement("UISizeConstraint", {
							MaxSize = Vector2.new(1e999, Font.BaseSize * Font.CaptionBody.RelativeSize * 2)
						})
					}) })
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
						onActivated = p1.cancelOnActivated,
						text = v36.cancelButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = onSave,
						text = v36.saveButtonText,
						isDisabled = not v42
					}
				}
			},
			forcedFillDirection = Enum.FillDirection.Horizontal
		}
	})
end
