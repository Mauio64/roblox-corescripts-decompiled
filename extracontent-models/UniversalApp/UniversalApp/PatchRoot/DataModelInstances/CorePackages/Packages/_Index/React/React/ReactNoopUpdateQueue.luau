local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console
local t1 = {}

local function warnNoop(p1, s1: string) -- line: 16
	-- upvalues: ReactGlobals (copy), t1 (copy), console (copy)
	if ReactGlobals.__DEV__ then
		local v8 = p1.__componentName or "ReactClass"
		local v9 = v8 .. "." .. s1

		if t1[v9] then
			return
		end

		console.error("Can't call %s on a component that is not yet mounted. This is a no-op, but it might indicate a bug in your application. Instead, assign to `self.state` directly with the desired state in the %s component's `init` method.", s1, v8)
		t1[v9] = true
	end
end

return {
	isMounted = function(_) -- line: 51
		return false
	end,
	enqueueForceUpdate = function(p3, _, _) -- line: 69
		-- upvalues: ReactGlobals (copy), t1 (copy), console (copy)
		if ReactGlobals.__DEV__ then
			local v14 = p3.__componentName or "ReactClass"
			local v15 = v14 .. "." .. "forceUpdate"

			if t1[v15] then
				return
			end

			console.error("Can't call %s on a component that is not yet mounted. This is a no-op, but it might indicate a bug in your application. Instead, assign to `self.state` directly with the desired state in the %s component's `init` method.", "forceUpdate", v14)
			t1[v15] = true
		end
	end,
	enqueueReplaceState = function(p6, _, _, _) -- line: 85
		-- upvalues: ReactGlobals (copy), t1 (copy), console (copy)
		if ReactGlobals.__DEV__ then
			local v20 = p6.__componentName or "ReactClass"
			local v21 = v20 .. "." .. "replaceState"

			if t1[v21] then
				return
			end

			console.error("Can't call %s on a component that is not yet mounted. This is a no-op, but it might indicate a bug in your application. Instead, assign to `self.state` directly with the desired state in the %s component's `init` method.", "replaceState", v20)
			t1[v21] = true
		end
	end,
	enqueueSetState = function(p10, _, _, _) -- line: 100
		-- upvalues: ReactGlobals (copy), t1 (copy), console (copy)
		if ReactGlobals.__DEV__ then
			local v26 = p10.__componentName or "ReactClass"
			local v27 = v26 .. "." .. "setState"

			if t1[v27] then
				return
			end

			console.error("Can't call %s on a component that is not yet mounted. This is a no-op, but it might indicate a bug in your application. Instead, assign to `self.state` directly with the desired state in the %s component's `init` method.", "setState", v26)
			t1[v27] = true
		end
	end
}
