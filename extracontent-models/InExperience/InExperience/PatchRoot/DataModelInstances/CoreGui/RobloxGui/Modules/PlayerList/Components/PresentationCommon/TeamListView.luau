local CorePackages = game:GetService("CorePackages")

local parent = script.Parent.Parent.Parent

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
require(CorePackages.Workspace.Packages.LeaderboardStore)

local useLayoutValues = PlayerList.Common.useLayoutValues
local useStyle = UIBlox.Core.Style.useStyle

local PlayerEntryContainer = require(parent.Components.Container.PlayerEntryContainer)
local TeamEntryContainer = require(parent.Components.Container.TeamEntryContainer)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagReplacePlayerIconRoduxWithSignal = SharedFlags.FFlagReplacePlayerIconRoduxWithSignal
local FFlagPlayerListUseFocusNavHook = PlayerList.Flags.FFlagPlayerListUseFocusNavHook

local PlayerIconInfoStore = require(CorePackages.Workspace.Packages.PlayerIconInfoStore)
local playerIconInfoStore = PlayerIconInfoStore.PlayerIconInfoStore

local function TeamListView(props)
	local v = useLayoutValues()
	local v2 = useStyle()

	local children = {}

	local createElement = React.createElement
	local v3 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		VerticalAlignment = Enum.VerticalAlignment.Top,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		Padding = 0
	}
	local padding

	if props.isDirectionalPreferred then
		padding = UDim.new(0, v.EntryPadding)
	end

	v3.Padding = padding
	children.UIListLayout = createElement("UIListLayout", v3)

	if props.showTeamEntry then
		children.TeamEntry = React.createElement(TeamEntryContainer, {
			size = UDim2.new(1, 0, 0, v.TeamEntrySizeY),
			teamData = props.teamData,
			entrySizeX = props.entrySizeX,
			isSmallTouchDevice = props.isSmallTouchDevice,
			isDirectionalPreferred = props.isDirectionalPreferred,
			layoutOrder = -1
		})
	end

	if props.teamPlayersCount > 0 then
		local count = 0

		if props.isSmallTouchDevice then
			children.BottomDiv = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.8,
				LayoutOrder = props.teamPlayersCount * 2
			})
		end

		props.teamData.players.iterateData(function(player, p)
			count += 1
			local playerIconInfo

			if FFlagReplacePlayerIconRoduxWithSignal then
				playerIconInfo = playerIconInfoStore.getPlayerIconInfoReactive(player.UserId)(false)
			else
				playerIconInfo = props.playerIconInfos[p]
			end

			local playerRelationship = props.playerRelationships[p]

			if not (playerIconInfo and playerRelationship) then
				return
			end

			local v4 = "PlayerEntry_" .. tostring(p)
			local createElement2 = React.createElement
			local v5 = {
				size = UDim2.new(1, v.EntryXOffset, 0, v.PlayerEntrySizeY),
				player = player,
				titlePlayerEntry = false,
				entrySizeX = props.entrySizeX,
				playerIconInfo = playerIconInfo,
				playerRelationship = playerRelationship,
				setDropDownPlayerDimensionY = props.setDropDownPlayerDimensionY,
				firstPlayerRef = props.firstPlayerRef,
				prevFocusedEntry = props.prevFocusedEntry,
				destroyedFocusedPlayerId = props.destroyedFocusedPlayerId,
				registerPlayerInstance = 0,
				unregisterPlayerInstance = 0,
				setSelectedPlayerId = 0
			}
			local registerPlayerInstance

			if FFlagPlayerListUseFocusNavHook then
				registerPlayerInstance = props.registerPlayerInstance
			end

			v5.registerPlayerInstance = registerPlayerInstance
			local unregisterPlayerInstance

			if FFlagPlayerListUseFocusNavHook then
				unregisterPlayerInstance = props.unregisterPlayerInstance
			end

			v5.unregisterPlayerInstance = unregisterPlayerInstance
			local setSelectedPlayerId

			if FFlagPlayerListUseFocusNavHook then
				setSelectedPlayerId = props.setSelectedPlayerId
			end

			v5.setSelectedPlayerId = setSelectedPlayerId
			children[v4] = createElement2(PlayerEntryContainer, v5)

			if props.isSmallTouchDevice then
				children["TopDiv_" .. count] = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 0, 0),
					AnchorPoint = Vector2.new(0, 0),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.8,
					LayoutOrder = (count - 1) * 2
				})
			end

			if count < props.teamPlayersCount and not (props.isSmallTouchDevice or props.isDirectionalPreferred) then
				children["Divider_" .. count] = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					Position = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundTransparency = v2.Theme.Divider.Transparency,
					BackgroundColor3 = v2.Theme.Divider.Color,
					BorderSizePixel = 0,
					LayoutOrder = count * 2
				})
			end
		end, false)
	end

	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		},
		children
	)
end

return React.memo(TeamListView)
