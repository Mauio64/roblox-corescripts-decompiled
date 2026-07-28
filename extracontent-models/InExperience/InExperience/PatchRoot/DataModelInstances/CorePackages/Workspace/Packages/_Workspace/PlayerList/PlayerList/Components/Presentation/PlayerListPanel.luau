local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local createSignalMap = require(ParentParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap

require(ParentParentParent.LeaderboardStore)

local View = Foundation.View
local ScrollView = Foundation.ScrollView
local FFlagPlayerListReskinPreferredTransparency = require(ParentParent.Flags.FFlagPlayerListReskinPreferredTransparency)
local FFlagPlayerListReskinOptimization = require(ParentParent.Flags.FFlagPlayerListReskinOptimization)
local v11 = if not FFlagPlayerListReskinPreferredTransparency then nil else require(ParentParent.Components.Presentation.PreferredTransparencyView)
local useLeaderboardStore = require(ParentParent.Hooks.useLeaderboardStore)
local usePanelLayout = require(ParentParent.Hooks.usePanelLayout)
local usePlatformLeaderboard = require(ParentParent.Hooks.usePlatformLeaderboard)
local computeStatColumns = require(ParentParent.Common.computeStatColumns)
local PlayerListVisibilityStore = require(ParentParent.Common.PlayerListVisibilityStore)
local PlayerContextualMenuStore = require(ParentParent.Common.PlayerContextualMenuStore)
local openContextMenu = PlayerContextualMenuStore.openContextMenu
local PanelHeader = require(ParentParent.Components.Presentation.PanelHeader)
local ColumnHeaderRow = require(ParentParent.Components.Presentation.ColumnHeaderRow)
local TeamListView = require(ParentParent.Components.Presentation.TeamListView)
local FFlagPlayerListReskinStickySelfRow = require(ParentParent.Flags.FFlagPlayerListReskinStickySelfRow)
local v23 = if not FFlagPlayerListReskinStickySelfRow then nil else require(ParentParent.Components.Presentation.EntryView)
local TabbedLeaderboardBody = require(ParentParent.Components.Presentation.TabbedLeaderboardBody)
local FFlagPlayerListTwoTabs = require(ParentParent.Flags.FFlagPlayerListTwoTabs)
local FallbackSignals = require(ParentParent.Common.FallbackSignals)
local v27 = createSignalMap()
local v28 = createSignalMap()

local function PlayerListPanelContent(t1: {[any]: any}) -- line: 66
	-- upvalues: useLeaderboardStore (copy), v27 (copy), v28 (copy), SignalsReact (copy), FFlagPlayerListTwoTabs (copy), usePlatformLeaderboard (copy), FallbackSignals (copy), usePanelLayout (copy), PlayerListVisibilityStore (copy), React (copy), PlayerContextualMenuStore (copy), FFlagPlayerListReskinStickySelfRow (copy), computeStatColumns (copy), TeamListView (copy), openContextMenu (copy), v23 (copy), ColumnHeaderRow (copy), ScrollView (copy), FFlagPlayerListReskinOptimization (copy), PanelHeader (copy), Foundation (copy), View (copy), FFlagPlayerListReskinPreferredTransparency (copy), v11 (copy), TabbedLeaderboardBody (copy)
	local v32 = t1.isSmallTouchDevice == true
	local title = t1.title
	local platformLeaderboardOverride = t1.platformLeaderboardOverride
	local v35 = useLeaderboardStore()
	local v36 = t1.localPlayerOverride or game:GetService("Players").LocalPlayer
	local v37 = if not v35 then v27 else v35.getTeamList()
	local v38 = if not v35 then v28 else v35.getGameStatsList()
	local v39 = SignalsReact.useSignalState(v37.getAllData)
	local v40 = SignalsReact.useSignalState(v38.getAllData)
	local v41 = v38.getCount(false)
	local v42 = if not FFlagPlayerListTwoTabs then nil else platformLeaderboardOverride or usePlatformLeaderboard()
	local v43 = if not v42 then FallbackSignals.getHasActiveLeaderboard else v42.getHasActiveLeaderboard
	local v44 = not not FFlagPlayerListTwoTabs and SignalsReact.useSignalState(v43)
	local v45 = usePanelLayout(v32, v41, v44)
	local v46 = SignalsReact.useSignalBinding(PlayerListVisibilityStore.getEffectiveVisible)
	local v47 = React.useCallback(function() -- line: 103
		-- upvalues: PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy)
		PlayerContextualMenuStore.closeContextMenu()
		PlayerListVisibilityStore.setVisible(false)
	end, {})
	local v48 = false

	if FFlagPlayerListReskinStickySelfRow and (v32 and v36 ~= nil and v35 ~= nil) then
		v48 = v37.getCount(false) > 0 or v41 > 0
	end

	local maxStatColumns = v45.maxStatColumns
	local v50 = React.useMemo(function() -- line: 124
		-- upvalues: computeStatColumns (copy), v38 (copy), maxStatColumns (copy)
		return computeStatColumns(v38, maxStatColumns)
	end, {
		v40,
		v38,
		maxStatColumns
	})
	local t2 = {}

	if v35 then
		local v52 = false

		for k, v in pairs(v39) do
			if v and k ~= "Neutral" then
				v52 = true

				break
			end
		end

		for k, v in pairs(v39) do
			if v then
				t2[`Team_{ tostring(k) }`] = React.createElement(TeamListView, {
					teamEntry = v,
					isNeutral = k == "Neutral",
					hasNonNeutralTeams = v52,
					leaderboardStore = v35,
					statColumns = v50,
					statWidth = v45.statWidth,
					rowHeight = v45.rowHeight,
					columnHeaderHeight = v45.columnHeaderHeight,
					onActivated = openContextMenu,
					localPlayer = v36
				})
			end
		end
	end

	local t3 = {
		StickySelfRow = if not v48 then nil else React.createElement(v23, {
			isCurrentUser = true,
			layoutOrder = 0,
			player = v36,
			leaderboardStore = v35,
			statColumns = v50,
			statWidth = v45.statWidth,
			rowHeight = v45.rowHeight,
			onActivated = openContextMenu
		}),
		ColumnHeaders = React.createElement(ColumnHeaderRow, {
			layoutOrder = 1,
			statColumns = v50,
			statWidth = v45.statWidth,
			headerHeight = v45.columnHeaderHeight
		}),
		PlayerRows = React.createElement(ScrollView, {
			LayoutOrder = 2,
			tag = "fill size-full-0",
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left
			},
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			selectionGroup = {
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			}
		}, t2)
	}
	local v58 = if not FFlagPlayerListReskinOptimization then {
		tag = "col radius-medium bg-over-media-200",
		Size = UDim2.fromOffset(v45.panelWidth, v45.panelHeight),
		Visible = v46
	} else React.useMemo(function() -- line: 206
		-- upvalues: v45 (copy), v46 (copy)
		return {
			tag = "col radius-medium bg-over-media-200",
			Size = UDim2.fromOffset(v45.panelWidth, v45.panelHeight),
			Visible = v46
		}
	end, {
		v45.panelWidth,
		v45.panelHeight,
		v46
	})
	local v59 = React.createElement(PanelHeader, {
		layoutOrder = 1,
		onClose = v47,
		height = v45.headerHeight,
		title = title
	})
	local v60 = React.createElement(Foundation.Divider, {
		LayoutOrder = 2
	})

	if FFlagPlayerListTwoTabs then
		local v61 = React.createElement(View, {
			LayoutOrder = 4,
			tag = "col fill size-full-0"
		}, t3)

		if FFlagPlayerListReskinPreferredTransparency then
			return React.createElement(v11, {
				size = UDim2.fromOffset(v45.panelWidth, v45.panelHeight),
				visible = v46
			}, {
				TabbedBody = React.createElement(TabbedLeaderboardBody, {
					serverBody = v61,
					panelHeader = v59,
					panelDivider = v60,
					panelProps = v58
				})
			})
		end

		return React.createElement(TabbedLeaderboardBody, {
			serverBody = v61,
			panelHeader = v59,
			panelDivider = v60,
			panelProps = v58
		})
	end

	if FFlagPlayerListReskinPreferredTransparency then
		return React.createElement(v11, {
			size = UDim2.fromOffset(v45.panelWidth, v45.panelHeight),
			visible = v46
		}, {
			Header = v59,
			HeaderDivider = v60,
			LeaderboardBody = React.createElement(View, {
				LayoutOrder = 3,
				tag = "col fill size-full-0"
			}, t3)
		})
	end

	return React.createElement(View, v58, {
		Header = v59,
		HeaderDivider = v60,
		LeaderboardBody = React.createElement(View, {
			LayoutOrder = 3,
			tag = "col fill size-full-0"
		}, t3)
	})
end
local function PlayerListPanelUnmountable(t4: {[any]: any}) -- line: 282
	-- upvalues: SignalsReact (copy), PlayerListVisibilityStore (copy), React (copy), PlayerListPanelContent (copy)
	if not SignalsReact.useSignalState(PlayerListVisibilityStore.getEffectiveVisible) then
		return nil
	end

	return React.createElement(PlayerListPanelContent, t4)
end

return React.memo(if not FFlagPlayerListReskinOptimization then PlayerListPanelContent else PlayerListPanelUnmountable)
