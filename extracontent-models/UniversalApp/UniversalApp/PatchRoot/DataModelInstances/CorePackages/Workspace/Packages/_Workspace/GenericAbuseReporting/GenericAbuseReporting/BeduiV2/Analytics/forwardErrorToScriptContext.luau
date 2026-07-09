local function forwardErrorToScriptContext(p1, s1: string?) -- line: 11
	task.spawn(function() -- line: 12
		-- upvalues: s1 (copy), p1 (copy)
		local v4 = not s1 and "" or s1

		error(tostring(p1) .. "\n" .. v4, 0)
	end)
end

return forwardErrorToScriptContext
