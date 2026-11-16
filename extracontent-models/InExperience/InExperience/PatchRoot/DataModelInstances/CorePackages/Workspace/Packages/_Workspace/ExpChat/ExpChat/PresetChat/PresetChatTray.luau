local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Otter = require(parent.Otter)
local SignalsReact = require(parent.SignalsReact)

local FFlagExpChatPresetTrayDismissAnalytics = require(ExpChat.Flags.FFlagExpChatPresetTrayDismissAnalytics)
local Config = require(ExpChat.Config)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local PresetChatContainer = require(script.Parent.PresetChatContainer)
local useAutoTrayHeight = require(script.Parent.useAutoTrayHeight)
local setIsPresetTrayOpen = require(script.Parent.Thunks.setIsPresetTrayOpen)
local CompactWidthThreshold = Config.PresetTray.CompactWidthThreshold
local SlideSpring = Config.PresetTray.SlideSpring

local function isCompactMode(): boolean -- 1 equivalent call inferred from this helper
	local currentCamera = workspace.CurrentCamera

	if currentCamera then
		return currentCamera.ViewportSize.X < CompactWidthThreshold
	end

	return false
end

local function PresetChatTray(props)
	local presetChatStore = GetPresetChatStore(false)
	local v = SignalsReact.useSignalState(presetChatStore.getIsTrayOpen)
	local compactMode = isCompactMode() -- inferred equivalent call
	local v2 = Foundation.Hooks.useTokens()

	local v3, v4 = useAutoTrayHeight()

	local state, setState = React.useState(false)
	local v5, v6 = React.useBinding(1)
	local ref = React.useRef(nil)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(0)
	local state4, setState4 = React.useState(GuiService.TopbarInset.Height)
	local v7 = v3 + math.max(0, state2 - state3 - state4)

	React.useEffect(function()
		local topbarInsetChangedConnection = GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function()
			setState4(GuiService.TopbarInset.Height)
		end)
		return function()
			topbarInsetChangedConnection:Disconnect()
		end
	end, {})

	local state5, setState5 = React.useState(false)

	local v8 = React.useCallback(function(p)
		setState2(p.AbsoluteSize.Y)
		setState5(p.AbsoluteSize.Y > p.AbsoluteSize.X)
	end, {})

	local v9 = React.useCallback(function(p)
		setState3(p.AbsoluteSize.Y)
		v4(p)
	end, { v4 })

	local v10 = React.useCallback(function()
		setIsPresetTrayOpen(presetChatStore, false)
	end, { presetChatStore })

	React.useEffect(function()
		if v then
			setState(true)

			if ref.current then
				ref.current:destroy()
			end

			local singleMotor = Otter.createSingleMotor(1)
			ref.current = singleMotor
			singleMotor:onStep(function(p)
				v6(p)
			end)
			singleMotor:setGoal(Otter.spring(0, SlideSpring))
		elseif ref.current then
			ref.current:setGoal(Otter.spring(1, SlideSpring))
			ref.current:onComplete(function()
				setState(false)
			end)
		end
	end, { v })

	React.useEffect(function()
		return function()
			if ref.current then
				ref.current:destroy()
				ref.current = nil
			end
		end
	end, {})

	React.useEffect(function()
		if not v then
			return
		end

		local inputBeganConnection = UserInputService.InputBegan:Connect(function(input, _)
			if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB then
				setIsPresetTrayOpen(presetChatStore, false)
			end
		end)

		local menuOpenedConnection = GuiService.MenuOpened:Connect(function()
			if FFlagExpChatPresetTrayDismissAnalytics then
				setIsPresetTrayOpen(presetChatStore, false)
			else
				presetChatStore.setIsTrayOpen(false)
			end
		end)

		return function()
			inputBeganConnection:Disconnect()
			menuOpenedConnection:Disconnect()
		end
	end, { v, presetChatStore, setIsPresetTrayOpen })

	if not state then
		return nil
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local createElement2 = React.createElement
	local v11 = {
		DisplayOrder = 9,
		ScreenInsets = Enum.ScreenInsets.None,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}
	local v12 = {
		SizeTracker = React.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = v8
		}),
		FullFrame = 0
	}
	local fullFrame

	if not state5 then
		fullFrame = React.createElement(Foundation.View, {
			AnchorPoint = Vector2.new(0, 1),
			Position = v5:map(function(p)
				return UDim2.new(0, 0, 1, (math.round(p * v7)))
			end),
			Size = UDim2.new(1, 0, 0, v7),
			tag = "bg-surface-200"
		})
	end

	v12.FullFrame = fullFrame
	return createElement(fragment, nil, {
		OuterScreenGui = createElement2("ScreenGui", v11, v12),
		InnerScreenGui = React.createElement(
			"ScreenGui",
			{
				DisplayOrder = 10,
				ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			},
			{
				Backdrop = React.createElement("TextButton", {
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0, 0),
					Size = UDim2.fromScale(1, 1),
					Text = "",
					ZIndex = 1,
					[React.Event.Activated] = v10,
					[React.Change.AbsoluteSize] = v9
				}),
				Tray = React.createElement(Foundation.View, {
					AnchorPoint = Vector2.new(0, 1),
					Position = v5:map(function(p)
						return UDim2.new(0, 0, 1, (math.round(p * v3)))
					end),
					Size = UDim2.new(1, 0, 0, v3),
					tag = "stroke-standard stroke-default bg-surface-200",
					ClipsDescendants = true,
					ZIndex = 1
				}, {
					Handle = React.createElement(Foundation.View, {
						Size = UDim2.new(0, Config.PresetTray.HandleWidth, 0, v2.Padding.XSmall),
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.new(0.5, 0, 0, v2.Padding.XSmall),
						ZIndex = 2,
						tag = "bg-divider radius-full"
					}),
					Content = React.createElement(
						Foundation.View,
						{
							Size = UDim2.fromScale(1, 1),
							Position = UDim2.fromScale(0, 0),
							tag = "auto-xy"
						},
						{
							Container = React.createElement(PresetChatContainer, {
								textChannel = props.textChannel,
								compact = compactMode,
								shouldShowKeyboardButton = true,
								onSendChat = props.onSendChat,
								onSendGlobalChat = props.onSendGlobalChat
							})
						}
					)
				})
			}
		)
	})
end

return React.memo(PresetChatTray)
