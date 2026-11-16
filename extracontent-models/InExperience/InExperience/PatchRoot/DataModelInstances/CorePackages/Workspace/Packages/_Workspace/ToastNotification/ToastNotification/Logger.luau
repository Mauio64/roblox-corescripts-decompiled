local parent = script.Parent

local dependencies = require(parent.dependencies)

local lumberyak = dependencies.Lumberyak
local logger = lumberyak.Logger

local defineFastString = game:DefineFastString("ToastNotificationEventLoggingLevel", lumberyak.Logger.Levels.Warning)

local v = logger.new(nil, "ToastNotification")

v:setContext({ prefix = "[ToastNotification] - " })
v:addSink({
	maxLevel = defineFastString,
	log = function(_, p, _)
		print(p)
	end
})

return v
