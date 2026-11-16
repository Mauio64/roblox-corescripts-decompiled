return function(callback, duration)
	local flag = false

	return function(...)
		if flag then
			return
		end

		flag = true
		callback(...)
		task.delay(duration, function()
			flag = false
		end)
	end
end
