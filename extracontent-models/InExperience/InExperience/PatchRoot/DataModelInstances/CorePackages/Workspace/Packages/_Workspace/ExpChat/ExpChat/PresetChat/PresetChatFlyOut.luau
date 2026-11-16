local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local FFlagExpChatPresetTrayDismissAnalytics = require(ExpChat.Flags.FFlagExpChatPresetTrayDismissAnalytics)
local Config = require(ExpChat.Config)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local PresetChatButton = require(script.Parent.PresetChatButton)
local PresetChatContainer = require(script.Parent.PresetChatContainer)
local setIsPresetTrayOpen = require(script.Parent.Thunks.setIsPresetTrayOpen)
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)
local FFlagExpChatPresetFullWidthButtonFixes = require(ExpChat.Flags.FFlagExpChatPresetFullWidthButtonFixes)
local FlyOutWidth = Config.PresetTray.FlyOutWidth
local FlyOutHeight = Config.PresetTray.FlyOutHeight

local function PresetChatFlyOut(props)
	local presetChatStore = GetPresetChatStore(false)
	local isOpen = SignalsReact.useSignalState(presetChatStore.getIsTrayOpen)

	local onPressedOutside = React.useCallback(function()
		setIsPresetTrayOpen(presetChatStore, false)
	end, { presetChatStore })

	React.useEffect(function()
		if not isOpen then
			return
		end

		local inputBeganConnection

		if FFlagExpChatPresetChatGamepadEnabled then
			inputBeganConnection = UserInputService.InputBegan:Connect(function(input, _)
				if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB then
					setIsPresetTrayOpen(presetChatStore, false)
				end
			end)
		else
			inputBeganConnection = nil
		end

		local menuOpenedConnection = GuiService.MenuOpened:Connect(function()
			if FFlagExpChatPresetTrayDismissAnalytics then
				setIsPresetTrayOpen(presetChatStore, false)
			else
				presetChatStore.setIsTrayOpen(false)
			end
		end)

		return function()
			if inputBeganConnection then
				inputBeganConnection:Disconnect()
			end

			menuOpenedConnection:Disconnect()
		end
	end, { isOpen, presetChatStore })

	local createElement = React.createElement
	local root = Foundation.Popover.Root

	local v = {
		Anchor = React.createElement(Foundation.Popover.Anchor, nil, {
			AnchorWrapper = React.createElement(Foundation.View, {
				tag = "size-0-full auto-x",
				padding = props.addTopPadding and { top = UDim.new(0, 6) } or nil,
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}
			}, {
				Button = React.createElement(PresetChatButton, {
					fullWidth = props.fullWidthButton,
					size = props.buttonSize,
					isCircular = props.buttonIsCircular,
					targetTextChannel = props.textChannel
				})
			})
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local content = Foundation.Popover.Content
	local position

	if FFlagExpChatPresetFullWidthButtonFixes and props.fullWidthButton then
		position = Foundation.Enums.PopoverSide.Bottom
	else
		position = Foundation.Enums.PopoverSide.Right
	end

	v.Content = createElement2(content, {
		side = { position = position, offset = 7 },
		align = {
			position = Foundation.Enums.PopoverAlign.Start,
			offset = FFlagExpChatPresetFullWidthButtonFixes and props.fullWidthButton and 0 or 3
		},
		hasArrow = false,
		radius = Foundation.Enums.Radius.Medium,
		onPressedOutside = onPressedOutside
	}, {
		ContentWrapper = React.createElement(Foundation.View, {
			Size = UDim2.fromOffset(FlyOutWidth, FlyOutHeight)
		}, {
			Container = React.createElement(PresetChatContainer, {
				textChannel = props.textChannel,
				compact = true,
				onSendChat = props.onSendChat,
				onSendGlobalChat = props.onSendGlobalChat
			})
		})
	})
	return createElement(root, { isOpen = isOpen }, v)
end

return React.memo(PresetChatFlyOut)
