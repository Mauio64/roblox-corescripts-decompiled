local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent.Parent
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

require(CorePackages.Workspace.Packages.LeaderboardStore)

local useLayoutValues = PlayerList.Common.useLayoutValues
local useStyle = UIBlox.Core.Style.useStyle
local PlayerEntryContainer = require(ParentParent.Components.Container.PlayerEntryContainer)
local TeamEntryContainer = require(ParentParent.Components.Container.TeamEntryContainer)
local FFlagReplacePlayerIconRoduxWithSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagReplacePlayerIconRoduxWithSignal
local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook
local PlayerIconInfoStore = require(CorePackages.Workspace.Packages.PlayerIconInfoStore).PlayerIconInfoStore

local function TeamListView(t1: {[any]: any}) -- line: 61
	-- upvalues: useLayoutValues (copy), useStyle (copy), React (copy), TeamEntryContainer (copy), FFlagReplacePlayerIconRoduxWithSignal (copy), PlayerIconInfoStore (copy), PlayerEntryContainer (copy), FFlagPlayerListUseFocusNavHook (copy)
	local v15 = useLayoutValues()
	local v16 = useStyle()
	local t2 = {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = if not t1.isDirectionalPreferred then nil else UDim.new(0, v15.EntryPadding)
		})
	}

	if t1.showTeamEntry then
		t2.TeamEntry = React.createElement(TeamEntryContainer, {
			layoutOrder = -1,
			size = UDim2.new(1, 0, 0, v15.TeamEntrySizeY),
			teamData = t1.teamData,
			entrySizeX = t1.entrySizeX,
			isSmallTouchDevice = t1.isSmallTouchDevice,
			isDirectionalPreferred = t1.isDirectionalPreferred
		})
	end

	if t1.teamPlayersCount > 0 then
		local n1 = 0

		if t1.isSmallTouchDevice then
			t2.BottomDiv = React.createElement("Frame", {
				BackgroundTransparency = 0.8,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				LayoutOrder = t1.teamPlayersCount * 2
			})
		end

		t1.teamData.players.iterateData(function(p1, p2) -- line: 100
			-- upvalues: n1 (ref), FFlagReplacePlayerIconRoduxWithSignal (copy), PlayerIconInfoStore (copy), t1 (copy), t2 (copy), React (copy), PlayerEntryContainer (copy), v15 (copy), FFlagPlayerListUseFocusNavHook (copy), v16 (copy)
			n1 += 1

			local v21 = if not FFlagReplacePlayerIconRoduxWithSignal then t1.playerIconInfos[p2] else PlayerIconInfoStore.getPlayerIconInfoReactive(p1.UserId)(false)
			local v22 = t1.playerRelationships[p2]

			if not v21 or not v22 then
				return
			end

			t2["PlayerEntry_" .. tostring(p2)] = React.createElement(PlayerEntryContainer, {
				titlePlayerEntry = false,
				size = UDim2.new(1, v15.EntryXOffset, 0, v15.PlayerEntrySizeY),
				player = p1,
				entrySizeX = t1.entrySizeX,
				playerIconInfo = v21,
				playerRelationship = v22,
				setDropDownPlayerDimensionY = t1.setDropDownPlayerDimensionY,
				firstPlayerRef = t1.firstPlayerRef,
				prevFocusedEntry = t1.prevFocusedEntry,
				destroyedFocusedPlayerId = t1.destroyedFocusedPlayerId,
				registerPlayerInstance = if not FFlagPlayerListUseFocusNavHook then nil else t1.registerPlayerInstance,
				unregisterPlayerInstance = if not FFlagPlayerListUseFocusNavHook then nil else t1.unregisterPlayerInstance,
				setSelectedPlayerId = if not FFlagPlayerListUseFocusNavHook then nil else t1.setSelectedPlayerId
			})

			if t1.isSmallTouchDevice then
				t2["TopDiv_" .. n1] = React.createElement("Frame", {
					BackgroundTransparency = 0.8,
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 0, 0),
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					LayoutOrder = (n1 - 1) * 2
				})
			end

			if n1 < t1.teamPlayersCount and not t1.isSmallTouchDevice and not t1.isDirectionalPreferred then
				t2["Divider_" .. n1] = React.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = v16.Theme.Divider.Transparency,
					BackgroundColor3 = v16.Theme.Divider.Color,
					LayoutOrder = n1 * 2
				})
			end
		end, false)
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.layoutOrder
	}, t2)
end

return React.memo(TeamListView)
