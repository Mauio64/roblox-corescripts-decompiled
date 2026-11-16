local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)

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

local ErrorHandlingroblox = require(script.Parent["ErrorHandling.roblox"])
local describeError = ErrorHandlingroblox.describeError

local function getWrappedName(p, p2, p3: string)
	local displayName = typeof(p2) == "table" and (p2.displayName or p2.name or "") or "<function>"

	local wrappedName = p.displayName

	if not wrappedName then
		if displayName == "" then
			wrappedName = p3
		else
			wrappedName = string.format("%s(%s)", p3, displayName) or p3
		end
	end

	return wrappedName
end

local function getContextName(p)
	return p.displayName or "Context"
end

local function getComponentName(data)
	if data == nil then
		return nil
	end

	local typeName = typeof(data)

	if ReactGlobals.__DEV__ and typeName == "table" and typeof(data.tag) == "number" then
		console.warn("Received an unexpected object in getComponentName(). This is likely a bug in React. Please file an issue.")
	end

	if typeName == "function" then
		local v = debug.info(data, "n")

		if v and string.len(v) > 0 then
			return v
		end

		local v2, v3 = debug.info(data, "sl")
		return string.format("%s:%d", v2, v3)
	else
		if typeName == "string" then
			return data
		end

		if data == REACT_FRAGMENT_TYPE then
			return "Fragment"
		end

		if data == REACT_PORTAL_TYPE then
			return "Portal"
		end

		if data == REACT_PROFILER_TYPE then
			return "Profiler"
		end

		if data == REACT_STRICT_MODE_TYPE then
			return "StrictMode"
		end

		if data == REACT_SUSPENSE_TYPE then
			return "Suspense"
		end

		if data == REACT_SUSPENSE_LIST_TYPE then
			return "SuspenseList"
		end

		if typeName ~= "table" then
			return nil
		end

		local Typeof = data["$$typeof"]

		if Typeof == REACT_CONTEXT_TYPE then
			return (data.displayName or "Context") .. ".Consumer"
		end

		if Typeof == REACT_PROVIDER_TYPE then
			return (data._context.displayName or "Context") .. ".Provider"
		end

		if Typeof == REACT_FORWARD_REF_TYPE then
			local render = data.render
			local displayName = typeof(render) == "table" and (render.displayName or render.name or "") or "<function>"

			return data.displayName
				or displayName ~= "" and string.format("%s(%s)", "ForwardRef", displayName)
				or "ForwardRef"
		end

		if Typeof == REACT_MEMO_TYPE then
			return getComponentName(data.type)
		end

		if Typeof == REACT_BLOCK_TYPE then
			return getComponentName(data._render)
		end

		if Typeof == REACT_LAZY_TYPE then
			local payload = data._payload
			local init = data._init

			local success, result = xpcall(init, describeError, payload)

			if success then
				return getComponentName(result)
			end

			return nil
		else
			if data.displayName then
				return data.displayName
			end

			if data.name then
				return data.name
			end

			local metatable = getmetatable(data)

			if metatable and rawget(metatable, "__tostring") then
				return (tostring(data))
			end
		end

		return nil
	end
end

return getComponentName
