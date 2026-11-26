local v5 = {
	"^roblox://placeid=",
	"^robloxmobile://placeid=",
	"^roblox://experiences/start%?",
	"^robloxmobile://experiences/start%?"
}

local v6 = { "roblox.com", "robloxlabs.com" }

local function isRobloxWebHost(value): boolean
	for k, v7 in v6 do
		if value == v7 or string.sub(value, -(#v7 + 1)) == "." .. v7 then
			return true
		end
	end

	return false
end

local function isGameLaunchUrl(value)
	for k, v7 in v5 do
		if string.find(value, v7) then
			return true
		end
	end

	local v7 = string.match(value, "^https?://([^/]+)/games/start%?")
	return v7 ~= nil and isRobloxWebHost(v7)
end

local function getGameLaunchPlaceId(value)
	local v7 = string.lower(value)

	if not isGameLaunchUrl(v7) then
		return nil
	end

	local v8 = string.match(v7, "[/?&]placeid=(%d+)")

	if v8 then
		return (tonumber(v8))
	end

	return nil
end

return getGameLaunchPlaceId
