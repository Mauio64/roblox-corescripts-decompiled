local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local parent = script.Parent.Parent.Parent
local ClosePlayerDropDown = require(parent.Actions.ClosePlayerDropDown)
local SetPlayerListVisibility = require(parent.Actions.SetPlayerListVisibility)

local isNewInGameMenuEnabled = require(CoreGui.RobloxGui.Modules.isNewInGameMenuEnabled)

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local extended = Roact.PureComponent:extend("TenFootSideBar")

function extended:init()
	self.sideBar = nil
end

function extended.render(_): nil
	return nil
end

function extended:openSidebar(p)
	local v = not RunService:IsStudio() and p ~= Players.LocalPlayer

	if not v then
		self.props.closeSideBar()
		return
	end

	local selectedCoreObject = GuiService.SelectedCoreObject
	local screenManager = RobloxGui.Modules:FindFirstChild("ScreenManager") or RobloxGui.Modules.Shell.ScreenManager
	local module = require(screenManager)
	local localizedStrings = RobloxGui.Modules:FindFirstChild("LocalizedStrings")
		or RobloxGui.Modules.Shell.LocalizedStrings
	local module2 = require(localizedStrings)

	if not self.sideBar then
		local sideBar = RobloxGui.Modules:FindFirstChild("SideBar") or RobloxGui.Modules.Shell.SideBar
		local module3 = require(sideBar)
		self.sideBar = module3()
	end

	self.sideBar:RemoveAllItems()

	if v then
		local locStringUA = module2:LocStringUA("Xbox.Old.ReportPlayer")
		self.sideBar:AddItem(locStringUA, function()
			self.props.closePlayerList()
			GuiService.SelectedCoreObject = nil

			if isNewInGameMenuEnabled() then
				local InGameMenuInit = require(RobloxGui.Modules.InGameMenuInit)
				InGameMenuInit.openReportDialog(p, self.__componentName)
			else
				local ReportAbuseMenuContainerPage = require(RobloxGui.Modules.Settings.Pages.ReportAbuseMenuContainerPage)
				ReportAbuseMenuContainerPage:ReportPlayer(p, self.__componentName)
			end
		end)
	end

	local closedConnection = nil

	closedConnection = self.sideBar.Closed:connect(function()
		closedConnection:disconnect()
		self.props.closeSideBar()

		if self.props.playerListVisible then
			if selectedCoreObject and selectedCoreObject.Parent then
				GuiService.SelectedCoreObject = selectedCoreObject
			else
				self.props.closePlayerList()
				self.props.openPlayerList()
			end
		end
	end)

	module:OpenScreen(self.sideBar, false)
end

function extended:didMount()
	if self.props.sideBarVisible then
		self:openSidebar(self.props.selectedPlayer)
	end
end

function extended:didUpdate(p)
	if self.props.sideBarVisible and self.props.sideBarVisible ~= p.sideBarVisible then
		self:openSidebar(self.props.selectedPlayer)
	end
end

local function mapStateToProps(p)
	return {
		selectedPlayer = p.playerDropDown.selectedPlayer,
		sideBarVisible = p.displayOptions.isTenFootInterface and p.playerDropDown.isVisible,
		playerListVisible = p.displayOptions.isVisible
	}
end

local function mapDispatchToProps(callback)
	return {
		closeSideBar = function()
			return callback(ClosePlayerDropDown())
		end,
		closePlayerList = function()
			return callback(SetPlayerListVisibility(false))
		end,
		openPlayerList = function()
			return callback(SetPlayerListVisibility(true))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(extended)
