local images = require("@game/CorePackages/Workspace/Packages/_Workspace/PlayerContextualMenu/UIBlox").App.ImageSet.Images
require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/Types")

local function getPresenceIcon(p2, p3)
	if not p2 then
		return nil, nil
	end

	if p2.status == "InGame" then
		return images["icons/menu/games_small"], p3.iconEmphasis
	end

	if p2.status == "Online" or p2.status == "InStudio" then
		return images["component_assets/circle_16"], p3.onlinePresence
	end

	return nil, nil
end

return getPresenceIcon
