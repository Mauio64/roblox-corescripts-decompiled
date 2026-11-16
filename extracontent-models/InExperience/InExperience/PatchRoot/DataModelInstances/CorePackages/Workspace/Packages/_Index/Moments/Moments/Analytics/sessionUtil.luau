local SessionService = game:GetService("SessionService")

return {
	setPlayIntent = function(p: string)
		if not SessionService:SessionExists("level2a") then
			return
		end

		SessionService:SetMetadata("level2a", "playIntentId", p)
	end
}
