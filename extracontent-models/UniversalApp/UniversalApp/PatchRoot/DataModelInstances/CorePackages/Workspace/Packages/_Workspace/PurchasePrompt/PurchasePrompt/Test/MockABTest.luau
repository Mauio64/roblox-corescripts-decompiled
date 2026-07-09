return {
	new = function(t1: {[any]: any}?) -- line: 9
		local t2 = {}
		local v3 = t1 or {}

		function t2.getLayerData(p1) -- line: 14
			-- upvalues: v3 (copy)
			return v3[p1]
		end
		function t2.logUserLayerExposure(p2) -- line: 18
			-- upvalues: v3 (copy)
			return v3[p2]
		end

		return t2
	end
}
