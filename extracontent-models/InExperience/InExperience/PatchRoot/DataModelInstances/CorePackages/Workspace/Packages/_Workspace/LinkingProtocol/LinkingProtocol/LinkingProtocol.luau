local parent = script.Parent.Parent

local MessageBusService = game:GetService("MessageBusService")

require(parent.MessageBus)
local Promise = require(parent.Promise)

local getFFlagEnableToSwitchToSettingsAppWithRouteLua = require(script.Parent.Flags.getFFlagEnableToSwitchToSettingsAppWithRouteLua)
local getFFlagEnableAdConsentAttribution = require(script.Parent.Flags.getFFlagEnableAdConsentAttribution)

require(script.Parent.LinkingProtocolTypes)
local DeepLinkSource = require(script.Parent.Enums.DeepLinkSource)
require(script.Parent.Enums.SettingsRoute)

local MockableProxyServices = require(parent.MockableProxyServices)
local LinkingService = MockableProxyServices.LinkingService

local LinkingProtocol = {}
LinkingProtocol.__index = LinkingProtocol
LinkingProtocol.DeepLinkSource = DeepLinkSource

local function getEngineFeature(p: string)
	return game:GetEngineFeature(p)
end

function LinkingProtocol.new(callback)
	return (setmetatable({
		_getEngineFeature = callback or getEngineFeature,
		isListeningForURLs = false,
		urlConnection = nil
	}, LinkingProtocol))
end

function LinkingProtocol:registerURL(p: string, p2)
	local engineHandlingPolicy

	if p2 then
		engineHandlingPolicy = p2.engineHandlingPolicy
	end

	if engineHandlingPolicy and self._getEngineFeature("ExternalOriginOnlyUrlRegistration") then
		LinkingService:RegisterLuaUrlWithPolicy(p, engineHandlingPolicy)
	else
		LinkingService:RegisterLuaUrl(p)
	end
end

function LinkingProtocol.getUID(_)
	if game:GetEngineFeature("EnableAppflyerUIDReporting") then
		return Promise.new(function(callback, _)
			MessageBusService:MakeRequest("Linking", "getUID", {}, function(p)
				callback(p.uid)
			end, {})
		end)
	end

	return Promise.resolve("")
end

function LinkingProtocol.detectURL(_, p: string)
	LinkingService:DetectUrl(p)
end

function LinkingProtocol:isInternalDlicEnabled()
	return self._getEngineFeature("EnableDLICInternalIngressSeeding")
end

function LinkingProtocol.createInternalDlic(_, p: string, p2)
	return LinkingService:CreateInternalDlic(p, p2)
end

function LinkingProtocol.detectDeeplinkIntent(_, p: string)
	LinkingService:DetectDlic(p)
end

function LinkingProtocol.adConsentResolved(_, p)
	if not getFFlagEnableAdConsentAttribution() then
		return
	end

	MessageBusService:Publish("Linking.adConsentResolved", p)
end

function LinkingProtocol.getLastLuaURL(_)
	return LinkingService:GetLastLuaUrl()
end

function LinkingProtocol:listenForLuaURLs(callback, _: boolean?)
	self:stopListeningForLuaURLs()
	self.urlConnection = LinkingService.OnLuaUrl:Connect(function(p, _, p2)
		callback(p, p2)
	end)
	self.isListeningForURLs = true
	local v = LinkingService:StartLuaUrlDelivery()

	if v and v.url then
		callback(v.url, v.attributionUrl)
	end
end

function LinkingProtocol:stopListeningForLuaURLs()
	if self.isListeningForURLs then
		self.urlConnection:Disconnect()
		LinkingService:StopLuaUrlDelivery()
		self.isListeningForURLs = false
	end
end

function LinkingProtocol.openURL(_, p: string)
	return Promise.new(function(callback, _)
		callback(LinkingService:OpenUrl(p))
	end)
end

function LinkingProtocol.isURLRegistered(_, p: string)
	return Promise.new(function(callback, _)
		callback(LinkingService:IsUrlRegistered(p))
	end)
end

function LinkingProtocol.getAndClearLastPendingURL(_)
	if game:GetEngineFeature("LinkingProtocolGetLastPendingUrlEnabled") then
		return Promise.new(function(callback, _)
			callback(LinkingService:GetAndClearLastPendingUrl())
		end)
	end

	return Promise.resolve({ hasPendingUrl = false })
end

function LinkingProtocol.switchToSettingsApp(_, p)
	if not getFFlagEnableToSwitchToSettingsAppWithRouteLua() then
		p = nil
	end

	return Promise.new(function(callback, _)
		callback(LinkingService:SwitchToSettingsApp(p))
	end)
end

function LinkingProtocol.supportsSwitchToSettingsApp(_, _)
	return Promise.new(function(callback, _)
		callback(LinkingService:SupportsSwitchToSettingsApp())
	end)
end

LinkingProtocol.default = LinkingProtocol.new()

return LinkingProtocol
