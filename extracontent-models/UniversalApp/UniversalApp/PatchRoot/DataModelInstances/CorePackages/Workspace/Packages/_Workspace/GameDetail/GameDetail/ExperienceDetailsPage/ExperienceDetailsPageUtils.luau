local Parent = script:FindFirstAncestor("GameDetail").Parent

require(Parent.Navigation)

return {
	getFromPropsOrNavigationParams = function(t1: {[any]: any}, s1: string) -- line: 12
		local v4 = t1.navigation and t1.navigation.getParam("extraProps")

		return t1[s1] or v4 and v4[s1]
	end,
	getUniverseId = function(t2: {[any]: any}) -- line: 18
		local v6 = t2.navigation and t2.navigation.getParam("extraProps")
		local v7 = t2.universeId or v6 and v6.universeId

		if v7 then
			return v7
		end

		return t2.navigation and t2.navigation.getParam("detail")
	end,
	getAnalyticsSource = function(t3: {[any]: any}) -- line: 26
		local v9 = t3.navigation and t3.navigation.getParam("extraProps")

		return t3.source or v9 and v9.source or "None"
	end,
	getTilePositionIndex = function(t4: {[any]: any}) -- line: 30
		local v11 = t4.navigation and t4.navigation.getParam("extraProps")
		local v12 = t4.index or v11 and v11.index

		if type(v12) == "number" then
			return v12
		end

		if type(v12) == "string" then
			local num = tonumber(v12)

			if num then
				return num
			end
		end

		return -1
	end,
	getResolvedIdentifier = function(s2: string, s3: string) -- line: 45
		return s2 .. "_" .. s3
	end
}
