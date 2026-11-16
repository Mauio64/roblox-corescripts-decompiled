local utilities = require(script.Parent.Parent.Parent.utilities)
local observable = utilities.Observable
return {
	fromError = function(p)
		return observable.new(function(object)
			object:error(p)
		end)
	end
}
