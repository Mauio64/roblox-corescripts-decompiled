local ParentParent = script.Parent.Parent.Parent
local ReactGlobals = require(ParentParent.ReactGlobals)
local t1 = {}
local u4 = nil

function t1.setExtraStackFrame(s1: string?) -- line: 19
	-- upvalues: ReactGlobals (copy), u4 (ref)
	if ReactGlobals.__DEV__ then
		u4 = s1
	end
end

if ReactGlobals.__DEV__ then
	t1.getCurrentStack = nil

	function t1.getStackAddendum() -- line: 36
		-- upvalues: u4 (ref), t1 (copy)
		local s2 = ""

		if u4 then
			s2 ..= u4
		end

		local getCurrentStack = t1.getCurrentStack

		if getCurrentStack then
			s2 ..= getCurrentStack() or ""
		end

		return s2
	end
end

return t1
