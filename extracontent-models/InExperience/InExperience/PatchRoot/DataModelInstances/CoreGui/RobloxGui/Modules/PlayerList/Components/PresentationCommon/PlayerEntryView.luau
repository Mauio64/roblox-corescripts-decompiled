local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InExperienceCapabilities = require(CorePackages.Workspace.Packages.InExperienceCapabilities).InExperienceCapabilities
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local SharedFlags = CorePackages.Workspace.Packages.SharedFlags
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

require(CorePackages.Workspace.Packages.LeaderboardStore)
require(CorePackages.Workspace.Packages.PlayerIconInfoStore)

local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local useLayoutValues = PlayerList.Common.useLayoutValues
local useStyle = UIBlox.Core.Style.useStyle
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local Foundation = require(CorePackages.Packages.Foundation)
local ControlState = Foundation.Enums.ControlState
local View = Foundation.View
local EntryFrameView = PlayerList.Presentation.EntryFrameView
local StatEntryContainer = require(scriptParentParentParent.Components.Container.StatEntryContainer)
local CellExtender = require(scriptParentParent.Presentation.CellExtender)
local PlayerIcon = require(scriptParent.PlayerIcon)
local PlayerNameTag = require(scriptParentParent.Presentation.PlayerNameTag)
local Constants = PlayerList.Common.Constants
local GetFFlagGateLeaderboardPlayerDropdownViaGUAC = require(SharedFlags).GetFFlagGateLeaderboardPlayerDropdownViaGUAC
local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local FFlagRemoveNewPlayerListOverlay = PlayerList.Flags.FFlagRemoveNewPlayerListOverlay
local FFlagEnableMobilePlayerListOnConsole = PlayerList.Flags.FFlagEnableMobilePlayerListOnConsole
local FFlagPlayerListFixLeaderstatsStacking = require(SharedFlags).FFlagPlayerListFixLeaderstatsStacking
local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook
local t1 = {
	Transparency = 1,
	Color = Color3.new(1, 1, 1)
}

local function IconAndName(t2: {[any]: any}) -- line: 118
	-- upvalues: React (copy), PlayerIcon (copy), PlayerNameTag (copy)
	return React.createElement(React.Fragment, {}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, t2.layoutValues.InitalPlayerEntryPadding)
		}),
		InitalPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, t2.layoutValues.InitalPlayerEntryPadding)
		}),
		PlayerIcon = React.createElement(PlayerIcon, {
			layoutOrder = 1,
			player = t2.player,
			playerIconInfo = t2.playerIconInfo,
			playerRelationship = t2.playerRelationship
		}),
		PlayerName = React.createElement(PlayerNameTag, {
			layoutOrder = 3,
			player = t2.player,
			isTitleEntry = t2.titlePlayerEntry,
			isHovered = t2.isHovered,
			textStyle = t2.textStyle,
			textFont = t2.playerNameFont
		})
	})
end

local u38 = React.memo(IconAndName)

local function PlayerEntryChildren(t3: {[any]: any}) -- line: 173
	-- upvalues: React (copy), u38 (ref), EntryFrameView (copy), FFlagRemoveNewPlayerListOverlay (copy), FFlagPlayerListFixLeaderstatsStacking (copy), SignalsReact (copy), Signals (copy), StatEntryContainer (copy), Cryo (copy), CellExtender (copy)
	local v44 = t3.isSmallTouchDevice or false
	local v45 = t3.isDirectionalPreferred or false
	local layoutValues = t3.layoutValues
	local textStyle = t3.textStyle
	local playerNameFont = t3.playerNameFont
	local isHovered = t3.isHovered
	local backgroundStyle = t3.backgroundStyle
	local overlayStyle = t3.overlayStyle
	local isPressed = t3.isPressed
	local gameStats = t3.gameStats
	local playerStats = t3.playerStats
	local gameStatsCount = t3.gameStatsCount
	local playerStatsCount = t3.playerStatsCount
	local t4 = {}
	local t5 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center
	}

	if v45 then
		t5.Padding = UDim.new(0, layoutValues.PlayerEntryPadding)
	end

	t4.Layout = React.createElement("UIListLayout", t5)

	local v59 = React.createElement(u38, {
		player = t3.player,
		playerIconInfo = t3.playerIconInfo,
		playerRelationship = t3.playerRelationship,
		titlePlayerEntry = t3.titlePlayerEntry,
		isHovered = isHovered,
		textStyle = textStyle,
		playerNameFont = playerNameFont,
		layoutValues = layoutValues
	})
	local t6 = {
		LayoutOrder = 0,
		BackgroundTransparency = 1
	}

	if v44 then
		t6.Size = UDim2.new(0, layoutValues.PlayerNameSizeXMobile, 0, layoutValues.PlayerEntrySizeY)
	else
		t6.Size = UDim2.new(0, t3.entrySizeX, 0, layoutValues.PlayerEntrySizeY)
	end

	t4.NameFrame = React.createElement("Frame", t6, v59)

	if v45 then
		t4.NameFrame = React.createElement("Frame", t6, {
			Shadow = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Image = layoutValues.ShadowImage,
				Position = UDim2.new(0, -layoutValues.ShadowSize, 0, 0),
				Size = UDim2.new(1, layoutValues.ShadowSize * 2, 1, layoutValues.ShadowSize),
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = layoutValues.ShadowSliceRect,
				Visible = v45
			}),
			BackgroundFrame = React.createElement(EntryFrameView, t3.backgroundFrameProps, v59)
		})
	end

	local MaxLeaderstats = layoutValues.MaxLeaderstats
	local t7 = {
		isTeamEntry = false,
		showStatTitle = t3.titlePlayerEntry and v45,
		textStyle = textStyle
	}

	if v45 then
		t7.backgroundStyle = backgroundStyle

		if not FFlagRemoveNewPlayerListOverlay then
			t7.overlayStyle = overlayStyle
			t7.doubleOverlay = isPressed
		end
	end

	if FFlagPlayerListFixLeaderstatsStacking then
		local v63 = SignalsReact.useSignalState(Signals.createComputed(function(p1) -- line: 265
			-- upvalues: gameStats (copy)
			if gameStats then
				return (gameStats.getAllData(p1))
			end

			return {}
		end))
		local v64 = SignalsReact.useSignalState(Signals.createComputed(function(p2) -- line: 269
			-- upvalues: playerStats (copy)
			if playerStats then
				return (playerStats.getAllData(p2))
			end

			return {}
		end))

		for v65, v66 in v63 do
			if not (MaxLeaderstats < v66.order(false)) then
				t4["GameStat_" .. v65] = React.createElement(StatEntryContainer, Cryo.Dictionary.join(t7, {
					statName = v65,
					stat = v64[v65]
				}))
			end
		end
	elseif gameStats and gameStatsCount and gameStatsCount > 0 and playerStats and playerStatsCount and playerStatsCount >= 0 then
		gameStats.iterateData(function(p3, p4) -- line: 288
			-- upvalues: MaxLeaderstats (copy), playerStats (copy), t4 (copy), React (copy), StatEntryContainer (copy), Cryo (copy), t7 (copy)
			if p4.order(false) > MaxLeaderstats then
				return
			end

			local v105 = playerStats.getData(p3, false)

			t4["GameStat_" .. p3] = React.createElement(StatEntryContainer, Cryo.Dictionary.join(t7, {
				statName = p3,
				stat = v105
			}))
		end, false)
	end

	if not FFlagRemoveNewPlayerListOverlay and not v44 and not v45 then
		t4.BackgroundExtender = React.createElement(CellExtender, {
			layoutOrder = 100,
			size = UDim2.new(0, layoutValues.ExtraContainerPadding, 1, 0),
			backgroundStyle = {
				Transparency = 1,
				Color = Color3.new(1, 1, 1)
			},
			overlayStyle = {
				Transparency = 1,
				Color = Color3.new(1, 1, 1)
			},
			doubleOverlay = isPressed
		})
	end

	return React.createElement(React.Fragment, {}, t4)
end

local u40 = React.memo(PlayerEntryChildren)

local function PlayerEntryView(t8: {[any]: any}) -- line: 328
	-- upvalues: FFlagPlayerListFixLeaderstatsStacking (copy), SignalsReact (copy), Signals (copy), React (copy), FFlagPlayerListUseFocusNavHook (copy), useFocusGuiObject (copy), Enabled (copy), useLayoutValues (copy), useStyle (copy), Players (copy), Constants (copy), GetFFlagGateLeaderboardPlayerDropdownViaGUAC (copy), InExperienceCapabilities (copy), ControlState (copy), t1 (copy), FFlagEnableMobilePlayerListOnConsole (copy), FFlagRemoveNewPlayerListOverlay (copy), FFlagAddNewPlayerListFocusNav (copy), GuiService (copy), FFlagAddNewPlayerListMobileFocusNav (copy), View (copy), u40 (ref), EntryFrameView (copy), Cryo (copy)
	local v68 = if not FFlagPlayerListFixLeaderstatsStacking then SignalsReact.useSignalState(t8.playerData.stats.getCount) else nil
	local v69 = SignalsReact.useSignalBinding(Signals.createComputed(function(p5) -- line: 332
		-- upvalues: t8 (copy)
		return t8.playerData.order(p5) * 2 - 1
	end))
	local v70 = React.useMemo(function() -- line: 336
		-- upvalues: t8 (copy), v69 (copy)
		if t8.layoutOrder then
			return t8.layoutOrder
		end

		return v69
	end, {
		t8.layoutOrder,
		v69
	})
	local v71 = React.useMemo(function() -- line: 340
		-- upvalues: t8 (copy)
		if t8.playerData.order(false) == 1 then
			return t8.firstPlayerRef
		end

		return nil
	end, {
		t8.playerData.order,
		t8.firstPlayerRef
	})
	local v72, v73 = React.useState(false)
	local v74, v75 = React.useState(false)
	local v76 = React.useRef(nil)
	local v77 = if FFlagPlayerListUseFocusNavHook then nil else React.useRef(nil)
	local v78 = useFocusGuiObject()
	local v79 = Enabled()
	local v80 = useLayoutValues()
	local v81 = useStyle()
	local v82 = if not t8.size then UDim2.new(1, v80.EntryXOffset, 0, v80.PlayerEntrySizeY) else t8.size
	local isSmallTouchDevice = t8.isSmallTouchDevice
	local IsTenFoot = v80.IsTenFoot
	local v85 = t8.player == Players.LocalPlayer
	local v86 = React.useCallback(function() -- line: 362
		-- upvalues: t8 (copy), FFlagPlayerListUseFocusNavHook (copy), Constants (copy), GetFFlagGateLeaderboardPlayerDropdownViaGUAC (copy), InExperienceCapabilities (copy), v76 (copy)
		if not t8.openDropdown or not t8.closeDropdown then
			return
		end

		if t8.dropdownOpen and t8.selectedPlayer == t8.player then
			t8.closeDropdown()

			return
		end

		if FFlagPlayerListUseFocusNavHook and t8.setSelectedPlayerId then
			if t8.titlePlayerEntry then
				t8.setSelectedPlayerId(Constants.SELECTED_TITLE_PLAYER_ID)
			else
				t8.setSelectedPlayerId(t8.player.UserId)
			end
		end

		if GetFFlagGateLeaderboardPlayerDropdownViaGUAC() then
			if InExperienceCapabilities.canViewPlayerDropdownInLeaderboard then
				t8.openDropdown(t8.player)

				if v76.current then
					local vector2 = Vector2.new(v76.current.AbsolutePosition.Y, v76.current.AbsoluteSize.Y)

					if t8.setDropDownPlayerDimensionY then
						t8.setDropDownPlayerDimensionY(vector2)

						return
					end
				end
			end
		else
			t8.openDropdown(t8.player)

			if v76.current then
				local vector2 = Vector2.new(v76.current.AbsolutePosition.Y, v76.current.AbsoluteSize.Y)

				if t8.setDropDownPlayerDimensionY then
					t8.setDropDownPlayerDimensionY(vector2)
				end
			end
		end
	end, {
		t8.dropdownOpen,
		t8.selectedPlayer,
		t8.player,
		t8.openDropdown,
		t8.closeDropdown,
		t8.setDropDownPlayerDimensionY,
		t8.titlePlayerEntry,
		t8.setSelectedPlayerId,
		v76.current
	})
	local v87 = React.useCallback(function(p6) -- line: 403
		-- upvalues: ControlState (copy), v75 (copy), v73 (copy)
		if p6 == ControlState.Pressed or p6 == ControlState.SelectedPressed then
			v75(true)

			return
		end

		if p6 == ControlState.Hover or p6 == ControlState.Selected then
			v73(true)

			return
		end

		if p6 == ControlState.Default then
			v73(false)
			v75(false)
		end
	end, {})
	local v88 = React.useMemo(function() -- line: 414
		-- upvalues: v79 (copy), v81 (copy)
		local v110 = if not v79 then v81.Theme.BackgroundContrast.Color else v81.Theme.BackgroundUIContrast.Color

		return {
			Transparency = 1,
			Color = v110
		}
	end, {
		v79,
		IsTenFoot
	})
	local v89 = React.useMemo(function() -- line: 424
		-- upvalues: v80 (copy)
		return {
			Transparency = 0.8,
			Color = v80.RowHoverColor
		}
	end, { v80 })
	local v90 = React.useMemo(function() -- line: 431
		-- upvalues: v80 (copy)
		return {
			Transparency = 0.8,
			Color = v80.RowDefaultColor
		}
	end, { v80 })
	local v91 = React.useCallback(function() -- line: 439
		-- upvalues: isSmallTouchDevice (copy), v72 (copy), v74 (copy), v89 (copy), v90 (copy), IsTenFoot (copy), v88 (copy), t8 (copy), v80 (copy)
		if isSmallTouchDevice then
			return (v72 or v74) and v89 or v90
		end

		if not IsTenFoot then
			return v88
		end

		local v111 = t8.dropdownOpen and t8.selectedPlayer == t8.player
		local v112 = v72

		if t8.titlePlayerEntry and v80.BackgroundStyle then
			if v112 and v80.BackgroundStyle.HoveredTitle then
				return v80.BackgroundStyle.HoveredTitle
			end

			if v80.BackgroundStyle.Title then
				return v80.BackgroundStyle.Title
			end
		end

		if v111 and v80.BackgroundStyle and v80.BackgroundStyle.Selected then
			return v80.BackgroundStyle.Selected or v80.BackgroundStyle.Default
		end

		if v112 and v80.BackgroundStyle and v80.BackgroundStyle.Hovered then
			return v80.BackgroundStyle.Hovered
		end

		if v80.BackgroundStyle and v80.BackgroundStyle.Default then
			return v80.BackgroundStyle.Default
		end

		return v88
	end, {
		v88,
		isSmallTouchDevice,
		t8.dropdownOpen,
		t8.selectedPlayer,
		t8.player,
		t8.titlePlayerEntry,
		v72,
		v74
	})
	local v92 = React.useCallback(function() -- line: 484
		-- upvalues: IsTenFoot (copy), v72 (copy), v80 (copy), v85 (copy), v81 (copy)
		if IsTenFoot then
			if v72 then
				return v80.HoveredTextStyle, v80.PlayerNameTextSize
			end

			return v80.DefaultTextStyle, v80.PlayerNameTextSize
		end

		if v85 then
			return v81.Theme.TextEmphasis, v80.PlayerNameTextSize
		end

		return v81.Theme.TextDefault, v80.PlayerNameTextSize
	end, {
		v72,
		v85,
		IsTenFoot,
		v80,
		v81
	})
	local v93 = React.useCallback(function() -- line: 505
		-- upvalues: IsTenFoot (copy), t8 (copy), v74 (copy), v81 (copy), v72 (copy), t1 (copy)
		if not IsTenFoot then
			local v113 = t8.dropdownOpen and t8.selectedPlayer == t8.player

			if v74 then
				return v81.Theme.BackgroundOnPress
			end

			if v113 then
				return v81.Theme.BackgroundOnPress
			end

			if v72 then
				return v81.Theme.BackgroundOnHover
			end
		end

		return t1
	end, {
		v72,
		v74,
		t8.dropdownOpen,
		t8.selectedPlayer,
		t8.player,
		v81,
		IsTenFoot
	})
	local v94 = React.useMemo(function() -- line: 528
		-- upvalues: isSmallTouchDevice (copy), v85 (copy), v81 (copy), FFlagEnableMobilePlayerListOnConsole (copy), v80 (copy), IsTenFoot (copy), t8 (copy)
		if isSmallTouchDevice then
			if v85 then
				return {
					Font = v81.Font.CaptionHeader.Font,
					Size = if not FFlagEnableMobilePlayerListOnConsole then v81.Font.CaptionHeader.RelativeSize * v81.Font.BaseSize else v80.PlayerNameTextSize,
					MinSize = if not FFlagEnableMobilePlayerListOnConsole then v81.Font.Footer.RelativeMinSize * v81.Font.BaseSize else v80.PlayerNameTextSize
				}
			end

			return {
				Font = v81.Font.CaptionBody.Font,
				Size = if not FFlagEnableMobilePlayerListOnConsole then v81.Font.CaptionBody.RelativeSize * v81.Font.BaseSize else v80.PlayerNameTextSize,
				MinSize = if not FFlagEnableMobilePlayerListOnConsole then v81.Font.Footer.RelativeMinSize * v81.Font.BaseSize else v80.PlayerNameTextSize
			}
		end

		if IsTenFoot then
			if t8.titlePlayerEntry then
				return {
					Font = v80.TitlePlayerEntryFont,
					Size = v80.PlayerNameTextSize,
					MinSize = v80.PlayerNameTextSize
				}
			end

			return {
				Font = v80.PlayerEntryFont,
				Size = v80.PlayerNameTextSize,
				MinSize = v80.PlayerNameTextSize
			}
		end

		if v85 then
			return {
				Font = v81.Font.CaptionHeader.Font,
				Size = v81.Font.CaptionHeader.RelativeSize * v81.Font.BaseSize,
				MinSize = v81.Font.Footer.RelativeMinSize * v81.Font.BaseSize
			}
		end

		return {
			Font = v81.Font.CaptionBody.Font,
			Size = v81.Font.CaptionBody.RelativeSize * v81.Font.BaseSize,
			MinSize = v81.Font.Footer.RelativeMinSize * v81.Font.BaseSize
		}
	end, {
		isSmallTouchDevice,
		IsTenFoot,
		v85,
		v81,
		v80
	})
	local v95 = v91()
	local v96 = v92()
	local u97 = nil

	if not FFlagRemoveNewPlayerListOverlay then
		u97 = v93()
	end

	local v98 = React.useMemo(function() -- line: 581
		-- upvalues: t8 (copy), v80 (copy), v95 (copy), FFlagRemoveNewPlayerListOverlay (copy), u97 (ref), v74 (copy), v71 (copy), FFlagPlayerListUseFocusNavHook (copy), FFlagAddNewPlayerListFocusNav (copy), v77 (copy), v86 (copy), v87 (copy)
		return {
			isTeamFrame = false,
			size = UDim2.new(0, t8.entrySizeX, 0, v80.PlayerEntrySizeY),
			backgroundStyle = v95,
			overlayStyle = if not FFlagRemoveNewPlayerListOverlay then u97 else nil,
			doubleOverlay = if not FFlagRemoveNewPlayerListOverlay then v74 else nil,
			firstPlayerRef = v71,
			ref = if FFlagPlayerListUseFocusNavHook or not FFlagAddNewPlayerListFocusNav then nil else v77,
			onActivated = v86,
			onStateChanged = v87
		}
	end, {
		t8.entrySizeX,
		v80.PlayerEntrySizeY,
		v95,
		u97,
		v74,
		v77,
		v86,
		v87
	})
	local v99 = React.useMemo(function() -- line: 605
		-- upvalues: isSmallTouchDevice (copy), IsTenFoot (copy), v80 (copy), v96 (copy), v94 (copy), v72 (copy), v95 (copy), FFlagRemoveNewPlayerListOverlay (copy), u97 (ref), v74 (copy), t8 (copy), v68 (copy), v98 (copy)
		return {
			isSmallTouchDevice = isSmallTouchDevice,
			isDirectionalPreferred = IsTenFoot,
			layoutValues = v80,
			textStyle = v96,
			playerNameFont = v94,
			isHovered = v72,
			backgroundStyle = v95,
			overlayStyle = if not FFlagRemoveNewPlayerListOverlay then u97 else nil,
			isPressed = if not FFlagRemoveNewPlayerListOverlay then v74 else nil,
			player = t8.player,
			playerIconInfo = t8.playerIconInfo,
			playerRelationship = t8.playerRelationship,
			titlePlayerEntry = t8.titlePlayerEntry,
			entrySizeX = t8.entrySizeX,
			gameStats = t8.gameStats,
			playerStats = t8.playerData.stats,
			playerStatsCount = v68,
			gameStatsCount = t8.gameStatsCount,
			backgroundFrameProps = v98
		}
	end, {
		isSmallTouchDevice,
		IsTenFoot,
		v80,
		v96,
		v94,
		v72,
		v95,
		u97,
		v74,
		t8.player,
		t8.playerIconInfo,
		t8.playerRelationship,
		t8.titlePlayerEntry,
		t8.entrySizeX,
		t8.playerData.stats,
		t8.gameStats,
		v68,
		t8.gameStatsCount,
		v98
	})

	if not FFlagPlayerListUseFocusNavHook then
		React.useEffect(function() -- line: 650
			-- upvalues: FFlagAddNewPlayerListFocusNav (copy), v77 (copy), t8 (copy), GuiService (copy), v78 (copy)
			local connection = nil
			local connection2 = nil

			if FFlagAddNewPlayerListFocusNav and (v77.current and t8.prevFocusedEntry and t8.destroyedFocusedPlayerId) then
				local current = v77.current

				connection = v77.current.SelectionLost:Connect(function() -- line: 658
					-- upvalues: t8 (copy), current (copy)
					t8.prevFocusedEntry.current = current
				end)
				connection2 = v77.current.Destroying:Connect(function() -- line: 663
					-- upvalues: connection (ref), GuiService (copy), current (copy), t8 (copy), v78 (copy), connection2 (ref)
					connection:Disconnect()

					if GuiService.SelectedCoreObject == current then
						t8.destroyedFocusedPlayerId.current = t8.player.UserId
						v78(nil)
					end

					connection2:Disconnect()
				end)
			end

			return function() -- line: 677
				-- upvalues: connection (ref)
				if connection then
					connection:Disconnect()
				end
			end
		end, {
			v78,
			t8.player,
			t8.prevFocusedEntry,
			t8.destroyedFocusedPlayerId,
			v77.current
		})
	end

	if FFlagPlayerListUseFocusNavHook then
		React.useEffect(function() -- line: 686
			-- upvalues: t8 (copy)
			return function() -- line: 687
				-- upvalues: t8 (copy)
				if t8.unregisterPlayerInstance then
					t8.unregisterPlayerInstance(t8.player.UserId)
				end
			end
		end, {
			t8.unregisterPlayerInstance,
			t8.player
		})
	end

	local v100 = React.useCallback(function(p7) -- line: 695
		-- upvalues: FFlagPlayerListUseFocusNavHook (copy), t8 (copy), FFlagAddNewPlayerListMobileFocusNav (copy), v77 (copy), v76 (copy)
		if FFlagPlayerListUseFocusNavHook and t8.registerPlayerInstance then
			t8.registerPlayerInstance(t8.player.UserId, p7, t8.playerData.order)
		end

		if not FFlagPlayerListUseFocusNavHook and FFlagAddNewPlayerListMobileFocusNav then
			v77.current = p7

			return
		end

		v76.current = p7
	end, {
		t8.player,
		t8.playerData,
		t8.registerPlayerInstance
	})

	if isSmallTouchDevice then
		return React.createElement(View, {
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Image = "",
			Size = v82,
			BackgroundColor3 = v95.Color,
			BackgroundTransparency = v95.Transparency,
			LayoutOrder = v70,
			ref = v100,
			onActivated = v86,
			onStateChanged = v87
		}, {
			ChildrenFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.new(0, 0, 0, 0)
			}, React.createElement(u40, v99))
		})
	end

	if IsTenFoot then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = v82,
			LayoutOrder = v70,
			ref = if not FFlagPlayerListUseFocusNavHook then v76 else v100
		}, React.createElement(u40, v99))
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v82,
		LayoutOrder = v70,
		ref = if not FFlagPlayerListUseFocusNavHook then v76 else v100
	}, {
		PlayerEntryContentFrame = React.createElement(EntryFrameView, Cryo.Dictionary.join(v98, {
			size = UDim2.new(1, 0, 0, v80.PlayerEntrySizeY)
		}), React.createElement(u40, v99))
	})
end

return React.memo(PlayerEntryView)
