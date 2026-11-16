local parent = script:FindFirstAncestor("EconomyCommonCoreScriptHooks").Parent
local React = require(parent.React)

local ScreenSizeContext = require(script.Parent.ScreenSizeContext)

local function useScreenSize()
	return React.useContext(ScreenSizeContext)
end

return useScreenSize
