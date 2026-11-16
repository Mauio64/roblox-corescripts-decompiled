local count = 0

return function()
	count += 1
	return ("MOCK-%d"):format(count)
end
