local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/dependencies")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Common/TextKeys")
local Analytics = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Analytics")
local eventNames = Analytics.EventNames
local useAnalytics = Analytics.useAnalytics

local react = dependencies.React
local uiBlox = dependencies.UIBlox
local foundation = dependencies.Foundation
local radius = foundation.Enums.Radius
local skeleton = foundation.Skeleton

local roactFitComponents = dependencies.RoactFitComponents
local useLocalization = dependencies.Hooks.useLocalization
local socialLibraries = dependencies.SocialLibraries
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/RoactUtils")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/FocusNavigationUtils")
local focusRoot = FocusNavigationUtils.FocusRoot
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/InputHandlers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/ReactFocusNavigation")

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

local FFlagSetAliasFixFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Flags/FFlagSetAliasFixFocusNavigation")

return function(props)
	local ref = react.useRef(nil)
	local state, setState = react.useState(Vector2.new(0, 0))
	local state2, setState2 = react.useState(props.alias)
	local v5 = props.alias and utf8.len(props.alias) or 0
	local state3, setState3 = react.useState(v5)

	useEffectOnce(function()
		setState2(props.alias)
		setState3(v5)
	end, props.isLoading == false)

	local v6 = useStyle()
	local font = v6.Font
	local theme = v6.Theme
	local v7 = font.BaseSize * font.Body.RelativeSize
	local v9 = {
		titleText = TextKeys.CUSTOMIZE_NAME_MODAL_TITLE,
		cancelButtonText = TextKeys.CANCEL_BUTTON,
		saveButtonText = TextKeys.SAVE_BUTTON,
		descriptionText = 0,
		recognizeFriendsByCustomNameText = 0,
		customNamePlaceholderText = 0,
		invalidAliasErrorText = 0
	}
	local v10 = if props.displayName then {
		TextKeys.SET_CUSTOM_NAME_DESCRIPTION,
		displayName = props.displayName
	} else TextKeys.SET_CUSTOM_NAME_NO_DISPLAY_NAME_DESCRIPTION
	v9.descriptionText = v10

	v9.recognizeFriendsByCustomNameText = TextKeys.RECOGNIZE_FRIENDS_BY_CUSTOM_NAME_DESCRIPTION
	v9.customNamePlaceholderText = TextKeys.CUSTOM_NAME_PLACEHOLDER
	v9.invalidAliasErrorText = TextKeys.INVALID_ALIAS_ERROR
	local v11 = useLocalization(v9)

	local v12 = useAnalytics()
	local ref2 = react.useRef(false)

	local v13 = not props.hasSaveAliasError

	local v14 = react.useCallback(function(p2)
		if state.X ~= p2.AbsoluteSize.X then
			setState(p2.AbsoluteSize)
		end
	end, { state })

	local function onActivated()
		props.saveOnActivated(state2)
	end

	local function onActivated2()
		if v12 then
			v12.fireAnalyticsEvent(eventNames.CustomizeNameModalClosed)
		end

		props.cancelOnActivated()
	end

	local function fn(text)
		local v15 = utf8.len(text)

		if v15 == nil then
			return
		end

		if v15 > 20 then
			text = if state3 == 20 then state2 else string.sub(text, 1, utf8.offset(text, 21) - 1)

			v15 = 20

			if ref and ref.current then
				ref.current.Text = text
			end
		end

		setState3(v15)
		setState2(text)

		if props.onTextChanged then
			props.onTextChanged()
		end

		if v15 == 0 and v12 then
			v12.fireAnalyticsEvent(eventNames.CustomizeNameClearedInput)
		end

		if v15 == 20 and v12 and not ref2.current then
			ref2.current = true
			v12.fireAnalyticsEvent(eventNames.CustomizeNameMaximumCharLimitTyped, {
				alias = text
			})
		end
	end

	local v15

	if FFlagSetAliasFixFocusNavigation then
		v15 = react.useMemo(function()
			local v16 = {}
			v16[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					if v12 then
						v12.fireAnalyticsEvent(eventNames.CustomizeNameModalClosed)
					end

					props.cancelOnActivated()

					object:cancel()
				end)
			}

			return v16
		end, { onActivated2 })
	end

	local element = react.createElement(interactiveAlert, {
		title = v11.titleText,
		screenSize = props.screenSize,
		anchorPoint = Vector2.new(0.5, 0),
		position = UDim2.new(0.5, 0, 0, state.Y),
		middleContent = function()
			local createElement = react.createElement
			local v17 = {
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				contentPadding = UDim.new(0, 16),
				[react.Change.AbsoluteSize] = v14
			}

			local createElement2 = react.createElement
			local v19 = {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 1
			}

			local v20 = {
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
					Text = v11.descriptionText,
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
							Text = v11.recognizeFriendsByCustomNameText,
							TextSize = font.BaseSize * font.CaptionBody.RelativeSize,
							TextColor3 = theme.TextDefault.Color
						})
					}
				),
				LoadingShimmer = 0,
				InputBackground = 0
			}

			local v21 = if props.isLoading then react.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, v7 + 20),
				LayoutOrder = 3,
				radius = radius.Medium
			}) else nil
			v20.LoadingShimmer = v21
			local v22

			if not props.isLoading then
				local createElement3 = react.createElement
				local v24 = {
					Size = UDim2.new(1, 0, 0, v7 + 20),
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					Image = images["component_assets/circle_21"],
					ImageColor3 = theme.UIMuted.Color,
					ImageTransparency = theme.UIMuted.Transparency,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(8, 8, 9, 9)
				}

				local createElement4 = react.createElement
				local v27 = {
					Size = UDim2.new(1, 0, 0, v7 + 20),
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Image = images["component_assets/circle_21_stroke_1"],
					ImageColor3 = 0,
					ScaleType = 0,
					SliceCenter = 0
				}
				local v28 = if props.hasSaveAliasError then theme.Alert.Color else theme.Divider.Color
				v27.ImageColor3 = v28

				v27.ScaleType = Enum.ScaleType.Slice
				v27.SliceCenter = Rect.new(8, 8, 9, 9)
				v22 = createElement3(imageSetLabel, v24, {
					InputBorder = createElement4(imageSetLabel, v27, {
						Padding = react.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, 12),
							PaddingRight = UDim.new(0, 12)
						}),
						Textbox = react.createElement(callbackInputBox, {
							inputTextXAlignment = Enum.TextXAlignment.Left,
							inputTextColor3 = theme.TextDefault.Color,
							inputTextTransparency = theme.TextDefault.Transparency,
							inputTextSize = v7,
							initialInputText = props.alias,
							placeholderText = v11.customNamePlaceholderText,
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

			v20.InputBackground = v22
			local children = {
				InputGroup = createElement2("Frame", v19, v20),
				Counter = 0
			}

			local createElement3 = react.createElement
			local v24 = {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				LayoutOrder = 2
			}

			local createElement4 = react.createElement
			local v27 = {
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
			local v28 = if props.hasSaveAliasError then v11.invalidAliasErrorText else string.format("%d/%d", state3, 20)
			v27.Text = v28

			v27.TextSize = font.BaseSize * font.CaptionBody.RelativeSize
			local v29 = if state3 == 20 or props.hasSaveAliasError then theme.Alert.Color else theme.TextMuted.Color
			v27.TextColor3 = v29

			local v30 = if state3 == 20 or props.hasSaveAliasError then theme.Alert.Transparency else theme.TextMuted.Transparency
			v27.TextTransparency = v30

			local v31 = if props.hasSaveAliasError then Vector2.new(0, 0.5) else Vector2.new(1, 0.5)
			v27.AnchorPoint = v31
			local v32 = if not props.hasSaveAliasError then UDim2.fromScale(1, 0) else nil
			v27.Position = v32
			children.Counter = createElement3("Frame", v24, { createElement4(fitTextLabel, v27, {
					UISizeConstraint = react.createElement("UISizeConstraint", {
						MaxSize = Vector2.new(1e999, font.BaseSize * font.CaptionBody.RelativeSize * 2)
					})
				}) })
			return createElement(fitFrameVertical, v17, children)
		end,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = { onActivated = onActivated2, text = v11.cancelButtonText }
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = onActivated,
						text = v11.saveButtonText,
						isDisabled = not v13
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
			focusRoot,
			{
				surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
				isAutoFocusRoot = true,
				isIsolated = true,
				eventHandlers = v15
			},
			{ Alert = element }
		)
	end

	return element
end
