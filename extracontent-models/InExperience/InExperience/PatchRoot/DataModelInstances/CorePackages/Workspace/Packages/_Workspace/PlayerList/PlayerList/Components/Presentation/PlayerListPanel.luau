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
local v10 = if not FFlagPlayerListReskinPreferredTransparency then nil else require(ParentParent.Components.Presentation.PreferredTransparencyView)
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
local TabbedLeaderboardBody = require(ParentParent.Components.Presentation.TabbedLeaderboardBody)
local FFlagPlayerListTwoTabs = require(ParentParent.Flags.FFlagPlayerListTwoTabs)
local FallbackSignals = require(ParentParent.Common.FallbackSignals)
local v24 = createSignalMap()
local v25 = createSignalMap()

local function PlayerListPanel(t1: {[any]: any}) -- line: 59
	-- upvalues: useLeaderboardStore (copy), v24 (copy), v25 (copy), SignalsReact (copy), FFlagPlayerListTwoTabs (copy), usePlatformLeaderboard (copy), FallbackSignals (copy), usePanelLayout (copy), PlayerListVisibilityStore (copy), React (copy), PlayerContextualMenuStore (copy), computeStatColumns (copy), TeamListView (copy), openContextMenu (copy), ColumnHeaderRow (copy), ScrollView (copy), PanelHeader (copy), Foundation (copy), View (copy), FFlagPlayerListReskinPreferredTransparency (copy), v10 (copy), TabbedLeaderboardBody (copy)
	local v28 = t1.isSmallTouchDevice == true
	local title = t1.title
	local platformLeaderboardOverride = t1.platformLeaderboardOverride
	local v31 = useLeaderboardStore()
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local v33 = if not v31 then v24 else v31.getTeamList()
	local v34 = if not v31 then v25 else v31.getGameStatsList()
	local v35 = SignalsReact.useSignalState(v33.getAllData)
	local v36 = SignalsReact.useSignalState(v34.getAllData)
	local v37 = v34.getCount(false)
	local v38 = if not FFlagPlayerListTwoTabs then nil else platformLeaderboardOverride or usePlatformLeaderboard()
	local v39 = if not v38 then FallbackSignals.getHasActiveLeaderboard else v38.getHasActiveLeaderboard
	local v40 = not not FFlagPlayerListTwoTabs and SignalsReact.useSignalState(v39)
	local v41 = usePanelLayout(v28, v37, v40)
	local v42 = SignalsReact.useSignalBinding(PlayerListVisibilityStore.getEffectiveVisible)
	local v43 = React.useCallback(function() -- line: 96
		-- upvalues: PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy)
		PlayerContextualMenuStore.closeContextMenu()
		PlayerListVisibilityStore.setVisible(false)
	end, {})
	local maxStatColumns = v41.maxStatColumns
	local v45 = React.useMemo(function() -- line: 108
		-- upvalues: computeStatColumns (copy), v34 (copy), maxStatColumns (copy)
		return computeStatColumns(v34, maxStatColumns)
	end, {
		v36,
		v34,
		maxStatColumns
	})
	local t2 = {}

	if v31 then
		local v47 = false

		for k, v in pairs(v35) do
			if v and k ~= "Neutral" then
				v47 = true

				break
			end
		end

		for k, v in pairs(v35) do
			if v then
				t2[`Team_{ tostring(k) }`] = React.createElement(TeamListView, {
					teamEntry = v,
					isNeutral = k == "Neutral",
					hasNonNeutralTeams = v47,
					leaderboardStore = v31,
					statColumns = v45,
					statWidth = v41.statWidth,
					rowHeight = v41.rowHeight,
					columnHeaderHeight = v41.columnHeaderHeight,
					onActivated = openContextMenu,
					localPlayer = LocalPlayer
				})
			end
		end
	end

	local t3 = {
		ColumnHeaders = React.createElement(ColumnHeaderRow, {
			layoutOrder = 1,
			statColumns = v45,
			statWidth = v41.statWidth,
			headerHeight = v41.columnHeaderHeight
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
	local t4 = {
		tag = "col radius-medium bg-over-media-200",
		Size = UDim2.fromOffset(v41.panelWidth, v41.panelHeight),
		Visible = v42
	}
	local v54 = React.createElement(PanelHeader, {
		layoutOrder = 1,
		onClose = v43,
		height = v41.headerHeight,
		title = title
	})
	local v55 = React.createElement(Foundation.Divider, {
		LayoutOrder = 2
	})

	if FFlagPlayerListTwoTabs then
		local v56 = React.createElement(View, {
			LayoutOrder = 4,
			tag = "col fill size-full-0"
		}, t3)

		if FFlagPlayerListReskinPreferredTransparency then
			return React.createElement(v10, {
				size = UDim2.fromOffset(v41.panelWidth, v41.panelHeight),
				visible = v42
			}, {
				TabbedBody = React.createElement(TabbedLeaderboardBody, {
					serverBody = v56,
					panelHeader = v54,
					panelDivider = v55,
					panelProps = t4
				})
			})
		end

		return React.createElement(TabbedLeaderboardBody, {
			serverBody = v56,
			panelHeader = v54,
			panelDivider = v55,
			panelProps = t4
		})
	end

	if FFlagPlayerListReskinPreferredTransparency then
		return React.createElement(v10, {
			size = UDim2.fromOffset(v41.panelWidth, v41.panelHeight),
			visible = v42
		}, {
			Header = v54,
			HeaderDivider = v55,
			LeaderboardBody = React.createElement(View, {
				LayoutOrder = 3,
				tag = "col fill size-full-0"
			}, t3)
		})
	end

	return React.createElement(View, t4, {
		Header = v54,
		HeaderDivider = v55,
		LeaderboardBody = React.createElement(View, {
			LayoutOrder = 3,
			tag = "col fill size-full-0"
		}, t3)
	})
end

return React.memo(PlayerListPanel)
