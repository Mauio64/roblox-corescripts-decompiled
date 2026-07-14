local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local ParentParent = script.Parent.Parent.Parent
local ClosePlayerDropDown = require(ParentParent.Actions.ClosePlayerDropDown)
local SetPlayerListVisibility = require(ParentParent.Actions.SetPlayerListVisibility)
local isNewInGameMenuEnabled = require(CoreGui.RobloxGui.Modules.isNewInGameMenuEnabled)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local v13 = Roact.PureComponent:extend("TenFootSideBar")

function v13.init(p1) -- line: 22
	p1.sideBar = nil
end
function v13.render(_) -- line: 26
	return nil
end
function v13.openSidebar(p3, p4) -- line: 30
	-- upvalues: RunService (copy), Players (copy), GuiService (copy), RobloxGui (copy), isNewInGameMenuEnabled (copy)
	local v20 = not RunService:IsStudio() and p4 ~= Players.LocalPlayer

	if not v20 then
		p3.props.closeSideBar()

		return
	end

	local SelectedCoreObject = GuiService.SelectedCoreObject
	local v22 = RobloxGui.Modules:FindFirstChild("ScreenManager") or RobloxGui.Modules.Shell.ScreenManager
	local lib = require(v22)
	local v24 = RobloxGui.Modules:FindFirstChild("LocalizedStrings") or RobloxGui.Modules.Shell.LocalizedStrings
	local lib2 = require(v24)

	if not p3.sideBar then
		local v26 = RobloxGui.Modules:FindFirstChild("SideBar") or RobloxGui.Modules.Shell.SideBar

		p3.sideBar = require(v26)()
	end

	p3.sideBar:RemoveAllItems()

	if v20 then
		local v27 = lib2:LocStringUA("Xbox.Old.ReportPlayer")

		p3.sideBar:AddItem(v27, function() -- line: 58
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

	local u28 = nil

	u28 = p3.sideBar.Closed:connect(function() -- line: 75
		-- upvalues: u28 (ref), p3 (copy), SelectedCoreObject (copy), GuiService (copy)
		u28:disconnect()
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
function v13.didMount(p5) -- line: 92
	if p5.props.sideBarVisible then
		p5:openSidebar(p5.props.selectedPlayer)
	end
end
function v13.didUpdate(p6, p7) -- line: 98
	if p6.props.sideBarVisible and p6.props.sideBarVisible ~= p7.sideBarVisible then
		p6:openSidebar(p6.props.selectedPlayer)
	end
end

local function mapStateToProps(p8) -- line: 104
	return {
		selectedPlayer = p8.playerDropDown.selectedPlayer,
		sideBarVisible = p8.displayOptions.isTenFootInterface and p8.playerDropDown.isVisible,
		playerListVisible = p8.displayOptions.isVisible
	}
end
local function mapDispatchToProps(p9) -- line: 112
	-- upvalues: ClosePlayerDropDown (copy), SetPlayerListVisibility (copy)
	return {
		closeSideBar = function() -- line: 114
			-- upvalues: p9 (copy), ClosePlayerDropDown (copy)
			return p9(ClosePlayerDropDown())
		end,
		closePlayerList = function() -- line: 118
			-- upvalues: p9 (copy), SetPlayerListVisibility (copy)
			return p9(SetPlayerListVisibility(false))
		end,
		openPlayerList = function() -- line: 122
			-- upvalues: p9 (copy), SetPlayerListVisibility (copy)
			return p9(SetPlayerListVisibility(true))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(v13)
