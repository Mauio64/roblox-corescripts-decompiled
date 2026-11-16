local parent = script:FindFirstAncestor("GameCollections").Parent

local DiscoveryTypes = require(parent.DiscoveryTypes)
local GameCollectionItemTypes = DiscoveryTypes.GameCollectionItemTypes

local React = require(parent.React)

local memo = React.memo(function(p)
	return React.createElement("Frame", { BackgroundTransparency = 1, LayoutOrder = p.index })
end)

return function(p)
	return React.createElement(memo, p), GameCollectionItemTypes.GameCollectionItemType.Blank
end
