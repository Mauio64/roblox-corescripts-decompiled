local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console

require(ParentParent.LuauPolyfill)

local t1 = {}

local function isCallable(p1) -- line: 29
	if typeof(p1) == "function" then
		return true
	end

	if typeof(p1) == "table" then
		local mt = getmetatable(p1)

		if mt and rawget(mt, "__call") then
			return true
		end

		if p1._isMockFunction then
			return true
		end
	end

	return false
end

local enableProfilerTimer = require(ParentParent.Shared).ReactFeatureFlags.enableProfilerTimer

require(script.Parent.ReactInternalTypes)
require(ParentParent.Shared)

local DidCapture = require(script.Parent.ReactFiberFlags).DidCapture
local u8 = nil
local u9 = nil
local u10 = false

function t1.isDevToolsPresent() -- line: 64
	-- upvalues: ReactGlobals (copy)
	return ReactGlobals.__REACT_DEVTOOLS_GLOBAL_HOOK__ ~= nil
end
function t1.injectInternals(p2) -- line: 68
	-- upvalues: ReactGlobals (copy), console (copy), u8 (ref), u9 (ref)
	if ReactGlobals.__REACT_DEVTOOLS_GLOBAL_HOOK__ == nil then
		return false
	end

	local __REACT_DEVTOOLS_GLOBAL_HOOK__ = ReactGlobals.__REACT_DEVTOOLS_GLOBAL_HOOK__

	if __REACT_DEVTOOLS_GLOBAL_HOOK__.isDisabled then
		return true
	end

	if not __REACT_DEVTOOLS_GLOBAL_HOOK__.supportsFiber then
		if ReactGlobals.__DEV__ then
			console.error("The installed version of React DevTools is too old and will not work with the current version of React. Please update React DevTools. https://reactjs.org/link/react-devtools")
		end

		return true
	end

	local ok, result = pcall(function() -- line: 91
		-- upvalues: u8 (ref), __REACT_DEVTOOLS_GLOBAL_HOOK__ (copy), p2 (copy), u9 (ref)
		u8 = __REACT_DEVTOOLS_GLOBAL_HOOK__.inject(p2)
		u9 = __REACT_DEVTOOLS_GLOBAL_HOOK__
	end)

	if not ok and ReactGlobals.__DEV__ then
		console.error("React instrumentation encountered an error: %s.", result)
	end

	return true
end
function t1.onScheduleRoot(p3, p4) -- line: 107
	-- upvalues: ReactGlobals (copy), u9 (ref), u8 (ref), u10 (ref), console (copy)
	if not ReactGlobals.__DEV__ or not u9 then
		return
	end

	local onScheduleFiberRoot = u9.onScheduleFiberRoot
	local g21 = nil
	local mt = nil
	local v20 = nil

	if typeof(onScheduleFiberRoot) == "function" then
		v20 = true
		g21 = true
	end

	repeat
		if g21 or (g21 or typeof(onScheduleFiberRoot) == "table") then
			if not g21 then
				if not g21 then
					mt = getmetatable(onScheduleFiberRoot)
				end
			end

			repeat
				if g21 or (g21 or (g21 or mt and rawget(mt, "__call"))) then
					if not g21 then
						if not g21 then
							if not g21 then
								v20 = true
							end
						end
					end

					g21 = false

					if v20 then
						local ok, result = pcall(u9.onScheduleFiberRoot, u8, p3, p4)

						if not ok and ReactGlobals.__DEV__ and not u10 then
							u10 = true
							console.error("React instrumentation encountered an error: %s", result)
						end
					end

					return
				end

				if onScheduleFiberRoot._isMockFunction then
					v20 = true
					g21 = true
				end
			until not g21
		end

		v20 = false
		g21 = true
	until not g21
end
function t1.onCommitRoot(p5, p6) -- line: 127
	-- upvalues: u9 (ref), DidCapture (copy), enableProfilerTimer (copy), u8 (ref), ReactGlobals (copy), u10 (ref), console (copy)
	if not u9 then
		return
	end

	local onCommitFiberRoot = u9.onCommitFiberRoot
	local g29 = nil
	local mt = nil
	local v28 = nil

	if typeof(onCommitFiberRoot) == "function" then
		v28 = true
		g29 = true
	end

	repeat
		if g29 or (g29 or typeof(onCommitFiberRoot) == "table") then
			if not g29 then
				if not g29 then
					mt = getmetatable(onCommitFiberRoot)
				end
			end

			repeat
				if g29 or (g29 or (g29 or mt and rawget(mt, "__call"))) then
					if not g29 then
						if not g29 then
							if not g29 then
								v28 = true
							end
						end
					end

					g29 = false

					if v28 then
						local ok, result = pcall(function() -- line: 133
							-- upvalues: p5 (copy), DidCapture (copy), enableProfilerTimer (copy), u9 (ref), u8 (ref), p6 (copy)
							local v40 = bit32.band(p5.current.flags, DidCapture) == DidCapture

							if enableProfilerTimer then
								u9.onCommitFiberRoot(u8, p5, p6, v40)

								return
							end

							u9.onCommitFiberRoot(u8, p5, nil, v40)
						end)

						if not ok and ReactGlobals.__DEV__ and not u10 then
							u10 = true
							console.error("React instrumentation encountered an error: %s", result)
						end
					end

					return
				end

				if onCommitFiberRoot._isMockFunction then
					v28 = true
					g29 = true
				end
			until not g29
		end

		v28 = false
		g29 = true
	until not g29
end
function t1.onCommitUnmount(p7) -- line: 152
	-- upvalues: u9 (ref), u8 (ref), ReactGlobals (copy), u10 (ref), console (copy)
	if not u9 then
		return
	end

	local onCommitFiberUnmount = u9.onCommitFiberUnmount
	local g36 = nil
	local mt = nil
	local v35 = nil

	if typeof(onCommitFiberUnmount) == "function" then
		v35 = true
		g36 = true
	end

	repeat
		if g36 or (g36 or typeof(onCommitFiberUnmount) == "table") then
			if not g36 then
				if not g36 then
					mt = getmetatable(onCommitFiberUnmount)
				end
			end

			repeat
				if g36 or (g36 or (g36 or mt and rawget(mt, "__call"))) then
					if not g36 then
						if not g36 then
							if not g36 then
								v35 = true
							end
						end
					end

					g36 = false

					if v35 then
						local ok, result = pcall(u9.onCommitFiberUnmount, u8, p7)

						if not ok and ReactGlobals.__DEV__ and not u10 then
							u10 = true
							console.error("React instrumentation encountered an error: %s", result)
						end
					end

					return
				end

				if onCommitFiberUnmount._isMockFunction then
					v35 = true
					g36 = true
				end
			until not g36
		end

		v35 = false
		g36 = true
	until not g36
end

return t1
