local function resolveNavigationTarget(data)
	if type(data) ~= "table" then
		return nil
	end

	if type(data.action) == "table" and data.action.routeName then
		return data.action.routeName
	end

	if data.routeName then
		return data.routeName
	end

	if type(data.actions) == "table" and data.index then
		return resolveNavigationTarget(data.actions[data.index])
	end

	return nil
end

return resolveNavigationTarget
