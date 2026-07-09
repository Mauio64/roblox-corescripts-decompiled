local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local useAnimateScrollViewToSelection = require(Parent.AppBlox).useAnimateScrollViewToSelection
local v4 = game:DefineFastInt("AXAnimatedScrollingFrameScrollTimeMs", 200)
local v5 = not (v4 > 0) and 0.2 or v4 / 1000

local function useAXAnimateScrollFrame(t1: {[any]: any}, n1: number?) -- line: 12
	-- upvalues: useAnimateScrollViewToSelection (copy), UserGameSettings (copy), v5 (copy)
	return useAnimateScrollViewToSelection(t1, if not UserGameSettings.ReducedMotion then n1 or v5 else 0)
end

return useAXAnimateScrollFrame
