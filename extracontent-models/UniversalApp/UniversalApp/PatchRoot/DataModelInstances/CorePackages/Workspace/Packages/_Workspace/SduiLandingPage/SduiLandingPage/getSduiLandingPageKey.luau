local function getSduiLandingPageKey(s1: string?) -- line: 1
	if s1 == nil or s1 == "" then
		return "SduiLandingPage-Unknown"
	end

	return `SduiLandingPage-{ s1 }`
end

return getSduiLandingPageKey
