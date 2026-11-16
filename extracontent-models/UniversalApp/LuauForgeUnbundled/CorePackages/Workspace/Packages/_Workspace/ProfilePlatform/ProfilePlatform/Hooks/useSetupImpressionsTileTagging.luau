local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local impressionsTagUtility = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Impressions").ImpressionsTagUtility

local function useSetupImpressionsTileTagging(p2, p3, p4)
	React.useEffect(function()
		impressionsTagUtility.AddTag(p2, p3, p4)
		return function()
			impressionsTagUtility.RemoveTag(p2, p3, p4)
		end
	end, { p2, p3, p4 })
end
return useSetupImpressionsTileTagging
