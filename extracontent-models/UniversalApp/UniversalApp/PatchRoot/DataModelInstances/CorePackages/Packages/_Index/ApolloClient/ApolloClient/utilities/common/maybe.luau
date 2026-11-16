return {
	maybe = function(callback)
		local _, result, v = xpcall(function()
			return callback(), true
		end, function() end)
		return if v then result else nil
	end
}
