local AdService = game:GetService("AdService")
local CoreGui = game:GetService("CoreGui")
local _script = script
local _scriptParent = _script.Parent
local Flags = require(_script.Flags)
local AdPlayerComponent = require(_script.components.AdPlayerComponent)
local AdsDisplayOrder = require(_scriptParent.AdGuiInteractivity).AdsDisplayOrder
local ReactRoblox = require(_scriptParent.ReactRoblox)
local React = require(_scriptParent.React)
local BaseComponent = require(_script.components.BaseComponent)

return {
	["jest.config"] = _script["jest.config"],
	init = function() -- line: 26
		-- upvalues: AdsDisplayOrder (copy), CoreGui (copy), ReactRoblox (copy), AdService (copy), Flags (copy), React (copy), BaseComponent (copy), AdPlayerComponent (copy)
		local ScreenGui = Instance.new("ScreenGui")

		ScreenGui.Name = "RewardedVideoAdPlayer"
		ScreenGui.DisplayOrder = AdsDisplayOrder.AdPlayer
		ScreenGui.IgnoreGuiInset = true
		ScreenGui.ResetOnSpawn = false
		ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		ScreenGui.Parent = CoreGui

		local v12 = ReactRoblox.createRoot(ScreenGui)

		function AdService.onDemandVideoPlayInUI(t1: {[any]: any}) -- line: 37
			-- upvalues: v12 (copy), AdService (copy), Flags (copy), React (copy), BaseComponent (copy), AdPlayerComponent (copy)
			local function onVideoCompleted(p1) -- line: 38
				-- upvalues: v12 (copy), AdService (copy), t1 (copy)
				v12:render(nil)
				AdService:onDemandVideoCompleteFromUI(p1, t1.encryptedAdTrackingData, t1.encryptionMetadata, t1.rewardDetails)
			end

			local v15 = nil

			if Flags.GetEnableLuaRewardTimerUI() and (t1.durationNeededForRewardMs and t1.durationNeededEnum == "Variable") then
				v15 = t1.durationNeededForRewardMs / 1000
			end

			local BindableEvent = Instance.new("BindableEvent")
			local u17 = nil

			v12:render(React.createElement(BaseComponent, {}, { React.createElement(AdPlayerComponent, {
				isEligible = t1.isEligible,
				creativeAssetUrl = t1.creativeAssetUrl,
				durationNeededForReward = if not Flags.GetEnableLuaRewardTimerUI() then nil else v15,
				onVideoFrameLoaded = function(p2) -- line: 66
					-- upvalues: u17 (ref), BindableEvent (copy)
					u17 = p2

					if BindableEvent then
						BindableEvent:Fire()
					end
				end,
				onCancel = function() -- line: 72
					-- upvalues: v12 (copy), AdService (copy), t1 (copy)
					local ShowInterrupted = Enum.ShowAdResult.ShowInterrupted

					v12:render(nil)
					AdService:onDemandVideoCompleteFromUI(ShowInterrupted, t1.encryptedAdTrackingData, t1.encryptionMetadata, t1.rewardDetails)
				end,
				onComplete = function() -- line: 75
					-- upvalues: v12 (copy), AdService (copy), t1 (copy)
					local ShowCompleted = Enum.ShowAdResult.ShowCompleted

					v12:render(nil)
					AdService:onDemandVideoCompleteFromUI(ShowCompleted, t1.encryptedAdTrackingData, t1.encryptionMetadata, t1.rewardDetails)
				end,
				showWhyThisAd = function() -- line: 78
					-- upvalues: AdService (copy)
					AdService:HandleWhyThisAdClicked("advertiserName", "payerName")
				end,
				getReportAdInfo = function() -- line: 81
					-- upvalues: t1 (copy)
					return {
						adUnitName = "Rewarded Video Ad",
						assetId = t1.creativeAssetUrl,
						encryptionMetadata = t1.encryptionMetadata,
						encryptedAdTrackingData = t1.encryptedAdTrackingData
					}
				end
			}) }))

			if not u17 then
				BindableEvent.Event:Wait()
			end

			BindableEvent:Destroy()

			return u17
		end
	end
}
