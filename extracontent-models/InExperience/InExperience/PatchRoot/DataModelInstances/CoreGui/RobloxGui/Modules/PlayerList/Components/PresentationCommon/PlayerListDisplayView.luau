local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(CorePackages.Packages.React)

require(CorePackages.Packages.Signals)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Otter = require(CorePackages.Packages.Otter)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)

require(CorePackages.Workspace.Packages.LeaderboardStore)

local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
local Enabled = require(CorePackages.Workspace.Packages.Chrome).Enabled
local useLayoutValues = PlayerList.Common.useLayoutValues
local usePlayerListFocusNavigation = PlayerList.Hooks.usePlayerListFocusNavigation
local useStyle = UIBlox.Core.Style.useStyle
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
local useFocusedGuiObject = ReactFocusNavigation.useFocusedGuiObject
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local v20 = UIBlox.App.ImageSet.getIconSize(IconSize.Small)
local Images = UIBlox.App.ImageSet.Images
local PlayerEntryContainer = require(ParentParentParent.Components.Container.PlayerEntryContainer)
local TeamListContainer = require(ParentParentParent.Components.Container.TeamListContainer)
local TitleBarContainer = require(ParentParentParent.Components.Container.TitleBarContainer)
local PlayerDropDown = require(ParentParent.Presentation.PlayerDropDown)
local FFlagPlayerListFixMobileScrolling = require(ParentParentParent.Flags.FFlagPlayerListFixMobileScrolling)
local v27 = game:DefineFastFlag("DisablePlayerListDisplayCloseBtn", false)
local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local FFlagAddNewPlayerListMobileFocusNav = PlayerList.Flags.FFlagAddNewPlayerListMobileFocusNav
local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook
local v31 = Enabled() and not v27
local t1 = {
	dampingRatio = 1,
	frequency = 4
}

local function PlayerListDisplayView(t2: {[any]: any}) -- line: 88
	-- upvalues: useLayoutValues (copy), useStyle (copy), useFocusGuiObject (copy), FFlagPlayerListUseFocusNavHook (copy), useFocusedGuiObject (copy), usePlayerListFocusNavigation (copy), React (copy), Otter (copy), t1 (copy), FFlagAddNewPlayerListFocusNav (copy), GuiService (copy), UserInputService (copy), FFlagAddNewPlayerListMobileFocusNav (copy), LocalPlayer (copy), PlayerEntryContainer (copy), TitleBarContainer (copy), TeamListContainer (copy), FFlagPlayerListFixMobileScrolling (copy), Enabled (copy), v31 (copy), v20 (copy), IconButton (copy), IconSize (copy), Images (copy), PlayerDropDown (copy)
	local v35 = useLayoutValues()
	local v36 = useStyle()
	local v37 = useFocusGuiObject()
	local v38 = if FFlagPlayerListUseFocusNavHook then nil else useFocusedGuiObject()
	local v39 = if not FFlagPlayerListUseFocusNavHook then nil else usePlayerListFocusNavigation()
	local v40 = React.useRef(nil)
	local v41 = React.useRef(nil)
	local v42 = if FFlagPlayerListUseFocusNavHook then nil else React.useRef(nil)
	local v43 = if FFlagPlayerListUseFocusNavHook then nil else React.useRef(nil)
	local v44 = React.useRef(Otter.createSingleMotor(0))
	local v45, v46 = React.useState(Vector2.new(0, 0))
	local v47, v48 = React.useState(100)
	local v49, v50 = React.useState(0)
	local v51, v52 = React.useState(true)
	local v53, v54 = React.useState(Vector2.new(0, 0))
	local v55, v56 = React.useState(0)
	local v57, v58 = React.useState(0)
	local v59, v60 = React.useState(0)
	local v61, v62 = React.useState(nil)
	local v63, v64 = React.createBinding(0)
	local v65, v66 = React.createBinding(0)
	local v67, v68 = React.createBinding(0)
	local v69 = React.joinBindings({
		v63,
		v65,
		v67
	}):map(function(t3: {[any]: any}) -- line: 125
		local v85 = t3[1]
		local v86 = t3[2]

		return v86 + (t3[3] - v86) * v85
	end)
	local v70 = React.useCallback(function(p1) -- line: 133
		-- upvalues: v58 (copy)
		v58(p1.AbsoluteSize.Y)
	end, {})
	local v71 = React.useCallback(function(p2) -- line: 137
		-- upvalues: v48 (copy)
		v48(p2.AbsoluteSize.Y)
	end, {})
	local v72 = React.useCallback(function(p3) -- line: 141
		-- upvalues: v46 (copy)
		v46(p3.CanvasPosition)
	end, {})
	local v73 = React.useCallback(function(p4) -- line: 145
		-- upvalues: v50 (copy)
		v50(p4.AbsolutePosition.Y)
	end, {})
	local v74 = React.useCallback(function() -- line: 149
		-- upvalues: t2 (copy)
		if not t2.isSmallTouchDevice then
			return false
		end

		local v91 = not not t2.teamList and (t2.teamList.getCount(false) > 0 or false)
		local v92 = t2.gameStatsCount > 0 or false

		return v91 or v92
	end, {
		t2.gameStatsCount,
		t2.isSmallTouchDevice,
		t2.teamList
	})

	React.useEffect(function() -- line: 160
		-- upvalues: v44 (copy), v64 (copy), v52 (copy)
		v44.current:onStep(v64)
		v44.current:onComplete(function(p5) -- line: 162
			-- upvalues: v52 (copy)
			if p5 == 0 then
				v52(true)
			end
		end)
	end, {})
	React.useEffect(function() -- line: 169
		-- upvalues: t2 (copy), v52 (copy), v44 (copy), Otter (copy), t1 (copy)
		if t2.isSmallTouchDevice then
			v52(not t2.isMinimized)

			return
		end

		if v44.current then
			v44.current:setGoal(Otter.spring(not t2.isMinimized and 0 or 1, t1))
		end

		if t2.isMinimized then
			v52(false)
		end
	end, {
		t2.isSmallTouchDevice,
		t2.isMinimized,
		v44.current
	})
	React.useEffect(function() -- line: 184
		-- upvalues: v47 (copy), t2 (copy), v35 (copy), v57 (copy), v56 (copy)
		local v93 = v47 - 8

		if t2.gameStatsCount > 0 then
			v93 -= v35.TitleBarSizeY or 0
		end

		local v94 = math.min(v57, v93)

		v56(v94)
	end, {
		v47,
		v57,
		t2.gameStatsCount,
		v35.TitleBarSizeY
	})
	React.useEffect(function() -- line: 195
		-- upvalues: v53 (copy), v40 (copy), t2 (copy), v60 (copy), v62 (copy)
		local X = v53.X
		local Y = v53.Y
		local current = v40.current

		if t2.isSmallTouchDevice or not current then
			v60(X)
			v62(nil)

			return
		end

		local v98 = X - current.AbsolutePosition.Y

		if v98 + Y >= current.AbsoluteSize.Y then
			local v99 = v98 + Y - current.AbsoluteSize.Y

			v60(v98 - v99)
			v62(Vector2.new(0, current.CanvasPosition.Y + v99))

			return
		end

		v60(v98)
		v62(nil)
	end, {
		v53,
		t2.isSmallTouchDevice,
		v40.current
	})

	if not FFlagPlayerListUseFocusNavHook then
		React.useEffect(function() -- line: 218
			-- upvalues: FFlagAddNewPlayerListFocusNav (copy), t2 (copy), GuiService (copy), v41 (copy), UserInputService (copy), v40 (copy)
			if not FFlagAddNewPlayerListFocusNav then
				if t2.isVisible then
					if t2.isDirectionalPreferred and t2.isUsingGamepad then
						GuiService.SelectedCoreObject = v41.current
						UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
					end

					if v40.current and not t2.isSmallTouchDevice then
						v40.current.SelectionGroup = true
						v40.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
						v40.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
						v40.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
						v40.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop

						return
					end
				else
					if t2.isDirectionalPreferred and t2.isUsingGamepad then
						UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
					end

					if v40.current and GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(v40.current) then
						GuiService.SelectedCoreObject = nil
					end

					if v40.current and not t2.isSmallTouchDevice then
						v40.current.SelectionGroup = false
					end
				end
			end
		end, {
			t2.isVisible,
			t2.isSmallTouchDevice,
			t2.isDirectionalPreferred,
			t2.isUsingGamepad,
			v41.current,
			v40.current
		})
		React.useEffect(function() -- line: 250
			-- upvalues: FFlagAddNewPlayerListFocusNav (copy), t2 (copy), v40 (copy), v37 (copy), UserInputService (copy)
			if FFlagAddNewPlayerListFocusNav and (t2.isVisible and v40.current) then
				if t2.isDirectionalPreferred and t2.isUsingGamepad then
					v37(nil)
					v37(v40.current)
					UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
				end

				if not t2.isSmallTouchDevice then
					v40.current.SelectionGroup = true
					v40.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
					v40.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
					v40.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
					v40.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
				end
			end
		end, {
			v37,
			t2.isVisible,
			t2.isSmallTouchDevice,
			t2.isDirectionalPreferred,
			t2.isUsingGamepad,
			v40.current
		})
		React.useEffect(function() -- line: 270
			-- upvalues: FFlagAddNewPlayerListMobileFocusNav (copy), t2 (copy), v40 (copy), LocalPlayer (copy), v37 (copy)
			if FFlagAddNewPlayerListMobileFocusNav and (t2.isVisible and t2.isSmallTouchDevice and t2.isUsingGamepad and v40.current) then
				local v100 = false

				if t2.dropDownPlayer and not t2.dropDownVisible then
					local v101 = if not LocalPlayer or t2.dropDownPlayer.UserId ~= LocalPlayer.UserId then v40.current:FindFirstChild("PlayerEntry_" .. t2.dropDownPlayer.UserId, true) else v40.current:FindFirstChild("TitlePlayer", true)

					if v101 and v101:IsA("GuiObject") then
						v37(v101)
						v100 = true
					end
				end

				if not v100 then
					v37(nil)
					v37(v40.current)
				end
			end
		end, {
			v37,
			t2.isVisible,
			t2.dropDownVisible,
			t2.dropDownPlayer,
			t2.isSmallTouchDevice,
			t2.isUsingGamepad,
			v40.current
		})
		React.useEffect(function() -- line: 296
			-- upvalues: FFlagAddNewPlayerListFocusNav (copy), t2 (copy), v40 (copy), FFlagAddNewPlayerListMobileFocusNav (copy), UserInputService (copy), v38 (copy), v37 (copy)
			if FFlagAddNewPlayerListFocusNav and (not t2.isVisible and v40.current) then
				if (FFlagAddNewPlayerListMobileFocusNav and t2.isSmallTouchDevice or t2.isDirectionalPreferred) and t2.isUsingGamepad then
					UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.None
				end

				if v38 and v38:IsDescendantOf(v40.current) then
					v37(nil)
				end

				if FFlagAddNewPlayerListMobileFocusNav or not t2.isSmallTouchDevice then
					v40.current.SelectionGroup = false
				end
			end
		end, {
			v38,
			v37,
			t2.isVisible,
			t2.isSmallTouchDevice,
			t2.isDirectionalPreferred,
			t2.isUsingGamepad,
			v40.current
		})
		React.useEffect(function() -- line: 312
			-- upvalues: FFlagAddNewPlayerListFocusNav (copy), t2 (copy), v38 (copy), v43 (copy), v40 (copy), v37 (copy), v42 (copy)
			if FFlagAddNewPlayerListFocusNav and (t2.isVisible and not v38 and v43.current and v40.current) then
				local v102 = v40.current:FindFirstChild("PlayerEntry_" .. v43.current, true)

				if v102 and v102:IsA("GuiObject") then
					v37(v102)
				elseif v42.current and v42.current:IsDescendantOf(v40.current) then
					v37(v42.current)
				else
					v37(v40.current)
				end

				v43.current = nil
			end
		end, {
			v38,
			v37,
			t2.isVisible,
			v42.current,
			v43.current,
			v40.current
		})
	end

	if FFlagPlayerListUseFocusNavHook then
		React.useEffect(function() -- line: 334
			-- upvalues: t2 (copy), v39 (copy)
			if t2.isVisible and (t2.isSmallTouchDevice and t2.isUsingGamepad and not t2.dropDownVisible) then
				v39.getFocus()
			end
		end, {
			v39,
			t2.isVisible,
			t2.isSmallTouchDevice,
			t2.isUsingGamepad,
			t2.dropDownVisible
		})
		React.useEffect(function() -- line: 341
			-- upvalues: t2 (copy), v40 (copy), GuiService (copy), v39 (copy)
			if not t2.isVisible then
				local v103 = v40.current and (GuiService.SelectedCoreObject and GuiService.SelectedCoreObject:IsDescendantOf(v40.current))

				v39.cleanup(v103)
			end
		end, {
			v39,
			t2.isVisible
		})
	end

	local v75 = if not FFlagPlayerListUseFocusNavHook then nil else React.useCallback(function(_: number, p6, _) -- line: 351
		-- upvalues: v39 (copy)
		v39.setTitlePlayerInstance(p6)
	end, { v39 })
	local v76 = if not FFlagPlayerListUseFocusNavHook then nil else React.useCallback(function(_: number) -- line: 357
		-- upvalues: v39 (copy)
		v39.setTitlePlayerInstance(nil)
	end, { v39 })
	local t4 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = if not t2.isDirectionalPreferred then nil else UDim.new(0, v35.EntryPadding)
		})
	}

	if LocalPlayer and t2.isSmallTouchDevice and v74() then
		t4.TitlePlayer = React.createElement(PlayerEntryContainer, {
			layoutOrder = -3,
			titlePlayerEntry = true,
			entrySizeX = t2.entrySizeX,
			player = LocalPlayer,
			playerIconInfo = t2.playerIconInfo[LocalPlayer.UserId] or {
				isPlaceOwner = false
			},
			playerRelationship = t2.playerRelationship[LocalPlayer.UserId] or {
				isBlocked = false,
				isFollowing = false,
				isFollower = false,
				friendStatus = Enum.FriendStatus.NotFriend
			},
			setDropDownPlayerDimensionY = v54,
			registerPlayerInstance = if not FFlagPlayerListUseFocusNavHook then nil else v75,
			unregisterPlayerInstance = if not FFlagPlayerListUseFocusNavHook then nil else v76,
			setSelectedPlayerId = if not FFlagPlayerListUseFocusNavHook then nil else v39.setSelectedPlayerId
		})
		t4.BottomDiv = React.createElement("Frame", {
			BackgroundTransparency = 0.8,
			LayoutOrder = -2,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		})
	end

	if t2.isSmallTouchDevice then
		t4.TitleBar = React.createElement(TitleBarContainer, {
			layoutOrder = -1,
			isSmallTouchDevice = true,
			size = UDim2.new(1, 0, 0, v35.TitleBarSizeY),
			entrySizeX = t2.entrySizeX,
			contentsVisible = v51
		})
	end

	if t2.teamListCount > 0 then
		local n3 = 1e999

		t2.teamList.iterateData(function(p8, p9) -- line: 412
			-- upvalues: FFlagAddNewPlayerListFocusNav (copy), n3 (ref), t4 (copy), React (copy), TeamListContainer (copy), t2 (copy), FFlagPlayerListUseFocusNavHook (copy), v41 (copy), v54 (copy), v42 (copy), v43 (copy), v39 (copy)
			local v110 = false

			if not FFlagAddNewPlayerListFocusNav and (p9.order(false) <= n3 and p9.players.getCount(false) > 0) then
				n3 = p9.order(false)
				v110 = true
			end

			t4["TeamList_" .. tostring(p8)] = React.createElement(TeamListContainer, {
				entrySizeX = t2.entrySizeX,
				teamId = if not FFlagPlayerListUseFocusNavHook then nil else p8,
				teamData = p9,
				playerIconInfos = t2.playerIconInfo,
				playerRelationships = t2.playerRelationship,
				firstPlayerRef = if FFlagAddNewPlayerListFocusNav or not v110 then nil else v41,
				setDropDownPlayerDimensionY = v54,
				prevFocusedEntry = if FFlagPlayerListUseFocusNavHook or not FFlagAddNewPlayerListFocusNav then nil else v42,
				destroyedFocusedPlayerId = if FFlagPlayerListUseFocusNavHook or not FFlagAddNewPlayerListFocusNav then nil else v43,
				registerTeamInstance = if not FFlagPlayerListUseFocusNavHook then nil else v39.registerTeamInstance,
				unregisterTeamInstance = if not FFlagPlayerListUseFocusNavHook then nil else v39.unregisterTeamInstance,
				setSelectedPlayerId = if not FFlagPlayerListUseFocusNavHook then nil else v39.setSelectedPlayerId,
				isSmallTouchDevice = t2.isSmallTouchDevice,
				isDirectionalPreferred = t2.isDirectionalPreferred
			})
		end, false)
	end

	if t2.isSmallTouchDevice then
		local v79 = true

		if not FFlagPlayerListFixMobileScrolling then
			v79 = not t2.dropDownVisible
		end

		return React.createElement("ScrollingFrame", {
			Active = FFlagPlayerListFixMobileScrolling,
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ScrollBarImageColor3 = v35.ScrollImageColor,
			ScrollBarImageTransparency = v35.ScrollImageTransparency,
			BorderSizePixel = 0,
			ScrollBarThickness = v35.ScrollBarSizeMobile,
			VerticalScrollBarInset = Enum.ScrollBarInset.None,
			HorizontalScrollBarInset = Enum.ScrollBarInset.None,
			ClipsDescendants = true,
			ScrollingEnabled = v79,
			ElasticBehavior = Enum.ElasticBehavior.Never,
			Selectable = false,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			SelectionGroup = not not FFlagAddNewPlayerListMobileFocusNav or nil,
			SelectionBehaviorUp = if not FFlagAddNewPlayerListMobileFocusNav then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = if not FFlagAddNewPlayerListMobileFocusNav then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = if not FFlagAddNewPlayerListMobileFocusNav then nil else Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = if not FFlagAddNewPlayerListMobileFocusNav then nil else Enum.SelectionBehavior.Stop,
			ref = if not FFlagAddNewPlayerListMobileFocusNav then nil else v40,
			[React.Change.CanvasPosition] = v72,
			[React.Change.AbsoluteSize] = v71
		}, t4)
	end

	if t2.isDirectionalPreferred then
		return React.createElement("Frame", {
			Position = v35.PlayerScrollListPosition,
			Size = v35.PlayerScrollListSize,
			BackgroundTransparency = 1,
			[React.Change.AbsoluteSize] = v71
		}, {
			TenFootScrollingFrame = React.createElement("ScrollingFrame", {
				Size = UDim2.new(1, 0, 1, 0),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				ScrollBarImageColor3 = v35.ScrollImageColor,
				ScrollBarImageTransparency = v35.ScrollImageTransparency,
				BorderSizePixel = 0,
				ScrollBarThickness = 6,
				VerticalScrollBarInset = Enum.ScrollBarInset.Always,
				ClipsDescendants = true,
				ScrollingEnabled = not t2.dropDownVisible,
				Selectable = false,
				CanvasPosition = t2.dropDownVisible and v61 or v45,
				ref = v40,
				[React.Change.CanvasPosition] = v72
			}, t4)
		})
	end

	local v80 = v35.FadedBackgroundScaleDelta or 0
	local v81 = v35.ScrollBarOffset or 0
	local v82 = v35.ScrollBarSize or 0
	local v83 = if not Enabled() then v36.Theme.BackgroundContrast.Color else v36.Theme.BackgroundUIContrast.Color

	v66(v35.OverrideBackgroundTransparency * v36.Settings.PreferredTransparency)
	v68(v35.FadedBackgroundTransparency or 0)

	return React.createElement("Frame", {
		Position = v35.PlayerScrollListPosition,
		Size = v35.PlayerScrollListSize,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = v71
	}, {
		SizeOffsetFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, {
			UIScale = React.createElement("UIScale", {
				Scale = v63:map(function(p10) -- line: 531
					-- upvalues: v80 (copy)
					return 1 - v80 * p10
				end)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			}),
			TopRoundedRect = if v31 then React.createElement("Frame", {
				LayoutOrder = 1,
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v20 + 2)
			}, {
				DismissIconFrame = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, (v20 + 2) * 2),
					BackgroundColor3 = v83,
					BackgroundTransparency = v69
				}, {
					DismissButton = React.createElement(IconButton, {
						position = UDim2.new(0, 1, 0, 1),
						iconSize = IconSize.Small,
						icon = Images["icons/navigation/close"],
						onActivated = t2.dismissPlayerList
					}),
					UICorner = React.createElement("UICorner", {
						CornerRadius = UDim.new(0, 7)
					})
				})
			}) else React.createElement("ImageLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/TopRoundedRect8px.png",
				SliceScale = 0.5,
				ImageColor3 = v83,
				ImageTransparency = v69,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 24, 18),
				Size = UDim2.new(1, 0, 0, 4)
			}),
			TitleBar = t2.gameStatsCount > 0 and React.createElement(TitleBarContainer, {
				layoutOrder = 2,
				showBackground = true,
				size = UDim2.new(1, 0, 0, v35.TitleBarSizeY),
				entrySizeX = t2.entrySizeX,
				contentsVisible = v51,
				backgroundTransparency = v69
			}),
			ScrollingFrameContainer = React.createElement("Frame", {
				LayoutOrder = 3,
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, v55),
				BackgroundColor3 = v83,
				BackgroundTransparency = v69,
				BorderSizePixel = 0,
				[React.Change.AbsolutePosition] = v73
			}, {
				PlayerDropDown = if not v51 then nil else React.createElement(PlayerDropDown, {
					contentsVisible = v51,
					selectedPlayer = t2.dropDownPlayer,
					positionY = v59,
					minPositionBoundY = -v49 + v35.DropDownScreenSidePadding,
					maxPositionBoundY = t2.screenSizeY - v49 - v35.DropDownScreenSidePadding
				}),
				ScrollingFrameClippingFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Visible = v51,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					ScrollingFrame = React.createElement("ScrollingFrame", {
						Size = UDim2.new(1, -v81, 0, v55),
						CanvasSize = UDim2.new(0, 0, 0, 0),
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						BackgroundTransparency = 1,
						ScrollBarImageColor3 = v35.ScrollImageColor,
						ScrollBarImageTransparency = v35.ScrollImageTransparency,
						BorderSizePixel = 0,
						ScrollBarThickness = v35.ScrollBarSize,
						VerticalScrollBarInset = Enum.ScrollBarInset.Always,
						ClipsDescendants = false,
						ScrollingEnabled = not t2.dropDownVisible,
						Selectable = false,
						CanvasPosition = t2.dropDownVisible and v61 or v45,
						ref = v40,
						[React.Change.CanvasPosition] = v72
					}, {
						OffsetUndoFrame = React.createElement("Frame", {
							Size = UDim2.new(1, v81 + v82, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundTransparency = 1,
							[React.Change.AbsoluteSize] = v70
						}, t4)
					})
				})
			}),
			BottomRoundedRect = if v31 then React.createElement("Frame", {
				LayoutOrder = 4,
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 7)
			}, { React.createElement("Frame", {
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0, -8),
				Size = UDim2.new(1, 0, 0, 14),
				BackgroundColor3 = v83,
				BackgroundTransparency = v69
			}, { React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 7)
			}) }) }) else React.createElement("ImageLabel", {
				LayoutOrder = 4,
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/BottomRoundedRect8px.png",
				SliceScale = 0.5,
				ImageColor3 = v83,
				ImageTransparency = v69,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 24, 16),
				Size = UDim2.new(1, 0, 0, 4)
			})
		})
	})
end

return React.memo(PlayerListDisplayView)
