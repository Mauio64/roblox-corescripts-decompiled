require(script.Parent.Types)

local function getPresenceText(p1) -- line: 3
	if p1 then
		if p1.status == "InGame" or p1.status == "InStudio" then
			return p1.locationString
		end

		if p1.status == "Online" then
			return "Online"
		end

		return "Offline"
	end

	return ""
end

return getPresenceText
