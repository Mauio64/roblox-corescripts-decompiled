local Promise = require(script.Parent.Parent.Parent.Promise)

return function()
	return Promise.defer(function(callback)
		callback(nil)
	end)
end
