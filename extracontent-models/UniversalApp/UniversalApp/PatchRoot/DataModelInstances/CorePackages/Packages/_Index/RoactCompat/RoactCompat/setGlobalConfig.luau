local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local warnOnce = require(script.Parent.warnOnce)

return function(_) -- line: 21
	-- upvalues: ReactGlobals (copy), warnOnce (copy)
	if ReactGlobals.__DEV__ and ReactGlobals.__COMPAT_WARNINGS__ then
		warnOnce("setGlobalConfig", "Roact 17 uses a `ReactGlobals.__DEV__` flag to enable development behavior. If you're seeing this warning, you already have it enabled. Please remove any redundant uses of `setGlobalConfig`.")
	end
end
