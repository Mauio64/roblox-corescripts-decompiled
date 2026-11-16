local PageSessionRodux = script:FindFirstAncestor("PageSessionRodux")
local parent = PageSessionRodux.Parent
local Cryo = require(parent.Cryo)
require(parent.DiscoveryTypes)

local SetPageSessionTimestamp = require(PageSessionRodux.SetPageSessionTimestamp)

return function(options, data)
	local v = options or {}

	if data.type ~= SetPageSessionTimestamp.name then
		return v
	end

	return (Cryo.Dictionary.join(v, { [data.page] = data.timestamp }))
end
