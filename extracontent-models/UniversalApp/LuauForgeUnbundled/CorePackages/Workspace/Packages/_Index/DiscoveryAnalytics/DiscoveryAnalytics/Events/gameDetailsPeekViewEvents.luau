local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/ArgCheck")
local fFlagLuaAppEdpBottomSheetPeekViewEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppEdpBottomSheetPeekViewEvents

return function(object, p2, p3, p4, p5, surface)
	ArgCheck.isType(p2, "string", "eventName")
	ArgCheck.isType(p3, "string", "universeId")
	ArgCheck.isType(p4, "string", "source")
	ArgCheck.isType(p5, "number", "index")

	if fFlagLuaAppEdpBottomSheetPeekViewEvents and surface ~= nil then
		ArgCheck.isType(surface, "string", "surface")
	end

	if Players.LocalPlayer then
		local v6 = {
			uid = tostring(Players.LocalPlayer.UserId),
			locale = LocalizationService.RobloxLocaleId,
			universeId = p3,
			source = p4,
			index = p5,
			surface = 0
		}

		if not fFlagLuaAppEdpBottomSheetPeekViewEvents then
			surface = nil
		end

		v6.surface = surface
		object:setRBXEventStream("GameDetailsPeekView", p2, v6)
	end
end
