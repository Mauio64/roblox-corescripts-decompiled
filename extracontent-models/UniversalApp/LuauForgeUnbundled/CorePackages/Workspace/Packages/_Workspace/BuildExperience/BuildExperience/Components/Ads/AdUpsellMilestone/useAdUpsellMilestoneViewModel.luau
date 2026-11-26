local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local adUpsellVisibilityUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdUpsellMilestone/adUpsellVisibilityUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Ads/AdUpsellMilestone/AdUpsellMilestoneView")
local FFlagBuildAgentAdCampaignCard = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAgentAdCampaignCard")
local FFlagBuildAdUpsellPinned = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAdUpsellPinned")

local function useAdUpsellMilestoneViewModel(data)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	React.useEffect(function()
		if data.isImpressed then
			ref2.current = data.anchorId
			return
		end

		if ref2.current == data.anchorId then
			return
		end

		local current = ref.current

		if FFlagBuildAdUpsellPinned then
			if current == nil or not data.isPageVisible then
				return
			end

			ref2.current = data.anchorId
			data.onImpression(data.anchorId)
		else
			local current2 = data.scrollingFrameRef and data.scrollingFrameRef.current

			if current2 == nil or current == nil then
				return
			end

			local v5 = {}
			local flag = false
			local function disconnectListeners()
				if flag then
					return
				end

				flag = true

				for k, connection in v5 do
					connection:Disconnect()
				end

				table.clear(v5)
			end
			local function reportIfVisible()
				if
					ref2.current ~= data.anchorId
					and data.isPageVisible
					and current:IsDescendantOf(current2)
					and adUpsellVisibilityUtils.isCardVisibleInScrollViewport(current2, current)
				then
					ref2.current = data.anchorId
					data.onImpression(data.anchorId)

					if flag then
						return
					end

					flag = true

					for k, connection in v5 do
						connection:Disconnect()
					end

					table.clear(v5)
				end
			end
			v5 = {
				current2:GetPropertyChangedSignal("CanvasPosition"):Connect(reportIfVisible),
				current2:GetPropertyChangedSignal("AbsolutePosition"):Connect(reportIfVisible),
				current2:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(reportIfVisible),
				current:GetPropertyChangedSignal("AbsolutePosition"):Connect(reportIfVisible),
				current:GetPropertyChangedSignal("AbsoluteSize"):Connect(reportIfVisible)
			}

			reportIfVisible()
			return disconnectListeners
		end
	end, {
		data.anchorId,
		data.isImpressed,
		data.isPageVisible,
		data.onImpression,
		data.scrollingFrameRef
	})

	local v5 = {
		order = data.order,
		congratsText = data.congratsText,
		freePromotionsRemaining = 0,
		cardRef = 0,
		isCreatePending = 0,
		isCreateDisabled = 0,
		onCreate = 0,
		onDismiss = 0
	}
	local v6 = if FFlagBuildAgentAdCampaignCard then data.freePromotionsRemaining else nil
	v5.freePromotionsRemaining = v6
	v5.cardRef = ref
	v5.isCreatePending = data.isCreatePending
	v5.isCreateDisabled = data.isCreateDisabled
	v5.onCreate = data.onCreate
	v5.onDismiss = data.onDismiss
	return v5
end

return useAdUpsellMilestoneViewModel
