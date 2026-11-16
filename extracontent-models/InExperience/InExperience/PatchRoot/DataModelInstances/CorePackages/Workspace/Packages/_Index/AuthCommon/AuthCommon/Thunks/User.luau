local AuthCommon = script:FindFirstAncestor("AuthCommon")

local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local parent = AuthCommon.Parent
local AuthLocalStorageKeys = require(AuthCommon.Enums.AuthLocalStorageKeys)
local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local engineFeature = game:GetEngineFeature("HasRobloxSubscriptionStorageKey")

local User = {}
User.__index = User

function User.new(userId: number, username: string, membershipType: number, isUnder: boolean, countryCode: string, p: string, hasRobloxSubscription: boolean?)
	local v = {
		userId = userId,
		username = username,
		displayName = p or nil,
		membershipType = membershipType,
		isUnder13 = isUnder,
		countryCode = countryCode,
		hasRobloxSubscription = hasRobloxSubscription
	}

	setmetatable(v, User)
	return v
end

function User.fromRequest(p)
	local v

	if FFlagEnableBlackbirdCheck then
		v = p.responseBody.HasRobloxSubscription == true
	end

	return User.new(
		p.responseBody.UserId,
		p.responseBody.Username,
		tonumber(p.responseBody.MembershipType),
		p.responseBody.AgeBracket == 1,
		p.responseBody.CountryCode,
		p.responseBody.DisplayName or nil,
		v
	)
end

function User.fromUserInfoRequest(p)
	local v = p.responseBody.isPremium and 4 or 0
	local v2

	if FFlagEnableBlackbirdCheck then
		v2 = p.responseBody.hasRobloxSubscription == true
	end

	return User.new(
		p.responseBody.id,
		p.responseBody.name,
		v,
		p.responseBody.ageBracket == 1,
		p.responseBody.countryCode,
		p.responseBody.displayName or nil,
		v2
	)
end

function User.fromLocalStorage()
	local v = nil

	if FFlagEnableBlackbirdCheck and engineFeature then
		local success, result = pcall(function()
			return AppStorageService:GetItem(AuthLocalStorageKeys.HasRobloxSubscription)
		end)

		if success then
			v = result == "true"
		else
			Logger:warning("Failed to read HasRobloxSubscription from local storage: {}", (tostring(result)))
		end
	end

	return User.new(
		tonumber(AppStorageService:GetItem(AuthLocalStorageKeys.UserId)) or -1,
		AppStorageService:GetItem(AuthLocalStorageKeys.Username),
		tonumber(AppStorageService:GetItem(AuthLocalStorageKeys.Membership)) or 0,
		AppStorageService:GetItem(AuthLocalStorageKeys.IsUnder13) == "true",
		AppStorageService:GetItem(AuthLocalStorageKeys.CountryCode) or nil,
		AppStorageService:GetItem(AuthLocalStorageKeys.DisplayName) or nil,
		v
	)
end

function User.clearLocalStorage()
	AppStorageService:SetItem(AuthLocalStorageKeys.UserId, "-1")
	AppStorageService:SetItem(AuthLocalStorageKeys.Username, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.Membership, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.IsUnder13, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.DisplayName, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.CountryCode, "")

	if FFlagEnableBlackbirdCheck and engineFeature then
		local success, result = pcall(function()
			AppStorageService:SetItem(AuthLocalStorageKeys.HasRobloxSubscription, "")
		end)

		if not success then
			Logger:warning("Failed to clear HasRobloxSubscription from local storage: {}", (tostring(result)))
		end
	end

	AppStorageService:Flush()
end

function User.setToLocalPlayer(data)
	if FFlagEnableBlackbirdCheck and data.hasRobloxSubscription ~= nil then
		Players:SetLocalPlayerInfo(
			data.userId,
			data.username,
			data.displayName or "",
			data.membershipType,
			data.isUnder13,
			data.hasRobloxSubscription
		)
	else
		Players:SetLocalPlayerInfo(
			data.userId,
			data.username,
			data.displayName or "",
			data.membershipType,
			data.isUnder13
		)
	end
end

function User.setToLocalStorage(data)
	AppStorageService:SetItem(AuthLocalStorageKeys.UserId, (tostring(data.userId)))
	AppStorageService:SetItem(AuthLocalStorageKeys.Username, data.username)
	AppStorageService:SetItem(AuthLocalStorageKeys.Membership, (tostring(data.membershipType)))
	AppStorageService:SetItem(AuthLocalStorageKeys.IsUnder13, (tostring(data.isUnder13)))
	AppStorageService:SetItem(AuthLocalStorageKeys.DisplayName, (tostring(data.displayName)))
	AppStorageService:SetItem(AuthLocalStorageKeys.CountryCode, (tostring(data.countryCode)))

	if FFlagEnableBlackbirdCheck and engineFeature then
		local success, result = pcall(function()
			AppStorageService:SetItem(
				AuthLocalStorageKeys.HasRobloxSubscription,
				(tostring(data.hasRobloxSubscription == true))
			)
		end)

		if not success then
			Logger:warning("Failed to save HasRobloxSubscription to local storage: {}", (tostring(result)))
		end
	end

	AppStorageService:Flush()
end

function User.isSame(p, p2): boolean
	return p.userId == p2.userId
end

function User.isEqual(data, data2): boolean
	if
		data.userId ~= data2.userId
		or data.username ~= data2.username
		or data.membershipType ~= data2.membershipType
		or data.isUnder13 ~= data2.isUnder13
		or data.displayName ~= data2.displayName
		or data.countryCode ~= data2.countryCode
	then
		return false
	end

	return not FFlagEnableBlackbirdCheck or data.hasRobloxSubscription == data2.hasRobloxSubscription
end

function User.toString(data)
	local str = string.format(
		"userId:%s, username:%s, membershipType:%s, isUnder13:%s, countryCode:%s",
		tostring(data.userId),
		data.username,
		tostring(data.membershipType),
		tostring(data.isUnder13),
		(tostring(data.countryCode))
	)

	if FFlagEnableBlackbirdCheck then
		str ..= string.format(", hasRobloxSubscription:%s", (tostring(data.hasRobloxSubscription)))
	end

	return str
end

function User.toJsonData(data)
	local v = {
		userId = data.userId,
		username = data.username,
		displayName = data.displayName or nil,
		membershipType = data.membershipType,
		isUnder13 = data.isUnder13,
		countryCode = data.countryCode
	}

	if FFlagEnableBlackbirdCheck then
		v.hasRobloxSubscription = data.hasRobloxSubscription
	end

	return HttpService:JSONEncode(v)
end

return User
