local SessionService = game:GetService("SessionService")

return {
	setPlayIntent = function(p2)
		if not SessionService:SessionExists("level2a") then
			return
		end

		SessionService:SetMetadata("level2a", "playIntentId", p2)
	end
}
