return {
	deprecate = function(callback, value, value2)
		return function(...)
			if value then
				warn(("[http] %s deprecated in version %s. See documentation at http://requests.paric.xyz/"):format(
					value2,
					value or "Function"
				))
			else
				warn(("[http] %s deprecated. See documentation at http://requests.paric.xyz/"):format(value2 or "Function"))
			end

			return callback(...)
		end
	end
}
