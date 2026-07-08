local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local ArgCheck = require(Parent.ArgCheck)

return function(p1, p2, p3, p4, p5) -- line: 7
	-- upvalues: ArgCheck (copy), Players (copy), LocalizationService (copy)
	ArgCheck.isType(p2, "string", "eventName")
	ArgCheck.isType(p3, "string", "universeId")
	ArgCheck.isType(p4, "string", "source")
	ArgCheck.isType(p5, "number", "index")

	if Players.LocalPlayer then
		local str = tostring(Players.LocalPlayer.UserId)
		local RobloxLocaleId = LocalizationService.RobloxLocaleId

		p1:setRBXEventStream("GameDetailsPeekView", p2, {
			uid = str,
			locale = RobloxLocaleId,
			universeId = p3,
			source = p4,
			index = p5
		})
	end
end
