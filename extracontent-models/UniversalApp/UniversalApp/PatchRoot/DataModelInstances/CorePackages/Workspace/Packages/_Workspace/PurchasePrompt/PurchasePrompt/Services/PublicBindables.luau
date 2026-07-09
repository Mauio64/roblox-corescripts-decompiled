return {
	new = function(t1: {[any]: any}) -- line: 7
		local t2 = {}

		setmetatable(t2, {
			__tostring = function() -- line: 11
				return "Service(PublicBindables)"
			end
		})

		function t2.getWindowStateChangedBindable() -- line: 16
			-- upvalues: t1 (copy)
			return t1.windowStateChangedBindable
		end

		return t2
	end
}
