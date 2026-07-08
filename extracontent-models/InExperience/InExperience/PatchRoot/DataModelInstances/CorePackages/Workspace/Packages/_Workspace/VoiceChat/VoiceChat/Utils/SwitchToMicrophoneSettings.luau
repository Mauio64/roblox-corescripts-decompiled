local VoiceChat = script:FindFirstAncestor("VoiceChat")
local dependencies = require(VoiceChat.dependencies)
local Promise = dependencies.Promise
local default = dependencies.LinkingProtocol.LinkingProtocol.default
local SettingsRoute = dependencies.LinkingProtocol.Enums.SettingsRoute

return function() -- line: 9
	-- upvalues: Promise (copy), default (copy), SettingsRoute (copy)
	return Promise.new(function(resolve, reject) -- line: 10
		-- upvalues: default (copy), SettingsRoute (copy)
		default:switchToSettingsApp(SettingsRoute.Microphone):andThen(function() -- line: 12
			-- upvalues: resolve (copy)
			resolve()
		end):catch(function() -- line: 15
			-- upvalues: reject (copy)
			reject()
		end)
	end)
end
