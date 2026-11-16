local function isWirable(p)
	return (pcall(function()
		local v = p
		v:GetInputPins()
		v:GetOutputPins()
		v:GetConnectedWires("Foo")
	end))
end

return isWirable
