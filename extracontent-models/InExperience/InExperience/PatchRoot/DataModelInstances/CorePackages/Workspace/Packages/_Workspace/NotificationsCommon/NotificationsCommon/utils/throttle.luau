return function(callback, value: number?)
	local flag = false
	local v = value or 1
	return function(...)
		if flag then
			return
		end

		flag = true
		callback(...)
		task.delay(v, function()
			flag = false
		end)
	end
end
