return {
	resolveDefaultProps = function(p, p2)
		if not p or typeof(p) ~= "table" or not p.defaultProps then
			return p2
		end

		local clone = table.clone(p2)
		local defaultProps = p.defaultProps

		for k, _ in defaultProps do
			if clone[k] == nil then
				clone[k] = defaultProps[k]
			end
		end

		return clone
	end
}
