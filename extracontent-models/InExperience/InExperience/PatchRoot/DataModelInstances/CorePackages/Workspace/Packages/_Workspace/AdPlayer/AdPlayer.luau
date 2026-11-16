local AdService = game:GetService("AdService")
local CoreGui = game:GetService("CoreGui")

local script = script
local parent = script.Parent
local AdPlayerComponent = require(script.components.AdPlayerComponent)
local AdGuiInteractivity = require(parent.AdGuiInteractivity)
local AdsDisplayOrder = AdGuiInteractivity.AdsDisplayOrder
local ReactRoblox = require(parent.ReactRoblox)
local React = require(parent.React)
local BaseComponent = require(script.components.BaseComponent)

return {
	["jest.config"] = script["jest.config"],
	init = function()
		local rewardedVideoAdPlayer = Instance.new("ScreenGui")
		rewardedVideoAdPlayer.Name = "RewardedVideoAdPlayer"
		rewardedVideoAdPlayer.DisplayOrder = AdsDisplayOrder.AdPlayer
		rewardedVideoAdPlayer.IgnoreGuiInset = true
		rewardedVideoAdPlayer.ResetOnSpawn = false
		rewardedVideoAdPlayer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		rewardedVideoAdPlayer.Parent = CoreGui

		local root = ReactRoblox.createRoot(rewardedVideoAdPlayer)

		function AdService.onDemandVideoPlayInUI(props)
			local function onVideoCompleted(p) -- 2 equivalent calls inferred from this helper
				root:render(nil)

				AdService:onDemandVideoCompleteFromUI(
					p,
					props.encryptedAdTrackingData,
					props.encryptionMetadata,
					props.rewardDetails
				)
			end

			local bindableEvent = Instance.new("BindableEvent")
			local v = nil
			root:render(React.createElement(BaseComponent, {}, { React.createElement(AdPlayerComponent, {
					isEligible = props.isEligible,
					creativeAssetUrl = props.creativeAssetUrl,
					onVideoFrameLoaded = function(p)
						v = p

						if bindableEvent then
							bindableEvent:Fire()
						end
					end,
					onCancel = function()
						onVideoCompleted(Enum.ShowAdResult.ShowInterrupted) -- inferred equivalent call
					end,
					onComplete = function()
						onVideoCompleted(Enum.ShowAdResult.ShowCompleted) -- inferred equivalent call
					end,
					showWhyThisAd = function()
						AdService:HandleWhyThisAdClicked("advertiserName", "payerName")
					end,
					getReportAdInfo = function()
						return {
							assetId = props.creativeAssetUrl,
							adUnitName = "Rewarded Video Ad",
							encryptionMetadata = props.encryptionMetadata,
							encryptedAdTrackingData = props.encryptedAdTrackingData
						}
					end
				}) }))

			if not v then
				bindableEvent.Event:Wait()
			end

			bindableEvent:Destroy()
			return v
		end
	end
}
