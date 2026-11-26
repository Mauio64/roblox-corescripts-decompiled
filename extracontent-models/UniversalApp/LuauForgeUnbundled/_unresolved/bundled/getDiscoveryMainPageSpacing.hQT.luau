local CorePackages = game:GetService("CorePackages")
require(CorePackages.Packages.Foundation)
local module = require("@luauforge/bundled/dKz")

local verticalEfficiencyExperimentation = require("@luauforge/bundled/egz").VerticalEfficiencyExperimentation
local flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagSubTabAddDesktopTopMargin = SharedFlags.FFlagSubTabAddDesktopTopMargin
local fIntLuaAppSubTabTopPadding = SharedFlags.FIntLuaAppSubTabTopPadding
local fFlagLuaAppMoveProfileIntoTopBar = SharedFlags.FFlagLuaAppMoveProfileIntoTopBar
local fFlagLuaAppMoveProfileIntoTopBarIXP = SharedFlags.FFlagLuaAppMoveProfileIntoTopBarIXP
local fFlagEnableIsChartsInSubTab = SharedFlags.FFlagEnableIsChartsInSubTab

local function getDiscoveryMainPageSpacing(p2, p3, p4, p5)
	local v6 = fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled()

	if fFlagEnableIsChartsInSubTab and p5 ~= nil then
		v6 = p5
	end

	local v7 = fFlagLuaAppMoveProfileIntoTopBar
		and (not fFlagLuaAppMoveProfileIntoTopBarIXP or verticalEfficiencyExperimentation.getIsProfileMovedToTopBar())

	local v8 = if fIntLuaAppSubTabTopPadding > 0 then fIntLuaAppSubTabTopPadding else p2.Size.Size_600

	if p4 and not p3 then
		v8 = not (fFlagSubTabAddDesktopTopMargin and v6) and 0 or v8
	elseif not v6 then
		if fFlagAppIaScrollAway and module.getScrollAwayEnabled() then
			v8 = p2.Size.Size_200
		else
			v8 = if v7 then p2.Size.Size_300 else p2.Size.Size_600
		end
	end

	return { topMargin = v8 }
end

return getDiscoveryMainPageSpacing
