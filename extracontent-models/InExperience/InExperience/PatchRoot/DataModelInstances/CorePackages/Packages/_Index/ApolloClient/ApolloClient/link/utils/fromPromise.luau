local FromPromise = {}
local parent = script.Parent.Parent.Parent.Parent

require(parent.LuauPolyfill)

local utilities = require(script.Parent.Parent.Parent.utilities)

local observable = utilities.Observable

function FromPromise.fromPromise(object)
	return observable.new(function(object2)
		object:andThen(function(p)
			object2:next(p)
			object2:complete()
		end):catch(function(p)
			object2.error(object2, p)
		end)
	end)
end

return FromPromise
