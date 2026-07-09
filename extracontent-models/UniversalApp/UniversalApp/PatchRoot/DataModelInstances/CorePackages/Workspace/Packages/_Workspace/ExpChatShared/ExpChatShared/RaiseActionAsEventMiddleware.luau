local ActionBindableEvent = require(script.Parent.ActionBindableEvent)

return function(p1, _) -- line: 3
	-- upvalues: ActionBindableEvent (copy)
	return function(p3) -- line: 4
		-- upvalues: ActionBindableEvent (copy), p1 (copy)
		ActionBindableEvent:Fire(p3)
		p1(p3)
	end
end
