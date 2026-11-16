local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/React")

local ImpressionsTagUtility = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsTagUtility")

return function(p2, p3, p4)
	React.useEffect(function()
		ImpressionsTagUtility.AddTag(p2, p3, p4)

		return function()
			ImpressionsTagUtility.RemoveTag(p2, p3, p4)
		end
	end, { p2, p3, p4 })
end
