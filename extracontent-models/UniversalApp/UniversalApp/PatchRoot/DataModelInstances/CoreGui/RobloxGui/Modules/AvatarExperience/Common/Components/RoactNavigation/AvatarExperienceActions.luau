local t1 = {
	ClearScreens = "ClearScreens"
}

function t1.clearScreens(t2: {[any]: any}) -- line: 9
	-- upvalues: t1 (copy)
	return {
		type = t1.ClearScreens,
		routeNames = t2
	}
end

return t1
