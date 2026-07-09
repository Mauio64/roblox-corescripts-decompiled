local Parent = script:FindFirstAncestor("GameCollections").Parent
local GameCollectionItemTypes = require(Parent.DiscoveryTypes).GameCollectionItemTypes
local React = require(Parent.React)
local v4 = React.memo(function(t1: {[any]: any}) -- line: 15
	-- upvalues: React (copy)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = t1.index
	})
end)

return function(t2: {[any]: any}) -- line: 23
	-- upvalues: React (copy), v4 (copy), GameCollectionItemTypes (copy)
	return React.createElement(v4, t2), GameCollectionItemTypes.GameCollectionItemType.Blank
end
