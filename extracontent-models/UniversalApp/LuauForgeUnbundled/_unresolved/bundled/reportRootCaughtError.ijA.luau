local function reportRootCaughtError(p2, p3)
	local v5 = "[LuaAppRootErrorBoundary]"

	if p3 then
		v5 ..= p3
	end

	local v6

	if typeof(p2) == "table" and p2.message ~= nil and p2.stack ~= nil then
		v6 = v5 .. "\n------ Error caught by React ------\n" .. tostring(p2.message) .. "\n------ Error caught by React ------\n" .. tostring(p2.stack)
	else
		v6 = tostring(p2) .. "\n" .. v5
	end

	task.spawn(function()
		error(v6, 0)
	end)
end

return reportRootCaughtError
