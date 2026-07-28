local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local ArgCheck = require(Parent.ArgCheck)
local FFlagLuaAppEdpBottomSheetPeekViewEvents = require(Parent.SharedFlags).FFlagLuaAppEdpBottomSheetPeekViewEvents

return function(p1, p2, p3, p4, p5, s1: string?) -- line: 8
	-- upvalues: ArgCheck (copy), FFlagLuaAppEdpBottomSheetPeekViewEvents (copy), Players (copy), LocalizationService (copy)
	ArgCheck.isType(p2, "string", "eventName")
	ArgCheck.isType(p3, "string", "universeId")
	ArgCheck.isType(p4, "string", "source")
	ArgCheck.isType(p5, "number", "index")

	if FFlagLuaAppEdpBottomSheetPeekViewEvents and s1 ~= nil then
		ArgCheck.isType(s1, "string", "surface")
	end

	if Players.LocalPlayer then
		local str = tostring(Players.LocalPlayer.UserId)
		local RobloxLocaleId = LocalizationService.RobloxLocaleId

		p1:setRBXEventStream("GameDetailsPeekView", p2, {
			uid = str,
			locale = RobloxLocaleId,
			universeId = p3,
			source = p4,
			index = p5,
			surface = if not FFlagLuaAppEdpBottomSheetPeekViewEvents then nil else s1
		})
	end
end
