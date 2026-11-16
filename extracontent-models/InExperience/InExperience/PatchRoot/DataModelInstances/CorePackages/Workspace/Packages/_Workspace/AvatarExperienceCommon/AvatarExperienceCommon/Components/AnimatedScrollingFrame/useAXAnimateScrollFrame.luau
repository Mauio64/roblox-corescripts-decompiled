local UserGameSettings = UserSettings():GetService("UserGameSettings")

local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local AppBlox = require(parent.AppBlox)
local useAnimateScrollViewToSelection = AppBlox.useAnimateScrollViewToSelection
local defineFastInt = game:DefineFastInt("AXAnimatedScrollingFrameScrollTimeMs", 200)

local v = not (defineFastInt > 0) and 0.2 or defineFastInt / 1000

local function useAXAnimateScrollFrame(p, p2: number?)
	return useAnimateScrollViewToSelection(p, UserGameSettings.ReducedMotion and 0 or p2 or v)
end

return useAXAnimateScrollFrame
