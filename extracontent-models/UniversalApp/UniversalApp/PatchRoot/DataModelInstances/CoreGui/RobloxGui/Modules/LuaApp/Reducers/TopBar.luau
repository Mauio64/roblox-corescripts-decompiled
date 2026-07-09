local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Immutable = require(Modules.Common.Immutable)
local SetTopBarHeight = require(Modules.LuaApp.Actions.SetTopBarHeight)
local SetStatusBarHeight = require(Modules.LuaApp.Actions.SetStatusBarHeight)
local Constants = require(Modules.LuaApp.Constants)

return function(t1: {[any]: any}?, p1) -- line: 14
	-- upvalues: Constants (copy), SetTopBarHeight (copy), Immutable (copy), SetStatusBarHeight (copy)
	local v8 = t1 or {
		statusBarHeight = 0,
		topBarHeight = Constants.TOP_BAR_SIZE
	}

	assert(v8, "")

	if p1.type == SetTopBarHeight.name then
		if v8.topBarHeight ~= p1.topBarHeight then
			local t2 = {
				topBarHeight = p1.topBarHeight
			}

			return (Immutable.JoinDictionaries(v8, t2))
		end
	elseif p1.type == SetStatusBarHeight.name then
		local t3 = {
			statusBarHeight = p1.statusBarHeight
		}

		v8 = Immutable.JoinDictionaries(v8, t3)
	end

	return v8
end
