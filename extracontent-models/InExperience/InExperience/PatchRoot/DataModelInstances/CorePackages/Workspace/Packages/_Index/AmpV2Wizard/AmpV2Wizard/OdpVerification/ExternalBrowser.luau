local LinkingService = game:GetService("LinkingService")

return {
	open = function(p: string)
		LinkingService:OpenUrl(p)
	end
}
