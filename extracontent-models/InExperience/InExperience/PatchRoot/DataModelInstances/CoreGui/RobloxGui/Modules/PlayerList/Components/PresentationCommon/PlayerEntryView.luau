local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")

local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local InExperienceCapabilities = require(CorePackages.Workspace.Packages.InExperienceCapabilities)
local inExperienceCapabilities = InExperienceCapabilities.InExperienceCapabilities
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local SharedFlags = CorePackages.Workspace.Packages.SharedFlags
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
require(CorePackages.Workspace.Packages.LeaderboardStore)
require(CorePackages.Workspace.Packages.PlayerIconInfoStore)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local Enabled = Chrome.Enabled

local useLayoutValues = PlayerList.Common.useLayoutValues
local useStyle = UIBlox.Core.Style.useStyle
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local Foundation = require(CorePackages.Packages.Foundation)
local ControlState = Foundation.Enums.ControlState
local View = Foundation.View
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useTokens = Foundation.Hooks.useTokens
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local EntryFrameView = PlayerList.Presentation.EntryFrameView
local StatEntryContainer = require(parent3.Components.Container.StatEntryContainer)

local CellExtender = require(parent2.Presentation.CellExtender)
local PlayerIcon = require(parent.PlayerIcon)
local PlayerNameTag = require(parent2.Presentation.PlayerNameTag)

local Constants = PlayerList.Common.Constants

local module = require(SharedFlags)
local getFFlagGateLeaderboardPlayerDropdownViaGUAC = module.GetFFlagGateLeaderboardPlayerDropdownViaGUAC
local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local FFlagRemoveNewPlayerListOverlay = PlayerList.Flags.FFlagRemoveNewPlayerListOverlay
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local module2 = require(SharedFlags)
local fFlagPlayerListFixLeaderstatsStacking = module2.FFlagPlayerListFixLeaderstatsStacking
local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook

local v = { Transparency = 1, Color = Color3.new(1, 1, 1) }

local function IconAndName(props)
	return React.createElement(React.Fragment, {}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, props.layoutValues.InitalPlayerEntryPadding)
		}),
		InitalPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, props.layoutValues.InitalPlayerEntryPadding)
		}),
		PlayerIcon = React.createElement(PlayerIcon, {
			player = props.player,
			playerIconInfo = props.playerIconInfo,
			playerRelationship = props.playerRelationship,
			layoutOrder = 1
		}),
		PlayerName = React.createElement(PlayerNameTag, {
			player = props.player,
			isTitleEntry = props.titlePlayerEntry,
			isHovered = props.isHovered,
			textStyle = props.textStyle,
			textFont = props.playerNameFont,
			layoutOrder = 3
		})
	})
end

local memo = React.memo(IconAndName)

local function PlayerEntryChildren(props)
	local isSmallTouchDevice = props.isSmallTouchDevice or false
	local isDirectionalPreferred = props.isDirectionalPreferred or false
	local layoutValues = props.layoutValues
	local textStyle = props.textStyle
	local playerNameFont = props.playerNameFont
	local isHovered = props.isHovered
	local backgroundStyle = props.backgroundStyle
	local overlayStyle = props.overlayStyle
	local isPressed = props.isPressed
	local gameStats = props.gameStats
	local playerStats = props.playerStats
	local gameStatsCount = props.gameStatsCount
	local playerStatsCount = props.playerStatsCount

	local children = {}

	local v2 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center
	}

	if isDirectionalPreferred then
		v2.Padding = UDim.new(0, layoutValues.PlayerEntryPadding)
	end

	children.Layout = React.createElement("UIListLayout", v2)

	local element = React.createElement(memo, {
		player = props.player,
		playerIconInfo = props.playerIconInfo,
		playerRelationship = props.playerRelationship,
		titlePlayerEntry = props.titlePlayerEntry,
		isHovered = isHovered,
		textStyle = textStyle,
		playerNameFont = playerNameFont,
		layoutValues = layoutValues
	})

	local v3 = { LayoutOrder = 0, BackgroundTransparency = 1 }

	if isSmallTouchDevice then
		v3.Size = UDim2.new(0, layoutValues.PlayerNameSizeXMobile, 0, layoutValues.PlayerEntrySizeY)
	else
		v3.Size = UDim2.new(0, props.entrySizeX, 0, layoutValues.PlayerEntrySizeY)
	end

	children.NameFrame = React.createElement("Frame", v3, element)

	if isDirectionalPreferred then
		children.NameFrame = React.createElement("Frame", v3, {
			Shadow = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = layoutValues.ShadowImage,
				Position = UDim2.new(0, -layoutValues.ShadowSize, 0, 0),
				Size = UDim2.new(1, layoutValues.ShadowSize * 2, 1, layoutValues.ShadowSize),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = layoutValues.ShadowSliceRect,
				Visible = isDirectionalPreferred
			}),
			BackgroundFrame = React.createElement(EntryFrameView, props.backgroundFrameProps, element)
		})
	end

	local maxLeaderstats = layoutValues.MaxLeaderstats
	local v4 = {
		isTeamEntry = false,
		showStatTitle = props.titlePlayerEntry and isDirectionalPreferred,
		textStyle = textStyle
	}

	if isDirectionalPreferred then
		v4.backgroundStyle = backgroundStyle

		if not FFlagRemoveNewPlayerListOverlay then
			v4.overlayStyle = overlayStyle
			v4.doubleOverlay = isPressed
		end
	end

	if fFlagPlayerListFixLeaderstatsStacking then
		local v5 = SignalsReact.useSignalState(Signals.createComputed(function(p)
			if gameStats then
				return (gameStats.getAllData(p))
			end

			return {}
		end))

		local v6 = SignalsReact.useSignalState(Signals.createComputed(function(p)
			if playerStats then
				return (playerStats.getAllData(p))
			end

			return {}
		end))

		for k, v7 in v5 do
			if not (maxLeaderstats < v7.order(false)) then
				children["GameStat_" .. k] = React.createElement(
					StatEntryContainer,
					Cryo.Dictionary.join(v4, { statName = k, stat = v6[k] })
				)
			end
		end
	elseif
		gameStats
		and gameStatsCount
		and gameStatsCount > 0
		and playerStats
		and playerStatsCount
		and playerStatsCount >= 0
	then
		gameStats.iterateData(function(statName, p)
			if maxLeaderstats < p.order(false) then
				return
			end

			local data = playerStats.getData(statName, false)
			children["GameStat_" .. statName] = React.createElement(
				StatEntryContainer,
				Cryo.Dictionary.join(v4, { statName = statName, stat = data })
			)
		end, false)
	end

	if not (FFlagRemoveNewPlayerListOverlay or isSmallTouchDevice or isDirectionalPreferred) then
		children.BackgroundExtender = React.createElement(CellExtender, {
			layoutOrder = 100,
			size = UDim2.new(0, layoutValues.ExtraContainerPadding, 1, 0),
			backgroundStyle = { Color = Color3.new(1, 1, 1), Transparency = 1 },
			overlayStyle = { Color = Color3.new(1, 1, 1), Transparency = 1 },
			doubleOverlay = isPressed
		})
	end

	return React.createElement(React.Fragment, {}, children)
end

local memo2 = React.memo(PlayerEntryChildren)

local function PlayerEntryView(props)
	local playerStatsCount

	if fFlagPlayerListFixLeaderstatsStacking then
		playerStatsCount = nil
	else
		playerStatsCount = SignalsReact.useSignalState(props.playerData.stats.getCount)
	end

	local v2 = SignalsReact.useSignalBinding(Signals.createComputed(function(p)
		return props.playerData.order(p) * 2 - 1
	end))

	local layoutOrder = React.useMemo(function()
		return if props.layoutOrder then props.layoutOrder else v2
	end, { props.layoutOrder, v2 })

	local firstPlayerRef = React.useMemo(function()
		if props.playerData.order(false) == 1 then
			return props.firstPlayerRef
		end

		return nil
	end, { props.playerData.order, props.firstPlayerRef })

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local ref = React.useRef(nil)
	local ref2

	if FFlagPlayerListUseFocusNavHook then
		ref2 = nil
	else
		ref2 = React.useRef(nil)
	end

	local v3 = useFocusGuiObject()

	local enabled = Enabled()
	local layoutValues = useLayoutValues()
	local v4 = useStyle()
	local v5

	if FoundationFontFaceMigration then
		v5 = useTokens()
	else
		v5 = nil
	end

	local size

	if props.size then
		size = props.size
	else
		size = UDim2.new(1, layoutValues.EntryXOffset, 0, layoutValues.PlayerEntrySizeY)
	end

	local isSmallTouchDevice = props.isSmallTouchDevice
	local isTenFoot = layoutValues.IsTenFoot
	local v6 = props.player == Players.LocalPlayer

	local onActivated = React.useCallback(function()
		if not (props.openDropdown and props.closeDropdown) then
			return
		end

		if props.dropdownOpen and props.selectedPlayer == props.player then
			props.closeDropdown()
			return
		end

		if FFlagPlayerListUseFocusNavHook and props.setSelectedPlayerId then
			if props.titlePlayerEntry then
				props.setSelectedPlayerId(Constants.SELECTED_TITLE_PLAYER_ID)
			else
				props.setSelectedPlayerId(props.player.UserId)
			end
		end

		if getFFlagGateLeaderboardPlayerDropdownViaGUAC() then
			if inExperienceCapabilities.canViewPlayerDropdownInLeaderboard then
				props.openDropdown(props.player)

				if ref.current then
					local vector2 = Vector2.new(ref.current.AbsolutePosition.Y, ref.current.AbsoluteSize.Y)

					if props.setDropDownPlayerDimensionY then
						props.setDropDownPlayerDimensionY(vector2)
					end
				end
			end
		else
			props.openDropdown(props.player)

			if ref.current then
				local vector2 = Vector2.new(ref.current.AbsolutePosition.Y, ref.current.AbsoluteSize.Y)

				if props.setDropDownPlayerDimensionY then
					props.setDropDownPlayerDimensionY(vector2)
				end
			end
		end
	end, {
		props.dropdownOpen,
		props.selectedPlayer,
		props.player,
		props.openDropdown,
		props.closeDropdown,
		props.setDropDownPlayerDimensionY,
		props.titlePlayerEntry,
		props.setSelectedPlayerId,
		ref.current
	})

	local onStateChanged = React.useCallback(function(p)
		if p == ControlState.Pressed or p == ControlState.SelectedPressed then
			setState2(true)
		elseif p == ControlState.Hover or p == ControlState.Selected then
			setState(true)
		elseif p == ControlState.Default then
			setState(false)
			setState2(false)
		end
	end, {})

	local v7 = React.useMemo(function()
		local color

		if enabled then
			color = v4.Theme.BackgroundUIContrast.Color
		else
			color = v4.Theme.BackgroundContrast.Color
		end

		return { Color = color, Transparency = 1 }
	end, { enabled, isTenFoot })

	local v8 = React.useMemo(function()
		return { Color = layoutValues.RowHoverColor, Transparency = 0.8 }
	end, { layoutValues })

	local v9 = React.useMemo(function()
		return { Color = layoutValues.RowDefaultColor, Transparency = 0.8 }
	end, { layoutValues })

	local v10 = React.useCallback(function()
		if isSmallTouchDevice then
			return (state or state2) and v8 or v9
		end

		if not isTenFoot then
			return v7
		end

		local v10 = props.dropdownOpen and props.selectedPlayer == props.player
		local isHovered = state

		if props.titlePlayerEntry and layoutValues.BackgroundStyle then
			if isHovered and layoutValues.BackgroundStyle.HoveredTitle then
				return layoutValues.BackgroundStyle.HoveredTitle
			end

			if layoutValues.BackgroundStyle.Title then
				return layoutValues.BackgroundStyle.Title
			end
		end

		if v10 and layoutValues.BackgroundStyle and layoutValues.BackgroundStyle.Selected then
			return layoutValues.BackgroundStyle.Selected or layoutValues.BackgroundStyle.Default
		end

		if isHovered and layoutValues.BackgroundStyle and layoutValues.BackgroundStyle.Hovered then
			return layoutValues.BackgroundStyle.Hovered
		end

		if layoutValues.BackgroundStyle and layoutValues.BackgroundStyle.Default then
			return layoutValues.BackgroundStyle.Default
		end

		return v7
	end, {
		v7,
		isSmallTouchDevice,
		props.dropdownOpen,
		props.selectedPlayer,
		props.player,
		props.titlePlayerEntry,
		state,
		state2
	})

	local v11 = React.useCallback(function()
		if isTenFoot then
			if state then
				return layoutValues.HoveredTextStyle, layoutValues.PlayerNameTextSize
			end

			return layoutValues.DefaultTextStyle, layoutValues.PlayerNameTextSize
		elseif v6 then
			return v4.Theme.TextEmphasis, layoutValues.PlayerNameTextSize
		else
			return v4.Theme.TextDefault, layoutValues.PlayerNameTextSize
		end
	end, { state, v6, isTenFoot, layoutValues, v4 })

	local v12 = React.useCallback(function()
		if isTenFoot then
			return v
		end

		local v12 = props.dropdownOpen and props.selectedPlayer == props.player

		if state2 or v12 then
			return v4.Theme.BackgroundOnPress
		end

		return if state then v4.Theme.BackgroundOnHover else v
	end, { state, state2, props.dropdownOpen, props.selectedPlayer, props.player, v4, isTenFoot })

	local playerNameFont = React.useMemo(function()
		if isSmallTouchDevice then
			if v6 then
				local v13 = {
					Font = v4.Font.CaptionHeader.Font,
					FontFace = 0,
					Size = 0,
					MinSize = 0
				}
				local fontFace

				if FoundationFontFaceMigration then
					fontFace = normalizeFontFace(v5.Typography.CaptionMedium.Font)
				end

				v13.FontFace = fontFace
				local size2

				if FFlagEnableMobilePlayerListOnConsole then
					size2 = layoutValues.PlayerNameTextSize
				else
					size2 = v4.Font.CaptionHeader.RelativeSize * v4.Font.BaseSize
				end

				v13.Size = size2
				local minSize

				if FFlagEnableMobilePlayerListOnConsole then
					minSize = layoutValues.PlayerNameTextSize
				else
					minSize = v4.Font.Footer.RelativeMinSize * v4.Font.BaseSize
				end

				v13.MinSize = minSize
				return v13
			else
				local v13 = { Font = v4.Font.CaptionBody.Font, FontFace = 0, Size = 0, MinSize = 0 }
				local fontFace

				if FoundationFontFaceMigration then
					fontFace = normalizeFontFace(v5.Typography.BodySmall.Font)
				end

				v13.FontFace = fontFace
				local size2

				if FFlagEnableMobilePlayerListOnConsole then
					size2 = layoutValues.PlayerNameTextSize
				else
					size2 = v4.Font.CaptionBody.RelativeSize * v4.Font.BaseSize
				end

				v13.Size = size2
				local minSize

				if FFlagEnableMobilePlayerListOnConsole then
					minSize = layoutValues.PlayerNameTextSize
				else
					minSize = v4.Font.Footer.RelativeMinSize * v4.Font.BaseSize
				end

				v13.MinSize = minSize
				return v13
			end
		elseif isTenFoot then
			if props.titlePlayerEntry then
				local v13 = {
					Font = layoutValues.TitlePlayerEntryFont,
					FontFace = 0,
					Size = 0,
					MinSize = 0
				}
				local fontFace

				if FoundationFontFaceMigration then
					fontFace = normalizeFontFace(layoutValues.TitlePlayerEntryFont)
				end

				v13.FontFace = fontFace
				v13.Size = layoutValues.PlayerNameTextSize
				v13.MinSize = layoutValues.PlayerNameTextSize
				return v13
			else
				local v13 = {
					Font = layoutValues.PlayerEntryFont,
					FontFace = 0,
					Size = 0,
					MinSize = 0
				}
				local fontFace

				if FoundationFontFaceMigration then
					fontFace = normalizeFontFace(layoutValues.PlayerEntryFont)
				end

				v13.FontFace = fontFace
				v13.Size = layoutValues.PlayerNameTextSize
				v13.MinSize = layoutValues.PlayerNameTextSize
				return v13
			end
		elseif v6 then
			local v13 = { Font = v4.Font.CaptionHeader.Font, FontFace = 0, Size = 0, MinSize = 0 }
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(v5.Typography.CaptionMedium.Font)
			end

			v13.FontFace = fontFace
			v13.Size = v4.Font.CaptionHeader.RelativeSize * v4.Font.BaseSize
			v13.MinSize = v4.Font.Footer.RelativeMinSize * v4.Font.BaseSize
			return v13
		else
			local v13 = { Font = v4.Font.CaptionBody.Font, FontFace = 0, Size = 0, MinSize = 0 }
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(v5.Typography.BodySmall.Font)
			end

			v13.FontFace = fontFace
			v13.Size = v4.Font.CaptionBody.RelativeSize * v4.Font.BaseSize
			v13.MinSize = v4.Font.Footer.RelativeMinSize * v4.Font.BaseSize
			return v13
		end
	end, { isSmallTouchDevice, isTenFoot, v6, v4, layoutValues, v5 })

	local backgroundStyle = v10()
	local textStyle = v11()
	local v13

	if FFlagRemoveNewPlayerListOverlay then
		v13 = nil
	else
		v13 = v12()
	end

	local backgroundFrameProps = React.useMemo(function()
		local v14 = {
			size = UDim2.new(0, props.entrySizeX, 0, layoutValues.PlayerEntrySizeY),
			isTeamFrame = false,
			backgroundStyle = backgroundStyle,
			overlayStyle = 0,
			doubleOverlay = 0,
			firstPlayerRef = 0,
			ref = 0,
			onActivated = 0,
			onStateChanged = 0
		}
		local overlayStyle

		if not FFlagRemoveNewPlayerListOverlay then
			overlayStyle = v13
		end

		v14.overlayStyle = overlayStyle
		local doubleOverlay

		if not FFlagRemoveNewPlayerListOverlay then
			doubleOverlay = state2
		end

		v14.doubleOverlay = doubleOverlay
		v14.firstPlayerRef = firstPlayerRef
		local ref3

		if not (FFlagPlayerListUseFocusNavHook or not FFlagAddNewPlayerListFocusNav) then
			ref3 = ref2
		end

		v14.ref = ref3

		v14.onActivated = onActivated
		v14.onStateChanged = onStateChanged
		return v14
	end, {
		props.entrySizeX,
		layoutValues.PlayerEntrySizeY,
		backgroundStyle,
		v13,
		state2,
		ref2,
		onActivated,
		onStateChanged
	})

	local v14 = React.useMemo(function()
		local v14 = {
			isSmallTouchDevice = isSmallTouchDevice,
			isDirectionalPreferred = isTenFoot,
			layoutValues = layoutValues,
			textStyle = textStyle,
			playerNameFont = playerNameFont,
			isHovered = state,
			backgroundStyle = backgroundStyle,
			overlayStyle = nil,
			isPressed = nil,
			player = 0,
			playerIconInfo = 0,
			playerRelationship = 0,
			titlePlayerEntry = 0,
			entrySizeX = 0,
			gameStats = 0,
			playerStats = 0,
			playerStatsCount = 0,
			gameStatsCount = 0,
			backgroundFrameProps = 0
		}
		local overlayStyle

		if not FFlagRemoveNewPlayerListOverlay then
			overlayStyle = v13
		end

		v14.overlayStyle = overlayStyle
		local isPressed

		if not FFlagRemoveNewPlayerListOverlay then
			isPressed = state2
		end

		v14.isPressed = isPressed
		v14.player = props.player
		v14.playerIconInfo = props.playerIconInfo
		v14.playerRelationship = props.playerRelationship
		v14.titlePlayerEntry = props.titlePlayerEntry
		v14.entrySizeX = props.entrySizeX
		v14.gameStats = props.gameStats
		v14.playerStats = props.playerData.stats
		v14.playerStatsCount = playerStatsCount
		v14.gameStatsCount = props.gameStatsCount
		v14.backgroundFrameProps = backgroundFrameProps
		return v14
	end, {
		isSmallTouchDevice,
		isTenFoot,
		layoutValues,
		textStyle,
		playerNameFont,
		state,
		backgroundStyle,
		v13,
		state2,
		props.player,
		props.playerIconInfo,
		props.playerRelationship,
		props.titlePlayerEntry,
		props.entrySizeX,
		props.playerData.stats,
		props.gameStats,
		playerStatsCount,
		props.gameStatsCount,
		backgroundFrameProps
	})

	if not FFlagPlayerListUseFocusNavHook then
		React.useEffect(function()
			local selectionLostConnection = nil
			local destroyingConnection = nil

			if
				FFlagAddNewPlayerListFocusNav
				and ref2.current
				and props.prevFocusedEntry
				and props.destroyedFocusedPlayerId
			then
				local current = ref2.current

				selectionLostConnection = ref2.current.SelectionLost:Connect(function()
					props.prevFocusedEntry.current = current
				end)

				destroyingConnection = ref2.current.Destroying:Connect(function()
					selectionLostConnection:Disconnect()

					if GuiService.SelectedCoreObject == current then
						props.destroyedFocusedPlayerId.current = props.player.UserId
						v3(nil)
					end

					destroyingConnection:Disconnect()
				end)
			end

			return function()
				if selectionLostConnection then
					selectionLostConnection:Disconnect()
				end
			end
		end, {
			v3,
			props.player,
			props.prevFocusedEntry,
			props.destroyedFocusedPlayerId,
			ref2.current
		})
	end

	if FFlagPlayerListUseFocusNavHook then
		React.useEffect(function()
			return function()
				if props.unregisterPlayerInstance then
					props.unregisterPlayerInstance(props.player.UserId)
				end
			end
		end, { props.unregisterPlayerInstance, props.player })
	end

	local ref3 = React.useCallback(function(current)
		if FFlagPlayerListUseFocusNavHook and props.registerPlayerInstance then
			props.registerPlayerInstance(props.player.UserId, current, props.playerData.order)
		end

		if FFlagPlayerListUseFocusNavHook or not FFlagAddNewPlayerListMobileFocusNav then
			ref.current = current
		else
			ref2.current = current
		end
	end, { props.player, props.playerData, props.registerPlayerInstance })

	if isSmallTouchDevice then
		return React.createElement(View, {
			Size = size,
			BackgroundColor3 = backgroundStyle.Color,
			BackgroundTransparency = backgroundStyle.Transparency,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Image = "",
			LayoutOrder = layoutOrder,
			ref = ref3,
			onActivated = onActivated,
			onStateChanged = onStateChanged
		}, {
			ChildrenFrame = React.createElement(
				"Frame",
				{
					Size = UDim2.fromScale(1, 1),
					Position = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1
				},
				React.createElement(memo2, v14)
			)
		})
	end

	if isTenFoot then
		local createElement = React.createElement

		if not FFlagPlayerListUseFocusNavHook then
			ref3 = ref
		end

		return createElement(
			"Frame",
			{ Size = size, BackgroundTransparency = 1, LayoutOrder = layoutOrder, ref = ref3 },
			React.createElement(memo2, v14)
		)
	else
		local createElement = React.createElement

		if not FFlagPlayerListUseFocusNavHook then
			ref3 = ref
		end

		return createElement(
			"Frame",
			{ Size = size, BackgroundTransparency = 1, LayoutOrder = layoutOrder, ref = ref3 },
			{
				PlayerEntryContentFrame = React.createElement(
					EntryFrameView,
					Cryo.Dictionary.join(backgroundFrameProps, {
						size = UDim2.new(1, 0, 0, layoutValues.PlayerEntrySizeY)
					}),
					React.createElement(memo2, v14)
				)
			}
		)
	end
end

return React.memo(PlayerEntryView)
