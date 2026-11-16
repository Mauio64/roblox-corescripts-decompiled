return {
	new = function(p)
		local v = {}

		setmetatable(v, {
			__tostring = function(): string
				return "Service(PublicBindables)"
			end
		})

		function v.getWindowStateChangedBindable()
			return p.windowStateChangedBindable
		end

		return v
	end
}
