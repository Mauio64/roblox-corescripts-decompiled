local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/React")
local Gifting = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceGifting/Gifting")

local buildGiftItem = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceGifting/AvatarExperienceGifting/Utils/buildGiftItem")

local useGiftEligibility = Gifting.Hooks.useGiftEligibility

local function useAvatarItemGiftEligibility(p2, p3)
	return useGiftEligibility(React.useMemo(function()
		local v6 = buildGiftItem(p2)

		if v6 == nil then
			return nil
		end

		return { v6 }
	end, { p2 }), p3)
end

return useAvatarItemGiftEligibility
