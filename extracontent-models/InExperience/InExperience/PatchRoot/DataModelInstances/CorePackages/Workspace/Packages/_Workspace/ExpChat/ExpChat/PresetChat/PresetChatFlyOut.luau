local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Foundation = require(ExpChatParent.Foundation)
local React = require(ExpChatParent.React)
local SignalsReact = require(ExpChatParent.SignalsReact)
local Config = require(ExpChat.Config)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local PresetChatButton = require(script.Parent.PresetChatButton)
local PresetChatContainer = require(script.Parent.PresetChatContainer)
local setIsPresetTrayOpen = require(script.Parent.Thunks.setIsPresetTrayOpen)
local FFlagExpChatPresetChatGamepadEnabled = require(ExpChat.Flags.FFlagExpChatPresetChatGamepadEnabled)
local FlyOutWidth = Config.PresetTray.FlyOutWidth
local FlyOutHeight = Config.PresetTray.FlyOutHeight

local function PresetChatFlyOut(t1: {[any]: any}) -- line: 27
	-- upvalues: GetPresetChatStore (copy), SignalsReact (copy), React (copy), setIsPresetTrayOpen (copy), FFlagExpChatPresetChatGamepadEnabled (copy), UserInputService (copy), GuiService (copy), Foundation (copy), PresetChatButton (copy), FlyOutWidth (copy), FlyOutHeight (copy), PresetChatContainer (copy)
	local v18 = GetPresetChatStore(false)
	local v19 = SignalsReact.useSignalState(v18.getIsTrayOpen)
	local v20 = React.useCallback(function() -- line: 31
		-- upvalues: setIsPresetTrayOpen (copy), v18 (copy)
		setIsPresetTrayOpen(v18, false)
	end, { v18 })

	React.useEffect(function() -- line: 35
		-- upvalues: v19 (copy), FFlagExpChatPresetChatGamepadEnabled (copy), UserInputService (copy), setIsPresetTrayOpen (copy), v18 (copy), GuiService (copy)
		if not v19 then
			return
		end

		local connection = nil

		if FFlagExpChatPresetChatGamepadEnabled then
			connection = UserInputService.InputBegan:Connect(function(input, _) -- line: 42
				-- upvalues: setIsPresetTrayOpen (copy), v18 (copy)
				if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB then
					setIsPresetTrayOpen(v18, false)
				end
			end)
		end

		local connection2 = GuiService.MenuOpened:Connect(function() -- line: 49
			-- upvalues: v18 (copy)
			v18.setIsTrayOpen(false)
		end)

		return function() -- line: 53
			-- upvalues: connection (ref), connection2 (copy)
			if connection then
				connection:Disconnect()
			end

			connection2:Disconnect()
		end
	end, {
		v19,
		v18
	})

	return React.createElement(Foundation.Popover.Root, {
		isOpen = v19
	}, {
		Anchor = React.createElement(Foundation.Popover.Anchor, nil, {
			AnchorWrapper = React.createElement(Foundation.View, {
				tag = "size-0-full auto-x",
				padding = if not t1.addTopPadding then nil else {
					top = UDim.new(0, 6)
				},
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}
			}, {
				Button = React.createElement(PresetChatButton, {
					fullWidth = t1.fullWidthButton,
					size = t1.buttonSize,
					isCircular = t1.buttonIsCircular,
					targetTextChannel = t1.textChannel
				})
			})
		}),
		Content = React.createElement(Foundation.Popover.Content, {
			hasArrow = false,
			side = {
				offset = 7,
				position = Foundation.Enums.PopoverSide.Right
			},
			align = {
				offset = 3,
				position = Foundation.Enums.PopoverAlign.Start
			},
			radius = Foundation.Enums.Radius.Medium,
			onPressedOutside = v20
		}, {
			ContentWrapper = React.createElement(Foundation.View, {
				Size = UDim2.fromOffset(FlyOutWidth, FlyOutHeight)
			}, {
				Container = React.createElement(PresetChatContainer, {
					compact = true,
					textChannel = t1.textChannel
				})
			})
		})
	})
end

return React.memo(PresetChatFlyOut)
