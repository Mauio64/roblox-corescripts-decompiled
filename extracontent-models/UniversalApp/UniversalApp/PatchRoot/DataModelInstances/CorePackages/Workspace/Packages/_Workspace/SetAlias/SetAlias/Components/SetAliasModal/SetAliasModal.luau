local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local dependencies = require(ParentParent.dependencies)
local TextKeys = require(ParentParent.Common.TextKeys)
local Analytics = require(ParentParent.Analytics)
local EventNames = Analytics.EventNames
local useAnalytics = Analytics.useAnalytics
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local Foundation = dependencies.Foundation
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local RoactFitComponents = dependencies.RoactFitComponents
local useLocalization = dependencies.Hooks.useLocalization
local SocialLibraries = dependencies.SocialLibraries
local RoactUtils = require(ParentParentParent.RoactUtils)
local FocusNavigationUtils = require(ParentParentParent.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(ParentParentParent.InputHandlers)

require(ParentParentParent.ReactFocusNavigation)

local FitFrameVertical = RoactFitComponents.FitFrameVertical
local FitTextLabel = RoactFitComponents.FitTextLabel
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local IconSize = UIBlox.App.Constant.IconSize
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local CallbackInputBox = SocialLibraries.Components.CallbackInputBox
local FFlagConnectionsToFriendsRename = require(ParentParentParent.SharedFlags).FFlagConnectionsToFriendsRename
local FFlagSetAliasFixFocusNavigation = require(ParentParent.Flags.FFlagSetAliasFixFocusNavigation)

return function(t1: {[any]: any}) -- line: 63
	-- upvalues: React (copy), useEffectOnce (copy), useStyle (copy), useLocalization (copy), TextKeys (copy), FFlagConnectionsToFriendsRename (copy), useAnalytics (copy), EventNames (copy), FFlagSetAliasFixFocusNavigation (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), InteractiveAlert (copy), FitFrameVertical (copy), FitTextLabel (copy), Skeleton (copy), EnumsRadius (copy), ImageSetLabel (copy), Images (copy), CallbackInputBox (copy), IconSize (copy), ButtonType (copy), FocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy)
	local v35 = React.useRef(nil)
	local v36, v37 = React.useState(Vector2.new(0, 0))
	local v38, v39 = React.useState(t1.alias)
	local v40 = not t1.alias and 0 or (utf8.len(t1.alias) or 0)
	local v41, v42 = React.useState(v40)

	useEffectOnce(function() -- line: 70
		-- upvalues: v39 (copy), t1 (copy), v42 (copy), v40 (copy)
		v39(t1.alias)
		v42(v40)
	end, t1.isLoading == false)

	local v43 = useStyle()
	local Font = v43.Font
	local Theme = v43.Theme
	local v46 = Font.BaseSize * Font.Body.RelativeSize
	local v47 = useLocalization({
		titleText = TextKeys.CUSTOMIZE_NAME_MODAL_TITLE,
		cancelButtonText = TextKeys.CANCEL_BUTTON,
		saveButtonText = TextKeys.SAVE_BUTTON,
		descriptionText = if not t1.displayName then TextKeys.SET_CUSTOM_NAME_NO_DISPLAY_NAME_DESCRIPTION else {
			TextKeys.SET_CUSTOM_NAME_DESCRIPTION,
			displayName = t1.displayName
		},
		recognizeFriendsByCustomNameText = if not FFlagConnectionsToFriendsRename then TextKeys.RECOGNIZE_CONNECTIONS_BY_CUSTOM_NAME_DESCRIPTION else TextKeys.RECOGNIZE_FRIENDS_BY_CUSTOM_NAME_DESCRIPTION,
		customNamePlaceholderText = TextKeys.CUSTOM_NAME_PLACEHOLDER,
		invalidAliasErrorText = TextKeys.INVALID_ALIAS_ERROR
	})
	local v48 = useAnalytics()
	local v49 = React.useRef(false)
	local hasSaveAliasError = t1.hasSaveAliasError
	local v51 = React.useCallback(function(p1) -- line: 100
		-- upvalues: v36 (copy), v37 (copy)
		if v36.X ~= p1.AbsoluteSize.X then
			v37(p1.AbsoluteSize)
		end
	end, { v36 })

	local function v52() -- line: 110
		-- upvalues: v48 (copy), EventNames (copy), t1 (copy)
		if v48 then
			v48.fireAnalyticsEvent(EventNames.CustomizeNameModalClosed)
		end

		t1.cancelOnActivated()
	end
	local function v53(s1: string) -- line: 117
		-- upvalues: v41 (copy), v38 (copy), v35 (copy), v42 (copy), v39 (copy), t1 (copy), v48 (copy), EventNames (copy), v49 (copy)
		local v58 = utf8.len(s1)

		if v58 == nil then
			return
		end

		if v58 > 20 then
			s1 = if v41 ~= 20 then string.sub(s1, 1, utf8.offset(s1, 21) - 1) else v38
			v58 = 20

			if v35 and v35.current then
				v35.current.Text = s1
			end
		end

		v42(v58)
		v39(s1)

		if t1.onTextChanged then
			t1.onTextChanged()
		end

		if v58 == 0 and v48 then
			v48.fireAnalyticsEvent(EventNames.CustomizeNameClearedInput)
		end

		if v58 == 20 and v48 and not v49.current then
			v49.current = true
			v48.fireAnalyticsEvent(EventNames.CustomizeNameMaximumCharLimitTyped, {
				alias = s1
			})
		end
	end

	local v54 = if not FFlagSetAliasFixFocusNavigation then nil else React.useMemo(function() -- line: 167
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v48 (copy), EventNames (copy), t1 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p2) -- line: 170
					-- upvalues: v48 (copy), EventNames (copy), t1 (copy)
					if v48 then
						v48.fireAnalyticsEvent(EventNames.CustomizeNameModalClosed)
					end

					t1.cancelOnActivated()
					p2:cancel()
				end)
			}
		}
	end, { v52 })
	local v55 = React.createElement(InteractiveAlert, {
		title = v47.titleText,
		screenSize = t1.screenSize,
		anchorPoint = Vector2.new(0.5, 0),
		position = UDim2.new(0.5, 0, 0, v36.Y),
		middleContent = function() -- line: 184
			-- upvalues: React (copy), FitFrameVertical (copy), v51 (copy), FitTextLabel (copy), v36 (copy), Font (copy), v47 (copy), Theme (copy), t1 (copy), Skeleton (copy), v46 (copy), EnumsRadius (copy), ImageSetLabel (copy), Images (copy), CallbackInputBox (copy), IconSize (copy), v53 (copy), v35 (copy), v41 (copy)
			return React.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				contentPadding = UDim.new(0, 16),
				[React.Change.AbsoluteSize] = v51
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
					Description = React.createElement(FitTextLabel, {
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						TextWrapped = true,
						RichText = true,
						width = FitTextLabel.Width.FitToText,
						maximumWidth = v36.X,
						Font = Font.Body.Font,
						Text = v47.descriptionText,
						TextSize = Font.BaseSize * Font.Body.RelativeSize,
						TextColor3 = Theme.TextDefault.Color
					}),
					RecognizeFriendsByCustomNameContainer = React.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						UIPadding = React.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 2),
							PaddingBottom = UDim.new(0, 24)
						}),
						RecognizeFriendsByCustomName = React.createElement(FitTextLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							TextWrapped = true,
							width = FitTextLabel.Width.FitToText,
							maximumWidth = v36.X,
							Font = Font.CaptionBody.Font,
							Text = v47.recognizeFriendsByCustomNameText,
							TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize,
							TextColor3 = Theme.TextDefault.Color
						})
					}),
					LoadingShimmer = if not t1.isLoading then nil else React.createElement(Skeleton, {
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, v46 + 20),
						radius = EnumsRadius.Medium
					}),
					InputBackground = if t1.isLoading then nil else React.createElement(ImageSetLabel, {
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, v46 + 20),
						Image = Images["component_assets/circle_21"],
						ImageColor3 = Theme.UIMuted.Color,
						ImageTransparency = Theme.UIMuted.Transparency,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(8, 8, 9, 9)
					}, {
						InputBorder = React.createElement(ImageSetLabel, {
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 0, v46 + 20),
							Image = Images["component_assets/circle_21_stroke_1"],
							ImageColor3 = if not t1.hasSaveAliasError then Theme.Divider.Color else Theme.Alert.Color,
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
								inputTextSize = v46,
								initialInputText = t1.alias,
								placeholderText = v47.customNamePlaceholderText,
								placeholderTextColor3 = Theme.TextDefault.Color,
								clearIcon = Images["icons/actions/edit/clear_small"],
								clearIconColor3 = Theme.IconEmphasis.Color,
								clearIconTransparency = Theme.IconEmphasis.Transparency,
								clearButtonSize = IconSize.Small,
								textChangedCallback = v53,
								inputBoxRef = v35
							})
						})
					})
				}),
				Counter = React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, { React.createElement(FitTextLabel, {
					BackgroundTransparency = 1,
					width = FitTextLabel.Width.FitToText,
					maximumWidth = v36.X,
					Font = Font.CaptionBody.Font,
					Text = if not t1.hasSaveAliasError then string.format("%d/%d", v41, 20) else v47.invalidAliasErrorText,
					TextSize = Font.BaseSize * Font.CaptionBody.RelativeSize,
					TextColor3 = if v41 ~= 20 and not t1.hasSaveAliasError then Theme.TextMuted.Color else Theme.Alert.Color,
					TextTransparency = if v41 ~= 20 and not t1.hasSaveAliasError then Theme.TextMuted.Transparency else Theme.Alert.Transparency,
					AnchorPoint = if not t1.hasSaveAliasError then Vector2.new(1, 0.5) else Vector2.new(0, 0.5),
					Position = if not t1.hasSaveAliasError then UDim2.fromScale(1, 0) else nil
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(1e999, Font.BaseSize * Font.CaptionBody.RelativeSize * 2)
					})
				}) })
			})
		end,
		buttonStackInfo = {
			buttonHeight = 48,
			marginBetween = 6,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						onActivated = v52,
						text = v47.cancelButtonText
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = function() -- line: 106
							-- upvalues: t1 (copy), v38 (copy)
							t1.saveOnActivated(v38)
						end,
						text = v47.saveButtonText,
						isDisabled = not not hasSaveAliasError
					}
				}
			},
			forcedFillDirection = Enum.FillDirection.Horizontal
		}
	})

	if FFlagSetAliasFixFocusNavigation then
		return React.createElement(FocusRoot, {
			isAutoFocusRoot = true,
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			eventHandlers = v54
		}, {
			Alert = v55
		})
	end

	return v55
end
