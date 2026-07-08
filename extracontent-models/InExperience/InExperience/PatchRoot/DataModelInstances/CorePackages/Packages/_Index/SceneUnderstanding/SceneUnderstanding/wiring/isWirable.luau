local function isWirable(p1) -- line: 1
	return (pcall(function() -- line: 2
		-- upvalues: p1 (copy)
		local v3 = p1

		v3:GetInputPins()
		v3:GetOutputPins()
		v3:GetConnectedWires("Foo")
	end))
end

return isWirable
