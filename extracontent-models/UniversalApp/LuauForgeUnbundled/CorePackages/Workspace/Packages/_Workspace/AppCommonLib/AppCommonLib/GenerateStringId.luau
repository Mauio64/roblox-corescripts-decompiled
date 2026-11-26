local count = 0

return function()
	count += 1
	return (tostring(count))
end
