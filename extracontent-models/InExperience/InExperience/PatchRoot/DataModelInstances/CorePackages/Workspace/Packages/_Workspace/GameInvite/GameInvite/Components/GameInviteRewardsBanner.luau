local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local MarketplaceService = game:GetService("MarketplaceService")
local Foundation = require(parent.Foundation)
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local GameInviteRewardsInfoModal = require(GameInvite.Components.GameInviteRewardsInfoModal)
local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")

local function fn(creatorId: number)
	local v = ""

	if creatorId == nil or creatorId == 0 then
		return ""
	end

	if game.CreatorType == Enum.CreatorType.Group then
		local success, result = pcall(function()
			return GroupService:GetGroupInfoAsync(creatorId)
		end)

		if result then
			return result.Name
		end

		return not success and "" or v
	end

	if game.CreatorType == Enum.CreatorType.User then
		local success, result = pcall(function()
			return Players:GetNameFromUserIdAsync(creatorId)
		end)
		return not success and "" or result
	end

	return v
end

return function(p)
	local v = useLocalization({
		rewardsModalTitle = "Roblox.ReferralRewards.RewardBannerModalTitle",
		rewardsHeader = {
			"Roblox.ReferralRewards.RewardBannerHeader",
			rewardName = p.rewardMetadata and p.rewardMetadata.name or ""
		},
		rewardsBody = {
			"Roblox.ReferralRewards.RewardBannerBody",
			gameName = (game.PlaceId == nil or game.PlaceId == 0) and "" or MarketplaceService:GetProductInfoAsync(game.PlaceId).Name,
			rewardName = p.rewardMetadata and p.rewardMetadata.name or ""
		},
		rewardsDetailsTitle = "Roblox.ReferralRewards.RewardBannerModalRewardDetails",
		rewardsLimitsTitle = "Roblox.ReferralRewards.AdditionalCreatorTerms",
		rewardsCreatorSupportText = {
			"Roblox.ReferralRewards.RewardBannerModalCreatorSupport",
			creatorName = (game.CreatorId == nil or game.CreatorId == 0) and "" or fn(game.CreatorId) or ""
		},
		rewardsExpiresText = "Roblox.ReferralRewards.Expires",
		rewardsTerms = "Roblox.ReferralRewards.ReferralProgramTerms"
	})

	local state, setState = React.useState(false)
	local createElement = React.createElement
	local fragment = React.Fragment
	local rewardInfoModal

	if state and p.rewardMetadata and v then
		rewardInfoModal = React.createElement(GameInviteRewardsInfoModal, {
			title = v.rewardsModalTitle,
			rewardDetailsTitle = v.rewardsDetailsTitle,
			rewardDetailsBody = p.rewardMetadata.description or "",
			rewardLimitsTitle = v.rewardsLimitsTitle,
			rewardLimitsBody = p.rewardMetadata.limits or "",
			rewardCreatorSupportText = v.rewardsCreatorSupportText,
			rewardsExpiresText = v.rewardsExpiresText,
			rewardsTerms = v.rewardsTerms,
			expiryUtc = p.rewardMetadata.rewardTimeOffset.endUtc or "",
			modalOpen = state,
			setModalOpen = setState
		}) or nil
	end

	local createElement2 = React.createElement
	local view = Foundation.View
	local v2 = {
		tag = "row padding-x-xxlarge size-full-0 auto-y items-center",
		layoutOrder = p.layoutOrder
	}

	local createElement3 = React.createElement
	local view2 = Foundation.View
	local rewardIcon

	if p.rewardMetadata and p.rewardMetadata.iconAssetId ~= nil and p.rewardMetadata.iconAssetId ~= "" then
		rewardIcon = React.createElement(Foundation.Image, {
			Image = "rbxassetid://" .. p.rewardMetadata.iconAssetId,
			tag = "col shrink size-1200-1200 radius-medium self-end",
			LayoutOrder = 0
		}) or nil
	end

	return createElement(fragment, nil, {
		RewardInfoModal = rewardInfoModal,
		RewardBannerContainer = createElement2(view, v2, {
			RewardBannerCard = createElement3(
				view2,
				{
					tag = "row size-full-0 auto-y wrap bg-surface-300 gap-medium padding-medium radius-medium align-y-top"
				},
				{
					RewardIcon = rewardIcon,
					RewardTextContainer = React.createElement(
						Foundation.View,
						{ tag = "col fill auto-xy items-start", LayoutOrder = 1 },
						{
							Text = React.createElement(Foundation.Text, {
								tag = "auto-xy text-title-medium text-wrap text-align-x-left",
								Text = v.rewardsHeader,
								LayoutOrder = 0
							}),
							Subtext = React.createElement(Foundation.Text, {
								tag = "auto-xy text-body-small text-wrap text-align-x-left",
								Text = v.rewardsBody,
								LayoutOrder = 1
							})
						}
					),
					RewardInfoButtonView = React.createElement(
						Foundation.View,
						{ tag = "col auto-xy items-end", LayoutOrder = 2 },
						{
							RewardInfoButton = React.createElement(IconButton, {
								testId = "RewardInfoButton",
								icon = "icons/actions/info_small",
								size = IconSize.Small,
								onActivated = function()
									setState(true)
								end
							})
						}
					)
				}
			)
		})
	})
end
