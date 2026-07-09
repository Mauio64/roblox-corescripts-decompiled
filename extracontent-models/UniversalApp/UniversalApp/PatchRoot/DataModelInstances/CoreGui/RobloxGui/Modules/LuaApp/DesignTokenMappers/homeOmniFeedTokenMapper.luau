local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.RobloxAppHooks)
require(CorePackages.Workspace.Packages.Style)

local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode

require(CorePackages.Packages.ReactOtter)

local VerticalEfficiencyExperimentation = require(CorePackages.Workspace.Packages.DiscoveryUtils).VerticalEfficiencyExperimentation
local AppNavBar = require(CorePackages.Workspace.Packages.AppNavBar)
local FFlagLuaAppMoveProfileIntoTopBar = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppMoveProfileIntoTopBar
local FFlagLuaAppMoveProfileIntoTopBarIXP = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppMoveProfileIntoTopBarIXP
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP
local v11 = game:DefineFastInt("LuaAppSubTabTopPadding", 0)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole

local function makeHomeOmniFeedTokens(p1, p2) -- line: 33
	-- upvalues: FFlagAppIaHomeSubTab (copy), FlyoutSidePanelIXP (copy), v11 (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), FFlagLuaAppMoveProfileIntoTopBar (copy), FFlagLuaAppMoveProfileIntoTopBarIXP (copy), VerticalEfficiencyExperimentation (copy), UiMode (copy), FFlagEnableLeftNavOnConsole (copy)
	local Size_600 = p2.Size.Size_600
	local Size_600_2 = p2.Size.Size_600
	local Size_1200 = p2.Size.Size_1200

	if FFlagAppIaHomeSubTab and FlyoutSidePanelIXP.isHomeSubTabEnabled() then
		if v11 > 0 then
			Size_600_2 = v11
		end
	elseif FFlagAppIaScrollAway and AppNavBar.getScrollAwayEnabled() then
		Size_600_2 = p2.Size.Size_200
	elseif FFlagLuaAppMoveProfileIntoTopBar and (not FFlagLuaAppMoveProfileIntoTopBarIXP or VerticalEfficiencyExperimentation.getIsProfileMovedToTopBar()) then
		Size_600_2 = p2.Size.Size_300
	end

	local t1 = {
		layoutPadding = 26,
		topMargin = 0,
		bottomMargin = 26
	}
	local t2 = {
		dampingRatio = 1,
		frequency = 3
	}

	if p1.uiMode == UiMode.TenFoot and not FFlagEnableLeftNavOnConsole then
		Size_600 = p2.Size.Size_800
		Size_600_2 = p2.Size.Size_600 + p2.Size.Size_400
		Size_1200 = p2.Size.Size_800
		t1.layoutPadding = Size_600
		t1.topMargin = Size_600_2
		t1.bottomMargin = Size_1200
	end

	return {
		trailingWhitespace = 1000,
		scrollBarThickness = 0,
		getLayoutSpacing = function(b1: boolean?) -- line: 78
			-- upvalues: t1 (copy), Size_600 (ref), Size_600_2 (ref), Size_1200 (ref)
			if b1 then
				return t1
			end

			return {
				layoutPadding = Size_600,
				topMargin = Size_600_2,
				bottomMargin = Size_1200
			}
		end,
		animationConfig = t2
	}
end

return makeHomeOmniFeedTokens
