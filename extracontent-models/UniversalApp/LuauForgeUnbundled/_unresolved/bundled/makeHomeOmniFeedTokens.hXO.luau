local CorePackages = game:GetService("CorePackages")
require("@game/CorePackages/Workspace/Packages/RobloxAppHooks")
require("@game/CorePackages/Workspace/Packages/Style")
require(CorePackages.Packages.ReactOtter)

local verticalEfficiencyExperimentation = require("@luauforge/bundled/edc").VerticalEfficiencyExperimentation
local module = require("@luauforge/bundled/dHu")

local fFlagLuaAppMoveProfileIntoTopBar = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMoveProfileIntoTopBar

local fFlagLuaAppMoveProfileIntoTopBarIXP = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppMoveProfileIntoTopBarIXP
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local fFlagSubTabAddDesktopTopMargin = SharedFlags.FFlagSubTabAddDesktopTopMargin

local flyoutSidePanelIXP = require("@luauforge/bundled/dHD").FlyoutSidePanelIXP
local fIntLuaAppSubTabTopPadding = SharedFlags.FIntLuaAppSubTabTopPadding

local function makeHomeOmniFeedTokens(p2, p3)
	local size_600 = p3.Size.Size_600
	local v5 = p3.Size.Size_600
	local size_1200 = p3.Size.Size_1200

	local v6 = fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled()

	if v6 then
		if fIntLuaAppSubTabTopPadding > 0 then
			v5 = fIntLuaAppSubTabTopPadding
		end
	elseif fFlagAppIaScrollAway and module.getScrollAwayEnabled() then
		v5 = p3.Size.Size_200
	elseif
		fFlagLuaAppMoveProfileIntoTopBar
		and (not fFlagLuaAppMoveProfileIntoTopBarIXP or verticalEfficiencyExperimentation.getIsProfileMovedToTopBar())
	then
		v5 = p3.Size.Size_300
	end

	local v7 = { layoutPadding = 26, topMargin = 0, bottomMargin = 26 }

	if fFlagSubTabAddDesktopTopMargin and v6 then
		v7.topMargin = v5
	end

	return {
		getLayoutSpacing = function(p4)
			if p4 then
				return v7
			end

			return {
				layoutPadding = size_600,
				topMargin = v5,
				bottomMargin = size_1200
			}
		end,
		trailingWhitespace = 1000,
		animationConfig = { dampingRatio = 1, frequency = 3 },
		scrollBarThickness = 0
	}
end

return makeHomeOmniFeedTokens
