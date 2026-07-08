local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local console = LuauPolyfill.console
local Array = LuauPolyfill.Array
local ReactSharedInternals = require(script.Parent.ReactSharedInternals)
local printWarning = nil
local t1 = {
	warn = function(p1, ...) -- line: 26
		-- upvalues: ReactGlobals (copy), printWarning (ref)
		if ReactGlobals.__DEV__ then
			printWarning("warn", p1, { ... })
		end
	end,
	error = function(p2, ...) -- line: 31
		-- upvalues: ReactGlobals (copy), printWarning (ref)
		if ReactGlobals.__DEV__ then
			printWarning("error", p2, { ... })
		end
	end
}

function printWarning(p3, p4, p5) -- line: 37
	-- upvalues: ReactGlobals (copy), ReactSharedInternals (copy), Array (copy), console (copy)
	if ReactGlobals.__DEV__ then
		local v14 = ReactSharedInternals.ReactDebugCurrentFrame.getStackAddendum()

		if v14 ~= "" then
			p4 ..= "%s"
			p5 = Array.slice(p5, 1)
			table.insert(p5, v14)
		end

		local v15 = Array.map(p5, tostring)

		table.insert(v15, 1, "Warning: " .. p4)
		console[p3](unpack(v15))
	end
end

return t1
