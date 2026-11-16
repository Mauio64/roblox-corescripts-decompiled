local ActionBindableEvent = require(script.Parent.ActionBindableEvent)

return function(callback, _)
	return function(p)
		ActionBindableEvent:Fire(p)
		callback(p)
	end
end
