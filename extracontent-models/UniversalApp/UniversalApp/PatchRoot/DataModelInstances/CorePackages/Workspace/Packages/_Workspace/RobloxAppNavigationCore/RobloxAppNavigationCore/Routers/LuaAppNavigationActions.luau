local t1 = {
	ClearAppScreensAction = "ClearAppScreensAction"
}

function t1.clearAppScreens(t2: {[any]: any}) -- line: 9
	-- upvalues: t1 (copy)
	return {
		type = t1.ClearAppScreensAction,
		routeNames = t2
	}
end

return t1
