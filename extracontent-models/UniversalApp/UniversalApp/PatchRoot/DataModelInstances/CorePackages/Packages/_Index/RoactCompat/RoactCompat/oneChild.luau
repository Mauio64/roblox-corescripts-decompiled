local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local ReactGlobals = require(ParentParent.ReactGlobals)
local warnOnce = require(script.Parent.warnOnce)

local function oneChild(p1) -- line: 22
	-- upvalues: ReactGlobals (copy), warnOnce (copy), React (copy)
	if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
		warnOnce("oneChild", "You likely don't need this at all! If you were assigning children via `React.oneChild(someChildren)`, you can simply use `someChildren` directly.")
	end

	if not p1 then
		return nil
	end

	local v7, v8 = next(p1)

	if not v8 then
		return nil
	end

	if next(p1, v7) then
		error("Expected at most one child, had more than one child.", 2)
	end

	return React.Children.only(v8)
end

return oneChild
