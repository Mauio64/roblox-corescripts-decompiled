local Parent = script:FindFirstAncestor("Moments").Parent
local SessionService = game:GetService("SessionService")
local FFlagMomentsWatchSessionalization = require(Parent.SharedFlags).FFlagMomentsWatchSessionalization

return {
	setPlayIntent = function(s1: string) -- line: 33
		-- upvalues: FFlagMomentsWatchSessionalization (copy), SessionService (copy)
		if not FFlagMomentsWatchSessionalization then
			return
		end

		if not SessionService:SessionExists("level2a") then
			return
		end

		SessionService:SetMetadata("level2a", "playIntentId", s1)
	end
}
