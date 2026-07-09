local ParentParent = script.Parent.Parent
local MessageBusService = game:GetService("MessageBusService")

require(ParentParent.MessageBus)

local Promise = require(ParentParent.Promise)
local getFFlagEnableToSwitchToSettingsAppWithRouteLua = require(script.Parent.Flags.getFFlagEnableToSwitchToSettingsAppWithRouteLua)

require(script.Parent.LinkingProtocolTypes)
require(script.Parent.Enums.SettingsRoute)

local LinkingService = require(ParentParent.MockableProxyServices).LinkingService
local t1 = {}

t1.__index = t1

function t1.new() -- line: 30
	-- upvalues: t1 (copy)
	return (setmetatable({
		isListeningForURLs = false,
		urlConnection = nil
	}, t1))
end
function t1.registerURL(_: {[any]: any}, s1: string) -- line: 45
	-- upvalues: LinkingService (copy)
	LinkingService:RegisterLuaUrl(s1)
end
function t1.getUID(_) -- line: 60
	-- upvalues: Promise (copy), MessageBusService (copy)
	if not game:GetEngineFeature("EnableAppflyerUIDReporting") then
		return Promise.resolve("")
	end

	return Promise.new(function(resolve, _) -- line: 65
		-- upvalues: MessageBusService (copy)
		MessageBusService:MakeRequest("Linking", "getUID", {}, function(t3: {[any]: any}) -- line: 66
			-- upvalues: resolve (copy)
			resolve(t3.uid)
		end, {})
	end)
end
function t1.detectURL(_: {[any]: any}, s2: string) -- line: 79
	-- upvalues: LinkingService (copy)
	LinkingService:DetectUrl(s2)
end
function t1.getLastLuaURL(_) -- line: 89
	-- upvalues: LinkingService (copy)
	return LinkingService:GetLastLuaUrl()
end
function t1.listenForLuaURLs(t5: {[any]: any}, p4: ((...any) -> ...any), _: boolean?) -- line: 101
	-- upvalues: LinkingService (copy)
	t5:stopListeningForLuaURLs()
	t5.urlConnection = LinkingService.OnLuaUrl:Connect(function(p5, _, p7) -- line: 103
		-- upvalues: p4 (copy)
		p4(p5, p7)
	end)
	t5.isListeningForURLs = true

	local v16 = LinkingService:StartLuaUrlDelivery()

	if v16 and v16.url then
		p4(v16.url, v16.attributionUrl)
	end
end
function t1.stopListeningForLuaURLs(p8) -- line: 118
	-- upvalues: LinkingService (copy)
	if p8.isListeningForURLs then
		p8.urlConnection:Disconnect()
		LinkingService:StopLuaUrlDelivery()
		p8.isListeningForURLs = false
	end
end
function t1.openURL(_: {[any]: any}, s3: string) -- line: 142
	-- upvalues: Promise (copy), LinkingService (copy)
	return Promise.new(function(resolve, _) -- line: 143
		-- upvalues: LinkingService (copy), s3 (copy)
		resolve(LinkingService:OpenUrl(s3))
	end)
end
function t1.isURLRegistered(_: {[any]: any}, s4: string) -- line: 166
	-- upvalues: Promise (copy), LinkingService (copy)
	return Promise.new(function(resolve, _) -- line: 167
		-- upvalues: LinkingService (copy), s4 (copy)
		resolve(LinkingService:IsUrlRegistered(s4))
	end)
end
function t1.getAndClearLastPendingURL(_) -- line: 181
	-- upvalues: Promise (copy), LinkingService (copy)
	if not game:GetEngineFeature("LinkingProtocolGetLastPendingUrlEnabled") then
		return Promise.resolve({
			hasPendingUrl = false
		})
	end

	return Promise.new(function(resolve, _) -- line: 188
		-- upvalues: LinkingService (copy)
		resolve(LinkingService:GetAndClearLastPendingUrl())
	end)
end
function t1.switchToSettingsApp(_, p14) -- line: 199
	-- upvalues: getFFlagEnableToSwitchToSettingsAppWithRouteLua (copy), Promise (copy), LinkingService (copy)
	local v25 = if not getFFlagEnableToSwitchToSettingsAppWithRouteLua() then nil else p14

	return Promise.new(function(resolve, _) -- line: 201
		-- upvalues: LinkingService (copy), v25 (copy)
		resolve(LinkingService:SwitchToSettingsApp(v25))
	end)
end
function t1.supportsSwitchToSettingsApp(_, _) -- line: 213
	-- upvalues: Promise (copy), LinkingService (copy)
	return Promise.new(function(resolve, _) -- line: 214
		-- upvalues: LinkingService (copy)
		resolve(LinkingService:SupportsSwitchToSettingsApp())
	end)
end

t1.default = t1.new()

return t1
