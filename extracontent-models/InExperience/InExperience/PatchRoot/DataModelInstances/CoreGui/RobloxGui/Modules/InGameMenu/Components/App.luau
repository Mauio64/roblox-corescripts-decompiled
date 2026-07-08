local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local ParentParent = script.Parent.Parent
local InGameMenuPolicy = require(ParentParent.InGameMenuPolicy)
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
local Flags = ParentParent.Flags
local FFlagLuaMenuPerfImprovements = require(Flags.FFlagLuaMenuPerfImprovements)
local Constants = require(ParentParent.Resources.Constants)

local function App(p1) -- line: 32
	-- upvalues: Roact (copy), FullscreenTitleBar (copy), Constants (copy), FFlagLuaMenuPerfImprovements (copy), ViewportOverlay (copy), SideNavigation (copy), LeaveGameDialog (copy), PageContainer (copy), RespawnDialog (copy), ReportDialog (copy), ReportSentDialog (copy), ControlLayoutSetter (copy), Connection (copy), EducationalPopup (copy), MenuIconTooltip (copy)
	local v26 = nil

	if p1.enableFullscreenTitleBar then
		v26 = Roact.createElement(FullscreenTitleBar, {
			displayOrder = Constants.DisplayOrder.FullscreenTitleBar
		})
	end

	if FFlagLuaMenuPerfImprovements then
		return Roact.createFragment({
			Content = p1.isMenuOpen and Roact.createFragment({
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
			EducationalPopup = p1.isEducationalPopupEnabled and Roact.createElement(EducationalPopup) or nil,
			MenuIconTooltip = p1.isEducationalPopupEnabled and Roact.createElement(MenuIconTooltip) or nil,
			FullscreenTitleBar = v26
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
		EducationalPopup = p1.isEducationalPopupEnabled and Roact.createElement(EducationalPopup) or nil,
		MenuIconTooltip = p1.isEducationalPopupEnabled and Roact.createElement(MenuIconTooltip) or nil,
		FullscreenTitleBar = v26
	})
end

local v23 = InGameMenuPolicy.connect(function(p2, _) -- line: 75
	return {
		enableFullscreenTitleBar = p2.enableFullscreenTitleBar(),
		isEducationalPopupEnabled = p2.enableEducationalPopup()
	}
end)(App)

local function mapStateToProps(p4, _) -- line: 82
	return {
		isMenuOpen = p4.isMenuOpen
	}
end

return RoactRodux.connect(mapStateToProps, nil)(v23)
