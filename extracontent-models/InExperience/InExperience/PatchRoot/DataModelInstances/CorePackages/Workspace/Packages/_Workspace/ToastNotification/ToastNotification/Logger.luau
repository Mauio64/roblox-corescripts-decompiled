local scriptParent = script.Parent
local Lumberyak = require(scriptParent.dependencies).Lumberyak
local Logger = Lumberyak.Logger
local v4 = game:DefineFastString("ToastNotificationEventLoggingLevel", Lumberyak.Logger.Levels.Warning)
local v5 = Logger.new(nil, "ToastNotification")

v5:setContext({
	prefix = "[ToastNotification] - "
})
v5:addSink({
	maxLevel = v4,
	log = function(_, p2, _) -- line: 16
		print(p2)
	end
})

return v5
