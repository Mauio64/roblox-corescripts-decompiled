local function getUtcDate(s1: string) -- line: 14
	return string.match(s1, "^(%d%d%d%d%-%d%d%-%d%d)")
end
local function isSameUtcDate(s2: string?, s3: string) -- line: 18
	return s2 ~= nil and string.match(s2, "^(%d%d%d%d%-%d%d%-%d%d)") == string.match(s3, "^(%d%d%d%d%-%d%d%-%d%d)")
end
local function createBuildAppStorage(p1, p2) -- line: 22
	local u10 = nil

	local function readData() -- line: 25
		-- upvalues: p1 (copy), p2 (copy)
		local ok, result = pcall(p1.GetItem, p1, "BuildAppStorageKey")

		if not ok or (type(result) ~= "string" or result == "") then
			return {}
		end

		local ok2, result2 = pcall(p2.JSONDecode, p2, result)

		if not ok2 or type(result2) ~= "table" then
			return {}
		end

		return result2
	end
	local function writeData(t1: {[any]: any}) -- line: 39
		-- upvalues: p2 (copy), p1 (copy)
		local ok, result = pcall(p2.JSONEncode, p2, t1)

		if not ok or type(result) ~= "string" then
			return false
		end

		return (pcall(function() -- line: 45
			-- upvalues: p1 (copy), result (copy)
			p1:SetItem("BuildAppStorageKey", result)
			p1:Flush()
		end))
	end

	return {
		STORAGE_KEY = "BuildAppStorageKey",
		wasPushNotificationsUpsellShownToday = function(p3) -- line: 52
			-- upvalues: u10 (ref), readData (copy)
			local v21 = (p3 or DateTime.now()):ToIsoDate()
			local v22 = u10

			if v22 ~= nil and string.match(v22, "^(%d%d%d%d%-%d%d%-%d%d)") == string.match(v21, "^(%d%d%d%d%-%d%d%-%d%d)") then
				return true
			end

			local pushNotificationsUpsell = readData().pushNotificationsUpsell
			local v24 = false

			if type(pushNotificationsUpsell) == "table" then
				local lastShownAt = pushNotificationsUpsell.lastShownAt

				v24 = lastShownAt ~= nil and string.match(lastShownAt, "^(%d%d%d%d%-%d%d%-%d%d)") == string.match(v21, "^(%d%d%d%d%-%d%d%-%d%d)")
			end

			return v24
		end,
		markPushNotificationsUpsellShown = function(p4) -- line: 63
			-- upvalues: u10 (ref), readData (copy), p2 (copy), p1 (copy)
			local v27 = (p4 or DateTime.now()):ToIsoDate()

			u10 = v27

			local v28 = readData()
			local pushNotificationsUpsell = v28.pushNotificationsUpsell
			local v30 = if type(pushNotificationsUpsell) ~= "table" then {} else table.clone(pushNotificationsUpsell)

			v30.lastShownAt = v27
			v28.pushNotificationsUpsell = v30

			local ok, result = pcall(p2.JSONEncode, p2, v28)

			if not ok or type(result) ~= "string" then
				return false
			end

			return (pcall(function() -- line: 45
				-- upvalues: p1 (copy), result (copy)
				p1:SetItem("BuildAppStorageKey", result)
				p1:Flush()
			end))
		end,
		clearSessionCacheForTests = function() -- line: 81
			-- upvalues: u10 (ref)
			u10 = nil
		end
	}
end

local v4 = createBuildAppStorage(game:GetService("AppStorageService"), (game:GetService("HttpService")))

return {
	STORAGE_KEY = "BuildAppStorageKey",
	wasPushNotificationsUpsellShownToday = v4.wasPushNotificationsUpsellShownToday,
	markPushNotificationsUpsellShown = v4.markPushNotificationsUpsellShown,
	clearSessionCacheForTests = v4.clearSessionCacheForTests,
	createForTests = createBuildAppStorage
}
