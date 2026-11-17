local AdService = game:GetService("AdService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local parent = script.Parent.Parent
local Promise = require(parent.Promise)

local AdsRewardServiceApi = require(script.Parent.AdsRewardServiceApi)

local RewardedVideoAdShowController = {}
RewardedVideoAdShowController.__index = RewardedVideoAdShowController

function RewardedVideoAdShowController.new()
	local v = { adShowsByPlayer = {} }

	setmetatable(v, RewardedVideoAdShowController)
	return v
end

function RewardedVideoAdShowController:abandonAdShow(p, message: string, flag: boolean)
	self.adShowsByPlayer[p] = nil

	if flag then
		error(message, 0)
	end

	return Enum.ShowAdResult.InternalError, message
end

function RewardedVideoAdShowController:onShowRewardedVideoAd(p, productId: number, p2: number?)
	if self.adShowsByPlayer[p] then
		return Enum.ShowAdResult.AdAlreadyShowing
	end

	local v = { productId = productId, resolvePlayback = nil }
	self.adShowsByPlayer[p] = v

	local v2, v3 = AdsRewardServiceApi.validateRewardAndPlacement(productId, p2)

	if not v2 then
		return self:abandonAdShow(p, `Reward validation failed - {v3}`, false)
	end

	if not v2.isValidReward then
		return self:abandonAdShow(p, `Reward is invalid for product id {productId}`, true)
	end

	if p.Parent ~= Players then
		return self:abandonAdShow(p, "Player instance is null in validation callback", false)
	end

	if p2 ~= nil and not v2.isValidPlacement then
		return self:abandonAdShow(p, `AdService:ShowRewardedVideoAdAsync - Invalid placementId '{p2}'`, true)
	end

	local success, result = pcall(function()
		AdService:PlayRewardedVideoAdOnClient(
			p,
			{
				productId = productId,
				productName = v2.productName,
				imageAssetIdString = v2.imageAssetIdString
			},
			p2 or v2.defaultPlacementId
		)
	end)

	if success then
		return Promise.new(function(resolvePlayback)
			v.resolvePlayback = resolvePlayback
		end):expect()
	end

	return self:abandonAdShow(p, `Failed to start playback - {result}`, false)
end

function RewardedVideoAdShowController.onRewardedVideoAdResult(p, p2, p3, p4: string, p5: string)
	local adShow = p.adShowsByPlayer[p2]

	if not (adShow and adShow.resolvePlayback) then
		return
	end

	p.adShowsByPlayer[p2] = nil
	adShow.resolvePlayback(p3)

	if p3 == Enum.ShowAdResult.ShowCompleted then
		task.spawn(function()
			if not RunService:IsStudio() then
				local v, v2 = AdsRewardServiceApi.grantAdReward(p2.UserId, adShow.productId, p4, p5)

				if not v then
					warn(`Failed to grant ad reward: {v2}`)
					return
				end
			end

			AdService:CompleteRewardedVideoGrant(p2.UserId, adShow.productId)
		end)
	end
end

function RewardedVideoAdShowController.onPlayerRemoving(p, p2)
	local adShow = p.adShowsByPlayer[p2]
	p.adShowsByPlayer[p2] = nil

	if adShow and adShow.resolvePlayback then
		adShow.resolvePlayback(Enum.ShowAdResult.ShowInterrupted)
	end
end

return RewardedVideoAdShowController
