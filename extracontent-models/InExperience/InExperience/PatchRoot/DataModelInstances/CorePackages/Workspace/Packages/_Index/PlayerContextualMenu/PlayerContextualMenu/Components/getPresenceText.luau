require(script.Parent.Types)

local function getPresenceText(p)
	if not p then
		return ""
	end

	if p.status == "InGame" or p.status == "InStudio" then
		return p.locationString
	end

	return if p.status == "Online" then "Online" else "Offline"
end

return getPresenceText
