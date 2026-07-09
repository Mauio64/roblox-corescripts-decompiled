local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("SocialCommon").Parent
local Cryo = require(Parent.Cryo)

local function ImpressionCacheImpl(t1: {[any]: any}) -- line: 23
	-- upvalues: Players (copy), AppStorageService (copy), HttpService (copy), Cryo (copy)
	local isKeyAvailableInEngine = t1.isKeyAvailableInEngine
	local dismissedValue = t1.dismissedValue
	local appStorageKey = t1.appStorageKey
	local v11 = t1.PlayersService or Players
	local v12 = t1.AppStorageService or AppStorageService

	local function getLocalUserId() -- line: 31
		-- upvalues: v11 (copy)
		local LocalPlayer = v11.LocalPlayer

		if LocalPlayer and (LocalPlayer.UserId and LocalPlayer.UserId > 0) then
			return (tostring(LocalPlayer.UserId))
		end

		return nil
	end
	local function updateStoredValue(t2: {[any]: any}) -- line: 40
		-- upvalues: HttpService (copy), v12 (copy), appStorageKey (copy)
		local ok, result = pcall(function() -- line: 41
			-- upvalues: HttpService (copy), t2 (copy)
			return HttpService:JSONEncode(t2)
		end)

		if ok then
			v12:SetItem(appStorageKey, result)
			v12:Flush()
		end
	end
	local function getStoredValue() -- line: 50
		-- upvalues: v12 (copy), appStorageKey (copy), HttpService (copy)
		local v23 = v12:GetItem(appStorageKey) or ""
		local ok, result = pcall(function() -- line: 53
			-- upvalues: HttpService (copy), v23 (copy)
			return HttpService:JSONDecode(v23)
		end)

		if ok and type(result) == "table" then
			return result
		end

		return nil
	end
	local function setImpressionCountPerUser(s1: string, n1: number) -- line: 60
		-- upvalues: v12 (copy), appStorageKey (copy), HttpService (copy), Cryo (copy)
		local v28 = v12:GetItem(appStorageKey) or ""
		local ok, result = pcall(function() -- line: 53
			-- upvalues: HttpService (copy), v28 (copy)
			return HttpService:JSONDecode(v28)
		end)
		local v31 = if not ok or type(result) ~= "table" then nil else result
		local v32 = Cryo.Dictionary.join(v31 or {}, {
			[s1] = n1
		})
		local ok2, result2 = pcall(function() -- line: 41
			-- upvalues: HttpService (copy), v32 (copy)
			return HttpService:JSONEncode(v32)
		end)

		if ok2 then
			v12:SetItem(appStorageKey, result2)
			v12:Flush()
		end
	end
	local function getImpressionCountPerUser(s2: string) -- line: 68
		-- upvalues: v12 (copy), appStorageKey (copy), HttpService (copy)
		local v36 = v12:GetItem(appStorageKey) or ""
		local ok, result = pcall(function() -- line: 53
			-- upvalues: HttpService (copy), v36 (copy)
			return HttpService:JSONDecode(v36)
		end)
		local v39 = if not ok or type(result) ~= "table" then nil else result

		return v39 and (not not v39[s2] and tonumber(v39[s2])) or 0
	end
	local function setValue(n2: number) -- line: 76
		-- upvalues: v11 (copy), isKeyAvailableInEngine (copy), setImpressionCountPerUser (copy)
		local LocalPlayer = v11.LocalPlayer
		local v42 = if not LocalPlayer or (not LocalPlayer.UserId or not (LocalPlayer.UserId > 0)) then nil else tostring(LocalPlayer.UserId)

		if isKeyAvailableInEngine and v42 then
			setImpressionCountPerUser(v42, n2)
		end
	end

	return {
		getValue = function() -- line: 83
			-- upvalues: v11 (copy), isKeyAvailableInEngine (copy), v12 (copy), appStorageKey (copy), HttpService (copy), dismissedValue (copy)
			local LocalPlayer = v11.LocalPlayer
			local v44 = if not LocalPlayer or (not LocalPlayer.UserId or not (LocalPlayer.UserId > 0)) then nil else tostring(LocalPlayer.UserId)

			if isKeyAvailableInEngine and v44 then
				local v45 = v12:GetItem(appStorageKey) or ""
				local ok, result = pcall(function() -- line: 53
					-- upvalues: HttpService (copy), v45 (copy)
					return HttpService:JSONDecode(v45)
				end)
				local v48 = if not ok or type(result) ~= "table" then nil else result

				return v48 and (not not v48[v44] and tonumber(v48[v44])) or 0
			end

			return dismissedValue
		end,
		incrementValue = function() -- line: 93
			-- upvalues: v11 (copy), isKeyAvailableInEngine (copy), v12 (copy), appStorageKey (copy), HttpService (copy), dismissedValue (copy), setImpressionCountPerUser (copy)
			local LocalPlayer = v11.LocalPlayer
			local v50 = if not LocalPlayer or (not LocalPlayer.UserId or not (LocalPlayer.UserId > 0)) then nil else tostring(LocalPlayer.UserId)
			local v55

			if isKeyAvailableInEngine and v50 then
				local v51 = v12:GetItem(appStorageKey) or ""
				local ok, result = pcall(function() -- line: 53
					-- upvalues: HttpService (copy), v51 (copy)
					return HttpService:JSONDecode(v51)
				end)
				local v54 = if not ok or type(result) ~= "table" then nil else result

				v55 = v54 and (not not v54[v50] and tonumber(v54[v50])) or 0
			else
				v55 = dismissedValue
			end

			local v56 = v55 + 1
			local LocalPlayer2 = v11.LocalPlayer
			local v58 = if not LocalPlayer2 or (not LocalPlayer2.UserId or not (LocalPlayer2.UserId > 0)) then nil else tostring(LocalPlayer2.UserId)

			if isKeyAvailableInEngine and v58 then
				setImpressionCountPerUser(v58, v56)
			end
		end,
		dismissValue = function() -- line: 97
			-- upvalues: dismissedValue (copy), v11 (copy), isKeyAvailableInEngine (copy), setImpressionCountPerUser (copy)
			local v59 = dismissedValue
			local LocalPlayer = v11.LocalPlayer
			local v61 = if not LocalPlayer or (not LocalPlayer.UserId or not (LocalPlayer.UserId > 0)) then nil else tostring(LocalPlayer.UserId)

			if isKeyAvailableInEngine and v61 then
				setImpressionCountPerUser(v61, v59)
			end
		end
	}
end

return ImpressionCacheImpl
