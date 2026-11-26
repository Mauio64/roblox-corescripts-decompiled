local UserGameSettings = UserSettings():GetService("UserGameSettings")

local useAnimateScrollViewToSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AppBlox").useAnimateScrollViewToSelection
local defineFastInt = game:DefineFastInt("AXAnimatedScrollingFrameScrollTimeMs", 200)

local v5 = not (defineFastInt > 0) and 0.2 or defineFastInt / 1000

local function useAXAnimateScrollFrame(p2, p3)
	return useAnimateScrollViewToSelection(p2, UserGameSettings.ReducedMotion and 0 or p3 or v5)
end

return useAXAnimateScrollFrame
