return function(p)
	return function(onEvent)
		p.Event:Connect(onEvent)
	end
end
