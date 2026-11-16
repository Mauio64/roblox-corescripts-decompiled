return function(duration, callback)
	local flag = false
	return function(...)
		if flag then
			return
		end

		flag = true
		task.delay(duration, function()
			flag = false
		end)
		return callback(...)
	end
end
