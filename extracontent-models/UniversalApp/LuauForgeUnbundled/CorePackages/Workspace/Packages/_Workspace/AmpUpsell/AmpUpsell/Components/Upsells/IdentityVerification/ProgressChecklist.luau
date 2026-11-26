local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local ProgressTile = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Components/Upsells/IdentityVerification/ProgressTile")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization
local idvStep = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums").IDVStep

local function ProgressChecklist(props)
	local v5 = useLocalization({
		connectedMobile = "Verification.Identity.Label.ConnectingToMobile",
		verifyingYou = "Verification.Identity.Label.VerifyingYou",
		waitingForResults = "Verification.Identity.Label.VerificationWaitingForResults",
		updatingRbxProfile = "Verification.Identity.Label.UpdatingRoblox"
	})

	local v6 = props.latestStepCompleted >= idvStep.ConnectedMobile
	local v7 = props.latestStepCompleted >= idvStep.Verified
	local v8 = props.latestStepCompleted >= idvStep.GotResults
	local v9 = props.latestStepCompleted >= idvStep.UpdatedRobloxProfile

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 4 * props.entryHeight),
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
			finished = v6,
			progressText = v5.connectedMobile
		}),
		VerifiedCheck = React.createElement(ProgressTile, {
			frameHeight = props.entryHeight,
			layoutOrder = 2,
			finished = v7,
			progressText = v5.verifyingYou
		}),
		GotResultsCheck = React.createElement(ProgressTile, {
			frameHeight = props.entryHeight,
			layoutOrder = 3,
			finished = v8,
			progressText = v5.waitingForResults
		}),
		UpdateProfileCheck = React.createElement(ProgressTile, {
			frameHeight = props.entryHeight,
			layoutOrder = 4,
			finished = v9,
			progressText = v5.updatingRbxProfile
		})
	})
end

return ProgressChecklist
