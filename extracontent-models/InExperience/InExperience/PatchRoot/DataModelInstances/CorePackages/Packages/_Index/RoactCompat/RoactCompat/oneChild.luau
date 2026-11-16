local parent = script.Parent.Parent
local React = require(parent.React)
local ReactGlobals = require(parent.ReactGlobals)

local warnOnce = require(script.Parent.warnOnce)

local function oneChild(items)
	if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
		warnOnce(
			"oneChild",
			"You likely don't need this at all! If you were assigning children via `React.oneChild(someChildren)`, you can simply use `someChildren` directly."
		)
	end

	if not items then
		return nil
	end

	local v, v2 = next(items)

	if not v2 then
		return nil
	end

	if next(items, v) then
		error("Expected at most one child, had more than one child.", 2)
	end

	return React.Children.only(v2)
end

return oneChild
