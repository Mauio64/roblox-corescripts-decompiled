local GameInvite = script:FindFirstAncestor("GameInvite")
local GameInviteParent = GameInvite.Parent
local React = require(GameInviteParent.React)
local useLocalization = require(GameInviteParent.Localization).Hooks.useLocalization
local MarketplaceService = game:GetService("MarketplaceService")
local Foundation = require(GameInviteParent.Foundation)
local IconButton = Foundation.IconButton
local IconSize = Foundation.Enums.IconSize
local GameInviteRewardsInfoModal = require(GameInvite.Components.GameInviteRewardsInfoModal)
local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")

local function v12(n1: number) -- line: 29
	-- upvalues: GroupService (copy), Players (copy)
	local s1 = ""

	if n1 == nil or n1 == 0 then
		return ""
	end

	if game.CreatorType == Enum.CreatorType.Group then
		local ok, result = pcall(function() -- line: 35
			-- upvalues: GroupService (copy), n1 (copy)
			return GroupService:GetGroupInfoAsync(n1)
		end)

		if not ok then
			s1 = ""
		end

		if result then
			return result.Name
		end
	elseif game.CreatorType == Enum.CreatorType.User then
		local ok

		ok, s1 = pcall(function() -- line: 46
			-- upvalues: Players (copy), n1 (copy)
			return Players:GetNameFromUserIdAsync(n1)
		end)

		if not ok then
			s1 = ""
		end
	end

	return s1
end

return function(t1: {[any]: any}) -- line: 56
	-- upvalues: useLocalization (copy), MarketplaceService (copy), v12 (copy), React (copy), GameInviteRewardsInfoModal (copy), Foundation (copy), IconButton (copy), IconSize (copy)
	local v19 = useLocalization({
		rewardsModalTitle = "Roblox.ReferralRewards.RewardBannerModalTitle",
		rewardsDetailsTitle = "Roblox.ReferralRewards.RewardBannerModalRewardDetails",
		rewardsLimitsTitle = "Roblox.ReferralRewards.AdditionalCreatorTerms",
		rewardsExpiresText = "Roblox.ReferralRewards.Expires",
		rewardsTerms = "Roblox.ReferralRewards.ReferralProgramTerms",
		rewardsHeader = {
			"Roblox.ReferralRewards.RewardBannerHeader",
			rewardName = t1.rewardMetadata and t1.rewardMetadata.name or ""
		},
		rewardsBody = {
			"Roblox.ReferralRewards.RewardBannerBody",
			gameName = (game.PlaceId == nil or game.PlaceId == 0) and "" or if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then MarketplaceService:GetProductInfo(game.PlaceId).Name else MarketplaceService:GetProductInfoAsync(game.PlaceId).Name,
			rewardName = t1.rewardMetadata and t1.rewardMetadata.name or ""
		},
		rewardsCreatorSupportText = {
			"Roblox.ReferralRewards.RewardBannerModalCreatorSupport",
			creatorName = game.CreatorId ~= nil and (game.CreatorId ~= 0 and v12(game.CreatorId)) or ""
		}
	})
	local v20, v21 = React.useState(false)

	return React.createElement(React.Fragment, nil, {
		RewardInfoModal = v20 and (not not t1.rewardMetadata and (not not v19 and React.createElement(GameInviteRewardsInfoModal, {
			title = v19.rewardsModalTitle,
			rewardDetailsTitle = v19.rewardsDetailsTitle,
			rewardDetailsBody = t1.rewardMetadata.description or "",
			rewardLimitsTitle = v19.rewardsLimitsTitle,
			rewardLimitsBody = t1.rewardMetadata.limits or "",
			rewardCreatorSupportText = v19.rewardsCreatorSupportText,
			rewardsExpiresText = v19.rewardsExpiresText,
			rewardsTerms = v19.rewardsTerms,
			expiryUtc = t1.rewardMetadata.rewardTimeOffset.endUtc or "",
			modalOpen = v20,
			setModalOpen = v21
		}))) or nil,
		RewardBannerContainer = React.createElement(Foundation.View, {
			tag = "row padding-x-xxlarge size-full-0 auto-y items-center",
			layoutOrder = t1.layoutOrder
		}, {
			RewardBannerCard = React.createElement(Foundation.View, {
				tag = "row size-full-0 auto-y wrap bg-surface-300 gap-medium padding-medium radius-medium align-y-top"
			}, {
				RewardIcon = t1.rewardMetadata and (t1.rewardMetadata.iconAssetId ~= nil and (t1.rewardMetadata.iconAssetId ~= "" and React.createElement(Foundation.Image, {
					tag = "col shrink size-1200-1200 radius-medium self-end",
					LayoutOrder = 0,
					Image = "rbxassetid://" .. t1.rewardMetadata.iconAssetId
				}))) or nil,
				RewardTextContainer = React.createElement(Foundation.View, {
					tag = "col fill auto-xy items-start",
					LayoutOrder = 1
				}, {
					Text = React.createElement(Foundation.Text, {
						tag = "auto-xy text-title-medium text-wrap text-align-x-left",
						LayoutOrder = 0,
						Text = v19.rewardsHeader
					}),
					Subtext = React.createElement(Foundation.Text, {
						tag = "auto-xy text-body-small text-wrap text-align-x-left",
						LayoutOrder = 1,
						Text = v19.rewardsBody
					})
				}),
				RewardInfoButtonView = React.createElement(Foundation.View, {
					tag = "col auto-xy items-end",
					LayoutOrder = 2
				}, {
					RewardInfoButton = React.createElement(IconButton, {
						testId = "RewardInfoButton",
						icon = "icons/actions/info_small",
						size = IconSize.Small,
						onActivated = function() -- line: 142
							-- upvalues: v21 (copy)
							v21(true)
						end
					})
				})
			})
		})
	})
end
