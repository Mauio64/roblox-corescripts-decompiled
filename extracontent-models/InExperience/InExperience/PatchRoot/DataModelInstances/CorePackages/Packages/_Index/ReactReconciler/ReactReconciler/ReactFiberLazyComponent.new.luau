return {
	resolveDefaultProps = function(p1, t1: {[any]: any}) -- line: 14
		if p1 and typeof(p1) == "table" and p1.defaultProps then
			local v3 = table.clone(t1)
			local defaultProps = p1.defaultProps

			for v5, _ in defaultProps do
				if v3[v5] == nil then
					v3[v5] = defaultProps[v5]
				end
			end

			return v3
		end

		return t1
	end
}
