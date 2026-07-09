local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local React = require(AmpUpsellParent.React)
local ProgressTile = require(script.Parent.ProgressTile)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local IDVStep = require(AmpUpsell.Common.Enums).IDVStep

local function ProgressChecklist(t1: {[any]: any}) -- line: 15
	-- upvalues: useLocalization (copy), IDVStep (copy), React (copy), ProgressTile (copy)
	local v9 = useLocalization({
		connectedMobile = "Verification.Identity.Label.ConnectingToMobile",
		verifyingYou = "Verification.Identity.Label.VerifyingYou",
		waitingForResults = "Verification.Identity.Label.VerificationWaitingForResults",
		updatingRbxProfile = "Verification.Identity.Label.UpdatingRoblox"
	})
	local v10 = t1.latestStepCompleted >= IDVStep.ConnectedMobile
	local v11 = t1.latestStepCompleted >= IDVStep.Verified
	local v12 = t1.latestStepCompleted >= IDVStep.GotResults
	local v13 = t1.latestStepCompleted >= IDVStep.UpdatedRobloxProfile

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, t1.entryHeight * 4),
		LayoutOrder = t1.layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		MobileCheck = React.createElement(ProgressTile, {
			layoutOrder = 1,
			frameHeight = t1.entryHeight,
			finished = v10,
			progressText = v9.connectedMobile
		}),
		VerifiedCheck = React.createElement(ProgressTile, {
			layoutOrder = 2,
			frameHeight = t1.entryHeight,
			finished = v11,
			progressText = v9.verifyingYou
		}),
		GotResultsCheck = React.createElement(ProgressTile, {
			layoutOrder = 3,
			frameHeight = t1.entryHeight,
			finished = v12,
			progressText = v9.waitingForResults
		}),
		UpdateProfileCheck = React.createElement(ProgressTile, {
			layoutOrder = 4,
			frameHeight = t1.entryHeight,
			finished = v13,
			progressText = v9.updatingRbxProfile
		})
	})
end

return ProgressChecklist
