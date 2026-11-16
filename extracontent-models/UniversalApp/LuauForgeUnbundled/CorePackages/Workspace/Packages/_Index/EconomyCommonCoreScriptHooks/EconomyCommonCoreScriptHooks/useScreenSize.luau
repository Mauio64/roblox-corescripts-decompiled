local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EconomyCommonCoreScriptHooks/React")

local ScreenSizeContext = require("@game/CorePackages/Workspace/Packages/_Index/EconomyCommonCoreScriptHooks/EconomyCommonCoreScriptHooks/ScreenSizeContext")

local function useScreenSize()
	return React.useContext(ScreenSizeContext)
end

return useScreenSize
