return {
	new = function(p2)
		local v5 = {}

		setmetatable(v5, {
			__tostring = function(): string
				return "Service(PublicBindables)"
			end
		})

		function v5.getWindowStateChangedBindable()
			return p2.windowStateChangedBindable
		end

		return v5
	end
}
