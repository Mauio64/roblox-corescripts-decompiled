local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local ArgCheck = require(parent.ArgCheck)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppEdpBottomSheetPeekViewEvents = SharedFlags.FFlagLuaAppEdpBottomSheetPeekViewEvents

return function(object, p, universeId, source, p2, surface: string?)
	ArgCheck.isType(p, "string", "eventName")
	ArgCheck.isType(universeId, "string", "universeId")
	ArgCheck.isType(source, "string", "source")
	ArgCheck.isType(p2, "number", "index")

	if FFlagLuaAppEdpBottomSheetPeekViewEvents and surface ~= nil then
		ArgCheck.isType(surface, "string", "surface")
	end

	if Players.LocalPlayer then
		local v = {
			uid = tostring(Players.LocalPlayer.UserId),
			locale = LocalizationService.RobloxLocaleId,
			universeId = universeId,
			source = source,
			index = p2,
			surface = 0
		}

		if not FFlagLuaAppEdpBottomSheetPeekViewEvents then
			surface = nil
		end

		v.surface = surface
		object:setRBXEventStream("GameDetailsPeekView", p, v)
	end
end
