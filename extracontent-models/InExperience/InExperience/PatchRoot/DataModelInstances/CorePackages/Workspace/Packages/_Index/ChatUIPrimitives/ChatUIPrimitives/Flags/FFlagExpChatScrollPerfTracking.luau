local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local FFlagLuaAppPerfTrackerUseLogger = require(Parent.SharedFlags).FFlagLuaAppPerfTrackerUseLogger

return game:DefineFastFlag("ExpChatScrollPerfTracking4", false) and FFlagLuaAppPerfTrackerUseLogger
