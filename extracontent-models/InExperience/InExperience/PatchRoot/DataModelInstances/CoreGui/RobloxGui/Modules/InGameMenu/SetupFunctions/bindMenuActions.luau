local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local DevConsoleMaster = require(CoreGui.RobloxGui.Modules.DevConsoleMaster)
local ParentParent = script.Parent.Parent
local OpenSystemMenu = require(ParentParent.Thunks.OpenSystemMenu)
local CloseMenu = require(ParentParent.Thunks.CloseMenu)
local SetRespawning = require(ParentParent.Actions.SetRespawning)
local SetCurrentPage = require(ParentParent.Actions.SetCurrentPage)
local NavigateBack = require(ParentParent.Actions.NavigateBack)
local SetCurrentZone = require(ParentParent.Actions.SetCurrentZone)
local Pages = require(ParentParent.Components.Pages)
local Constants = require(ParentParent.Resources.Constants)

local function bindMenuActions(p1) -- line: 31
	-- upvalues: Pages (copy), SetCurrentPage (copy), Constants (copy), OpenSystemMenu (copy), CloseMenu (copy), ContextActionService (copy), DevConsoleMaster (copy), UserInputService (copy), UserGameSettings (copy), SetRespawning (copy), NavigateBack (copy), SetCurrentZone (copy)
	local function toggleMenuFunc(_, p3, _) -- line: 32
		-- upvalues: p1 (copy), Pages (copy), SetCurrentPage (copy), Constants (copy), OpenSystemMenu (copy), CloseMenu (copy)
		if p3 ~= Enum.UserInputState.Begin then
			return
		end

		local v25 = p1:getState()
		local isMenuOpen = v25.isMenuOpen
		local v27 = Pages.pagesByKey[v25.menuPage]

		if v27 and v27.isModal then
			p1:dispatch(SetCurrentPage(Constants.defaultPageKey))

			return
		end

		if isMenuOpen then
			if v25.menuPage == Constants.InitalPageKey then
				p1:dispatch(OpenSystemMenu(Constants.AnalyticsMenuOpenTypes.Keyboard))

				return
			end

			p1:dispatch(CloseMenu)

			return
		end

		p1:dispatch(OpenSystemMenu(Constants.AnalyticsMenuOpenTypes.Keyboard))
	end

	ContextActionService:BindCoreAction("ToggleInGameMenu", toggleMenuFunc, false, Enum.KeyCode.Escape)
	ContextActionService:BindCoreAction("ToggleDeveloperConsole", function(p5, p6) -- line: 59
		-- upvalues: DevConsoleMaster (copy)
		if p5 ~= "ToggleDeveloperConsole" then
			return
		end

		if p6 ~= Enum.UserInputState.Begin then
			return
		end

		DevConsoleMaster:ToggleVisibility()
	end, false, Enum.KeyCode.F9)
	ContextActionService:BindCoreAction("TogglePerformanceStats", function(p7, p8) -- line: 71
		-- upvalues: UserInputService (copy), UserGameSettings (copy)
		if not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and not UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
			return Enum.ContextActionResult.Pass
		end

		if p7 ~= "TogglePerformanceStats" then
			return
		end

		if p8 ~= Enum.UserInputState.Begin then
			return
		end

		UserGameSettings.PerformanceStatsVisible = not UserGameSettings.PerformanceStatsVisible
	end, false, Enum.KeyCode.F7)

	local function leaveGameFunc(_, p10, _) -- line: 90
		-- upvalues: p1 (copy), Pages (copy), SetCurrentPage (copy), Constants (copy)
		local v35 = p1:getState()

		if p10 ~= Enum.UserInputState.Begin or not v35.isMenuOpen then
			return Enum.ContextActionResult.Pass
		end

		if Pages.pagesByKey[v35.menuPage].isModal then
			return Enum.ContextActionResult.Pass
		end

		p1:dispatch(SetCurrentPage(Constants.LeaveGamePromptPageKey))

		return Enum.ContextActionResult.Sink
	end

	ContextActionService:BindCoreAction("LeaveGame", leaveGameFunc, false, Enum.KeyCode.L, Enum.KeyCode.ButtonX)

	local function resetCharacterFunc(_, p13, _) -- line: 107
		-- upvalues: p1 (copy), Pages (copy), Constants (copy), SetRespawning (copy)
		local v39 = p1:getState()

		if p13 ~= Enum.UserInputState.Begin or not v39.isMenuOpen then
			return Enum.ContextActionResult.Pass
		end

		if not v39.respawn.enabled then
			return Enum.ContextActionResult.Pass
		end

		if Pages.pagesByKey[v39.menuPage].isModal then
			return Enum.ContextActionResult.Pass
		end

		if v39.menuPage == Constants.InitalPageKey then
			return Enum.ContextActionResult.Pass
		end

		p1:dispatch(SetRespawning(true))

		return Enum.ContextActionResult.Sink
	end

	ContextActionService:BindCoreAction("ResetCharacter", resetCharacterFunc, false, Enum.KeyCode.R, Enum.KeyCode.ButtonY)

	local function navigateBackFunc(_, p16, _) -- line: 132
		-- upvalues: p1 (copy), Pages (copy), DevConsoleMaster (copy), CloseMenu (copy), NavigateBack (copy)
		local v43 = p1:getState()
		local parentPage = Pages.pagesByKey[v43.menuPage].parentPage
		local Visibility = DevConsoleMaster:GetVisibility()

		if p16 ~= Enum.UserInputState.End or not v43.isMenuOpen and not Visibility then
			return Enum.ContextActionResult.Pass
		end

		if Visibility then
			DevConsoleMaster:SetVisibility(false)
		elseif parentPage == nil and not v43.respawn.dialogOpen then
			p1:dispatch(CloseMenu)
		else
			p1:dispatch(NavigateBack())
		end

		return Enum.ContextActionResult.Sink
	end

	ContextActionService:BindCoreAction("NavigateBack", navigateBackFunc, false, Enum.KeyCode.ButtonB)

	local function canBumperSwitch() -- line: 159
		-- upvalues: p1 (copy)
		local v46 = p1:getState()

		return v46.menuPage ~= "Controls" and (v46.isMenuOpen and (not v46.respawn.dialogOpen and (not v46.report.dialogOpen and not v46.report.reportSentOpen)))
	end

	ContextActionService:BindCoreAction("LeftBumperSwitchToZone0", function(_, p19, _) -- line: 169
		-- upvalues: p1 (copy), SetCurrentZone (copy)
		if p19 == Enum.UserInputState.Begin then
			local v50 = p1:getState()

			if v50.menuPage ~= "Controls" and (v50.isMenuOpen and (not v50.respawn.dialogOpen and (not v50.report.dialogOpen and not v50.report.reportSentOpen))) then
				p1:dispatch(SetCurrentZone(0))

				return Enum.ContextActionResult.Sink
			end
		end

		return Enum.ContextActionResult.Pass
	end, false, Enum.KeyCode.ButtonL1)
	ContextActionService:BindCoreAction("RightBumperSwitchToZone1", function(_, p22, _) -- line: 179
		-- upvalues: p1 (copy), SetCurrentZone (copy)
		if p22 == Enum.UserInputState.Begin then
			local v54 = p1:getState()

			if v54.menuPage ~= "Controls" and (v54.isMenuOpen and (not v54.respawn.dialogOpen and (not v54.report.dialogOpen and not v54.report.reportSentOpen))) then
				p1:dispatch(SetCurrentZone(1))

				return Enum.ContextActionResult.Sink
			end
		end

		return Enum.ContextActionResult.Pass
	end, false, Enum.KeyCode.ButtonR1)
end

return bindMenuActions
