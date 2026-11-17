local v = {
	"^roblox://placeid=",
	"^robloxmobile://placeid=",
	"^roblox://experiences/start%?",
	"^robloxmobile://experiences/start%?"
}

local v2 = { "roblox.com", "robloxlabs.com" }

local function isRobloxWebHost(value: string): boolean
	for _, v3 in v2 do
		if value == v3 or string.sub(value, -(#v3 + 1)) == "." .. v3 then
			return true
		end
	end

	return false
end

local function isGameLaunchUrl(value: string)
	for _, v3 in v do
		if string.find(value, v3) then
			return true
		end
	end

	local v3 = string.match(value, "^https?://([^/]+)/games/start%?")
	return v3 ~= nil and isRobloxWebHost(v3)
end

local function getGameLaunchPlaceId(value: string)
	local v3 = string.lower(value)

	if not isGameLaunchUrl(v3) then
		return nil
	end

	local v4 = string.match(v3, "[/?&]placeid=(%d+)")

	if v4 then
		return (tonumber(v4))
	end

	return nil
end

return getGameLaunchPlaceId
