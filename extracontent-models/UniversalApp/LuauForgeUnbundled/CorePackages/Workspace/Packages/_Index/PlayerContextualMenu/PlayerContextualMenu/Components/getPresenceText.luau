require("@game/CorePackages/Workspace/Packages/_Index/PlayerContextualMenu/PlayerContextualMenu/Components/Types")

local function getPresenceText(p2)
	if not p2 then
		return ""
	end

	if p2.status == "InGame" or p2.status == "InStudio" then
		return p2.locationString
	end

	if p2.status == "Online" then
		return "Online"
	end

	return "Offline"
end

return getPresenceText
