local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local Roact = require(CorePackages.Packages.Roact)
local TopBarSearchSignalContext = require(Modules.LuaApp.Context.TopBarSearchSignalContext)

return function(p1) -- line: 24
	-- upvalues: ArgCheck (copy), Roact (copy), TopBarSearchSignalContext (copy)
	ArgCheck.isNotNil(p1, "withTopBarSearchSignal must be passed a render prop")

	return Roact.createElement(TopBarSearchSignalContext.Consumer, {
		render = p1
	})
end
