local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetMetaDataFromShareLink = require(Modules.LuaApp.Thunks.Authentication.AuthIntent.GetMetaDataFromShareLink)

function getDeepLinkData(p1, s1: string) -- line: 11
	-- upvalues: GetMetaDataFromShareLink (copy)
	local v5, v6, v7 = s1:match("code=(.-)&type=(.-)&stamp=(.*)")

	if not v7 then
		v5, v6 = s1:match("code=(.-)&type=(.*)")
	end

	if v5 and v6 then
		local v8, v9 = GetMetaDataFromShareLink(p1, v5, v6):await()

		if v8 and v9 then
			return {
				universeId = v9.universeId,
				inviterId = v9.inviterId,
				placeId = v9.placeId
			}
		end

		warn("Failed to get deep link data for url:", s1, "Got:", v9)

		return nil
	end

	warn("Failed to parse deep link data for url:", s1)

	return nil
end

return getDeepLinkData
