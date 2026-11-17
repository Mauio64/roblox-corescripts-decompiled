local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local Config = require(ExpChat.Config)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local SignalsReact = require(parent.SignalsReact)
local Signals = require(parent.Signals)
local createEffect = Signals.createEffect
local ExpChatShared = require(parent.ExpChatShared)
local Cryo = require(parent.Cryo)
local UIBlox = require(parent.UIBlox)

local Analytics = ExpChatShared.Analytics

local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor

local useInterpolatedClientSettings = require(ExpChat.ClientSettings.useInterpolatedClientSettings)
local GetFocusNavigationStore = require(ExpChat.Stores.GetFocusNavigationStore)
local focusNavigationStore = GetFocusNavigationStore(false)
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore
local SharedFlags2 = require(parent.SharedFlags)
local FFlagExpChatTabShortcutNav = SharedFlags2.FFlagExpChatTabShortcutNav
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local ExpChatPerfTracker = ChatUIPrimitives.Telemetry.ExpChatPerfTracker
local ChatUIPrimitives2 = require(parent.ChatUIPrimitives)
local FFlagExpChatPerfTrackerTabName = ChatUIPrimitives2.Flags.FFlagExpChatPerfTrackerTabName
local FFlagGlobalTextChatAddPlaySessionField = require(ExpChat.Flags.FFlagGlobalTextChatAddPlaySessionField)
local GetChatLayoutStore = require(ExpChat.Stores.GetChatLayoutStore)

local ChannelTab = require(script.Parent.Parent.ChannelTab)

local joined = Cryo.List.join(
	Analytics.DefaultStandardizedFields,
	{ "addPlaceInstanceId" },
	FFlagGlobalTextChatAddPlaySessionField and { "addPlaySessionId" } or {}
)

local iconsnavigationcycleDown = Images["icons/navigation/cycleDown"]
local color = Color3.fromRGB(255, 255, 255)

local color2 = Color3.fromRGB(100, 100, 100)

local defineFastInt = game:DefineFastInt("ExpChatTabNavFocusPollDelayFrames", 3)
local defineFastInt2 = game:DefineFastInt("ExpChatTabNavFocusPollFrames", 4)

local function countAllChannelTabs(allChannelTabs) -- 1 equivalent call inferred from this helper
	local count = 0

	for _ in pairs(allChannelTabs) do
		count += 1
	end

	return count
end

local function setTransparency(p, transparencyValue) -- 9 equivalent calls inferred from this helper
	return transparencyValue:map(function(p2)
		if p == nil then
			return 1
		end

		return p + p2 * (1 - p)
	end)
end

local function ChannelBar(props)
	local count = countAllChannelTabs(props.allChannelTabs) -- inferred equivalent call
	local v = Config.ChatWindowSize.Y.Scale * props.chatWindowSettings.HeightScale * Config.ChatWindowMaxWidth

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local v2 = SignalsReact.useSignalState(GetChatLayoutStore(false).getChatWindowWidth)
	local state3, setState3 = React.useState(1024)

	local state4, setState4 = React.useState(false)

	local v3 = SignalsReact.useSignalState(focusNavigationStore.getChatInputBarFocused)
	local ref = React.useRef(nil)
	local v4 = ReactFocusNavigation.useFocusGuiObject()
	local selectionImageObject = useSelectionCursor(CursorKind.Invisible)
	local selectionImageObject2 = useSelectionCursor(CursorKind.RoundedSlot)
	local state5, setState5

	if FFlagExpChatTabShortcutNav then
		state5, setState5 = React.useState(nil)
	else
		state5 = nil
	end

	local ref2

	if FFlagExpChatTabShortcutNav then
		ref2 = React.useRef({})
	else
		ref2 = nil
	end

	local state6, setState6

	if FFlagExpChatTabShortcutNav then
		state6, setState6 = React.useState(nil)
	else
		setState6 = nil
		state6 = nil
	end

	local v5 = v2 or state3
	local dropdownMenu = v5 < count * Config.ChannelTabsSettings.MinTabWidth
	local v6

	if dropdownMenu or not count then
		v6 = math.floor((v5 - Config.ChannelTabsSettings.DropdownIconContainerWidth) / Config.ChannelTabsSettings.MinTabWidth)
	else
		v6 = count
	end

	local v7 = (v5 - (dropdownMenu and Config.ChannelTabsSettings.DropdownIconContainerWidth or 0)) / v6

	local v8 = (count - v6) * 40

	React.useEffect(function()
		if not FFlagExpChatTabShortcutNav then
			return
		end

		focusNavigationStore.setTabBarVisible(props.visible)
		return function()
			focusNavigationStore.setTabBarVisible(false)
		end
	end, { props.visible })

	React.useEffect(function()
		if not FFlagExpChatTabShortcutNav then
			return
		end

		focusNavigationStore.setTabBarRoot(state5)
		return function()
			focusNavigationStore.setTabBarRoot(nil)
		end
	end, { state5 })

	local function somethingElseHoldsFocus() -- 1 equivalent call inferred from this helper
		return focusNavigationStore.getIsChatFocused() and not focusNavigationStore.getIsTabBarFocused()
			or UserInputService:GetFocusedTextBox() ~= nil
	end

	React.useEffect(function()
		if not FFlagExpChatTabShortcutNav then
			return
		end

		local v9 = false

		local effect = createEffect(function(p)
			local tabNavFocusRequestTime = focusNavigationStore.getTabNavFocusRequestTime(p)
			local tabNavFocusTabName = focusNavigationStore.getTabNavFocusTabName(p)

			if tabNavFocusRequestTime == nil then
				return
			end

			local v10

			if tabNavFocusTabName then
				v10 = props.allChannelTabs[tabNavFocusTabName]
			end

			if v10 == nil then
				focusNavigationStore.clearTabNavFocusRequest()
				return
			end

			local v11

			if FFlagExpChatUseChannelTabsStore then
				v11 = v10.tabIndex
			else
				v11 = v10.TabIndex
			end

			setState2(v6 < v11)

			local function superseded() -- 2 equivalent calls inferred from this helper
				return v9 or focusNavigationStore.getTabNavFocusRequestTime(false) ~= tabNavFocusRequestTime
			end

			task.spawn(function()
				for _ = 1, defineFastInt do
					RunService.Heartbeat:Wait()

					if superseded() then -- inferred equivalent call
						return
					end
				end

				for i = 1, defineFastInt2 do
					if i > 1 then
						RunService.Heartbeat:Wait()
					end

					if superseded() then -- inferred equivalent call
						return
					end

					if
						(not focusNavigationStore.getIsChatFocused() or focusNavigationStore.getIsTabBarFocused())
						and UserInputService:GetFocusedTextBox() == nil
					then
						setState6(tabNavFocusTabName)
						focusNavigationStore.clearTabNavFocusRequest()
						return
					end
				end

				if not v9 and focusNavigationStore.getTabNavFocusRequestTime(false) == tabNavFocusRequestTime then
					focusNavigationStore.clearTabNavFocusRequest()
				end
			end)
		end)
		return function()
			v9 = true
			effect()
		end
	end, { v6, props.allChannelTabs })

	React.useEffect(function()
		if not FFlagExpChatTabShortcutNav or state6 == nil then
			return
		end

		if somethingElseHoldsFocus() then -- inferred equivalent call
			setState6(nil)
			return
		end

		local v9 = ref2.current[state6]

		if v9 then
			v4(v9)
			setState6(nil)
		elseif props.allChannelTabs[state6] == nil then
			setState6(nil)
		end
	end, { state6, state2, props.allChannelTabs, v4 })

	local unreadDot = React.useMemo(function(): boolean
		for _, allChannelTab in pairs(props.allChannelTabs) do
			local v9

			if FFlagExpChatUseChannelTabsStore then
				v9 = allChannelTab.tabIndex
			else
				v9 = allChannelTab.TabIndex
			end

			if v6 < v9 and allChannelTab.HasUnreadMessages then
				return true
			end
		end

		return false
	end, { v6, props.allChannelTabs })

	local children = {}
	children["$layout"] = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal
	})

	local children2 = {}
	children2["$layout"] = React.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical
	})

	for k, allChannelTab in pairs(props.allChannelTabs) do
		local tabIndex

		if FFlagExpChatUseChannelTabsStore then
			tabIndex = allChannelTab.tabIndex
		else
			tabIndex = allChannelTab.TabIndex
		end

		local v9 = tabIndex <= v6
		local allTextChannel = props.allTextChannels[k]
		local kind

		if FFlagExpChatUseChannelTabsStore then
			kind = allChannelTab.type
		else
			kind = allChannelTab.Type
		end

		local createElement = React.createElement
		local v10 = {
			channelTabsSettings = props.channelTabsSettings,
			channelName = k,
			textChannel = allTextChannel,
			tabType = kind,
			hasUnreadMessages = allChannelTab.HasUnreadMessages,
			isDividerVisible = 0,
			isTabCollapsed = 0,
			isTabSelected = 0,
			tabIndex = 0,
			isTabVisibleToUser = 0,
			isLayoutReady = 0,
			tabRef = 0,
			onTabSelected = 0,
			setTransparency = 0
		}
		local isDividerVisible

		if tabIndex < v6 or dropdownMenu then
			isDividerVisible = tabIndex < count
		else
			isDividerVisible = dropdownMenu
		end

		v10.isDividerVisible = isDividerVisible
		v10.isTabCollapsed = not v9
		v10.isTabSelected = props.selectedTabName and props.selectedTabName == k
		v10.tabIndex = tabIndex
		v10.isTabVisibleToUser = v9 or state2
		v10.isLayoutReady = state4
		v10.tabRef = FFlagExpChatTabShortcutNav and function(p)
			ref2.current[k] = p
		end or nil

		function v10.onTabSelected()
			ExpChatPerfTracker.cancelAll()
			ExpChatPerfTracker.start(
				ExpChatPerfTracker.Events.ChatWindowTabSwitchTTI,
				{ tabId = k },
				FFlagExpChatPerfTrackerTabName and { tabName = k } or nil
			)

			if not v9 and v3 and ref.current then
				v4(ref.current)
			end

			Analytics:TelemetryLogEvent(Analytics.ExpChatTabClickedConfig, {
				name = k,
				type = kind or "Unknown",
				index = tabIndex,
				in_overflow = not v9,
				badge_count = allChannelTab.HasUnreadMessages and 1 or 0,
				previous_tab_name = props.selectedTabName
			}, joined)

			props.onTabSelected(allTextChannel, not v9, k, kind)
			setState2(false)
		end
		function v10.setTransparency(p)
			return setTransparency(p, props.transparencyValue)
		end

		local element = createElement(ChannelTab, v10)

		if v9 then
			children[tabIndex] = React.createElement(
				"Frame",
				{
					Size = UDim2.new(0, v7, 1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = tabIndex
				},
				{ ChannelTab = element }
			)
		else
			local layoutOrder = tabIndex - v6
			children2[layoutOrder] = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundTransparency = 1,
					LayoutOrder = layoutOrder
				},
				{ ChannelTab = element }
			)
		end
	end

	local channelTabsConfiguration = TextChatService:FindFirstChildOfClass("ChannelTabsConfiguration")
	local channelTabsSettings = props.channelTabsSettings
	local backgroundTransparency = useInterpolatedClientSettings(channelTabsSettings).BackgroundTransparency
	local backgroundColor3 = useInterpolatedClientSettings(channelTabsSettings).BackgroundColor3

	local createElement = React.createElement
	local v9 = {
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		["Size"] = nil,
		Size = UDim2.new(1, 0, 0, Config.ChannelTabsSettings.HorizontalBarHeight),
		BackgroundTransparency = 1,
		Visible = props.visible,
		BorderSizePixel = 0,
		ZIndex = 3
	}

	if not FFlagExpChatTabShortcutNav then
		setState5 = nil
	end

	v9.ref = setState5
	v9[React.Event.MouseEnter] = props.onHovered
	v9[React.Event.MouseLeave] = props.onUnhovered
	v9[React.Change.AbsoluteSize] = function(p)
		setState3(p.AbsoluteSize.X)
		setState4(true)

		if channelTabsConfiguration then
			channelTabsConfiguration:SetAbsoluteSize(p.AbsoluteSize)
		end
	end
	v9[React.Change.AbsolutePosition] = function(p)
		if channelTabsConfiguration then
			channelTabsConfiguration:SetAbsolutePosition(p.AbsolutePosition)
		end
	end
	local v10 = {
		HorizontalBar = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0 },
			{
				ContentContainer = React.createElement(
					"Frame",
					{
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ClipsDescendants = true
					},
					children
				),
				TopCorner = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					ImageColor3 = backgroundColor3,
					ImageTransparency = setTransparency(backgroundTransparency, props.transparencyValue), -- inferred equivalent call
					Image = "rbxasset://textures/ui/TopRoundedRect8px.png",
					ScaleType = Enum.ScaleType.Slice,
					Size = UDim2.new(1, 0, 0, 8),
					SliceCenter = Rect.new(8, 8, 24, 32),
					BorderSizePixel = 0,
					Selectable = true,
					SelectionImageObject = selectionImageObject,
					ref = props.topBorderRef
				}),
				BottomBorder = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, -1),
					BackgroundColor3 = Config.ChannelTabsSettings.BorderColor3,
					BackgroundTransparency = setTransparency( -- inferred equivalent call
						Config.ChannelTabsSettings.BorderTransparency,
						props.transparencyValue
					),
					BorderSizePixel = 0
				}),
				Background = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, Config.ChannelTabsSettings.HorizontalBarHeight - 8 - 1),
					Position = UDim2.new(0, 0, 0, 8),
					BackgroundColor3 = backgroundColor3,
					BackgroundTransparency = setTransparency(backgroundTransparency, props.transparencyValue), -- inferred equivalent call
					BorderSizePixel = 0
				})
			}
		),
		DropdownButton = 0,
		DropdownMenu = 0
	}
	local dropdownButton

	if dropdownMenu then
		local createElement2 = React.createElement
		local v11 = {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 8),
			Size = UDim2.new(0, Config.ChannelTabsSettings.DropdownIconContainerWidth, 1, -9),
			BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v12 = {
			TextButton = React.createElement("TextButton", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -Config.ChannelTabsSettings.DropdownIconPadding / 2, 0.5, -4),
				Size = UDim2.new(0, 27, 0, 27),
				BackgroundTransparency = setTransparency(state and 0.3 or 1, props.transparencyValue), -- inferred equivalent call
				BackgroundColor3 = color2,
				Text = "",
				BorderSizePixel = 0,
				Selectable = true,
				SelectionImageObject = selectionImageObject2,
				ref = ref,
				[React.Event.MouseEnter] = function()
					setState(true)
				end,
				[React.Event.MouseLeave] = function()
					setState(false)
				end,
				[React.Event.Activated] = function()
					setState2(not state2)
				end
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 27) }),
				DropdownIconImage = React.createElement(ImageSetLabel, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromScale(0.6, 0.6),
					BackgroundTransparency = 1,
					Image = iconsnavigationcycleDown,
					ImageColor3 = color,
					ImageTransparency = setTransparency(0, props.transparencyValue), -- inferred equivalent call
					ScaleType = Enum.ScaleType.Stretch,
					BorderSizePixel = 0
				})
			}),
			UnreadDot = 0
		}

		if unreadDot then
			unreadDot = React.createElement("Frame", {
				Size = UDim2.new(0, 8, 0, 8),
				Position = UDim2.new(0, 18, 0.5, -4),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundColor3 = Config.ChannelTabsSettings.UnreadDotColor3,
				BackgroundTransparency = setTransparency(0, props.transparencyValue), -- inferred equivalent call
				BorderSizePixel = 0
			}, {
				UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
			})
		end

		v12.UnreadDot = unreadDot
		dropdownButton = createElement2("Frame", v11, v12)
	else
		dropdownButton = dropdownMenu
	end

	v10.DropdownButton = dropdownButton

	if dropdownMenu then
		dropdownMenu = React.createElement("Frame", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -1, 0, Config.ChannelTabsSettings.HorizontalBarHeight + 1),
			Size = UDim2.new(0, 150, 0, v8),
			BackgroundTransparency = 1,
			Visible = state2
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = Vector2.new(150, v)
			}),
			Border = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Config.ChannelTabsSettings.BorderColor3,
				Transparency = setTransparency(Config.ChannelTabsSettings.BorderTransparency, props.transparencyValue) -- inferred equivalent call
			}),
			ScrollView = React.createElement("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				CanvasSize = UDim2.new(0, 150, 0, v8),
				BackgroundTransparency = setTransparency(0, props.transparencyValue), -- inferred equivalent call
				ScrollBarThickness = 4,
				ScrollBarImageTransparency = setTransparency(0, props.transparencyValue), -- inferred equivalent call
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ElasticBehavior = Enum.ElasticBehavior.Always,
				ClipsDescendants = true,
				Selectable = false,
				BorderSizePixel = 0
			}, children2)
		})
	end

	v10.DropdownMenu = dropdownMenu
	return createElement("Frame", v9, v10)
end

return ChannelBar
