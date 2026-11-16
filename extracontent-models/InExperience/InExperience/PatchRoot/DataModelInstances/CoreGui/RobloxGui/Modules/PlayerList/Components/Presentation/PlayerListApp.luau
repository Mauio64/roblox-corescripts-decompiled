local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local Otter = require(CorePackages.Packages.Otter)
local Cryo = require(CorePackages.Packages.Cryo)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
require(CorePackages.Workspace.Packages.LeaderboardStore)
local Display = require(CorePackages.Workspace.Packages.Display)

local StatsUtils = require(RobloxGui.Modules.Stats.StatsUtils)

local parent = script.Parent
local presentationCommon = parent.Parent.PresentationCommon
local parent2 = parent.Parent.Parent

local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore
local usePlatformLeaderboard = PlayerList.Hooks.usePlatformLeaderboard
local Constants = PlayerList.Common.Constants

local PlayerEntryContainer = require(parent2.Components.Container.PlayerEntryContainer)
local PlayerListDisplayContainer = require(parent2.Components.Container.PlayerListDisplayContainer)
local TenFootSideBar = require(presentationCommon.TenFootSideBar)

local connection = parent2.Components.Connection
local EventConnections = require(connection.EventConnections)
local ContextActionsBinder = require(connection.ContextActionsBinder)
local TopStatConnector = require(connection.TopStatConnector)
local LayoutValues = require(connection.LayoutValues)
local WithLayoutValues = LayoutValues.WithLayoutValues

local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local FFlagPlayerListFixPlatformLeaderboardSizing = PlayerList.Flags.FFlagPlayerListFixPlatformLeaderboardSizing
local FFlagPlayerListTwoTabsOnLegacy = PlayerList.Flags.FFlagPlayerListTwoTabsOnLegacy
local FFlagPlayerListRemoveTopStat = require(parent2.Flags.FFlagPlayerListRemoveTopStat)

local v = { dampingRatio = 1, frequency = 7 }
local v2

if FFlagPlayerListFixPlatformLeaderboardSizing and FFlagPlayerListTwoTabsOnLegacy then
	v2 = Signals.createSignal(false)
else
	v2 = nil
end

local extended = Roact.PureComponent:extend("PlayerListApp")

local function shouldShowNeutralTeam(list): boolean -- 1 equivalent call inferred from this helper
	for _, item in ipairs(list) do
		if item.Team == nil then
			return true
		end
	end

	return false
end

local function getTeamCount(teams, players)
	local numberSet = {}
	local count = 0

	for _, item in pairs(teams) do
		if numberSet[item.TeamColor.Number] then
			continue
		end

		numberSet[item.TeamColor.Number] = true
		count += 1
	end

	if count > 0 and shouldShowNeutralTeam(players) then -- inferred equivalent call
		count += 1
	end

	return count
end

function extended:init()
	self.state = { visible = true }

	local binding, updatePositionOffset = Roact.createBinding(UDim2.new(0, 0, 0, 0))
	self.positionOffset = binding
	self.updatePositionOffset = updatePositionOffset

	self.positionMotor = Otter.createSingleMotor(0)
	self.positionMotor:onStep(function(p)
		self.updatePositionOffset(UDim2.new(p, 0, 0, 0))
	end)
	self.positionMotor:onComplete(function(_)
		if not self.props.displayOptions.isVisible then
			self:setState({ visible = false })
		end
	end)
	self.disposeUiScaleEffect = Signals.createEffect(function(p)
		self:setState({
			UiScale = Display.GetDisplayStore(p).getUIScale(p)
		})
	end)
end

function extended.render(props)
	if props.state.visible then
		return WithLayoutValues(function(props2)
			local containerPosition = props2.ContainerPosition
			local size = props2.ContainerSize
			local anchorPoint = props2.AnchorPoint

			if not props2.IsTenFoot and props.props.displayOptions.performanceStatsVisible then
				containerPosition += UDim2.fromOffset(0, StatsUtils.ButtonHeight)
			end

			local position = containerPosition + UDim2.fromOffset(0, props2.TopBarOffset * props.state.UiScale)

			local v3 = props2.MaxLeaderstats

			if props.props.displayOptions.isSmallTouchDevice then
				v3 = props2.MaxLeaderstatsSmallScreen
			end

			local v4 = math.min(props.props.gameStatsCount, v3)

			if v4 > 0 then
				local v5 = props2.StatEntrySizeX + props2.EntryPadding
				size += UDim2.new(0, v5 * v4, 0, 0)
			end

			local v5

			if props2.IsTenFoot then
				v5 = props2.EntrySizeX
			else
				v5 = props2.EntryBaseSizeX + math.min(4, v4) * props2.EntrySizeIncreasePerStat

				local v6 = size + UDim2.new(0, props2.ExtraContainerPadding, 0, 0)

				if FFlagPlayerListFixPlatformLeaderboardSizing and props.props.hasPlatformLeaderboard then
					v5 = math.max(v5, Constants.PLATFORM_PANEL_WIDTH - v6.X.Offset)
				end

				local v7 = props2.PlayerDropDownSizeX + props2.PlayerDropDownOffset
				local v8 = v6.X.Offset + props2.ContainerPadding * 2 + v7

				if props.props.screenSizeX - v8 < v5 then
					v5 = props.props.screenSizeX - v8
				end

				size = v6 + UDim2.new(0, v5, 0, 0)
			end

			local v6 = 1e999
			local v7

			if Players.MaxPlayers >= 6 then
				v7 = Players.MaxPlayers <= 12
			else
				v7 = false
			end

			if v7 then
				v6 = Players.MaxPlayers * 26 + getTeamCount(props.props.teams, props.props.players) * 20
			end

			local minSize = Vector2.zero

			if FFlagPlayerListFixPlatformLeaderboardSizing and props.props.hasPlatformLeaderboard then
				minSize = Vector2.new(
					math.min(Constants.PLATFORM_PANEL_WIDTH, size.X.Offset),
					Constants.LEGACY_PLATFORM_PANEL_MIN_HEIGHT
				)

				v6 = math.max(v6, minSize.Y)
			end

			local children = {}

			if props2.IsTenFoot then
				for _, player in ipairs(props.props.players) do
					if player == Players.LocalPlayer then
						children.TitlePlayerEntry = Roact.createElement(
							"Frame",
							{
								Position = UDim2.fromOffset(0, 0),
								Size = UDim2.new(1, props2.EntryXOffset, 0, props2.PlayerEntrySizeY),
								BackgroundTransparency = 1
							},
							{
								PlayerEntry = Roact.createElement(PlayerEntryContainer, {
									entrySizeX = v5,
									titlePlayerEntry = true,
									player = player,
									playerIconInfo = props.props.playerIconInfo[player.UserId],
									playerRelationship = props.props.playerRelationship[player.UserId]
								})
							}
						)
						break
					end
				end
			end

			local createElement = Roact.createElement
			local v8 = { screenSizeY = props.props.screenSizeY, entrySize = v5, isVisible = 0 }
			local isVisible

			if FFlagAddNewPlayerListFocusNav then
				isVisible = props.state.visible
			end

			v8.isVisible = isVisible
			children.PlayerScrollList = createElement(PlayerListDisplayContainer, v8)

			children.EventConnections = Roact.createElement(EventConnections)
			children.ContextActionsBindings = Roact.createElement(ContextActionsBinder)

			if not FFlagPlayerListRemoveTopStat then
				children.TopStatConnector = Roact.createElement(TopStatConnector)
			end

			if props.props.displayOptions.isTenFootInterface then
				children.TenFootSideBar = Roact.createElement(TenFootSideBar)
			end

			return Roact.createElement("Frame", {
				Position = position,
				AnchorPoint = anchorPoint,
				Size = size,
				BackgroundTransparency = 1,
				Visible = props.state.visible,
				ZIndex = props2.IsTenFoot and 2 or 1,
				AutoLocalize = false,
				[Roact.Ref] = props.rootRef
			}, {
				OffsetFrame = Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 1, 0),
						Position = props.positionOffset,
						BackgroundTransparency = 1
					},
					children
				),
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = minSize,
					MaxSize = Vector2.new(1e999, v6)
				}) or nil
			})
		end)
	end

	local createFragment = Roact.createFragment
	local element = Roact.createElement(ContextActionsBinder)
	local v3

	if FFlagAddNewPlayerListFocusNav then
		v3 = Roact.createElement(EventConnections)
	end

	return createFragment({ element, v3 })
end

function extended.didMount(object)
	object:setState({ visible = object.props.displayOptions.isVisible })
end

function extended.didUpdate(object, p, _)
	if object.props.displayOptions.isVisible ~= p.displayOptions.isVisible then
		if object.props.displayOptions.isTenFootInterface then
			object:setState({ visible = object.props.displayOptions.isVisible })
		elseif object.props.displayOptions.isVisible then
			object:setState({ visible = true })

			object.positionMotor:setGoal(Otter.instant(0.2))
			object.positionMotor:step(0)
			object.positionMotor:setGoal(Otter.spring(0, v))
		else
			object.positionMotor:setGoal(Otter.spring(1.1, v))
		end
	end
end

function extended:willUnmount()
	self.positionMotor:destroy()
	self.positionMotor = nil

	if self.disposeUiScaleEffect then
		self.disposeUiScaleEffect()
	end
end

local function mapStateToProps(data)
	return {
		screenSizeX = data.screenSize.X,
		screenSizeY = data.screenSize.Y,
		displayOptions = data.displayOptions,
		players = data.players,
		playerStats = data.playerStats,
		playerIconInfo = data.playerIconInfo,
		playerRelationship = data.playerRelationship,
		gameStats = data.gameStats,
		teams = data.teams
	}
end

local function PlayerListAppWithLeaderboardStore(p)
	local v3 = useLeaderboardStore()

	local computed = Signals.createComputed(function(p2)
		if v3 then
			return (v3.getGameStatsList().getCount(p2))
		end

		return #p.gameStats
	end)

	local gameStatsCount = SignalsReact.useSignalState(computed)
	local hasPlatformLeaderboard

	if FFlagPlayerListFixPlatformLeaderboardSizing and FFlagPlayerListTwoTabsOnLegacy then
		local v4 = usePlatformLeaderboard()

		local v5 = if v4 then v4.getHasActiveLeaderboard else v2

		hasPlatformLeaderboard = SignalsReact.useSignalState(v5)
	else
		hasPlatformLeaderboard = false
	end

	return Roact.createElement(
		extended,
		Cryo.Dictionary.join(p, {
			gameStatsCount = gameStatsCount,
			hasPlatformLeaderboard = hasPlatformLeaderboard
		})
	)
end

return RoactRodux.connect(mapStateToProps, nil)(PlayerListAppWithLeaderboardStore)
