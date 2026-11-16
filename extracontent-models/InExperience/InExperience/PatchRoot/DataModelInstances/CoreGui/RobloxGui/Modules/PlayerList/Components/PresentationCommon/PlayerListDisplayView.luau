local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.Signals)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Otter = require(CorePackages.Packages.Otter)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
require(CorePackages.Workspace.Packages.LeaderboardStore)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome.Enabled

local useLayoutValues = PlayerList.Common.useLayoutValues
local usePlayerListFocusNavigation = PlayerList.Hooks.usePlayerListFocusNavigation

local useStyle = UIBlox.Core.Style.useStyle
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useFocusedGuiObject = ReactFocusNavigation.useFocusedGuiObject

local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local iconSize = UIBlox.App.ImageSet.getIconSize(IconSize.Small)

local Images = UIBlox.App.ImageSet.Images

local PlayerEntryContainer = require(parent2.Components.Container.PlayerEntryContainer)
local TeamListContainer = require(parent2.Components.Container.TeamListContainer)
local TitleBarContainer = require(parent2.Components.Container.TitleBarContainer)

local PlayerDropDown = require(parent.Presentation.PlayerDropDown)

local FFlagPlayerListFixMobileScrolling = require(parent2.Flags.FFlagPlayerListFixMobileScrolling)
local defineFastFlag = game:DefineFastFlag("DisablePlayerListDisplayCloseBtn", false)
local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook
local FFlagPlayerListTwoTabsOnLegacy = PlayerList.Flags.FFlagPlayerListTwoTabsOnLegacy
local LegacyTwoTabsBody = PlayerList.Presentation.LegacyTwoTabsBody

local v = Enabled() and not defineFastFlag

local v2 = { dampingRatio = 1, frequency = 4 }

local function PlayerListDisplayView(props)
	local v3 = useLayoutValues()
	local v4 = useStyle()
	local backgroundTransparency = (v3.OverrideBackgroundTransparency or 0) * v4.Settings.PreferredTransparency

	local v5 = useFocusGuiObject()
	local v6

	if FFlagPlayerListUseFocusNavHook then
		v6 = nil
	else
		v6 = useFocusedGuiObject()
	end

	local v7

	if FFlagPlayerListUseFocusNavHook then
		v7 = usePlayerListFocusNavigation()
	else
		v7 = nil
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3

	if FFlagPlayerListUseFocusNavHook then
		ref3 = nil
	else
		ref3 = React.useRef(nil)
	end

	local ref4

	if FFlagPlayerListUseFocusNavHook then
		ref4 = nil
	else
		ref4 = React.useRef(nil)
	end

	local ref5 = React.useRef(Otter.createSingleMotor(0))

	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(100)
	local state3, setState3 = React.useState(0)
	local state4, setState4 = React.useState(true)

	local state5, setState5 = React.useState(Vector2.new(0, 0))

	local state6, setState6 = React.useState(0)
	local state7, setState7 = React.useState(0)

	local state8, setState8 = React.useState(0)
	local state9, setState9 = React.useState(nil)

	local binding, v8 = React.createBinding(0)
	local binding2, v9 = React.createBinding(0)
	local binding3, v10 = React.createBinding(0)
	local mapped = React.joinBindings({ binding, binding2, binding3 }):map(function(list)
		local item = list[1]
		local item2 = list[2]
		return item2 + (list[3] - item2) * item
	end)

	local v11 = React.useCallback(function(p)
		setState7(p.AbsoluteSize.Y)
	end, {})

	local v12 = React.useCallback(function(p)
		setState2(p.AbsoluteSize.Y)
	end, {})

	local v13 = React.useCallback(function(p)
		setState(p.CanvasPosition)
	end, {})

	local v14 = React.useCallback(function(p)
		setState3(p.AbsolutePosition.Y)
	end, {})

	local v15 = React.useCallback(function()
		if not props.isSmallTouchDevice then
			return false
		end

		local v15 = props.teamList and props.teamList.getCount(false) > 0 and true or false
		local v16 = props.gameStatsCount > 0

		return v15 or v16
	end, { props.gameStatsCount, props.isSmallTouchDevice, props.teamList })

	React.useEffect(function()
		ref5.current:onStep(v8)
		ref5.current:onComplete(function(p)
			if p == 0 then
				setState4(true)
			end
		end)
	end, { v8 })

	React.useEffect(function()
		if props.isSmallTouchDevice then
			setState4(not props.isMinimized)
			return
		end

		if ref5.current then
			ref5.current:setGoal(Otter.spring(props.isMinimized and 1 or 0, v2))
		end

		if props.isMinimized then
			setState4(false)
		end
	end, { props.isSmallTouchDevice, props.isMinimized, ref5.current })

	React.useEffect(function()
		local v16 = state2 - 8

		if props.gameStatsCount > 0 then
			v16 -= v3.TitleBarSizeY or 0
		end

		setState6((math.min(state7, v16)))
	end, { state2, state7, props.gameStatsCount, v3.TitleBarSizeY })

	React.useEffect(function()
		local x = state5.X
		local y = state5.Y

		local current = ref.current

		if props.isSmallTouchDevice or not current then
			setState8(x)
			setState9(nil)
		else
			local v16 = x - current.AbsolutePosition.Y

			if v16 + y >= current.AbsoluteSize.Y then
				local v17 = v16 + y - current.AbsoluteSize.Y
				setState8(v16 - v17)
				setState9(Vector2.new(0, current.CanvasPosition.Y + v17))
			else
				setState8(v16)
				setState9(nil)
			end
		end
	end, { state5, props.isSmallTouchDevice, ref.current })

	if not FFlagPlayerListUseFocusNavHook then
		React.useEffect(function()
			if not FFlagAddNewPlayerListFocusNav then
				if props.isVisible then
					if props.isDirectionalPreferred and props.isUsingGamepad then
						GuiService.SelectedCoreObject = ref2.current
						UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
					end

					if ref.current and not props.isSmallTouchDevice then
						ref.current.SelectionGroup = true
						ref.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
						ref.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
						ref.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
						ref.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
					end
				else
					if props.isDirectionalPreferred and props.isUsingGamepad then
						UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
					end

					if
						ref.current
						and GuiService.SelectedCoreObject
						and GuiService.SelectedCoreObject:IsDescendantOf(ref.current)
					then
						GuiService.SelectedCoreObject = nil
					end

					if ref.current and not props.isSmallTouchDevice then
						ref.current.SelectionGroup = false
					end
				end
			end
		end, {
			props.isVisible,
			props.isSmallTouchDevice,
			props.isDirectionalPreferred,
			props.isUsingGamepad,
			ref2.current,
			ref.current
		})

		React.useEffect(function()
			if FFlagAddNewPlayerListFocusNav and props.isVisible and ref.current then
				if props.isDirectionalPreferred and props.isUsingGamepad then
					v5(nil)
					v5(ref.current)
					UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
				end

				if not props.isSmallTouchDevice then
					ref.current.SelectionGroup = true
					ref.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
					ref.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
					ref.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
					ref.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
				end
			end
		end, {
			v5,
			props.isVisible,
			props.isSmallTouchDevice,
			props.isDirectionalPreferred,
			props.isUsingGamepad,
			ref.current
		})

		React.useEffect(function()
			if
				FFlagAddNewPlayerListMobileFocusNav
				and props.isVisible
				and props.isSmallTouchDevice
				and props.isUsingGamepad
				and ref.current
			then
				local v16 = false

				if props.dropDownPlayer and not props.dropDownVisible then
					local guiObject

					if LocalPlayer and props.dropDownPlayer.UserId == LocalPlayer.UserId then
						guiObject = ref.current:FindFirstChild("TitlePlayer", true)
					else
						guiObject = ref.current:FindFirstChild("PlayerEntry_" .. props.dropDownPlayer.UserId, true)
					end

					if guiObject and guiObject:IsA("GuiObject") then
						v5(guiObject)
						v16 = true
					end
				end

				if not v16 then
					v5(nil)
					v5(ref.current)
				end
			end
		end, {
			v5,
			props.isVisible,
			props.dropDownVisible,
			props.dropDownPlayer,
			props.isSmallTouchDevice,
			props.isUsingGamepad,
			ref.current
		})

		React.useEffect(function()
			if FFlagAddNewPlayerListFocusNav and not props.isVisible and ref.current then
				if
					(FFlagAddNewPlayerListMobileFocusNav and props.isSmallTouchDevice or props.isDirectionalPreferred)
					and props.isUsingGamepad
				then
					UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
				end

				if v6 and v6:IsDescendantOf(ref.current) then
					v5(nil)
				end

				if FFlagAddNewPlayerListMobileFocusNav or not props.isSmallTouchDevice then
					ref.current.SelectionGroup = false
				end
			end
		end, {
			v6,
			v5,
			props.isVisible,
			props.isSmallTouchDevice,
			props.isDirectionalPreferred,
			props.isUsingGamepad,
			ref.current
		})

		React.useEffect(function()
			if FFlagAddNewPlayerListFocusNav and props.isVisible and not v6 and ref4.current and ref.current then
				local guiObject = ref.current:FindFirstChild("PlayerEntry_" .. ref4.current, true)

				if guiObject and guiObject:IsA("GuiObject") then
					v5(guiObject)
				elseif ref3.current and ref3.current:IsDescendantOf(ref.current) then
					v5(ref3.current)
				else
					v5(ref.current)
				end

				ref4.current = nil
			end
		end, { v6, v5, props.isVisible, ref3.current, ref4.current, ref.current })
	end

	if FFlagPlayerListUseFocusNavHook then
		React.useEffect(function()
			if props.isVisible and props.isSmallTouchDevice and props.isUsingGamepad and not props.dropDownVisible then
				v7.getFocus()
			end
		end, {
			v7,
			props.isVisible,
			props.isSmallTouchDevice,
			props.isUsingGamepad,
			props.dropDownVisible
		})

		React.useEffect(function()
			if not props.isVisible then
				local v16 = ref.current
					and GuiService.SelectedCoreObject
					and GuiService.SelectedCoreObject:IsDescendantOf(ref.current)
				v7.cleanup(v16)
			end
		end, { v7, props.isVisible })
	end

	local registerPlayerInstance

	if FFlagPlayerListUseFocusNavHook then
		registerPlayerInstance = React.useCallback(function(_: number, p, _)
			v7.setTitlePlayerInstance(p)
		end, { v7 })
	end

	local unregisterPlayerInstance

	if FFlagPlayerListUseFocusNavHook then
		unregisterPlayerInstance = React.useCallback(function(_: number)
			v7.setTitlePlayerInstance(nil)
		end, { v7 })
	end

	local children = {}

	local createElement = React.createElement
	local v16 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		Padding = 0
	}
	local padding

	if props.isDirectionalPreferred then
		padding = UDim.new(0, v3.EntryPadding)
	end

	v16.Padding = padding
	children.UIListLayout = createElement("UIListLayout", v16)

	if LocalPlayer and props.isSmallTouchDevice and v15() then
		local createElement2 = React.createElement
		local v17 = {
			entrySizeX = props.entrySizeX,
			layoutOrder = -3,
			titlePlayerEntry = true,
			player = LocalPlayer,
			playerIconInfo = props.playerIconInfo[LocalPlayer.UserId] or { isPlaceOwner = false },
			playerRelationship = props.playerRelationship[LocalPlayer.UserId] or {
				isBlocked = false,
				friendStatus = Enum.FriendStatus.NotFriend,
				isFollowing = false,
				isFollower = false
			},
			setDropDownPlayerDimensionY = setState5,
			registerPlayerInstance = 0,
			unregisterPlayerInstance = 0,
			setSelectedPlayerId = 0
		}

		if not FFlagPlayerListUseFocusNavHook then
			registerPlayerInstance = nil
		end

		v17.registerPlayerInstance = registerPlayerInstance

		if not FFlagPlayerListUseFocusNavHook then
			unregisterPlayerInstance = nil
		end

		v17.unregisterPlayerInstance = unregisterPlayerInstance
		local setSelectedPlayerId

		if FFlagPlayerListUseFocusNavHook then
			setSelectedPlayerId = v7.setSelectedPlayerId
		end

		v17.setSelectedPlayerId = setSelectedPlayerId
		children.TitlePlayer = createElement2(PlayerEntryContainer, v17)

		children.BottomDiv = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.8,
			LayoutOrder = -2
		})
	end

	if props.isSmallTouchDevice then
		children.TitleBar = React.createElement(TitleBarContainer, {
			size = UDim2.new(1, 0, 0, v3.TitleBarSizeY),
			entrySizeX = props.entrySizeX,
			layoutOrder = -1,
			contentsVisible = state4,
			isSmallTouchDevice = true
		})
	end

	if props.teamListCount > 0 then
		local v17 = 1e999
		props.teamList.iterateData(function(teamId, teamData)
			local v18

			if
				FFlagAddNewPlayerListFocusNav
				or not (teamData.order(false) <= v17 and teamData.players.getCount(false) > 0)
			then
				v18 = false
			else
				v17 = teamData.order(false)
				v18 = true
			end

			local v19 = "TeamList_" .. tostring(teamId)
			local createElement2 = React.createElement
			local v20 = {
				entrySizeX = props.entrySizeX,
				teamId = 0,
				teamData = 0,
				playerIconInfos = 0,
				playerRelationships = 0,
				firstPlayerRef = 0,
				setDropDownPlayerDimensionY = 0,
				prevFocusedEntry = 0,
				destroyedFocusedPlayerId = 0,
				registerTeamInstance = 0,
				unregisterTeamInstance = 0,
				setSelectedPlayerId = 0,
				isSmallTouchDevice = 0,
				isDirectionalPreferred = 0
			}

			if not FFlagPlayerListUseFocusNavHook then
				teamId = nil
			end

			v20.teamId = teamId
			v20.teamData = teamData
			v20.playerIconInfos = props.playerIconInfo
			v20.playerRelationships = props.playerRelationship
			local firstPlayerRef

			if not (FFlagAddNewPlayerListFocusNav or not v18) then
				firstPlayerRef = ref2
			end

			v20.firstPlayerRef = firstPlayerRef

			v20.setDropDownPlayerDimensionY = setState5
			local prevFocusedEntry

			if not (FFlagPlayerListUseFocusNavHook or not FFlagAddNewPlayerListFocusNav) then
				prevFocusedEntry = ref3
			end

			v20.prevFocusedEntry = prevFocusedEntry
			local destroyedFocusedPlayerId

			if not (FFlagPlayerListUseFocusNavHook or not FFlagAddNewPlayerListFocusNav) then
				destroyedFocusedPlayerId = ref4
			end

			v20.destroyedFocusedPlayerId = destroyedFocusedPlayerId
			local registerTeamInstance

			if FFlagPlayerListUseFocusNavHook then
				registerTeamInstance = v7.registerTeamInstance
			end

			v20.registerTeamInstance = registerTeamInstance
			local unregisterTeamInstance

			if FFlagPlayerListUseFocusNavHook then
				unregisterTeamInstance = v7.unregisterTeamInstance
			end

			v20.unregisterTeamInstance = unregisterTeamInstance
			local setSelectedPlayerId

			if FFlagPlayerListUseFocusNavHook then
				setSelectedPlayerId = v7.setSelectedPlayerId
			end

			v20.setSelectedPlayerId = setSelectedPlayerId

			v20.isSmallTouchDevice = props.isSmallTouchDevice
			v20.isDirectionalPreferred = props.isDirectionalPreferred
			children[v19] = createElement2(TeamListContainer, v20)
		end, false)
	end

	if props.isSmallTouchDevice then
		local scrollingEnabled = FFlagPlayerListFixMobileScrolling and true or not props.dropDownVisible

		local createElement2 = React.createElement
		local v17 = {
			["Active"] = FFlagPlayerListFixMobileScrolling,
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ScrollBarImageColor3 = v3.ScrollImageColor,
			ScrollBarImageTransparency = v3.ScrollImageTransparency,
			BorderSizePixel = 0,
			ScrollBarThickness = v3.ScrollBarSizeMobile,
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			HorizontalScrollBarInset = Enum.ScrollBarInset.None,
			ClipsDescendants = true,
			ScrollingEnabled = scrollingEnabled,
			ElasticBehavior = Enum.ElasticBehavior.Never,
			Selectable = false,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			SelectionGroup = FFlagAddNewPlayerListMobileFocusNav and true or nil
		}
		local selectionBehaviorUp

		if FFlagAddNewPlayerListMobileFocusNav then
			selectionBehaviorUp = Enum.SelectionBehavior.Stop
		end

		v17.SelectionBehaviorUp = selectionBehaviorUp
		local selectionBehaviorDown

		if FFlagAddNewPlayerListMobileFocusNav then
			selectionBehaviorDown = Enum.SelectionBehavior.Stop
		end

		v17.SelectionBehaviorDown = selectionBehaviorDown
		local selectionBehaviorLeft

		if FFlagAddNewPlayerListMobileFocusNav then
			selectionBehaviorLeft = Enum.SelectionBehavior.Stop
		end

		v17.SelectionBehaviorLeft = selectionBehaviorLeft
		local selectionBehaviorRight

		if FFlagAddNewPlayerListMobileFocusNav then
			selectionBehaviorRight = Enum.SelectionBehavior.Stop
		end

		v17.SelectionBehaviorRight = selectionBehaviorRight
		local ref6

		if FFlagAddNewPlayerListMobileFocusNav then
			ref6 = ref
		end

		v17.ref = ref6

		v17[React.Change.CanvasPosition] = v13
		v17[React.Change.AbsoluteSize] = v12
		local element = createElement2("ScrollingFrame", v17, children)

		if not FFlagPlayerListTwoTabsOnLegacy then
			return element
		end

		local backgroundColor

		if Enabled() then
			backgroundColor = v4.Theme.BackgroundUIContrast.Color
		else
			backgroundColor = v4.Theme.BackgroundContrast.Color
		end

		return React.createElement(
			"Frame",
			{ Size = v3.PlayerScrollListSizeTwoTabsOnLegacy, BackgroundTransparency = 1 },
			{
				TwoTabsBody = React.createElement(LegacyTwoTabsBody, {
					serverBody = element,
					isVisible = props.isVisible,
					isDirectionalPreferred = props.isDirectionalPreferred,
					backgroundColor = backgroundColor,
					backgroundTransparency = backgroundTransparency
				})
			}
		)
	elseif props.isDirectionalPreferred then
		local createElement2 = React.createElement
		local v17 = {
			["Size"] = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ScrollBarImageColor3 = v3.ScrollImageColor,
			ScrollBarImageTransparency = v3.ScrollImageTransparency,
			BorderSizePixel = 0,
			ScrollBarThickness = 6,
			VerticalScrollBarInset = Enum.ScrollBarInset.Always,
			ClipsDescendants = true,
			ScrollingEnabled = not props.dropDownVisible,
			Selectable = false
		}

		state = props.dropDownVisible and state9 or state
		v17.CanvasPosition = state
		v17.ref = ref

		v17[React.Change.CanvasPosition] = v13
		local element = createElement2("ScrollingFrame", v17, children)

		local createElement3 = React.createElement
		local v18 = {
			Position = v3.PlayerScrollListPosition,
			Size = v3.PlayerScrollListSize,
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = v12
		}
		local tenFootScrollingFrame

		if not FFlagPlayerListTwoTabsOnLegacy then
			tenFootScrollingFrame = element
		end

		local twoTabsBody

		if FFlagPlayerListTwoTabsOnLegacy then
			local createElement4 = React.createElement

			local v19 = {
				serverBody = element,
				isVisible = props.isVisible,
				isDirectionalPreferred = props.isDirectionalPreferred,
				backgroundColor = 0,
				backgroundTransparency = 0
			}
			local backgroundColor

			if Enabled() then
				backgroundColor = v4.Theme.BackgroundUIContrast.Color
			else
				backgroundColor = v4.Theme.BackgroundContrast.Color
			end

			v19.backgroundColor = backgroundColor

			v19.backgroundTransparency = backgroundTransparency
			twoTabsBody = createElement4(LegacyTwoTabsBody, v19)
		end

		return createElement3("Frame", v18, {
			TenFootScrollingFrame = tenFootScrollingFrame,
			TwoTabsBody = twoTabsBody
		})
	else
		local fadedBackgroundScaleDelta = v3.FadedBackgroundScaleDelta or 0
		local scrollBarOffset = v3.ScrollBarOffset or 0
		local scrollBarSize = v3.ScrollBarSize or 0
		local color

		if Enabled() then
			color = v4.Theme.BackgroundUIContrast.Color
		else
			color = v4.Theme.BackgroundContrast.Color
		end

		v9(backgroundTransparency)
		v10(v3.FadedBackgroundTransparency or 0)

		local createElement2 = React.createElement
		local v17 = {
			LayoutOrder = 3,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, state6),
			BackgroundColor3 = color,
			BackgroundTransparency = mapped,
			BorderSizePixel = 0,
			[React.Change.AbsolutePosition] = v14
		}
		local playerDropDown

		if state4 then
			playerDropDown = React.createElement(PlayerDropDown, {
				contentsVisible = state4,
				selectedPlayer = props.dropDownPlayer,
				positionY = state8,
				minPositionBoundY = -state3 + v3.DropDownScreenSidePadding,
				maxPositionBoundY = props.screenSizeY - state3 - v3.DropDownScreenSidePadding
			})
		end

		local createElement3 = React.createElement
		local v18 = {
			Visible = state4,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ClipsDescendants = true
		}

		local createElement4 = React.createElement
		local v19 = {
			["Size"] = UDim2.new(1, -scrollBarOffset, 0, state6),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ScrollBarImageColor3 = v3.ScrollImageColor,
			ScrollBarImageTransparency = v3.ScrollImageTransparency,
			BorderSizePixel = 0,
			ScrollBarThickness = v3.ScrollBarSize,
			VerticalScrollBarInset = Enum.ScrollBarInset.Always,
			ClipsDescendants = false,
			ScrollingEnabled = not props.dropDownVisible,
			Selectable = false
		}

		state = props.dropDownVisible and state9 or state
		v19.CanvasPosition = state
		v19.ref = ref

		v19[React.Change.CanvasPosition] = v13
		local element = createElement2("Frame", v17, {
			PlayerDropDown = playerDropDown,
			ScrollingFrameClippingFrame = createElement3("Frame", v18, {
				ScrollingFrame = createElement4("ScrollingFrame", v19, {
					OffsetUndoFrame = React.createElement("Frame", {
						Size = UDim2.new(1, scrollBarOffset + scrollBarSize, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						[React.Change.AbsoluteSize] = v11
					}, children)
				})
			})
		})
		local titleBar

		if props.gameStatsCount > 0 then
			titleBar = React.createElement(TitleBarContainer, {
				size = UDim2.new(1, 0, 0, v3.TitleBarSizeY),
				entrySizeX = props.entrySizeX,
				layoutOrder = 2,
				contentsVisible = state4,
				showBackground = true,
				backgroundTransparency = mapped
			})
		end

		local createElement5 = React.createElement
		local v20 = {
			Position = v3.PlayerScrollListPosition,
			Size = v3.PlayerScrollListSize,
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = v12
		}

		local createElement6 = React.createElement
		local v21 = {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}
		local v22 = {
			UIScale = React.createElement("UIScale", {
				Scale = binding:map(function(p)
					return 1 - fadedBackgroundScaleDelta * p
				end)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			TopRoundedRect = 0,
			TitleBar = 0,
			ScrollingFrameContainer = 0,
			TwoTabsBody = 0,
			BottomRoundedRect = 0
		}
		local topRoundedRect

		if v then
			topRoundedRect = React.createElement("Frame", {
				LayoutOrder = 1,
				ClipsDescendants = true,
				Size = UDim2.new(1, 0, 0, iconSize + 2),
				BackgroundTransparency = 1
			}, {
				DismissIconFrame = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, (iconSize + 2) * 2),
					BackgroundColor3 = color,
					BackgroundTransparency = mapped
				}, {
					DismissButton = React.createElement(IconButton, {
						position = UDim2.new(0, 1, 0, 1),
						iconSize = IconSize.Small,
						icon = Images["icons/navigation/close"],
						onActivated = props.dismissPlayerList
					}),
					UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 7) })
				})
			})
		else
			topRoundedRect = React.createElement("ImageLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/TopRoundedRect8px.png",
				ImageColor3 = color,
				ImageTransparency = mapped,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 24, 18),
				SliceScale = 0.5,
				Size = UDim2.new(1, 0, 0, 4)
			})
		end

		v22.TopRoundedRect = topRoundedRect
		local titleBar2

		if not FFlagPlayerListTwoTabsOnLegacy then
			if props.gameStatsCount > 0 then
				titleBar2 = React.createElement(TitleBarContainer, {
					size = UDim2.new(1, 0, 0, v3.TitleBarSizeY),
					entrySizeX = props.entrySizeX,
					layoutOrder = 2,
					contentsVisible = state4,
					showBackground = true,
					backgroundTransparency = mapped
				})
			else
				titleBar2 = false
			end
		end

		v22.TitleBar = titleBar2
		local scrollingFrameContainer

		if not FFlagPlayerListTwoTabsOnLegacy then
			scrollingFrameContainer = element
		end

		v22.ScrollingFrameContainer = scrollingFrameContainer
		local twoTabsBody

		if FFlagPlayerListTwoTabsOnLegacy then
			twoTabsBody = React.createElement(LegacyTwoTabsBody, {
				titleBar = titleBar,
				serverBody = element,
				isVisible = props.isVisible,
				isDirectionalPreferred = props.isDirectionalPreferred,
				layoutOrder = 2,
				platformBodyHeight = state6 + (props.gameStatsCount > 0 and v3.TitleBarSizeY or 0),
				backgroundColor = color,
				backgroundTransparency = mapped
			})
		end

		v22.TwoTabsBody = twoTabsBody
		local bottomRoundedRect

		if v then
			bottomRoundedRect = React.createElement("Frame", {
				LayoutOrder = 4,
				ClipsDescendants = true,
				Size = UDim2.new(1, 0, 0, 7),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, { React.createElement("Frame", {
					Position = UDim2.new(0, 0, 0, -8),
					Size = UDim2.new(1, 0, 0, 14),
					BackgroundColor3 = color,
					BackgroundTransparency = mapped,
					BorderSizePixel = 0
				}, { React.createElement("UICorner", { CornerRadius = UDim.new(0, 7) }) }) })
		else
			bottomRoundedRect = React.createElement("ImageLabel", {
				LayoutOrder = 4,
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/BottomRoundedRect8px.png",
				ImageColor3 = color,
				ImageTransparency = mapped,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 24, 16),
				SliceScale = 0.5,
				Size = UDim2.new(1, 0, 0, 4)
			})
		end

		v22.BottomRoundedRect = bottomRoundedRect
		return createElement5("Frame", v20, {
			SizeOffsetFrame = createElement6("Frame", v21, v22)
		})
	end
end

return React.memo(PlayerListDisplayView)
