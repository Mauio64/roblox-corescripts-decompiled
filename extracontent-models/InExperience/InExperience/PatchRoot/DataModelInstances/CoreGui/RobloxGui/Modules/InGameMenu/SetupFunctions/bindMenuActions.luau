local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local DevConsoleMaster = require(CoreGui.RobloxGui.Modules.DevConsoleMaster)

local parent = script.Parent.Parent

local OpenSystemMenu = require(parent.Thunks.OpenSystemMenu)
local CloseMenu = require(parent.Thunks.CloseMenu)
local SetRespawning = require(parent.Actions.SetRespawning)
local SetCurrentPage = require(parent.Actions.SetCurrentPage)
local NavigateBack = require(parent.Actions.NavigateBack)
local SetCurrentZone = require(parent.Actions.SetCurrentZone)

local Pages = require(parent.Components.Pages)
local Constants = require(parent.Resources.Constants)

local function bindMenuActions(object)
	local function toggleMenuFunc(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return
		end

		local state = object:getState()
		local isMenuOpen = state.isMenuOpen

		local page = Pages.pagesByKey[state.menuPage]

		if page and page.isModal then
			object:dispatch(SetCurrentPage(Constants.defaultPageKey))
		elseif not isMenuOpen then
			object:dispatch(OpenSystemMenu(Constants.AnalyticsMenuOpenTypes.Keyboard))
		elseif state.menuPage == Constants.InitalPageKey then
			object:dispatch(OpenSystemMenu(Constants.AnalyticsMenuOpenTypes.Keyboard))
		else
			object:dispatch(CloseMenu)
		end
	end

	ContextActionService:BindCoreAction("ToggleInGameMenu", toggleMenuFunc, false, Enum.KeyCode.Escape)

	ContextActionService:BindCoreAction("ToggleDeveloperConsole", function(p, p2)
		if not (p == "ToggleDeveloperConsole" and p2 == Enum.UserInputState.Begin) then
			return
		end

		DevConsoleMaster:ToggleVisibility()
	end, false, Enum.KeyCode.F9)

	ContextActionService:BindCoreAction("TogglePerformanceStats", function(p, p2)
		if not (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
			return Enum.ContextActionResult.Pass
		end

		if not (p == "TogglePerformanceStats" and p2 == Enum.UserInputState.Begin) then
			return
		end

		UserGameSettings.PerformanceStatsVisible = not UserGameSettings.PerformanceStatsVisible
	end, false, Enum.KeyCode.F7)

	local function leaveGameFunc(_, p, _)
		local state = object:getState()

		if p ~= Enum.UserInputState.Begin or not state.isMenuOpen or Pages.pagesByKey[state.menuPage].isModal then
			return Enum.ContextActionResult.Pass
		end

		object:dispatch(SetCurrentPage(Constants.LeaveGamePromptPageKey))

		return Enum.ContextActionResult.Sink
	end

	ContextActionService:BindCoreAction("LeaveGame", leaveGameFunc, false, Enum.KeyCode.L, Enum.KeyCode.ButtonX)

	local function resetCharacterFunc(_, p, _)
		local state = object:getState()

		if
			p ~= Enum.UserInputState.Begin
			or not state.isMenuOpen
			or not state.respawn.enabled
			or Pages.pagesByKey[state.menuPage].isModal
		then
			return Enum.ContextActionResult.Pass
		end

		if state.menuPage == Constants.InitalPageKey then
			return Enum.ContextActionResult.Pass
		end

		object:dispatch(SetRespawning(true))

		return Enum.ContextActionResult.Sink
	end

	ContextActionService:BindCoreAction(
		"ResetCharacter",
		resetCharacterFunc,
		false,
		Enum.KeyCode.R,
		Enum.KeyCode.ButtonY
	)

	local function navigateBackFunc(_, p, _)
		local state = object:getState()
		local parentPage = Pages.pagesByKey[state.menuPage].parentPage
		local visibility = DevConsoleMaster:GetVisibility()

		if p ~= Enum.UserInputState.End or not (state.isMenuOpen or visibility) then
			return Enum.ContextActionResult.Pass
		end

		if visibility then
			DevConsoleMaster:SetVisibility(false)
		elseif parentPage == nil and not state.respawn.dialogOpen then
			object:dispatch(CloseMenu)
		else
			object:dispatch(NavigateBack())
		end

		return Enum.ContextActionResult.Sink
	end

	ContextActionService:BindCoreAction("NavigateBack", navigateBackFunc, false, Enum.KeyCode.ButtonB)

	local function canBumperSwitch() -- 2 equivalent calls inferred from this helper
		local state = object:getState()
		return state.menuPage ~= "Controls"
			and state.isMenuOpen
			and not state.respawn.dialogOpen
			and not (state.report.dialogOpen or state.report.reportSentOpen)
	end

	ContextActionService:BindCoreAction("LeftBumperSwitchToZone0", function(_, p, _)
		if p == Enum.UserInputState.Begin and canBumperSwitch() then -- inferred equivalent call
			object:dispatch(SetCurrentZone(0))
			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end, false, Enum.KeyCode.ButtonL1)

	ContextActionService:BindCoreAction("RightBumperSwitchToZone1", function(_, p, _)
		if p == Enum.UserInputState.Begin and canBumperSwitch() then -- inferred equivalent call
			object:dispatch(SetCurrentZone(1))
			return Enum.ContextActionResult.Sink
		end

		return Enum.ContextActionResult.Pass
	end, false, Enum.KeyCode.ButtonR1)
end

return bindMenuActions
