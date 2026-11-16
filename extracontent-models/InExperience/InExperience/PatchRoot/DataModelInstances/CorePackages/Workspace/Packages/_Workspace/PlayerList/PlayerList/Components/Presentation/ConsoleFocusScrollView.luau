local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local React = require(parent2.React)
local CoreGuiCommon = require(parent2.CoreGuiCommon)
local SignalsReact = require(parent2.SignalsReact)
local Foundation = require(parent2.Foundation)
require(parent2.LeaderboardStore)

local ScrollView = Foundation.ScrollView

local PlayerListVisibilityStore = require(parent.Common.PlayerListVisibilityStore)
local PlayerContextualMenuStore = require(parent.Common.PlayerContextualMenuStore)
local TeamListView = require(parent.Components.Presentation.TeamListView)
local useGamepadStickScroll = CoreGuiCommon.Hooks.useGamepadStickScroll

local function isGamepad(): boolean -- 1 equivalent call inferred from this helper
	return UserInputService:GetLastInputType().Name:find("Gamepad") ~= nil
end

local function ConsoleFocusScrollView(props)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v = SignalsReact.useSignalState(PlayerListVisibilityStore.getEffectiveVisible)
	local v2 = SignalsReact.useSignalState(PlayerContextualMenuStore.getMenuData) ~= nil
	local enabled = v and not v2
	local allTeams = props.allTeams
	local v3

	if props.isGamepadOverride == nil then
		v3 = isGamepad() -- inferred equivalent call
	else
		v3 = props.isGamepadOverride
	end

	useGamepadStickScroll({
		actionName = "RbxPlayerListReskinGamepadStickScroll",
		scrollingFrameRef = ref2,
		enabled = enabled
	})

	local ref3 = React.useRef(Enum.OverrideMouseIconBehavior.None)
	local ref4 = React.useRef(nil)
	local ref5 = React.useRef(false)
	local ref6 = React.useRef(false)

	local function restoreHud() -- 2 equivalent calls inferred from this helper
		if not ref6.current then
			return
		end

		UserInputService.OverrideMouseIconBehavior = ref3.current
		ref3.current = Enum.OverrideMouseIconBehavior.None
		local selectedCoreObject = GuiService.SelectedCoreObject

		if selectedCoreObject and ref2.current and selectedCoreObject:IsDescendantOf(ref2.current) then
			GuiService.SelectedCoreObject = ref4.current
		end

		ref4.current = nil
		ref6.current = false
		ref5.current = false
	end

	local function releaseRosterSelection() -- 2 equivalent calls inferred from this helper
		local selectedCoreObject = GuiService.SelectedCoreObject

		if selectedCoreObject and ref2.current and selectedCoreObject:IsDescendantOf(ref2.current) then
			GuiService.SelectedCoreObject = nil
		end

		ref5.current = false
	end

	React.useEffect(function()
		if v then
			if v2 then
				releaseRosterSelection() -- inferred equivalent call
				return function() end
			end

			if not ref5.current and v3 and ref.current then
				if not ref6.current then
					ref4.current = GuiService.SelectedCoreObject
					ref3.current = UserInputService.OverrideMouseIconBehavior
					ref6.current = true
				end

				GuiService.SelectedCoreObject = ref.current
				UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
				ref5.current = true
			end

			return function()
				if PlayerListVisibilityStore.getEffectiveVisible(false) then
					if PlayerContextualMenuStore.getMenuData(false) ~= nil then
						releaseRosterSelection() -- inferred equivalent call
					end
				else
					restoreHud() -- inferred equivalent call
				end
			end
		end

		restoreHud() -- inferred equivalent call
		return function() end
	end, { v, v2, v3 })

	React.useEffect(function()
		if not (enabled and v3 and ref.current) then
			return
		end

		if ref5.current then
			GuiService.SelectedCoreObject = ref.current

			return
		end

		if not ref6.current then
			ref4.current = GuiService.SelectedCoreObject
			ref3.current = UserInputService.OverrideMouseIconBehavior
			ref6.current = true
		end

		GuiService.SelectedCoreObject = ref.current
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide
		ref5.current = true
	end, { enabled, allTeams, v3 })

	React.useEffect(function()
		if not enabled then
			return function() end
		end

		ContextActionService:BindCoreAction("RbxPlayerListReskinGamepadClose", function(_, p, _)
			if p ~= Enum.UserInputState.Begin then
				return Enum.ContextActionResult.Pass
			end

			PlayerContextualMenuStore.closeContextMenu()
			PlayerListVisibilityStore.setVisible(false)
			return Enum.ContextActionResult.Sink
		end, false, Enum.KeyCode.ButtonB)
		return function()
			ContextActionService:UnbindCoreAction("RbxPlayerListReskinGamepadClose")
		end
	end, { enabled })

	local leaderboardStore = props.leaderboardStore
	local statColumns = props.statColumns
	local statWidth = props.statWidth
	local rowHeight = props.rowHeight
	local columnHeaderHeight = props.columnHeaderHeight
	local hasNonNeutralTeams = props.hasNonNeutralTeams
	local localPlayer = props.localPlayer
	local onActivated = props.onActivated

	local v4 = {}

	for k, allTeam in pairs(allTeams) do
		if allTeam then
			table.insert(v4, k)
		end
	end

	table.sort(v4, function(a, b): boolean
		if a == "Neutral" and b ~= "Neutral" then
			return false
		end

		if b == "Neutral" and a ~= "Neutral" then
			return true
		end

		local allTeam = allTeams[a]
		local allTeam2 = allTeams[b]
		local v5 = not (allTeam and allTeam.order) and 0 or allTeam.order(false)
		local v6 = not (allTeam2 and allTeam2.order) and 0 or allTeam2.order(false)

		if v5 == v6 then
			return tostring(a) < tostring(b)
		end

		return v5 < v6
	end)
	local v5 = false
	local children = {}

	for _, v6 in ipairs(v4) do
		local allTeam = allTeams[v6]
		local v7 = allTeam and allTeam.players and next(allTeam.players.getAllData(false)) ~= nil
		local firstRowRefForward

		if not (v5 or not v7) then
			firstRowRefForward = ref
			v5 = true
		end

		children[`Team_{tostring(v6)}`] = React.createElement(TeamListView, {
			teamEntry = allTeam,
			isNeutral = v6 == "Neutral",
			hasNonNeutralTeams = hasNonNeutralTeams,
			leaderboardStore = leaderboardStore,
			statColumns = statColumns,
			statWidth = statWidth,
			rowHeight = rowHeight,
			columnHeaderHeight = columnHeaderHeight,
			onActivated = onActivated,
			localPlayer = localPlayer,
			firstRowRefForward = firstRowRefForward
		})
	end

	local clone = table.clone(props.scrollViewProps)
	clone.ref = ref2

	return React.createElement(ScrollView, clone, children)
end

return ConsoleFocusScrollView
