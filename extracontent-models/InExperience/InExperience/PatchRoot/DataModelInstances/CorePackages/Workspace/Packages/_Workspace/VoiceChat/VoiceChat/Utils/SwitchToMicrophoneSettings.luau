local VoiceChat = script:FindFirstAncestor("VoiceChat")

local dependencies = require(VoiceChat.dependencies)

local promise = dependencies.Promise
local default = dependencies.LinkingProtocol.LinkingProtocol.default
local settingsRoute = dependencies.LinkingProtocol.Enums.SettingsRoute

return function()
	return promise.new(function(callback, callback2)
		default:switchToSettingsApp(settingsRoute.Microphone):andThen(function()
			callback()
		end):catch(function()
			callback2()
		end)
	end)
end
