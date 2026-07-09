local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local SetSearchBarFocused = require(Modules.LuaApp.Actions.SetSearchBarFocused)

return function(p1, p2) -- line: 6
	-- upvalues: SetSearchBarFocused (copy), Cryo (copy)
	local v7 = p1 or {
		focused = false
	}

	if p2.type == SetSearchBarFocused.name then
		v7 = Cryo.Dictionary.join(v7, {
			focused = p2.focused
		})
	end

	return v7
end
