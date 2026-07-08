local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(script.Parent.console)
local ReactSymbols = require(script.Parent.ReactSymbols)
local REACT_CONTEXT_TYPE = ReactSymbols.REACT_CONTEXT_TYPE
local REACT_FORWARD_REF_TYPE = ReactSymbols.REACT_FORWARD_REF_TYPE
local REACT_FRAGMENT_TYPE = ReactSymbols.REACT_FRAGMENT_TYPE
local REACT_PORTAL_TYPE = ReactSymbols.REACT_PORTAL_TYPE
local REACT_MEMO_TYPE = ReactSymbols.REACT_MEMO_TYPE
local REACT_PROFILER_TYPE = ReactSymbols.REACT_PROFILER_TYPE
local REACT_PROVIDER_TYPE = ReactSymbols.REACT_PROVIDER_TYPE
local REACT_STRICT_MODE_TYPE = ReactSymbols.REACT_STRICT_MODE_TYPE
local REACT_SUSPENSE_TYPE = ReactSymbols.REACT_SUSPENSE_TYPE
local REACT_SUSPENSE_LIST_TYPE = ReactSymbols.REACT_SUSPENSE_LIST_TYPE
local REACT_LAZY_TYPE = ReactSymbols.REACT_LAZY_TYPE
local REACT_BLOCK_TYPE = ReactSymbols.REACT_BLOCK_TYPE

require(script.Parent.ReactTypes)

local describeError = require(script.Parent["ErrorHandling.roblox"]).describeError

local function getWrappedName(p1, p2, s1: string) -- line: 44
	local s2 = "<function>"

	if typeof(p2) == "table" then
		s2 = p2.displayName or (p2.name or "")
	end

	return p1.displayName or (s2 ~= "" and string.format("%s(%s)", s1, s2) or s1)
end
local function getContextName(p3) -- line: 57
	return p3.displayName or "Context"
end
local function getComponentName(p4) -- line: 61
	-- upvalues: ReactGlobals (copy), console (copy), REACT_FRAGMENT_TYPE (copy), REACT_PORTAL_TYPE (copy), REACT_PROFILER_TYPE (copy), REACT_STRICT_MODE_TYPE (copy), REACT_SUSPENSE_TYPE (copy), REACT_SUSPENSE_LIST_TYPE (copy), REACT_CONTEXT_TYPE (copy), REACT_PROVIDER_TYPE (copy), REACT_FORWARD_REF_TYPE (copy), REACT_MEMO_TYPE (copy), getComponentName (copy), REACT_BLOCK_TYPE (copy), REACT_LAZY_TYPE (copy), describeError (copy)
	if p4 == nil then
		return nil
	end

	local v27 = typeof(p4)

	if ReactGlobals.__DEV__ and v27 == "table" and typeof(p4.tag) == "number" then
		console.warn("Received an unexpected object in getComponentName(). This is likely a bug in React. Please file an issue.")
	end

	if v27 == "function" then
		local v28 = debug.info(p4, "n")

		if v28 and string.len(v28) > 0 then
			return v28
		end

		local v29, v30 = debug.info(p4, "sl")

		return string.format("%s:%d", v29, v30)
	end

	if v27 == "string" then
		return p4
	end

	if p4 == REACT_FRAGMENT_TYPE then
		return "Fragment"
	end

	if p4 == REACT_PORTAL_TYPE then
		return "Portal"
	end

	if p4 == REACT_PROFILER_TYPE then
		return "Profiler"
	end

	if p4 == REACT_STRICT_MODE_TYPE then
		return "StrictMode"
	end

	if p4 == REACT_SUSPENSE_TYPE then
		return "Suspense"
	end

	if p4 == REACT_SUSPENSE_LIST_TYPE then
		return "SuspenseList"
	end

	if v27 == "table" then
		local v31 = p4["$$typeof"]

		if v31 == REACT_CONTEXT_TYPE then
			return (p4.displayName or "Context") .. ".Consumer"
		end

		if v31 == REACT_PROVIDER_TYPE then
			return (p4._context.displayName or "Context") .. ".Provider"
		end

		if v31 == REACT_FORWARD_REF_TYPE then
			local render = p4.render
			local s3 = "<function>"

			if typeof(render) == "table" then
				s3 = render.displayName or (render.name or "")
			end

			return p4.displayName or (s3 ~= "" and string.format("%s(%s)", "ForwardRef", s3) or "ForwardRef")
		end

		if v31 == REACT_MEMO_TYPE then
			return getComponentName(p4.type)
		end

		if v31 == REACT_BLOCK_TYPE then
			return getComponentName(p4._render)
		end

		if v31 == REACT_LAZY_TYPE then
			local _payload = p4._payload
			local _init = p4._init
			local ok, result = xpcall(_init, describeError, _payload)

			if ok then
				return getComponentName(result)
			end

			return nil
		end

		if p4.displayName then
			return p4.displayName
		end

		if p4.name then
			return p4.name
		end

		local mt = getmetatable(p4)

		if mt and rawget(mt, "__tostring") then
			return (tostring(p4))
		end
	end

	return nil
end

return getComponentName
