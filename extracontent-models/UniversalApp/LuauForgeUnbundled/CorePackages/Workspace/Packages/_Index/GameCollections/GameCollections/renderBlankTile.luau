local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes").GameCollectionItemTypes

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")

local memo = React.memo(function(p2)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = p2.index
	})
end)

return function(p2)
	return React.createElement(memo, p2), gameCollectionItemTypes.GameCollectionItemType.Blank
end
