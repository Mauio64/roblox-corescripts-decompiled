local JoinExperienceAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/JoinExperienceAction")
local PlayExperienceAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/PlayExperienceAction")
local ChatAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/ChatAction")
local ViewProfileAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/ViewProfileAction")
local UnlockExperienceAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/UnlockExperienceAction")

require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")

local result = {}

for k, v5 in { JoinExperienceAction, PlayExperienceAction, ChatAction, ViewProfileAction, UnlockExperienceAction } do
	for k2, v6 in v5 do
		assert(result[k2] == nil, "Duplicate GameJoinCard action key: " .. tostring(k2))
		result[k2] = v6
	end
end

return result
