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
local computeStatColumns = require(ParentParent.Common.computeStatColumns)
local PlayerListVisibilityStore = require(ParentParent.Common.PlayerListVisibilityStore)
local PlayerContextualMenuStore = require(ParentParent.Common.PlayerContextualMenuStore)
local openContextMenu = PlayerContextualMenuStore.openContextMenu
local PanelHeader = require(ParentParent.Components.Presentation.PanelHeader)
local ColumnHeaderRow = require(ParentParent.Components.Presentation.ColumnHeaderRow)
local TeamListView = require(ParentParent.Components.Presentation.TeamListView)
local v18 = createSignalMap()
local v19 = createSignalMap()

local function PlayerListPanel(t1: {[any]: any}) -- line: 38
	-- upvalues: useLeaderboardStore (copy), v18 (copy), v19 (copy), SignalsReact (copy), usePanelLayout (copy), PlayerListVisibilityStore (copy), React (copy), PlayerContextualMenuStore (copy), computeStatColumns (copy), TeamListView (copy), openContextMenu (copy), View (copy), PanelHeader (copy), Foundation (copy), ColumnHeaderRow (copy), ScrollView (copy)
	local v22 = t1.isSmallTouchDevice == true
	local title = t1.title
	local v24 = useLeaderboardStore()
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local v26 = if not v24 then v18 else v24.getTeamList()
	local v27 = if not v24 then v19 else v24.getGameStatsList()
	local v28 = SignalsReact.useSignalState(v26.getAllData)
	local v29 = SignalsReact.useSignalState(v27.getAllData)
	local v30 = v27.getCount(false)
	local v31 = usePanelLayout(v22, v30)
	local v32 = SignalsReact.useSignalBinding(PlayerListVisibilityStore.getEffectiveVisible)
	local v33 = React.useCallback(function() -- line: 63
		-- upvalues: PlayerContextualMenuStore (copy), PlayerListVisibilityStore (copy)
		PlayerContextualMenuStore.closeContextMenu()
		PlayerListVisibilityStore.setVisible(false)
	end, {})
	local maxStatColumns = v31.maxStatColumns
	local v35 = React.useMemo(function() -- line: 75
		-- upvalues: computeStatColumns (copy), v27 (copy), maxStatColumns (copy)
		return computeStatColumns(v27, maxStatColumns)
	end, {
		v29,
		v27,
		maxStatColumns
	})
	local t2 = {}

	if v24 then
		local v37 = false

		for k, v in pairs(v28) do
			if v and k ~= "Neutral" then
				v37 = true

				break
			end
		end

		for k, v in pairs(v28) do
			if v then
				t2[`Team_{ tostring(k) }`] = React.createElement(TeamListView, {
					teamEntry = v,
					isNeutral = k == "Neutral",
					hasNonNeutralTeams = v37,
					leaderboardStore = v24,
					statColumns = v35,
					statWidth = v31.statWidth,
					rowHeight = v31.rowHeight,
					columnHeaderHeight = v31.columnHeaderHeight,
					onActivated = openContextMenu,
					localPlayer = LocalPlayer
				})
			end
		end
	end

	return React.createElement(View, {
		tag = "col radius-medium bg-over-media-200",
		Size = UDim2.fromOffset(v31.panelWidth, v31.panelHeight),
		Visible = v32
	}, {
		Header = React.createElement(PanelHeader, {
			layoutOrder = 1,
			onClose = v33,
			height = v31.headerHeight,
			title = title
		}),
		HeaderDivider = React.createElement(Foundation.Divider, {
			LayoutOrder = 2
		}),
		LeaderboardBody = React.createElement(View, {
			LayoutOrder = 3,
			tag = "col fill size-full-0"
		}, {
			ColumnHeaders = React.createElement(ColumnHeaderRow, {
				layoutOrder = 1,
				statColumns = v35,
				statWidth = v31.statWidth,
				headerHeight = v31.columnHeaderHeight
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
		})
	})
end

return React.memo(PlayerListPanel)
