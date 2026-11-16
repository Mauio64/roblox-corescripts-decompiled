local parent = script:FindFirstAncestor("AmpUpsell").Parent
local Promise = require(parent.Promise)

local MockLinking = {}

MockLinking.__index = MockLinking

function MockLinking.new()
	return (setmetatable({}, MockLinking))
end

function MockLinking.registerURL(_, _: string) end

function MockLinking.detectURL(_, _: string) end

function MockLinking.isInternalDlicEnabled(_): boolean
	return false
end

function MockLinking.createInternalDlic(_, _: string, _: string): string
	return "mock-deeplink-id"
end

function MockLinking.detectDeeplinkIntent(_, _: string) end

function MockLinking.listenForLuaURLs(_, _) end

function MockLinking.stopListeningForLuaURLs(_) end

function MockLinking:openURL(lastOpenedURL: string)
	self.lastOpenedURL = lastOpenedURL
	return Promise.resolve(true)
end

function MockLinking.isURLRegistered(_, _: string)
	return Promise.resolve(true)
end

return MockLinking
