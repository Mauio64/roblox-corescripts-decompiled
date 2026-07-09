local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local TopBarSearchSignalContext = require(Modules.LuaApp.Context.TopBarSearchSignalContext)

local function useTopBarSearchSignal() -- line: 9
	-- upvalues: React (copy), TopBarSearchSignalContext (copy)
	local v7 = React.useContext(TopBarSearchSignalContext.Context)

	if v7 then
		return v7
	end

	return nil
end

return useTopBarSearchSignal
