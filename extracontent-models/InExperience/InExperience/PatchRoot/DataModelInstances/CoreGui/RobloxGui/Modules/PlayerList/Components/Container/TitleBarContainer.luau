local CorePackages = game:GetService("CorePackages")
local ParentParent = script.Parent.Parent.Parent
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)

require(CorePackages.Workspace.Packages.LeaderboardStore)

local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore
local TitleBarView = require(ParentParent.Components.PresentationCommon.TitleBarView)
local FFlagPlayerListFixLeaderstatsStacking = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPlayerListFixLeaderstatsStacking

local function TitleBarContainer(t1: {[any]: any}) -- line: 41
	-- upvalues: useLeaderboardStore (copy), FFlagPlayerListFixLeaderstatsStacking (copy), SignalsReact (copy), React (copy), TitleBarView (copy)
	local v11 = useLeaderboardStore().getGameStatsList()
	local v12 = if not FFlagPlayerListFixLeaderstatsStacking then SignalsReact.useSignalState(v11.getCount) else nil

	return React.createElement(TitleBarView, {
		gameStats = v11,
		gameStatsCount = if not FFlagPlayerListFixLeaderstatsStacking then v12 else nil,
		size = t1.size,
		entrySizeX = t1.entrySizeX,
		layoutOrder = t1.layoutOrder,
		contentsVisible = t1.contentsVisible,
		isSmallTouchDevice = t1.isSmallTouchDevice,
		showDivider = t1.showDivider,
		showBackground = t1.showBackground,
		backgroundTransparency = t1.backgroundTransparency,
		useCustomTextColor = t1.useCustomTextColor,
		customTextColor = t1.customTextColor,
		headerPaddingLeft = t1.headerPaddingLeft
	})
end

return React.memo(TitleBarContainer)
