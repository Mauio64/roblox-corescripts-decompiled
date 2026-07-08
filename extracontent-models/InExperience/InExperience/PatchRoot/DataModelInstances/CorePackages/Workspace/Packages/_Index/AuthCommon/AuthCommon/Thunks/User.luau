local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local AuthCommonParent = AuthCommon.Parent
local AuthLocalStorageKeys = require(AuthCommon.Enums.AuthLocalStorageKeys)
local Logger = require(AuthCommonParent.Loggers).Logger
local v8 = game:DefineFastFlag("EnableBlackbirdCheck", false)
local EngineFeature = game:GetEngineFeature("HasRobloxSubscriptionStorageKey")
local t1 = {}

t1.__index = t1

function t1.new(n1: number, s1: string, n2: number, b1: boolean, s2: string, s3: string, b2: boolean?) -- line: 39
	-- upvalues: t1 (copy)
	local t2 = {
		userId = n1,
		username = s1,
		displayName = s3 or nil,
		membershipType = n2,
		isUnder13 = b1,
		countryCode = s2,
		hasRobloxSubscription = b2
	}

	setmetatable(t2, t1)

	return t2
end
function t1.fromRequest(p1) -- line: 62
	-- upvalues: v8 (copy), t1 (copy)
	local v20 = if not v8 then nil else p1.responseBody.HasRobloxSubscription == true

	return t1.new(p1.responseBody.UserId, p1.responseBody.Username, tonumber(p1.responseBody.MembershipType), p1.responseBody.AgeBracket == 1, p1.responseBody.CountryCode, p1.responseBody.DisplayName or nil, v20)
end
function t1.fromUserInfoRequest(p2) -- line: 77
	-- upvalues: v8 (copy), t1 (copy)
	local v22 = not p2.responseBody.isPremium and 0 or 4
	local v23 = if not v8 then nil else p2.responseBody.hasRobloxSubscription == true

	return t1.new(p2.responseBody.id, p2.responseBody.name, v22, p2.responseBody.ageBracket == 1, p2.responseBody.countryCode, p2.responseBody.displayName or nil, v23)
end
function t1.fromLocalStorage() -- line: 94
	-- upvalues: v8 (copy), EngineFeature (copy), AppStorageService (copy), AuthLocalStorageKeys (copy), Logger (copy), t1 (copy)
	local v24 = nil

	if v8 and EngineFeature then
		local ok, result = pcall(function() -- line: 98
			-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
			return AppStorageService:GetItem(AuthLocalStorageKeys.HasRobloxSubscription)
		end)

		if ok then
			v24 = result == "true" or false
		else
			Logger:warning("Failed to read HasRobloxSubscription from local storage: {}", (tostring(result)))
		end
	end

	return t1.new(tonumber(AppStorageService:GetItem(AuthLocalStorageKeys.UserId)) or -1, AppStorageService:GetItem(AuthLocalStorageKeys.Username), tonumber(AppStorageService:GetItem(AuthLocalStorageKeys.Membership)) or 0, AppStorageService:GetItem(AuthLocalStorageKeys.IsUnder13) == "true", AppStorageService:GetItem(AuthLocalStorageKeys.CountryCode) or nil, AppStorageService:GetItem(AuthLocalStorageKeys.DisplayName) or nil, v24)
end
function t1.clearLocalStorage() -- line: 118
	-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy), v8 (copy), EngineFeature (copy), Logger (copy)
	AppStorageService:SetItem(AuthLocalStorageKeys.UserId, "-1")
	AppStorageService:SetItem(AuthLocalStorageKeys.Username, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.Membership, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.IsUnder13, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.DisplayName, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.CountryCode, "")

	if v8 and EngineFeature then
		local ok, result = pcall(function() -- line: 126
			-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy)
			AppStorageService:SetItem(AuthLocalStorageKeys.HasRobloxSubscription, "")
		end)

		if not ok then
			Logger:warning("Failed to clear HasRobloxSubscription from local storage: {}", (tostring(result)))
		end
	end

	AppStorageService:Flush()
end
function t1.setToLocalPlayer(p3) -- line: 136
	-- upvalues: v8 (copy), Players (copy)
	if v8 and p3.hasRobloxSubscription ~= nil then
		Players:SetLocalPlayerInfo(p3.userId, p3.username, p3.displayName or "", p3.membershipType, p3.isUnder13, p3.hasRobloxSubscription)

		return
	end

	Players:SetLocalPlayerInfo(p3.userId, p3.username, p3.displayName or "", p3.membershipType, p3.isUnder13)
end
function t1.setToLocalStorage(p4) -- line: 157
	-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy), v8 (copy), EngineFeature (copy), Logger (copy)
	AppStorageService:SetItem(AuthLocalStorageKeys.UserId, (tostring(p4.userId)))
	AppStorageService:SetItem(AuthLocalStorageKeys.Username, p4.username)
	AppStorageService:SetItem(AuthLocalStorageKeys.Membership, (tostring(p4.membershipType)))
	AppStorageService:SetItem(AuthLocalStorageKeys.IsUnder13, (tostring(p4.isUnder13)))
	AppStorageService:SetItem(AuthLocalStorageKeys.DisplayName, (tostring(p4.displayName)))
	AppStorageService:SetItem(AuthLocalStorageKeys.CountryCode, (tostring(p4.countryCode)))

	if v8 and EngineFeature then
		local ok, result = pcall(function() -- line: 165
			-- upvalues: AppStorageService (copy), AuthLocalStorageKeys (copy), p4 (copy)
			AppStorageService:SetItem(AuthLocalStorageKeys.HasRobloxSubscription, (tostring(p4.hasRobloxSubscription == true)))
		end)

		if not ok then
			Logger:warning("Failed to save HasRobloxSubscription to local storage: {}", (tostring(result)))
		end
	end

	AppStorageService:Flush()
end
function t1.isSame(p5, p6) -- line: 178
	return p5.userId == p6.userId
end
function t1.isEqual(p7, p8) -- line: 182
	-- upvalues: v8 (copy)
	local v37 = false

	if p7.userId == p8.userId then
		v37 = false

		if p7.username == p8.username then
			v37 = false

			if p7.membershipType == p8.membershipType then
				v37 = false

				if p7.isUnder13 == p8.isUnder13 then
					v37 = false

					if p7.displayName == p8.displayName then
						v37 = false

						if p7.countryCode == p8.countryCode then
							if v8 then
								return p7.hasRobloxSubscription == p8.hasRobloxSubscription
							end

							v37 = true
						end
					end
				end
			end
		end
	end

	return v37
end
function t1.toString(p9) -- line: 192
	-- upvalues: v8 (copy)
	local v39 = string.format("userId:%s, username:%s, membershipType:%s, isUnder13:%s, countryCode:%s", tostring(p9.userId), p9.username, tostring(p9.membershipType), tostring(p9.isUnder13), (tostring(p9.countryCode)))

	if v8 then
		v39 ..= string.format(", hasRobloxSubscription:%s", (tostring(p9.hasRobloxSubscription)))
	end

	return v39
end
function t1.toJsonData(p10) -- line: 207
	-- upvalues: v8 (copy), HttpService (copy)
	local t3 = {
		userId = p10.userId,
		username = p10.username,
		displayName = p10.displayName or nil,
		membershipType = p10.membershipType,
		isUnder13 = p10.isUnder13,
		countryCode = p10.countryCode
	}

	if v8 then
		t3.hasRobloxSubscription = p10.hasRobloxSubscription
	end

	return HttpService:JSONEncode(t3)
end

return t1
