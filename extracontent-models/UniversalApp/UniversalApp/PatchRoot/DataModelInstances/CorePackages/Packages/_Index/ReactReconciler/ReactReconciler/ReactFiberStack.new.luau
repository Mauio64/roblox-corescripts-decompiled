local ParentParent = script.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local console = require(ParentParent.Shared).console

require(script.Parent.ReactInternalTypes)

local t1 = {}
local t2 = {}
local t3 = nil

if ReactGlobals.__DEV__ then
	t3 = {}
end

local n1 = 0

return {
	createCursor = function(p1) -- line: 36
		return {
			current = p1
		}
	end,
	isEmpty = function() -- line: 42
		-- upvalues: n1 (ref)
		return n1 == 0
	end,
	pop = function(t4: {[any]: any}, p2) -- line: 46
		-- upvalues: n1 (ref), ReactGlobals (copy), console (copy), t3 (ref), t2 (copy), t1 (copy)
		if n1 < 1 then
			if ReactGlobals.__DEV__ then
				console.error("Unexpected pop.")
			end

			return
		end

		if ReactGlobals.__DEV__ and p2 ~= t3[n1] then
			console.error("Unexpected Fiber popped.")
		end

		local v11 = t2[n1]

		if v11 == t1 then
			t4.current = nil
		else
			t4.current = v11
		end

		t2[n1] = nil

		if ReactGlobals.__DEV__ then
			t3[n1] = nil
		end

		n1 -= 1
	end,
	push = function(t5: {[any]: any}, p3, p4) -- line: 78
		-- upvalues: n1 (ref), t2 (copy), t1 (copy), ReactGlobals (copy), t3 (ref)
		n1 += 1

		local current = t5.current

		if current == nil then
			t2[n1] = t1
		else
			t2[n1] = current
		end

		if ReactGlobals.__DEV__ then
			t3[n1] = p4
		end

		t5.current = p3
	end,
	checkThatStackIsEmpty = function() -- line: 95
		-- upvalues: ReactGlobals (copy), n1 (ref), console (copy)
		if ReactGlobals.__DEV__ and n1 ~= 0 then
			console.error("Expected an empty stack. Something was not reset properly.")
		end
	end,
	resetStackAfterFatalErrorInDev = function() -- line: 103
		-- upvalues: ReactGlobals (copy), n1 (ref), t2 (copy), t3 (ref)
		if ReactGlobals.__DEV__ then
			n1 = 0
			table.clear(t2)
			table.clear(t3)
		end
	end
}
