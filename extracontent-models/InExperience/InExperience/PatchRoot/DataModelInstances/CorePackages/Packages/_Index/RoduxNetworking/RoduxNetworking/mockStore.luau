return {
	config = function(options)
		local v = options or {}

		local state = v.state or {}
		return {
			dispatch = v.dispatch or function(p, callback)
				if type(callback) == "function" then
					callback(p)
				end
			end,
			getState = function()
				return state
			end,
			setState = function(_, p)
				state = p
			end
		}
	end
}
