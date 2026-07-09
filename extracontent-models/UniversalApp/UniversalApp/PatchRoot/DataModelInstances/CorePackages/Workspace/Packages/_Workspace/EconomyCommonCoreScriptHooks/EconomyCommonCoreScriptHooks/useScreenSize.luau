local Parent = script:FindFirstAncestor("EconomyCommonCoreScriptHooks").Parent
local React = require(Parent.React)
local ScreenSizeContext = require(script.Parent.ScreenSizeContext)

local function useScreenSize() -- line: 7
	-- upvalues: React (copy), ScreenSizeContext (copy)
	return React.useContext(ScreenSizeContext)
end

return useScreenSize
