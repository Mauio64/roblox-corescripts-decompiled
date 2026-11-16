local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux

local parent = script.Parent.Parent
local InGameMenuPolicy = require(parent.InGameMenuPolicy)

local ViewportOverlay = require(script.Parent.ViewportOverlay)
local SideNavigation = require(script.Parent.SideNavigation)
local LeaveGameDialog = require(script.Parent.LeaveGameDialog)
local PageContainer = require(script.Parent.PageContainer)
local RespawnDialog = require(script.Parent.RespawnDialog)
local ReportDialog = require(script.Parent.ReportPage.ReportDialog)
local ReportSentDialog = require(script.Parent.ReportPage.ReportSentDialog)
local ControlLayoutSetter = require(script.Parent.ControlsPage.ControlLayoutSetter)
local Connection = require(script.Parent.Connection)
local EducationalPopup = require(script.Parent.EducationalPopup)
local MenuIconTooltip = require(script.Parent.MenuIconTooltip)
local FullscreenTitleBar = require(script.Parent.FullscreenTitleBar)

local flags = parent.Flags
local FFlagLuaMenuPerfImprovements = require(flags.FFlagLuaMenuPerfImprovements)

local Constants = require(parent.Resources.Constants)

local function App(props)
	local fullscreenTitleBar

	if props.enableFullscreenTitleBar then
		fullscreenTitleBar = Roact.createElement(FullscreenTitleBar, {
			displayOrder = Constants.DisplayOrder.FullscreenTitleBar
		})
	end

	if FFlagLuaMenuPerfImprovements then
		return Roact.createFragment({
			Content = props.isMenuOpen and Roact.createFragment({
				Overlay = Roact.createElement(ViewportOverlay),
				SideNavigation = Roact.createElement(SideNavigation),
				LeaveGameDialog = Roact.createElement(LeaveGameDialog),
				PageContainer = Roact.createElement(PageContainer),
				RespawnDialog = Roact.createElement(RespawnDialog),
				ReportDialog = Roact.createElement(ReportDialog),
				ReportSentDialog = Roact.createElement(ReportSentDialog),
				ControlLayoutSetter = Roact.createElement(ControlLayoutSetter)
			}) or nil,
			Connection = Roact.createElement(Connection),
			EducationalPopup = props.isEducationalPopupEnabled and Roact.createElement(EducationalPopup) or nil,
			MenuIconTooltip = props.isEducationalPopupEnabled and Roact.createElement(MenuIconTooltip) or nil,
			FullscreenTitleBar = fullscreenTitleBar
		})
	end

	return Roact.createFragment({
		Overlay = Roact.createElement(ViewportOverlay),
		SideNavigation = Roact.createElement(SideNavigation),
		LeaveGameDialog = Roact.createElement(LeaveGameDialog),
		PageContainer = Roact.createElement(PageContainer),
		RespawnDialog = Roact.createElement(RespawnDialog),
		ReportDialog = Roact.createElement(ReportDialog),
		ReportSentDialog = Roact.createElement(ReportSentDialog),
		ControlLayoutSetter = Roact.createElement(ControlLayoutSetter),
		Connection = Roact.createElement(Connection),
		EducationalPopup = props.isEducationalPopupEnabled and Roact.createElement(EducationalPopup) or nil,
		MenuIconTooltip = props.isEducationalPopupEnabled and Roact.createElement(MenuIconTooltip) or nil,
		FullscreenTitleBar = fullscreenTitleBar
	})
end

local v = InGameMenuPolicy.connect(function(p, _)
	return {
		enableFullscreenTitleBar = p.enableFullscreenTitleBar(),
		isEducationalPopupEnabled = p.enableEducationalPopup()
	}
end)(App)

local function mapStateToProps(p, _)
	return { isMenuOpen = p.isMenuOpen }
end

return RoactRodux.connect(mapStateToProps, nil)(v)
