local lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/dependencies").Lumberyak
local logger = lumberyak.Logger

local defineFastString = game:DefineFastString(
	"ToastNotificationEventLoggingLevel",
	lumberyak.Logger.Levels.Warning
)

local v5 = logger.new(nil, "ToastNotification")

v5:setContext({ prefix = "[ToastNotification] - " })
v5:addSink({
	maxLevel = defineFastString,
	log = function(p2, p3, p4)
		print(p3)
	end
})

return v5
