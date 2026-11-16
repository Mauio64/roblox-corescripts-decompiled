return function(callback, value)
	local flag = false
	local v5 = value or 1
	return function(...)
		if flag then
			return
		end

		flag = true
		callback(...)
		task.delay(v5, function()
			flag = false
		end)
	end
end
