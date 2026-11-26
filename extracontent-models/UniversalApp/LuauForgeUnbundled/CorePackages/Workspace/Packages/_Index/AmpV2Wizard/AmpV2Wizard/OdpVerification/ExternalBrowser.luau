local LinkingService = game:GetService("LinkingService")

return {
	open = function(p2)
		LinkingService:OpenUrl(p2)
	end
}
