local TimeToInteractiveTracker = script:FindFirstAncestor("TimeToInteractiveTracker")

local Logger = require(TimeToInteractiveTracker.Logger)
local v = Logger:new(script.Name)

require(script.Parent.Parent.types)

local mergeTTIEventMetadata = require(script.Parent.Parent.Parent.Utils.mergeTTIEventMetadata)

return function(callback)
	return function(p: string, p2)
		callback(function(p3)
			local v2 = p3[p]

			if v2 == nil then
				v:warning(`called before trackStart for eventName={p}`)
				return p3
			end

			local clone = table.clone(p3)

			local clone2 = table.clone(v2)
			clone2.metadata = mergeTTIEventMetadata(v2.metadata, p2)
			clone[p] = clone2

			return clone
		end)
	end
end
