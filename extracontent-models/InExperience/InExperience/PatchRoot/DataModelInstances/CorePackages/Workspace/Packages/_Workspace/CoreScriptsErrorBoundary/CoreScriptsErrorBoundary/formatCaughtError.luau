local function formatCaughtError(p, p2)
	local v = `[CoreScriptsErrorBoundary surface={p2.surface}]`

	if p2.componentStack then
		v ..= p2.componentStack
	end

	if typeof(p) == "table" and p.message ~= nil and p.stack ~= nil then
		return v .. "\n------ Error caught by React ------\n" .. tostring(p.message) .. "\n------ Error caught by React ------\n" .. tostring(p.stack)
	end

	return tostring(p) .. "\n" .. v
end

return formatCaughtError
