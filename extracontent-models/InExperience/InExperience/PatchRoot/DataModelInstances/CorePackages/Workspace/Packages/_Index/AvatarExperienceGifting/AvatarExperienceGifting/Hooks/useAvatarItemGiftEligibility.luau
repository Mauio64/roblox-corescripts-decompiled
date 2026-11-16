local AvatarExperienceGifting = script:FindFirstAncestor("AvatarExperienceGifting")
local parent = AvatarExperienceGifting.Parent

local React = require(parent.React)
local Gifting = require(parent.Gifting)

local buildGiftItem = require(AvatarExperienceGifting.Utils.buildGiftItem)

local useGiftEligibility = Gifting.Hooks.useGiftEligibility

local function useAvatarItemGiftEligibility(p: string?, p2)
	return useGiftEligibility(React.useMemo(function()
		local giftItem = buildGiftItem(p)

		if giftItem == nil then
			return nil
		end

		return { giftItem }
	end, { p }), p2)
end

return useAvatarItemGiftEligibility
