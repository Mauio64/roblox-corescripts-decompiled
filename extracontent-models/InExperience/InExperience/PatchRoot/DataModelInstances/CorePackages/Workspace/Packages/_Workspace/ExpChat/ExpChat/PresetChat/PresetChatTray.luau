local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local Foundation = require(ExpChatParent.Foundation)
local React = require(ExpChatParent.React)
local Otter = require(ExpChatParent.Otter)
local SignalsReact = require(ExpChatParent.SignalsReact)
local Config = require(ExpChat.Config)
local GetPresetChatStore = require(ExpChat.Stores.GetPresetChatStore)
local PresetChatContainer = require(script.Parent.PresetChatContainer)
local useAutoTrayHeight = require(script.Parent.useAutoTrayHeight)
local setIsPresetTrayOpen = require(script.Parent.Thunks.setIsPresetTrayOpen)
local CompactWidthThreshold = Config.PresetTray.CompactWidthThreshold
local SlideSpring = Config.PresetTray.SlideSpring

local function isCompactMode() -- line: 23
	-- upvalues: CompactWidthThreshold (copy)
	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera then
		return CurrentCamera.ViewportSize.X < CompactWidthThreshold
	end

	return false
end
local function PresetChatTray(t1: {[any]: any}) -- line: 31
	-- upvalues: GetPresetChatStore (copy), SignalsReact (copy), CompactWidthThreshold (copy), Foundation (copy), useAutoTrayHeight (copy), React (copy), GuiService (copy), setIsPresetTrayOpen (copy), Otter (copy), SlideSpring (copy), UserInputService (copy), Config (copy), PresetChatContainer (copy)
	local v20 = GetPresetChatStore(false)
	local v21 = SignalsReact.useSignalState(v20.getIsTrayOpen)
	local CurrentCamera = workspace.CurrentCamera
	local v23 = not not CurrentCamera and CurrentCamera.ViewportSize.X < CompactWidthThreshold
	local v24 = Foundation.Hooks.useTokens()
	local v25, v26 = useAutoTrayHeight()
	local v27, v28 = React.useState(false)
	local v29, v30 = React.useBinding(1)
	local v31 = React.useRef(nil)
	local v32, v33 = React.useState(0)
	local v34, v35 = React.useState(0)
	local v36, v37 = React.useState(GuiService.TopbarInset.Height)
	local v38 = v25 + math.max(0, v32 - v34 - v36)

	React.useEffect(function() -- line: 49
		-- upvalues: GuiService (copy), v37 (copy)
		local connection = GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(function() -- line: 50
			-- upvalues: v37 (copy), GuiService (copy)
			v37(GuiService.TopbarInset.Height)
		end)

		return function() -- line: 53
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v39, v40 = React.useState(false)
	local v41 = React.useCallback(function(p1) -- line: 60
		-- upvalues: v33 (copy), v40 (copy)
		v33(p1.AbsoluteSize.Y)
		v40(p1.AbsoluteSize.Y > p1.AbsoluteSize.X)
	end, {})
	local v42 = React.useCallback(function(p2) -- line: 65
		-- upvalues: v35 (copy), v26 (copy)
		v35(p2.AbsoluteSize.Y)
		v26(p2)
	end, { v26 })
	local v43 = React.useCallback(function() -- line: 70
		-- upvalues: setIsPresetTrayOpen (copy), v20 (copy)
		setIsPresetTrayOpen(v20, false)
	end, { v20 })

	React.useEffect(function() -- line: 74
		-- upvalues: v21 (copy), v28 (copy), v31 (copy), Otter (copy), v30 (copy), SlideSpring (copy)
		if v21 then
			v28(true)

			if v31.current then
				v31.current:destroy()
			end

			local v47 = Otter.createSingleMotor(1)

			v31.current = v47
			v47:onStep(function(p3) -- line: 82
				-- upvalues: v30 (copy)
				v30(p3)
			end)
			v47:setGoal(Otter.spring(0, SlideSpring))

			return
		end

		if v31.current then
			v31.current:setGoal(Otter.spring(1, SlideSpring))
			v31.current:onComplete(function() -- line: 89
				-- upvalues: v28 (copy)
				v28(false)
			end)
		end
	end, { v21 })
	React.useEffect(function() -- line: 96
		-- upvalues: v31 (copy)
		return function() -- line: 97
			-- upvalues: v31 (copy)
			if v31.current then
				v31.current:destroy()
				v31.current = nil
			end
		end
	end, {})
	React.useEffect(function() -- line: 105
		-- upvalues: v21 (copy), UserInputService (copy), setIsPresetTrayOpen (copy), v20 (copy), GuiService (copy)
		if not v21 then
			return
		end

		local connection = UserInputService.InputBegan:Connect(function(input, _) -- line: 110
			-- upvalues: setIsPresetTrayOpen (copy), v20 (copy)
			if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB then
				setIsPresetTrayOpen(v20, false)
			end
		end)
		local connection2 = GuiService.MenuOpened:Connect(function() -- line: 116
			-- upvalues: v20 (copy)
			v20.setIsTrayOpen(false)
		end)

		return function() -- line: 120
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {
		v21,
		v20,
		setIsPresetTrayOpen
	})

	if not v27 then
		return nil
	end

	return React.createElement(React.Fragment, nil, {
		OuterScreenGui = React.createElement("ScreenGui", {
			DisplayOrder = 9,
			ScreenInsets = Enum.ScreenInsets.None,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			SizeTracker = React.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				[React.Change.AbsoluteSize] = v41
			}),
			FullFrame = if v39 then nil else React.createElement(Foundation.View, {
				tag = "bg-surface-200",
				AnchorPoint = Vector2.new(0, 1),
				Position = v29:map(function(p5) -- line: 144
					-- upvalues: v38 (copy)
					return UDim2.new(0, 0, 1, (math.round(p5 * v38)))
				end),
				Size = UDim2.new(1, 0, 0, v38)
			})
		}),
		InnerScreenGui = React.createElement("ScreenGui", {
			DisplayOrder = 10,
			ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			Backdrop = React.createElement("TextButton", {
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0, 0),
				Size = UDim2.fromScale(1, 1),
				Text = "",
				ZIndex = 1,
				[React.Event.Activated] = v43,
				[React.Change.AbsoluteSize] = v42
			}),
			Tray = React.createElement(Foundation.View, {
				tag = "stroke-standard stroke-default bg-surface-200",
				ClipsDescendants = true,
				ZIndex = 1,
				AnchorPoint = Vector2.new(0, 1),
				Position = v29:map(function(p6) -- line: 169
					-- upvalues: v25 (copy)
					return UDim2.new(0, 0, 1, (math.round(p6 * v25)))
				end),
				Size = UDim2.new(1, 0, 0, v25)
			}, {
				Handle = React.createElement(Foundation.View, {
					ZIndex = 2,
					tag = "bg-divider radius-full",
					Size = UDim2.new(0, Config.PresetTray.HandleWidth, 0, v24.Padding.XSmall),
					AnchorPoint = Vector2.new(0.5, 0),
					Position = UDim2.new(0.5, 0, 0, v24.Padding.XSmall)
				}),
				Content = React.createElement(Foundation.View, {
					tag = "auto-xy",
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.fromScale(0, 0)
				}, {
					Container = React.createElement(PresetChatContainer, {
						shouldShowKeyboardButton = true,
						textChannel = t1.textChannel,
						compact = v23
					})
				})
			})
		})
	})
end

return React.memo(PresetChatTray)
