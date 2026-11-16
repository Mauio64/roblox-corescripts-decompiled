local parent = script:FindFirstAncestor("PlayerContextualMenu").Parent

local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
require(script.Parent.Types)

local function getPresenceIcon(p, p2)
	if not p then
		return nil, nil
	end

	if p.status == "InGame" then
		return Images["icons/menu/games_small"], p2.iconEmphasis
	end

	if p.status == "Online" or p.status == "InStudio" then
		return Images["component_assets/circle_16"], p2.onlinePresence
	end

	return nil, nil
end

return getPresenceIcon
