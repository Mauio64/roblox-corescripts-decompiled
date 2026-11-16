local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local React = require(parent.React)
local ProgressTile = require(script.Parent.ProgressTile)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Enums = require(AmpUpsell.Common.Enums)
local IDVStep = Enums.IDVStep

local function ProgressChecklist(props)
	local v = useLocalization({
		connectedMobile = "Verification.Identity.Label.ConnectingToMobile",
		verifyingYou = "Verification.Identity.Label.VerifyingYou",
		waitingForResults = "Verification.Identity.Label.VerificationWaitingForResults",
		updatingRbxProfile = "Verification.Identity.Label.UpdatingRoblox"
	})

	local finished = props.latestStepCompleted >= IDVStep.ConnectedMobile
	local finished2 = props.latestStepCompleted >= IDVStep.Verified
	local finished3 = props.latestStepCompleted >= IDVStep.GotResults
	local finished4 = props.latestStepCompleted >= IDVStep.UpdatedRobloxProfile

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, props.entryHeight * 4),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		MobileCheck = React.createElement(ProgressTile, {
			frameHeight = props.entryHeight,
			layoutOrder = 1,
			finished = finished,
			progressText = v.connectedMobile
		}),
		VerifiedCheck = React.createElement(ProgressTile, {
			frameHeight = props.entryHeight,
			layoutOrder = 2,
			finished = finished2,
			progressText = v.verifyingYou
		}),
		GotResultsCheck = React.createElement(ProgressTile, {
			frameHeight = props.entryHeight,
			layoutOrder = 3,
			finished = finished3,
			progressText = v.waitingForResults
		}),
		UpdateProfileCheck = React.createElement(ProgressTile, {
			frameHeight = props.entryHeight,
			layoutOrder = 4,
			finished = finished4,
			progressText = v.updatingRbxProfile
		})
	})
end

return ProgressChecklist
