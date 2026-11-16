local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)

local adUpsellVisibilityUtils = require(script.Parent.adUpsellVisibilityUtils)
require(script.Parent.AdUpsellMilestoneView)
local FFlagBuildAgentAdCampaignCard = require(BuildExperience.Flags.FFlagBuildAgentAdCampaignCard)
local FFlagBuildAdUpsellPinned = require(BuildExperience.Flags.FFlagBuildAdUpsellPinned)

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

			local v = {}
			local flag = false
			local function disconnectListeners() -- 1 equivalent call inferred from this helper
				if flag then
					return
				end

				flag = true

				for _, connection in v do
					connection:Disconnect()
				end

				table.clear(v)
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
					disconnectListeners() -- inferred equivalent call
				end
			end
			v = {
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

	local v = {
		order = data.order,
		congratsText = data.congratsText,
		freePromotionsRemaining = 0,
		cardRef = 0,
		isCreatePending = 0,
		isCreateDisabled = 0,
		onCreate = 0,
		onDismiss = 0
	}
	local freePromotionsRemaining

	if FFlagBuildAgentAdCampaignCard then
		freePromotionsRemaining = data.freePromotionsRemaining
	end

	v.freePromotionsRemaining = freePromotionsRemaining
	v.cardRef = ref
	v.isCreatePending = data.isCreatePending
	v.isCreateDisabled = data.isCreateDisabled
	v.onCreate = data.onCreate
	v.onDismiss = data.onDismiss
	return v
end

return useAdUpsellMilestoneViewModel
