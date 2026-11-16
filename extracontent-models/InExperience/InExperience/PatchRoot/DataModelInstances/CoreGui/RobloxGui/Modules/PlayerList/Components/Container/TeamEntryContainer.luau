local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local parent = script.Parent.Parent.Parent

local React = require(CorePackages.Packages.React)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
require(CorePackages.Workspace.Packages.LeaderboardStore)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local GameTranslator = require(RobloxGui.Modules.GameTranslator)

local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore

local TeamEntryView = require(parent.Components.PresentationCommon.TeamEntryView)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagPlayerListFixLeaderstatsStacking = SharedFlags.FFlagPlayerListFixLeaderstatsStacking

local function TeamEntryContainer(props)
	local gameStatsList = useLeaderboardStore().getGameStatsList()
	local stats = props.teamData.stats

	local teamName = SignalsReact.useSignalBinding(function(p)
		return GameTranslator:TranslateGameText(CoreGui, props.teamData.name(p))
	end)

	local teamColor = SignalsReact.useSignalState(props.teamData.color)
	local gameStatsCount

	if not FFlagPlayerListFixLeaderstatsStacking then
		gameStatsCount = SignalsReact.useSignalState(gameStatsList.getCount)
	end

	local teamStatsCount

	if not FFlagPlayerListFixLeaderstatsStacking then
		teamStatsCount = SignalsReact.useSignalState(stats.getCount)
	end

	local createElement = React.createElement

	if FFlagPlayerListFixLeaderstatsStacking then
		gameStatsCount = nil
	end

	if FFlagPlayerListFixLeaderstatsStacking then
		teamStatsCount = nil
	end

	return createElement(TeamEntryView, {
		teamName = teamName,
		teamColor = teamColor,
		gameStatsCount = gameStatsCount,
		teamStatsCount = teamStatsCount,
		gameStats = gameStatsList,
		teamStats = stats,
		size = props.size,
		entrySizeX = props.entrySizeX,
		layoutOrder = props.layoutOrder,
		isSmallTouchDevice = props.isSmallTouchDevice,
		isDirectionalPreferred = props.isDirectionalPreferred
	})
end

return React.memo(TeamEntryContainer)
