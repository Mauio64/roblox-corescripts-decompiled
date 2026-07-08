local Parent = script:FindFirstAncestor("PlayerContextualMenu").Parent
local Images = require(Parent.UIBlox).App.ImageSet.Images

require(script.Parent.Types)

local function getPresenceIcon(p1, t1: {[any]: any}) -- line: 9
	-- upvalues: Images (copy)
	if p1 then
		if p1.status == "InGame" then
			return Images["icons/menu/games_small"], t1.iconEmphasis
		end

		if p1.status == "Online" or p1.status == "InStudio" then
			return Images["component_assets/circle_16"], t1.onlinePresence
		end
	end

	return nil, nil
end

return getPresenceIcon
