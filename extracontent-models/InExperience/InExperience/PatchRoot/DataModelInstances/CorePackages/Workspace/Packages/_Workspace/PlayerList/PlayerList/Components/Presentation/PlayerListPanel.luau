local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SignalsReact = require(ParentParentParent.SignalsReact)
local Foundation = require(ParentParentParent.Foundation)
local createSignalMap = require(ParentParentParent.CoreScriptsRoactCommon).Utilities.createSignalMap

require(ParentParentParent.LeaderboardStore)

local View = Foundation.View
local ScrollView = Foundation.ScrollView
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
local v22 = createSignalMap()
local v23 = createSignalMap()

local function PlayerListPanel(t1: {[any]: any}) -- line: 53
	-- upvalues: useLeaderboardStore (copy), v22 (copy), v23 (copy), SignalsReact (copy), FFlagPlayerListTwoTabs (copy), usePlatformLeaderboard (copy), FallbackSignals (copy), usePanelLayout (copy), PlayerListVisibilityStore (copy), React (copy), PlayerContextualMenuStore (copy), computeStatColumns (copy), TeamListView (copy), openContextMenu (copy), ColumnHeaderRow (copy), ScrollView (copy), PanelHeader (copy), Foundation (copy), View (copy), TabbedLeaderboardBody (copy)
	local v26 = t1.isSmallTouchDevice == true
	local title = t1.title
	local platformLeaderboardOverride = t1.platformLeaderboardOverride
	local v29 = useLeaderboardStore()
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local v31 = if not v29 then v22 else v29.getTeamList()
	local v32 = if not v29 then v23 else v29.getGameStatsList()
	local v33 = SignalsReact.useSignalState(v31.getAllData)
	local v34 = SignalsReact.useSignalState(v32.getAllData)
	local v35 = v32.getCount(false)
	local v36 = if not FFlagPlayerListTwoTabs then nil else platformLeaderboardOverride or usePlatformLeaderboard()
	local v37 = if not v36 then FallbackSignals.getHasActiveLeaderboard else v36.getHasActiveLeaderboard
	local v38 = not not FFlagPlayerListTwoTabs and SignalsReact.useSignalState(v37)
	local v39 = usePanelLayout(v26, v35, v38)
	local v40 = SignalsReact.useSignalBinding(PlayerListVisibilityStore.getEffectiveVisible)
	local v41 = React.useCallback(function() -- line: 90
		-- upvalues: PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy)
		PlayerContextualMenuStore.closeContextMenu()
		PlayerListVisibilityStore.setVisible(false)
	end, {})
	local maxStatColumns = v39.maxStatColumns
	local v43 = React.useMemo(function() -- line: 102
		-- upvalues: computeStatColumns (copy), v32 (copy), maxStatColumns (copy)
		return computeStatColumns(v32, maxStatColumns)
	end, {
		v34,
		v32,
		maxStatColumns
	})
	local t2 = {}

	if v29 then
		local v45 = false

		for k, v in pairs(v33) do
			if v and k ~= "Neutral" then
				v45 = true

				break
			end
		end

		for k, v in pairs(v33) do
			if v then
				t2[`Team_{ tostring(k) }`] = React.createElement(TeamListView, {
					teamEntry = v,
					isNeutral = k == "Neutral",
					hasNonNeutralTeams = v45,
					leaderboardStore = v29,
					statColumns = v43,
					statWidth = v39.statWidth,
					rowHeight = v39.rowHeight,
					columnHeaderHeight = v39.columnHeaderHeight,
					onActivated = openContextMenu,
					localPlayer = LocalPlayer
				})
			end
		end
	end

	local t3 = {
		ColumnHeaders = React.createElement(ColumnHeaderRow, {
			layoutOrder = 1,
			statColumns = v43,
			statWidth = v39.statWidth,
			headerHeight = v39.columnHeaderHeight
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
		Size = UDim2.fromOffset(v39.panelWidth, v39.panelHeight),
		Visible = v40
	}
	local v52 = React.createElement(PanelHeader, {
		layoutOrder = 1,
		onClose = v41,
		height = v39.headerHeight,
		title = title
	})
	local v53 = React.createElement(Foundation.Divider, {
		LayoutOrder = 2
	})

	if FFlagPlayerListTwoTabs then
		local v54 = React.createElement(View, {
			LayoutOrder = 4,
			tag = "col fill size-full-0"
		}, t3)

		return React.createElement(TabbedLeaderboardBody, {
			serverBody = v54,
			panelHeader = v52,
			panelDivider = v53,
			panelProps = t4
		})
	end

	return React.createElement(View, t4, {
		Header = v52,
		HeaderDivider = v53,
		LeaderboardBody = React.createElement(View, {
			LayoutOrder = 3,
			tag = "col fill size-full-0"
		}, t3)
	})
end

return React.memo(PlayerListPanel)
