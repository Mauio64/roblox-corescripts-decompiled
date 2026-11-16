local v5 = { ClearAppScreensAction = "ClearAppScreensAction" }

function v5.clearAppScreens(p2)
	return { type = v5.ClearAppScreensAction, routeNames = p2 }
end

return v5
