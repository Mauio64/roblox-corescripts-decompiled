local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/RoactUtils")

local FFlagEnableCallCard = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Flags/FFlagEnableCallCard")
local createLazyComponent = RoactUtils.Components.createLazyComponent

local v5 = {
	scheduled_group_up = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components").ScheduledSquadCard
	end),
	group_up = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components").SquadCard.SquadCard
	end)
}

if FFlagEnableCallCard then
	v5.call = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SocialCards/Components/CallCard")
	end)
end

return { CardComponent = v5 }
