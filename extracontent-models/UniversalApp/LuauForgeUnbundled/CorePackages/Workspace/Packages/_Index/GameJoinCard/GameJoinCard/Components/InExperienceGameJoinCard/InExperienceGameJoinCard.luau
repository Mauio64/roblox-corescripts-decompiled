local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")

local MobileGameJoinCard = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/MobileGameJoinCard/MobileGameJoinCard")
local useInExperienceGameJoinCardViewModel = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/InExperienceGameJoinCard/useInExperienceGameJoinCardViewModel")
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/InExperienceGameJoinCard/Types")

local function InExperienceGameJoinCard(p2)
	local v5 = useInExperienceGameJoinCardViewModel(p2)
	return React.createElement(MobileGameJoinCard, v5)
end

return InExperienceGameJoinCard
