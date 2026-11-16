local Subclassing = {}

local parent = script.Parent.Parent.Parent.Parent

require(parent.LuauPolyfill)

local Observable = require(script.Parent.Observable)
local observable = Observable.Observable

function Subclassing:fixObservableSubclass()
	local function set(p) -- 1 equivalent call inferred from this helper
		self[p] = observable
	end

	set("@@species") -- inferred equivalent call
	return self
end

return Subclassing
