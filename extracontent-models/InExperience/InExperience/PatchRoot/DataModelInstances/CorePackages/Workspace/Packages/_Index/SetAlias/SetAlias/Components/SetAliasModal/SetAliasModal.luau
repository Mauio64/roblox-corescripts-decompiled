local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local dependencies = require(parent.dependencies)
local TextKeys = require(parent.Common.TextKeys)
local Analytics = require(parent.Analytics)
local EventNames = Analytics.EventNames
local useAnalytics = Analytics.useAnalytics

local react = dependencies.React
local uiBlox = dependencies.UIBlox
local foundation = dependencies.Foundation
local radius = foundation.Enums.Radius
local skeleton = foundation.Skeleton

local roactFitComponents = dependencies.RoactFitComponents
local useLocalization = dependencies.Hooks.useLocalization
local socialLibraries = dependencies.SocialLibraries
local RoactUtils = require(parent2.RoactUtils)

local FocusNavigationUtils = require(parent2.FocusNavigationUtils)
local FocusRoot = FocusNavigationUtils.FocusRoot
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent2.InputHandlers)
require(parent2.ReactFocusNavigation)

local fitFrameVertical = roactFitComponents.FitFrameVertical
local fitTextLabel = roactFitComponents.FitTextLabel
local interactiveAlert = uiBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = uiBlox.App.Button.Enum.ButtonType
local useStyle = uiBlox.Core.Style.useStyle
local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local images = uiBlox.App.ImageSet.Images
local iconSize = uiBlox.App.Constant.IconSize
local useEffectOnce = RoactUtils.Hooks.useEffectOnce

local callbackInputBox = socialLibraries.Components.CallbackInputBox

local FFlagSetAliasFixFocusNavigation = require(parent.Flags.FFlagSetAliasFixFocusNavigation)

return function(props)
	local ref = react.useRef(nil)
	local state, setState = react.useState(Vector2.new(0, 0))
	local state2, setState2 = react.useState(props.alias)
	local v = props.alias and utf8.len(props.alias) or 0
	local state3, setState3 = react.useState(v)

	useEffectOnce(function()
		setState2(props.alias)
		setState3(v)
	end, props.isLoading == false)

	local v2 = useStyle()
	local font = v2.Font
	local theme = v2.Theme
	local inputTextSize = font.BaseSize * font.Body.RelativeSize
	local v3 = {
		titleText = TextKeys.CUSTOMIZE_NAME_MODAL_TITLE,
		cancelButtonText = TextKeys.CANCEL_BUTTON,
		saveButtonText = TextKeys.SAVE_BUTTON,
		descriptionText = 0,
		recognizeFriendsByCustomNameText = 0,
		customNamePlaceholderText = 0,
		invalidAliasErrorText = 0
	}
	local descriptionText

	if props.displayName then
		descriptionText = {
			TextKeys.SET_CUSTOM_NAME_DESCRIPTION,
			displayName = props.displayName
		}
	else
		descriptionText = TextKeys.SET_CUSTOM_NAME_NO_DISPLAY_NAME_DESCRIPTION
	end

	v3.descriptionText = descriptionText

	v3.recognizeFriendsByCustomNameText = TextKeys.RECOGNIZE_FRIENDS_BY_CUSTOM_NAME_DESCRIPTION
	v3.customNamePlaceholderText = TextKeys.CUSTOM_NAME_PLACEHOLDER
	v3.invalidAliasErrorText = TextKeys.INVALID_ALIAS_ERROR
	local v4 = useLocalization(v3)

	local v5 = useAnalytics()
	local ref2 = react.useRef(false)

	local v6 = not props.hasSaveAliasError

	local v7 = react.useCallback(function(p)
		if state.X ~= p.AbsoluteSize.X then
			setState(p.AbsoluteSize)
		end
	end, { state })

	local function onActivated()
		props.saveOnActivated(state2)
	end

	local function onActivated2() -- 1 equivalent call inferred from this helper
		if v5 then
			v5.fireAnalyticsEvent(EventNames.CustomizeNameModalClosed)
		end

		props.cancelOnActivated()
	end

	local function fn(text: string)
		local v8 = utf8.len(text)

		if v8 == nil then
			return
		end

		if v8 > 20 then
			if state3 == 20 then
				text = state2
			else
				text = string.sub(text, 1, utf8.offset(text, 21) - 1)
			end

			v8 = 20

			if ref and ref.current then
				ref.current.Text = text
			end
		end

		setState3(v8)
		setState2(text)

		if props.onTextChanged then
			props.onTextChanged()
		end

		if v8 == 0 and v5 then
			v5.fireAnalyticsEvent(EventNames.CustomizeNameClearedInput)
		end

		if v8 == 20 and v5 and not ref2.current then
			ref2.current = true
			v5.fireAnalyticsEvent(EventNames.CustomizeNameMaximumCharLimitTyped, { alias = text })
		end
	end

	local eventHandlers

	if FFlagSetAliasFixFocusNavigation then
		eventHandlers = react.useMemo(function()
			local v8 = {}
			v8[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					onActivated2() -- inferred equivalent call
					object:cancel()
				end)
			}

			return v8
		end, { onActivated2 })
	end

	local element = react.createElement(interactiveAlert, {
		title = v4.titleText,
		screenSize = props.screenSize,
		anchorPoint = Vector2.new(0.5, 0),
		position = UDim2.new(0.5, 0, 0, state.Y),
		middleContent = function()
			local createElement = react.createElement
			local v8 = {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				contentPadding = UDim.new(0, 16),
				[react.Change.AbsoluteSize] = v7
			}

			local createElement2 = react.createElement
			local v9 = {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1
			}

			local v10 = {
				UIListLayout = react.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Description = react.createElement(fitTextLabel, {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					TextWrapped = true,
					width = fitTextLabel.Width.FitToText,
					maximumWidth = state.X,
					Font = font.Body.Font,
					Text = v4.descriptionText,
					TextSize = font.BaseSize * font.Body.RelativeSize,
					TextColor3 = theme.TextDefault.Color,
					RichText = true
				}),
				RecognizeFriendsByCustomNameContainer = react.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = 2
					},
					{
						UIPadding = react.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 2),
							PaddingBottom = UDim.new(0, 24)
						}),
						RecognizeFriendsByCustomName = react.createElement(fitTextLabel, {
							LayoutOrder = 1,
							BackgroundTransparency = 1,
							TextWrapped = true,
							width = fitTextLabel.Width.FitToText,
							maximumWidth = state.X,
							Font = font.CaptionBody.Font,
							Text = v4.recognizeFriendsByCustomNameText,
							TextSize = font.BaseSize * font.CaptionBody.RelativeSize,
							TextColor3 = theme.TextDefault.Color
						})
					}
				),
				LoadingShimmer = 0,
				InputBackground = 0
			}
			local loadingShimmer

			if props.isLoading then
				loadingShimmer = react.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, inputTextSize + 20),
					LayoutOrder = 3,
					radius = radius.Medium
				})
			end

			v10.LoadingShimmer = loadingShimmer
			local inputBackground

			if not props.isLoading then
				local createElement3 = react.createElement
				local v11 = {
					Size = UDim2.new(1, 0, 0, inputTextSize + 20),
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Image = images["component_assets/circle_21"],
					ImageColor3 = theme.UIMuted.Color,
					ImageTransparency = theme.UIMuted.Transparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9)
				}

				local createElement4 = react.createElement
				local v12 = {
					Size = UDim2.new(1, 0, 0, inputTextSize + 20),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = images["component_assets/circle_21_stroke_1"],
					ImageColor3 = 0,
					ScaleType = 0,
					SliceCenter = 0
				}
				local imageColor

				if props.hasSaveAliasError then
					imageColor = theme.Alert.Color
				else
					imageColor = theme.Divider.Color
				end

				v12.ImageColor3 = imageColor

				v12.ScaleType = Enum.ScaleType.Slice
				v12.SliceCenter = Rect.new(8, 8, 9, 9)
				inputBackground = createElement3(imageSetLabel, v11, {
					InputBorder = createElement4(imageSetLabel, v12, {
						Padding = react.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 12),
							PaddingRight = UDim.new(0, 12)
						}),
						Textbox = react.createElement(callbackInputBox, {
							inputTextXAlignment = Enum.TextXAlignment.Left,
							inputTextColor3 = theme.TextDefault.Color,
							inputTextTransparency = theme.TextDefault.Transparency,
							inputTextSize = inputTextSize,
							initialInputText = props.alias,
							placeholderText = v4.customNamePlaceholderText,
							placeholderTextColor3 = theme.TextDefault.Color,
							captureFocusOnMount = true,
							clearIcon = images["icons/actions/edit/clear_small"],
							clearIconColor3 = theme.IconEmphasis.Color,
							clearIconTransparency = theme.IconEmphasis.Transparency,
							clearButtonSize = iconSize.Small,
							clearButtonDisabled = false,
							textChangedCallback = fn,
							inputBoxRef = ref
						})
					})
				})
			end

			v10.InputBackground = inputBackground
			local children = {
				InputGroup = createElement2("Frame", v9, v10),
				Counter = 0
			}

			local createElement3 = react.createElement
			local v11 = {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2
			}

			local createElement4 = react.createElement
			local v12 = {
				BackgroundTransparency = 1,
				width = fitTextLabel.Width.FitToText,
				maximumWidth = state.X,
				Font = font.CaptionBody.Font,
				Text = 0,
				TextSize = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				AnchorPoint = 0,
				Position = 0
			}
			local text

			if props.hasSaveAliasError then
				text = v4.invalidAliasErrorText
			else
				text = string.format("%d/%d", state3, 20)
			end

			v12.Text = text

			v12.TextSize = font.BaseSize * font.CaptionBody.RelativeSize
			local textColor

			if state3 == 20 or props.hasSaveAliasError then
				textColor = theme.Alert.Color
			else
				textColor = theme.TextMuted.Color
			end

			v12.TextColor3 = textColor
			local textTransparency

			if state3 == 20 or props.hasSaveAliasError then
				textTransparency = theme.Alert.Transparency
			else
				textTransparency = theme.TextMuted.Transparency
			end

			v12.TextTransparency = textTransparency
			local anchorPoint

			if props.hasSaveAliasError then
				anchorPoint = Vector2.new(0, 0.5)
			else
				anchorPoint = Vector2.new(1, 0.5)
			end

			v12.AnchorPoint = anchorPoint
			local position

			if not props.hasSaveAliasError then
				position = UDim2.fromScale(1, 0)
			end

			v12.Position = position
			children.Counter = createElement3("Frame", v11, { createElement4(fitTextLabel, v12, {
					UISizeConstraint = react.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(1e999, font.BaseSize * font.CaptionBody.RelativeSize * 2)
					})
				}) })
			return createElement(fitFrameVertical, v8, children)
		end,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = onActivated2, text = v4.cancelButtonText }
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = onActivated,
						text = v4.saveButtonText,
						isDisabled = not v6
					}
				}
			},
			buttonHeight = 48,
			marginBetween = 6,
			forcedFillDirection = Enum.FillDirection.Horizontal
		}
	})

	if FFlagSetAliasFixFocusNavigation then
		return react.createElement(
			FocusRoot,
			{
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
				isAutoFocusRoot = true,
				isIsolated = true,
				eventHandlers = eventHandlers
			},
			{ Alert = element }
		)
	end

	return element
end
