local CorePackages = game:GetService("CorePackages")
require(CorePackages.Packages.Foundation)
local module = require("@luauforge/bundled/dHu")

local verticalEfficiencyExperimentation = require("@luauforge/bundled/edc").VerticalEfficiencyExperimentation
local flyoutSidePanelIXP = require("@luauforge/bundled/dHD").FlyoutSidePanelIXP

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagSubTabAddDesktopTopMargin = SharedFlags.FFlagSubTabAddDesktopTopMargin
local fIntLuaAppSubTabTopPadding = SharedFlags.FIntLuaAppSubTabTopPadding
local fFlagLuaAppMoveProfileIntoTopBar = SharedFlags.FFlagLuaAppMoveProfileIntoTopBar
local fFlagLuaAppMoveProfileIntoTopBarIXP = SharedFlags.FFlagLuaAppMoveProfileIntoTopBarIXP

local function getDiscoveryMainPageSpacing(p2, p3, p4)
	local v6 = fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled()

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
