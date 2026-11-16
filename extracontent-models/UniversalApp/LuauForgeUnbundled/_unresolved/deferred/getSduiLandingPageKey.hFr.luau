local function getSduiLandingPageKey(p2)
	if p2 == nil or p2 == "" then
		return "SduiLandingPage-Unknown"
	end

	return `SduiLandingPage-{p2}`
end

return getSduiLandingPageKey
