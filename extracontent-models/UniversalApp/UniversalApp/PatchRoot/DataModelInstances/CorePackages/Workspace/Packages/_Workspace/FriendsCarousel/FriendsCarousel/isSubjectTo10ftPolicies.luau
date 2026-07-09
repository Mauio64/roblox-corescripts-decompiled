local v1 = game:DefineFastFlag("FriendCarouselHas10ftPolicies", false)
local GuiService = game:GetService("GuiService")

return function() -- line: 4
	-- upvalues: v1 (copy), GuiService (copy)
	if v1 then
		return GuiService:IsTenFootInterface()
	end

	return false
end
