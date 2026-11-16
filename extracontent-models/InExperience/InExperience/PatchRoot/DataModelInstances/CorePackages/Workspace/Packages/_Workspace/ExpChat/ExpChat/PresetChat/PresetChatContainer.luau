local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local ExpChatShared = require(parent.ExpChatShared)
local Foundation = require(parent.Foundation)
local InputType = require(parent.InputType)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SignalsReact = require(parent.SignalsReact)

local SharedFlags = require(parent.SharedFlags)
local EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint = SharedFlags.EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Text = Foundation.Text
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local Localization = require(ExpChat.Localization)
local PresetBorderlessGridButton = require(script.Parent.PresetBorderlessGridButton)
local PresetCooldownProvider = require(script.Parent.PresetCooldownProvider)
local PresetMessageButton = require(script.Parent.PresetMessageButton)
local PresetTrayKeyboardSelected = require(ExpChat.Actions.PresetTrayKeyboardSelected)
local Constants = require(ExpChat.PresetChat.Constants)
local setIsPresetTrayOpen = require(script.Parent.Thunks.setIsPresetTrayOpen)
local useOnEmojiActivated = require(script.Parent.useOnEmojiActivated)
local useOnPresetActivated = require(script.Parent.useOnPresetActivated)
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)
local FFlagExpChatPresetChatTabMemory = require(ExpChat.Flags.FFlagExpChatPresetChatTabMemory)
local FFlagExpChatPresetTrayDismissAnalytics = require(ExpChat.Flags.FFlagExpChatPresetTrayDismissAnalytics)

local FFlagExpChatPresetTrayPresetOnlyDisclaimer = require(ExpChat.Flags.FFlagExpChatPresetTrayPresetOnlyDisclaimer)

local function PresetChatContainer(props)
	local v = Foundation.Hooks.useTokens()
	local presetChatStore = GetPresetChatStore(false)
	local v2 = useDispatch()
	local v3 = SignalsReact.useSignalState(presetChatStore.getIsLoading)
	local v4 = SignalsReact.useSignalState(presetChatStore.getCategoryGroups)

	local v5 = SignalsReact.useSignalState(GetMessagesStore(false).getCanLocalUserChat)

	local v6 = Localization.useLocalization({
		footerDescription = "Feature.Chat.PresetChat.Disclaimer"
	})

	local closePresetTray = React.useCallback(function()
		setIsPresetTrayOpen(presetChatStore, false)
	end, { presetChatStore })

	local onActivated = React.useCallback(function()
		closePresetTray()
		v2(PresetTrayKeyboardSelected())

		ExpChatShared.Analytics:TelemetryLogEvent(
			ExpChatShared.Analytics.ExpChatPresetActionConfig,
			{
				event_type = Constants.Analytics.EventTypes.Click,
				component = Constants.Analytics.Components.PresetKeyboardIcon
			},
			ExpChatShared.Analytics.DefaultStandardizedFields
		)
	end, { closePresetTray, v2 })

	local ref = React.useRef(nil)

	local categoryGroupId = v4 and #v4 > 0 and v4[1].categoryGroupId or ""
	local state, setState = React.useState(categoryGroupId)

	if FFlagExpChatPresetChatTabMemory then
		local v7 = SignalsReact.useSignalState(presetChatStore.getSelectedGroupIndex)
		local v8 = v4 and v4[v7]
		state = if v8 then v8.categoryGroupId else categoryGroupId
	end

	React.useEffect(function()
		if not FFlagExpChatPresetChatTabMemory and state == "" and categoryGroupId ~= "" then
			setState(categoryGroupId)
		end
	end, { categoryGroupId, state })
	local v7

	if FFlagExpChatPresetChatGamepadEnabled or FFlagExpChatPresetTrayDismissAnalytics then
		v7 = SignalsReact.useSignalState(presetChatStore.getIsTrayOpen)
	else
		v7 = nil
	end

	React.useEffect(function()
		if FFlagExpChatPresetTrayDismissAnalytics and v7 and not v3 and state ~= "" then
			presetChatStore.markGroupViewed(state)
		end
	end, { v7, v3, state, presetChatStore })

	local ref2 = React.useRef(nil)

	local function isValidSelection(current) -- 2 equivalent calls inferred from this helper
		if current == nil then
			return false
		end

		local success, result = pcall(function()
			return current:IsDescendantOf(game) and current:FindFirstAncestorOfClass("ScreenGui") ~= nil
		end)

		return success and result
	end

	local useEffect = React.useEffect
	local function fn()
		if FFlagExpChatPresetChatGamepadEnabled and not v7 then
			return
		end

		local current = ref.current

		if not (current ~= nil and InputType.getInputGroup(UserInputService:GetLastInputType()) == InputType.InputTypeConstants.Gamepad) then
			return
		end

		if ref2.current == nil then
			local current2

			if FFlagExpChatPresetChatGamepadEnabled then
				current2 = GuiService.SelectedCoreObject
			else
				current2 = GuiService.SelectedObject
			end

			ref2.current = current2
		end

		task.defer(function()
			if isValidSelection(current) then -- inferred equivalent call
				pcall(function()
					if FFlagExpChatPresetChatGamepadEnabled then
						GuiService.SelectedCoreObject = current
					else
						GuiService.SelectedObject = current
					end
				end)
			end
		end)
	end

	local v8

	if FFlagExpChatPresetChatGamepadEnabled then
		v8 = { state, v7 }
	else
		v8 = { state }
	end

	useEffect(fn, v8)

	React.useEffect(function()
		local transparencyStore = GetTransparencyStore(false)
		transparencyStore.setContextMenuOpen()
		return function()
			transparencyStore.clearContextMenuOpen()
			local current = ref2.current
			pcall(function()
				if isValidSelection(current) then -- inferred equivalent call
					if FFlagExpChatPresetChatGamepadEnabled then
						GuiService.SelectedCoreObject = current
					else
						GuiService.SelectedObject = current
					end
				elseif FFlagExpChatPresetChatGamepadEnabled then
					GuiService.SelectedCoreObject = nil
				else
					GuiService.SelectedObject = nil
				end
			end)
			ref2.current = nil
		end
	end, {})

	local onActivated2 = useOnPresetActivated({
		textChannel = props.textChannel,
		closePresetTray = closePresetTray
	})

	local onActivated3 = useOnEmojiActivated({
		textChannel = props.textChannel,
		onSendChat = props.onSendChat,
		onSendGlobalChat = props.onSendGlobalChat,
		closePresetTray = closePresetTray
	})

	if v3 then
		return React.createElement(Foundation.Text, {
			Text = "Loading presets...",
			tag = "size-full text-body-medium content-muted"
		})
	end

	if not v4 or #v4 == 0 then
		return nil
	end

	local v9 = nil

	for _, v10 in v4 do
		if v10.categoryGroupId == state then
			v9 = v10
			break
		end
	end

	local fontStyle = {
		Font = Enum.Font.BuilderSansBold,
		FontSize = v.FontSize.FontSize_300,
		LineHeight = 1.4
	}

	local children = {}
	local flag = true
	local v10 = not FFlagExpChatPresetTrayPresetOnlyDisclaimer

	if v9 then
		for k, category in v9.categories do
			local children2 = {}
			local v11

			if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
				v11 = category.contents
			else
				v11 = category.messages
			end

			for k2, v12 in v11 do
				v10 = not EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint or v12.kind == "Preset" or v10

				if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint and v12.kind == "Emoji" then
					local v13 = "Emoji_" .. v12.emoteId
					local createElement = React.createElement
					local v14 = {
						unicode = v12.unicode,
						layoutOrder = k2,
						onActivated = onActivated3,
						buttonRef = 0
					}
					local buttonRef

					if flag then
						buttonRef = ref
					end

					v14.buttonRef = buttonRef
					children2[v13] = createElement(PresetBorderlessGridButton, v14)
				else
					local v13 = "Msg_" .. v12.presetId
					local createElement = React.createElement
					local v14 = {
						presetId = v12.presetId,
						text = 0,
						layoutOrder = 0,
						onActivated = 0,
						buttonRef = 0
					}
					local text

					if EngineFeaturePresetChatUseExpressionTrayOptionsEndpoint then
						text = v12.text
					else
						text = v12.value
					end

					v14.text = text
					v14.layoutOrder = k2
					v14.onActivated = onActivated2
					local buttonRef

					if flag then
						buttonRef = ref
					end

					v14.buttonRef = buttonRef
					children2[v13] = createElement(PresetMessageButton, v14)
				end

				flag = false
			end

			children["Category_" .. category.categoryId] = React.createElement(
				Foundation.View,
				{ LayoutOrder = k, tag = "col gap-small size-full-0 auto-y" },
				{
					Header = React.createElement(Foundation.Text, {
						LayoutOrder = 1,
						Text = category.name or category.categoryId,
						tag = "size-full-0 auto-y text-align-x-left content-default",
						fontStyle = fontStyle
					}),
					Pills = React.createElement(Foundation.View, {
						LayoutOrder = 2,
						tag = "size-full-0 auto-y",
						layout = {
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, v.Padding.Small),
							Wraps = true
						}
					}, children2)
				}
			)
		end

		if v10 then
			children.Footer = React.createElement(Text, {
				LayoutOrder = #v9.categories + 1,
				Text = v6.footerDescription,
				TextWrapped = true,
				tag = "size-full-0 auto-y text-body-small text-align-x-left content-muted"
			})
		end
	end

	local children2 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v.Padding.XLarge),
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		})
	}

	local v11 = #v4 > 1

	for k, v12 in v4 do
		local categoryGroupId2 = v12.categoryGroupId
		local v13 = categoryGroupId2 == state
		local textStyle

		if v13 or not v11 then
			textStyle = v.Color.Content.Emphasis
		else
			textStyle = v.Color.Content.Muted
		end

		local v14 = {
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, 36),
			LayoutOrder = k,
			Text = v12.name or categoryGroupId2,
			fontStyle = v.Typography.LabelMedium,
			textStyle = textStyle,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}

		local v15 = v13 and v11 and {
			Indicator = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.new(0.5, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, 2),
				BackgroundColor3 = v.Color.Content.Emphasis.Color3,
				BorderSizePixel = 0
			})
		} or nil

		if v11 then
			function v14.onActivated()
				if FFlagExpChatPresetChatTabMemory then
					presetChatStore.setSelectedGroupIndex(k)
				else
					setState(categoryGroupId2)
				end
			end
		end

		children2["Tab_" .. categoryGroupId2] = React.createElement(Text, v14, v15)
	end

	local v12 = {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v.Padding.Large),
			PaddingRight = UDim.new(0, v.Padding.Large),
			PaddingTop = UDim.new(0, v.Padding.XSmall)
		}),
		TabsGroup = React.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1
			},
			children2
		),
		KeyboardButton = 0
	}
	local keyboardButton

	if v5 and props.shouldShowKeyboardButton then
		keyboardButton = React.createElement(Foundation.IconButton, {
			LayoutOrder = 2,
			icon = { name = "keyboard", variant = "Regular" },
			variant = Foundation.Enums.ButtonVariant.Utility,
			size = Foundation.Enums.InputSize.Small,
			isCircular = true,
			isDisabled = false,
			onActivated = onActivated
		})
	end

	v12.KeyboardButton = keyboardButton

	return React.createElement(
		PresetCooldownProvider,
		{},
		React.createElement("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, {
			RootLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			TabRow = React.createElement(
				"Frame",
				{
					LayoutOrder = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					BackgroundTransparency = 1
				},
				v12
			),
			TabRowBaseline = React.createElement("Frame", {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 1),
				BackgroundColor3 = v.Color.Stroke.Default.Color3,
				BackgroundTransparency = v.Color.Stroke.Default.Transparency,
				BorderSizePixel = 0
			}),
			Scroll = React.createElement(Foundation.ScrollView, {
				LayoutOrder = 3,
				tag = "grow size-full-0",
				scroll = {
					scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.Always,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(0, 0, 0, 0)
				}
			}, {
				Categories = React.createElement(Foundation.View, {
					tag = "size-full-0 auto-y",
					layout = {
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, v.Padding.Large)
					},
					padding = {
						top = UDim.new(0, v.Padding.Large),
						bottom = UDim.new(0, v.Padding.Large),
						left = UDim.new(0, v.Padding.Large),
						right = UDim.new(0, v.Padding.Large)
					}
				}, children)
			})
		})
	)
end

return React.memo(PresetChatContainer)
