local MessageBusService = game:GetService("MessageBusService")

require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/MessageBus")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/Promise")

local getFFlagEnableToSwitchToSettingsAppWithRouteLua = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/Flags/getFFlagEnableToSwitchToSettingsAppWithRouteLua")
local getFFlagEnableAdConsentAttribution = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/Flags/getFFlagEnableAdConsentAttribution")

require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/LinkingProtocolTypes")
local DeepLinkSource = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/Enums/DeepLinkSource")
require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/LinkingProtocol/Enums/SettingsRoute")

local linkingService = require("@game/CorePackages/Workspace/Packages/_Workspace/LinkingProtocol/MockableProxyServices").LinkingService

local class = {}
class.__index = class
class.DeepLinkSource = DeepLinkSource

local function getEngineFeature(p2)
	return game:GetEngineFeature(p2)
end

function class.new(p2)
	return (setmetatable({
		_getEngineFeature = p2 or getEngineFeature,
		isListeningForURLs = false,
		urlConnection = nil
	}, class))
end

function class:registerURL(p3, p4)
	local engineHandlingPolicy = if p4 then p4.engineHandlingPolicy else nil

	if engineHandlingPolicy and self._getEngineFeature("ExternalOriginOnlyUrlRegistration") then
		linkingService:RegisterLuaUrlWithPolicy(p3, engineHandlingPolicy)
	else
		linkingService:RegisterLuaUrl(p3)
	end
end

function class:getUID()
	if game:GetEngineFeature("EnableAppflyerUIDReporting") then
		return Promise.new(function(callback, p3)
			MessageBusService:MakeRequest("Linking", "getUID", {}, function(p4)
				callback(p4.uid)
			end, {})
		end)
	end

	return Promise.resolve("")
end

function class:detectURL(p3)
	linkingService:DetectUrl(p3)
end

function class:isInternalDlicEnabled()
	return self._getEngineFeature("EnableDLICInternalIngressSeeding")
end

function class:createInternalDlic(p3, p4)
	return linkingService:CreateInternalDlic(p3, p4)
end

function class:detectDeeplinkIntent(p3)
	linkingService:DetectDlic(p3)
end

function class:adConsentResolved(p3)
	if not getFFlagEnableAdConsentAttribution() then
		return
	end

	MessageBusService:Publish("Linking.adConsentResolved", p3)
end

function class:getLastLuaURL()
	return linkingService:GetLastLuaUrl()
end

function class:listenForLuaURLs(callback, p2)
	self:stopListeningForLuaURLs()
	self.urlConnection = linkingService.OnLuaUrl:Connect(function(p3, p4, p5)
		callback(p3, p5)
	end)
	self.isListeningForURLs = true
	local v5 = linkingService:StartLuaUrlDelivery()

	if v5 and v5.url then
		callback(v5.url, v5.attributionUrl)
	end
end

function class:stopListeningForLuaURLs()
	if self.isListeningForURLs then
		self.urlConnection:Disconnect()
		linkingService:StopLuaUrlDelivery()
		self.isListeningForURLs = false
	end
end

function class:openURL(p3)
	return Promise.new(function(callback, p4)
		callback(linkingService:OpenUrl(p3))
	end)
end

function class:isURLRegistered(p3)
	return Promise.new(function(callback, p4)
		callback(linkingService:IsUrlRegistered(p3))
	end)
end

function class:getAndClearLastPendingURL()
	if game:GetEngineFeature("LinkingProtocolGetLastPendingUrlEnabled") then
		return Promise.new(function(callback, p3)
			callback(linkingService:GetAndClearLastPendingUrl())
		end)
	end

	return Promise.resolve({ hasPendingUrl = false })
end

function class:switchToSettingsApp(p3)
	if not getFFlagEnableToSwitchToSettingsAppWithRouteLua() then
		p3 = nil
	end

	return Promise.new(function(callback, p4)
		callback(linkingService:SwitchToSettingsApp(p3))
	end)
end

function class:supportsSwitchToSettingsApp(p3)
	return Promise.new(function(callback, p4)
		callback(linkingService:SupportsSwitchToSettingsApp())
	end)
end

class.default = class.new()

return class
