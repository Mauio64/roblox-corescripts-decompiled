local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local SetGameDetailsPeekViewState = require(Modules.LuaApp.Actions.Games.SetGameDetailsPeekViewState)

return function(p1, p2) -- line: 7
	-- upvalues: PeekViewState (copy), SetGameDetailsPeekViewState (copy), Cryo (copy)
	local v8 = p1 or {
		viewState = PeekViewState.Closed
	}

	if p2.type == SetGameDetailsPeekViewState.name then
		v8 = Cryo.Dictionary.join(v8, {
			viewState = p2.viewState
		})
	end

	return v8
end
