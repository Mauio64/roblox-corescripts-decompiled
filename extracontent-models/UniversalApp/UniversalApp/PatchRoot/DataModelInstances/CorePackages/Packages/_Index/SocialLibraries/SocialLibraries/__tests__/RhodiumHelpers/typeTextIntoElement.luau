return function(object, value)
	for i = 1, #value do
		object:sendText(value:sub(i, i))
	end

	wait(0)
end
