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
local scriptParent = script.Parent
local PresentationCommon = scriptParent.Parent.PresentationCommon
local ParentParent = scriptParent.Parent.Parent
local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore
local PlayerEntryContainer = require(ParentParent.Components.Container.PlayerEntryContainer)
local PlayerListDisplayContainer = require(ParentParent.Components.Container.PlayerListDisplayContainer)
local TenFootSideBar = require(PresentationCommon.TenFootSideBar)
local Connection = ParentParent.Components.Connection
local EventConnections = require(Connection.EventConnections)
local ContextActionsBinder = require(Connection.ContextActionsBinder)
local TopStatConnector = require(Connection.TopStatConnector)
local WithLayoutValues = require(Connection.LayoutValues).WithLayoutValues
local FFlagAddNewPlayerListFocusNav = PlayerList.Flags.FFlagAddNewPlayerListFocusNav
local t1 = {
	dampingRatio = 1,
	frequency = 7
}
local v28 = Roact.PureComponent:extend("PlayerListApp")

local function shouldShowNeutralTeam(p1) -- line: 53
	for _, v in ipairs(p1) do
		if v.Team == nil then
			return true
		end
	end

	return false
end
local function getTeamCount(p2, p3) -- line: 62
	local t2 = {}
	local n1 = 0
	local g45 = nil
	local v44 = nil

	for _, v in pairs(p2) do
		if not t2[v.TeamColor.Number] then
			t2[v.TeamColor.Number] = true
			n1 += 1
		end
	end

	if n1 > 0 then
		for _, v in ipairs(p3) do
			if v.Team == nil then
				v44 = true
				g45 = true
			end

			if g45 then
				break
			end
		end

		if not g45 then
			v44 = false
		end

		g45 = false

		if v44 then
			n1 += 1
		end
	end

	return n1
end

function v28.init(p4) -- line: 77
	-- upvalues: Roact (copy), Otter (copy), Signals (copy), Display (copy)
	p4.state = {
		visible = true
	}

	local v47, v48 = Roact.createBinding(UDim2.new(0, 0, 0, 0))

	p4.positionOffset = v47
	p4.updatePositionOffset = v48
	p4.positionMotor = Otter.createSingleMotor(0)
	p4.positionMotor:onStep(function(p5) -- line: 85
		-- upvalues: p4 (copy)
		p4.updatePositionOffset(UDim2.new(p5, 0, 0, 0))
	end)
	p4.positionMotor:onComplete(function(_) -- line: 88
		-- upvalues: p4 (copy)
		if not p4.props.displayOptions.isVisible then
			p4:setState({
				visible = false
			})
		end
	end)
	p4.disposeUiScaleEffect = Signals.createEffect(function(p7) -- line: 95
		-- upvalues: Display (copy), p4 (copy)
		local v63 = Display.GetDisplayStore(p7)

		p4:setState({
			UiScale = v63.getUIScale(p7)
		})
	end)
end
function v28.render(p8) -- line: 103
	-- upvalues: Roact (copy), ContextActionsBinder (copy), FFlagAddNewPlayerListFocusNav (copy), EventConnections (copy), WithLayoutValues (copy), StatsUtils (copy), Players (copy), getTeamCount (copy), PlayerEntryContainer (copy), PlayerListDisplayContainer (copy), TopStatConnector (copy), TenFootSideBar (copy)
	if not p8.state.visible then
		return Roact.createFragment({
			Roact.createElement(ContextActionsBinder),
			if not FFlagAddNewPlayerListFocusNav then nil else Roact.createElement(EventConnections)
		})
	end

	return WithLayoutValues(function(p9) -- line: 111
		-- upvalues: p8 (copy), StatsUtils (copy), Players (copy), getTeamCount (copy), Roact (copy), PlayerEntryContainer (copy), PlayerListDisplayContainer (copy), FFlagAddNewPlayerListFocusNav (copy), EventConnections (copy), ContextActionsBinder (copy), TopStatConnector (copy), TenFootSideBar (copy)
		local ContainerPosition = p9.ContainerPosition
		local ContainerSize = p9.ContainerSize
		local p9AnchorPoint = p9.AnchorPoint

		if not p9.IsTenFoot and p8.props.displayOptions.performanceStatsVisible then
			ContainerPosition += UDim2.fromOffset(0, StatsUtils.ButtonHeight)
		end

		local v68 = ContainerPosition + UDim2.fromOffset(0, p9.TopBarOffset * p8.state.UiScale)
		local MaxLeaderstats = p9.MaxLeaderstats

		if p8.props.displayOptions.isSmallTouchDevice then
			MaxLeaderstats = p9.MaxLeaderstatsSmallScreen
		end

		local v70 = math.min(p8.props.gameStatsCount, MaxLeaderstats)

		if v70 > 0 then
			local v71 = p9.StatEntrySizeX + p9.EntryPadding

			ContainerSize += UDim2.new(0, v71 * v70, 0, 0)
		end

		local EntrySizeX

		if p9.IsTenFoot then
			EntrySizeX = p9.EntrySizeX
		else
			EntrySizeX = p9.EntryBaseSizeX + math.min(4, v70) * p9.EntrySizeIncreasePerStat

			local v73 = ContainerSize + UDim2.new(0, p9.ExtraContainerPadding, 0, 0)
			local v74 = p9.PlayerDropDownSizeX + p9.PlayerDropDownOffset
			local v75 = v73.X.Offset + p9.ContainerPadding * 2 + v74

			if EntrySizeX > p8.props.screenSizeX - v75 then
				EntrySizeX = p8.props.screenSizeX - v75
			end

			ContainerSize = v73 + UDim2.new(0, EntrySizeX, 0, 0)
		end

		local n2 = 1e999

		if Players.MaxPlayers >= 6 and Players.MaxPlayers <= 12 then
			n2 = Players.MaxPlayers * 26 + getTeamCount(p8.props.teams, p8.props.players) * 20
		end

		local t3 = {}

		if p9.IsTenFoot then
			for _, v in ipairs(p8.props.players) do
				if v == Players.LocalPlayer then
					t3.TitlePlayerEntry = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(0, 0),
						Size = UDim2.new(1, p9.EntryXOffset, 0, p9.PlayerEntrySizeY)
					}, {
						PlayerEntry = Roact.createElement(PlayerEntryContainer, {
							titlePlayerEntry = true,
							entrySizeX = EntrySizeX,
							player = v,
							playerIconInfo = p8.props.playerIconInfo[v.UserId],
							playerRelationship = p8.props.playerRelationship[v.UserId]
						})
					})

					break
				end
			end
		end

		t3.PlayerScrollList = Roact.createElement(PlayerListDisplayContainer, {
			screenSizeY = p8.props.screenSizeY,
			entrySize = EntrySizeX,
			isVisible = if not FFlagAddNewPlayerListFocusNav then nil else p8.state.visible
		})
		t3.EventConnections = Roact.createElement(EventConnections)
		t3.ContextActionsBindings = Roact.createElement(ContextActionsBinder)
		t3.TopStatConnector = Roact.createElement(TopStatConnector)

		if p8.props.displayOptions.isTenFootInterface then
			t3.TenFootSideBar = Roact.createElement(TenFootSideBar)
		end

		return Roact.createElement("Frame", {
			Position = v68,
			AnchorPoint = p9AnchorPoint,
			Size = ContainerSize,
			BackgroundTransparency = 1,
			Visible = p8.state.visible,
			ZIndex = not p9.IsTenFoot and 1 or 2,
			AutoLocalize = false,
			[Roact.Ref] = p8.rootRef
		}, {
			OffsetFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
				Position = p8.positionOffset
			}, t3),
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, 0),
				MaxSize = Vector2.new(1e999, n2)
			}) or nil
		})
	end)
end
function v28.didMount(p10) -- line: 221
	p10:setState({
		visible = p10.props.displayOptions.isVisible
	})
end
function v28.didUpdate(p11, p12, _) -- line: 227
	-- upvalues: Otter (copy), t1 (copy)
	if p11.props.displayOptions.isVisible ~= p12.displayOptions.isVisible then
		if p11.props.displayOptions.isTenFootInterface then
			p11:setState({
				visible = p11.props.displayOptions.isVisible
			})

			return
		end

		if p11.props.displayOptions.isVisible then
			p11:setState({
				visible = true
			})
			p11.positionMotor:setGoal(Otter.instant(0.2))
			p11.positionMotor:step(0)
			p11.positionMotor:setGoal(Otter.spring(0, t1))

			return
		end

		p11.positionMotor:setGoal(Otter.spring(1.1, t1))
	end
end
function v28.willUnmount(p14) -- line: 248
	p14.positionMotor:destroy()
	p14.positionMotor = nil

	if p14.disposeUiScaleEffect then
		p14.disposeUiScaleEffect()
	end
end

local function mapStateToProps(p15) -- line: 257
	return {
		screenSizeX = p15.screenSize.X,
		screenSizeY = p15.screenSize.Y,
		displayOptions = p15.displayOptions,
		players = p15.players,
		playerStats = p15.playerStats,
		playerIconInfo = p15.playerIconInfo,
		playerRelationship = p15.playerRelationship,
		gameStats = p15.gameStats,
		teams = p15.teams
	}
end
local function PlayerListAppWithLeaderboardStore(p16) -- line: 273
	-- upvalues: useLeaderboardStore (copy), Signals (copy), SignalsReact (copy), Roact (copy), v28 (copy), Cryo (copy)
	local v57 = useLeaderboardStore()
	local v58 = Signals.createComputed(function(p17) -- line: 276
		-- upvalues: v57 (copy), p16 (copy)
		if v57 then
			return (v57.getGameStatsList().getCount(p17))
		end

		return #p16.gameStats
	end)
	local v59 = SignalsReact.useSignalState(v58)

	return Roact.createElement(v28, Cryo.Dictionary.join(p16, {
		gameStatsCount = v59
	}))
end

return RoactRodux.connect(mapStateToProps, nil)(PlayerListAppWithLeaderboardStore)
