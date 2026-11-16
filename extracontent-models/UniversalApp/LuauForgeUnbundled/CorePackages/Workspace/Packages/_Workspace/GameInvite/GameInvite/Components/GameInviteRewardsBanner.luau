local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Localization").Hooks.useLocalization
local MarketplaceService = game:GetService("MarketplaceService")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Foundation")
local iconButton = Foundation.IconButton
local iconSize = Foundation.Enums.IconSize
local GameInviteRewardsInfoModal = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteRewardsInfoModal")
local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")

local function fn(creatorId)
	local v5 = ""

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

		v5 = not success and "" or v5
		return v5
	end

	if game.CreatorType == Enum.CreatorType.User then
		local success, result = pcall(function()
			return Players:GetNameFromUserIdAsync(creatorId)
		end)
		v5 = not success and "" or result
	end

	return v5
end

return function(p2)
	local v5 = useLocalization({
		rewardsModalTitle = "Roblox.ReferralRewards.RewardBannerModalTitle",
		rewardsHeader = {
			"Roblox.ReferralRewards.RewardBannerHeader",
			rewardName = p2.rewardMetadata and p2.rewardMetadata.name or ""
		},
		rewardsBody = {
			"Roblox.ReferralRewards.RewardBannerBody",
			gameName = (game.PlaceId == nil or game.PlaceId == 0) and "" or MarketplaceService:GetProductInfoAsync(game.PlaceId).Name,
			rewardName = p2.rewardMetadata and p2.rewardMetadata.name or ""
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
	local v8 = if state and p2.rewardMetadata and v5 then React.createElement(GameInviteRewardsInfoModal, {
		title = v5.rewardsModalTitle,
		rewardDetailsTitle = v5.rewardsDetailsTitle,
		rewardDetailsBody = p2.rewardMetadata.description or "",
		rewardLimitsTitle = v5.rewardsLimitsTitle,
		rewardLimitsBody = p2.rewardMetadata.limits or "",
		rewardCreatorSupportText = v5.rewardsCreatorSupportText,
		rewardsExpiresText = v5.rewardsExpiresText,
		rewardsTerms = v5.rewardsTerms,
		expiryUtc = p2.rewardMetadata.rewardTimeOffset.endUtc or "",
		modalOpen = state,
		setModalOpen = setState
	}) or nil else nil

	local createElement2 = React.createElement
	local view = Foundation.View
	local v9 = {
		tag = "row padding-x-xxlarge size-full-0 auto-y items-center",
		layoutOrder = p2.layoutOrder
	}

	local createElement3 = React.createElement
	local view2 = Foundation.View

	local v12 = if p2.rewardMetadata and p2.rewardMetadata.iconAssetId ~= nil and p2.rewardMetadata.iconAssetId ~= "" then React.createElement(Foundation.Image, {
		Image = "rbxassetid://" .. p2.rewardMetadata.iconAssetId,
		tag = "col shrink size-1200-1200 radius-medium self-end",
		LayoutOrder = 0
	}) or nil else nil
	return createElement(fragment, nil, {
		RewardInfoModal = v8,
		RewardBannerContainer = createElement2(view, v9, {
			RewardBannerCard = createElement3(
				view2,
				{
					tag = "row size-full-0 auto-y wrap bg-surface-300 gap-medium padding-medium radius-medium align-y-top"
				},
				{
					RewardIcon = v12,
					RewardTextContainer = React.createElement(
						Foundation.View,
						{ tag = "col fill auto-xy items-start", LayoutOrder = 1 },
						{
							Text = React.createElement(Foundation.Text, {
								tag = "auto-xy text-title-medium text-wrap text-align-x-left",
								Text = v5.rewardsHeader,
								LayoutOrder = 0
							}),
							Subtext = React.createElement(Foundation.Text, {
								tag = "auto-xy text-body-small text-wrap text-align-x-left",
								Text = v5.rewardsBody,
								LayoutOrder = 1
							})
						}
					),
					RewardInfoButtonView = React.createElement(
						Foundation.View,
						{ tag = "col auto-xy items-end", LayoutOrder = 2 },
						{
							RewardInfoButton = React.createElement(iconButton, {
								testId = "RewardInfoButton",
								icon = "icons/actions/info_small",
								size = iconSize.Small,
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
