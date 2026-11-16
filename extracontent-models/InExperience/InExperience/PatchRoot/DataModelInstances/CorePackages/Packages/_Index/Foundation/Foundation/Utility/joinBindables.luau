local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local React = require(parent.React)
local ReactIs = require(parent.ReactIs)

require(Foundation.Components.Types)

local function joinBindables(items, callback)
	local v = {}
	local v2 = {}
	local flag = false

	for k, item in items do
		if ReactIs.isBinding(item) then
			v[k] = item
			flag = true
		else
			v2[k] = item
		end
	end

	if flag then
		return React.joinBindings(v):map(function(items2)
			local clone = table.clone(v2)

			for k, item in items2 do
				clone[k] = item
			end

			return callback(clone)
		end)
	end

	return callback(v2)
end

return joinBindables
