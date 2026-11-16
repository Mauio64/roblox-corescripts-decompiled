local module = require("@luauforge/bundled/fQs")

function LUAUFORGE_MODULE_GLOBALS_fQr_getDeepLinkData(p2, value)
	local v5, v6, v7 = value:match("code=(.-)&type=(.-)&stamp=(.*)")

	if not v7 then
		v5, v6 = value:match("code=(.-)&type=(.*)")
	end

	if not (v5 and v6) then
		warn("Failed to parse deep link data for url:", value)
		return nil
	end

	local v8, v9 = module(p2, v5, v6):await()

	if v8 and v9 then
		return {
			universeId = v9.universeId,
			inviterId = v9.inviterId,
			placeId = v9.placeId
		}
	end

	warn("Failed to get deep link data for url:", value, "Got:", v9)
	return nil
end

return LUAUFORGE_MODULE_GLOBALS_fQr_getDeepLinkData
