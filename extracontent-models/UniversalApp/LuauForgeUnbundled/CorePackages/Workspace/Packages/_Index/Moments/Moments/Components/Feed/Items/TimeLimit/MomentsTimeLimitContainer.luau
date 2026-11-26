local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local MomentsTimeLimitView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/TimeLimit/MomentsTimeLimitView")
local useMomentsTimeLimitViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/TimeLimit/useMomentsTimeLimitViewModel")

local function MomentsTimeLimitContainer()
	local v5 = useMomentsTimeLimitViewModel()
	return React.createElement(MomentsTimeLimitView, v5)
end

return MomentsTimeLimitContainer
