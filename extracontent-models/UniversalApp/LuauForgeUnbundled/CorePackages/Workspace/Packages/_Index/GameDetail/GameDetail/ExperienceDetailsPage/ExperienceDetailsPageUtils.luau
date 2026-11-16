require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/Navigation")

return {
	getFromPropsOrNavigationParams = function(p2, p3)
		local v5 = p2.navigation and p2.navigation.getParam("extraProps")
		return p2[p3] or v5 and v5[p3]
	end,
	getUniverseId = function(p2)
		local v5 = p2.navigation and p2.navigation.getParam("extraProps")
		local universeId = p2.universeId or v5 and v5.universeId

		if universeId then
			return universeId
		end

		return p2.navigation and p2.navigation.getParam("detail")
	end,
	getAnalyticsSource = function(p2)
		local v5 = p2.navigation and p2.navigation.getParam("extraProps")
		return p2.source or v5 and v5.source or "None"
	end,
	getTilePositionIndex = function(p2)
		local v5 = p2.navigation and p2.navigation.getParam("extraProps")
		local index = p2.index or v5 and v5.index

		if type(index) == "number" then
			return index
		end

		local v6 = type(index) == "string" and tonumber(index)

		if v6 then
			return v6
		end

		return -1
	end,
	getResolvedIdentifier = function(p2, p3)
		return p2 .. "_" .. p3
	end
}
