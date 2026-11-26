local module = require("@game/CorePackages/Workspace/Packages/_Index/SocialStopwatch/SocialStopwatch/Events")
require("@game/CorePackages/Workspace/Packages/_Index/SocialStopwatch/SocialStopwatch/Types")

local v5 = require("@game/CorePackages/Workspace/Packages/_Index/SocialStopwatch/SocialStopwatch/initializeStopwatch")()

return {
	Events = module,
	Stopwatch = v5,
	TestUtils = { resetStopwatchState = v5._unsafeClearEventLog }
}
