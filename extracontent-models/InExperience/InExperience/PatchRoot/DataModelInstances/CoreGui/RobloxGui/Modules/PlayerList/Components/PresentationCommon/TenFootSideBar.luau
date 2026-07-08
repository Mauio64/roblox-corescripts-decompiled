local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local FFlagAppShellMigrateLocales = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppShellMigrateLocales
local ParentParent = script.Parent.Parent.Parent
local ClosePlayerDropDown = require(ParentParent.Actions.ClosePlayerDropDown)
local SetPlayerListVisibility = require(ParentParent.Actions.SetPlayerListVisibility)
local isNewInGameMenuEnabled = require(CoreGui.RobloxGui.Modules.isNewInGameMenuEnabled)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local v14 = Roact.PureComponent:extend("TenFootSideBar")

function v14.init(p1) -- line: 23
	p1.sideBar = nil
end
function v14.render(_) -- line: 27
	return nil
end
function v14.openSidebar(p3, p4) -- line: 31
	-- upvalues: RunService (copy), Players (copy), GuiService (copy), RobloxGui (copy), FFlagAppShellMigrateLocales (copy), isNewInGameMenuEnabled (copy)
	local v21 = not RunService:IsStudio() and p4 ~= Players.LocalPlayer

	if not v21 then
		p3.props.closeSideBar()

		return
	end

	local SelectedCoreObject = GuiService.SelectedCoreObject
	local v23 = RobloxGui.Modules:FindFirstChild("ScreenManager") or RobloxGui.Modules.Shell.ScreenManager
	local lib = require(v23)
	local v25 = RobloxGui.Modules:FindFirstChild("LocalizedStrings") or RobloxGui.Modules.Shell.LocalizedStrings
	local lib2 = require(v25)

	if not p3.sideBar then
		local v27 = RobloxGui.Modules:FindFirstChild("SideBar") or RobloxGui.Modules.Shell.SideBar

		p3.sideBar = require(v27)()
	end

	p3.sideBar:RemoveAllItems()

	if v21 then
		local v28 = if not FFlagAppShellMigrateLocales then lib2:LocalizedString("ReportPlayer") else lib2:LocStringUA("Xbox.Old.ReportPlayer")

		p3.sideBar:AddItem(v28, function() -- line: 61
			-- upvalues: p3 (copy), GuiService (copy), isNewInGameMenuEnabled (copy), RobloxGui (copy), p4 (copy)
			p3.props.closePlayerList()
			GuiService.SelectedCoreObject = nil

			if isNewInGameMenuEnabled() then
				require(RobloxGui.Modules.InGameMenuInit).openReportDialog(p4, p3.__componentName)

				return
			end

			require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuNewContainerPage):ReportPlayer(p4, p3.__componentName)
		end)
	end

	local u29 = nil

	u29 = p3.sideBar.Closed:connect(function() -- line: 78
		-- upvalues: u29 (ref), p3 (copy), SelectedCoreObject (copy), GuiService (copy)
		u29:disconnect()
		p3.props.closeSideBar()

		if p3.props.playerListVisible then
			if SelectedCoreObject and SelectedCoreObject.Parent then
				GuiService.SelectedCoreObject = SelectedCoreObject

				return
			end

			p3.props.closePlayerList()
			p3.props.openPlayerList()
		end
	end)
	lib:OpenScreen(p3.sideBar, false)
end
function v14.didMount(p5) -- line: 95
	if p5.props.sideBarVisible then
		p5:openSidebar(p5.props.selectedPlayer)
	end
end
function v14.didUpdate(p6, p7) -- line: 101
	if p6.props.sideBarVisible and p6.props.sideBarVisible ~= p7.sideBarVisible then
		p6:openSidebar(p6.props.selectedPlayer)
	end
end

local function mapStateToProps(p8) -- line: 107
	return {
		selectedPlayer = p8.playerDropDown.selectedPlayer,
		sideBarVisible = p8.displayOptions.isTenFootInterface and p8.playerDropDown.isVisible,
		playerListVisible = p8.displayOptions.isVisible
	}
end
local function mapDispatchToProps(p9) -- line: 115
	-- upvalues: ClosePlayerDropDown (copy), SetPlayerListVisibility (copy)
	return {
		closeSideBar = function() -- line: 117
			-- upvalues: p9 (copy), ClosePlayerDropDown (copy)
			return p9(ClosePlayerDropDown())
		end,
		closePlayerList = function() -- line: 121
			-- upvalues: p9 (copy), SetPlayerListVisibility (copy)
			return p9(SetPlayerListVisibility(false))
		end,
		openPlayerList = function() -- line: 125
			-- upvalues: p9 (copy), SetPlayerListVisibility (copy)
			return p9(SetPlayerListVisibility(true))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v14)
