local AppStorageService = game:GetService("AppStorageService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local AuthLocalStorageKeys = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Enums/AuthLocalStorageKeys")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Loggers").Logger

local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableBlackbirdCheck
local engineFeature = game:GetEngineFeature("HasRobloxSubscriptionStorageKey")

local class = {}
class.__index = class

function class.new(p2, p3, p4, p5, p6, p7, p8)
	local v5 = {
		userId = p2,
		username = p3,
		displayName = p7 or nil,
		membershipType = p4,
		isUnder13 = p5,
		countryCode = p6,
		hasRobloxSubscription = p8
	}

	setmetatable(v5, class)
	return v5
end

function class.fromRequest(p2)
	local v5 = if fFlagEnableBlackbirdCheck then p2.responseBody.HasRobloxSubscription == true else nil

	return class.new(
		p2.responseBody.UserId,
		p2.responseBody.Username,
		tonumber(p2.responseBody.MembershipType),
		p2.responseBody.AgeBracket == 1,
		p2.responseBody.CountryCode,
		p2.responseBody.DisplayName or nil,
		v5
	)
end

function class.fromUserInfoRequest(p2)
	local v5 = p2.responseBody.isPremium and 4 or 0

	local v6 = if fFlagEnableBlackbirdCheck then p2.responseBody.hasRobloxSubscription == true else nil

	return class.new(
		p2.responseBody.id,
		p2.responseBody.name,
		v5,
		p2.responseBody.ageBracket == 1,
		p2.responseBody.countryCode,
		p2.responseBody.displayName or nil,
		v6
	)
end

function class.fromLocalStorage()
	local v5 = nil

	if fFlagEnableBlackbirdCheck and engineFeature then
		local success, result = pcall(function()
			return AppStorageService:GetItem(AuthLocalStorageKeys.HasRobloxSubscription)
		end)

		if success then
			v5 = result == "true"
		else
			logger:warning(
				"Failed to read HasRobloxSubscription from local storage: {}",
				(tostring(result))
			)
		end
	end

	return class.new(
		tonumber(AppStorageService:GetItem(AuthLocalStorageKeys.UserId)) or -1,
		AppStorageService:GetItem(AuthLocalStorageKeys.Username),
		tonumber(AppStorageService:GetItem(AuthLocalStorageKeys.Membership)) or 0,
		AppStorageService:GetItem(AuthLocalStorageKeys.IsUnder13) == "true",
		AppStorageService:GetItem(AuthLocalStorageKeys.CountryCode) or nil,
		AppStorageService:GetItem(AuthLocalStorageKeys.DisplayName) or nil,
		v5
	)
end

function class.clearLocalStorage()
	AppStorageService:SetItem(AuthLocalStorageKeys.UserId, "-1")
	AppStorageService:SetItem(AuthLocalStorageKeys.Username, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.Membership, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.IsUnder13, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.DisplayName, "")
	AppStorageService:SetItem(AuthLocalStorageKeys.CountryCode, "")

	if fFlagEnableBlackbirdCheck and engineFeature then
		local success, result = pcall(function()
			AppStorageService:SetItem(AuthLocalStorageKeys.HasRobloxSubscription, "")
		end)

		if not success then
			logger:warning(
				"Failed to clear HasRobloxSubscription from local storage: {}",
				(tostring(result))
			)
		end
	end

	AppStorageService:Flush()
end

function class:setToLocalPlayer()
	if fFlagEnableBlackbirdCheck and self.hasRobloxSubscription ~= nil then
		Players:SetLocalPlayerInfo(
			self.userId,
			self.username,
			self.displayName or "",
			self.membershipType,
			self.isUnder13,
			self.hasRobloxSubscription
		)
	else
		Players:SetLocalPlayerInfo(
			self.userId,
			self.username,
			self.displayName or "",
			self.membershipType,
			self.isUnder13
		)
	end
end

function class:setToLocalStorage()
	AppStorageService:SetItem(AuthLocalStorageKeys.UserId, (tostring(self.userId)))
	AppStorageService:SetItem(AuthLocalStorageKeys.Username, self.username)
	AppStorageService:SetItem(AuthLocalStorageKeys.Membership, (tostring(self.membershipType)))
	AppStorageService:SetItem(AuthLocalStorageKeys.IsUnder13, (tostring(self.isUnder13)))
	AppStorageService:SetItem(AuthLocalStorageKeys.DisplayName, (tostring(self.displayName)))
	AppStorageService:SetItem(AuthLocalStorageKeys.CountryCode, (tostring(self.countryCode)))

	if fFlagEnableBlackbirdCheck and engineFeature then
		local success, result = pcall(function()
			AppStorageService:SetItem(
				AuthLocalStorageKeys.HasRobloxSubscription,
				(tostring(self.hasRobloxSubscription == true))
			)
		end)

		if not success then
			logger:warning("Failed to save HasRobloxSubscription to local storage: {}", (tostring(result)))
		end
	end

	AppStorageService:Flush()
end

function class.isSame(p2, p3): boolean
	return p2.userId == p3.userId
end

function class.isEqual(data, data2): boolean
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

	if fFlagEnableBlackbirdCheck then
		return data.hasRobloxSubscription == data2.hasRobloxSubscription
	end

	return true
end

function class.toString(data)
	local str = string.format(
		"userId:%s, username:%s, membershipType:%s, isUnder13:%s, countryCode:%s",
		tostring(data.userId),
		data.username,
		tostring(data.membershipType),
		tostring(data.isUnder13),
		(tostring(data.countryCode))
	)

	if fFlagEnableBlackbirdCheck then
		str ..= string.format(", hasRobloxSubscription:%s", (tostring(data.hasRobloxSubscription)))
	end

	return str
end

function class:toJsonData()
	local v5 = {
		userId = self.userId,
		username = self.username,
		displayName = self.displayName or nil,
		membershipType = self.membershipType,
		isUnder13 = self.isUnder13,
		countryCode = self.countryCode
	}

	if fFlagEnableBlackbirdCheck then
		v5.hasRobloxSubscription = self.hasRobloxSubscription
	end

	return HttpService:JSONEncode(v5)
end

return class
