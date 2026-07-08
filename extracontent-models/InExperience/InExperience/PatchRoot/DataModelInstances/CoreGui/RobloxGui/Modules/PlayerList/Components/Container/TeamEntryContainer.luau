local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local ParentParent = script.Parent.Parent.Parent
local React = require(CorePackages.Packages.React)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

require(CorePackages.Workspace.Packages.LeaderboardStore)

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local GameTranslator = require(RobloxGui.Modules.GameTranslator)
local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore
local TeamEntryView = require(ParentParent.Components.PresentationCommon.TeamEntryView)
local FFlagPlayerListFixLeaderstatsStacking = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlayerListFixLeaderstatsStacking

local function TeamEntryContainer(t1: {[any]: any}) -- line: 44
	-- upvalues: useLeaderboardStore (copy), SignalsReact (copy), GameTranslator (copy), CoreGui (copy), FFlagPlayerListFixLeaderstatsStacking (copy), React (copy), TeamEntryView (copy)
	local v14 = useLeaderboardStore().getGameStatsList()
	local stats = t1.teamData.stats
	local v16 = SignalsReact.useSignalBinding(function(p1) -- line: 50
		-- upvalues: GameTranslator (copy), CoreGui (copy), t1 (copy)
		return GameTranslator:TranslateGameText(CoreGui, t1.teamData.name(p1))
	end)
	local v17 = SignalsReact.useSignalState(t1.teamData.color)
	local v18 = if not FFlagPlayerListFixLeaderstatsStacking then SignalsReact.useSignalState(v14.getCount) else nil
	local v19 = if not FFlagPlayerListFixLeaderstatsStacking then SignalsReact.useSignalState(stats.getCount) else nil

	return React.createElement(TeamEntryView, {
		teamName = v16,
		teamColor = v17,
		gameStatsCount = if not FFlagPlayerListFixLeaderstatsStacking then v18 else nil,
		teamStatsCount = if not FFlagPlayerListFixLeaderstatsStacking then v19 else nil,
		gameStats = v14,
		teamStats = stats,
		size = t1.size,
		entrySizeX = t1.entrySizeX,
		layoutOrder = t1.layoutOrder,
		isSmallTouchDevice = t1.isSmallTouchDevice,
		isDirectionalPreferred = t1.isDirectionalPreferred
	})
end

return React.memo(TeamEntryContainer)
