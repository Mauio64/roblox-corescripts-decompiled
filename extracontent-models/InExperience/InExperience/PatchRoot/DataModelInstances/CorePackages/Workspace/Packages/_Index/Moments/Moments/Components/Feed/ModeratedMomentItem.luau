local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local Players = game:GetService("Players")
local Foundation = require(MomentsParent.Foundation)
local Localization = require(MomentsParent.Localization)
local MomentsCommon = require(MomentsParent.MomentsCommon)

require(MomentsParent.MomentsTypes)

local React = require(MomentsParent.React)
local FoundationImage = Foundation.Image
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local FoundationText = Foundation.Text
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useImageLoadingState = MomentsCommon.Hooks.useImageLoadingState
local useLocalization = Localization.Hooks.useLocalization
local Constants = require(Moments.Constants)
local FormFactor = MomentsCommon.Enums.FormFactor
local FFlagMomentsUseCompositionLibrary = require(Moments.Flags.FFlagMomentsUseCompositionLibrary)
local t1 = {
	moderatedBody = "Feature.Moments.Label.ModeratedRodeoBody",
	unavailableBody = "Feature.Moments.Label.MomentUnavailableDefault"
}

local function ModeratedMomentItem(t2: {[any]: any}) -- line: 37
	-- upvalues: useLocalization (copy), t1 (copy), FFlagMomentsUseCompositionLibrary (copy), useFormFactor (copy), Players (copy), React (copy), useImageLoadingState (copy), FoundationImage (copy), Skeleton (copy), View (copy), Constants (copy), FormFactor (copy), FoundationText (copy)
	local v21 = useLocalization(t1)
	local v22 = nil

	if not FFlagMomentsUseCompositionLibrary then
		v22 = useFormFactor()
	end

	local LocalPlayer = Players.LocalPlayer
	local v24 = if not LocalPlayer then nil else LocalPlayer.UserId
	local v25 = React.useMemo(function() -- line: 46
		-- upvalues: v24 (copy), t2 (copy)
		return v24 ~= nil and t2.creatorId == v24
	end, {
		t2.creatorId,
		v24 or false
	})
	local v26 = "rbxthumb://type=Asset&id=" .. t2.moment.assetId .. "&w=480&h=270"
	local v27 = useImageLoadingState(if not v25 then nil else v26)
	local v28 = nil

	if v25 then
		v28 = React.createElement(FoundationImage, {
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			Image = v26
		}, {
			Skeleton = if v27 then nil else React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1)
			})
		})
	end

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center size-full"
	}, {
		OverlayText = React.createElement(View, {
			tag = "col flex-evenly align-x-center position-center-center anchor-center-center size-full padding-xlarge",
			testId = "--moments-moderated-overlay-text",
			ZIndex = 3,
			sizeConstraint = {
				MaxSize = if not FFlagMomentsUseCompositionLibrary then if v22 == FormFactor.Wide then Constants.MaxSize.BottomUI else nil else Constants.MaxSize.BottomUI
			}
		}, {
			Text = React.createElement(FoundationText, {
				tag = "auto-xy text-wrap",
				LayoutOrder = 1,
				Text = if not v25 then v21.unavailableBody else v21.moderatedBody
			})
		}),
		Overlay = React.createElement(View, {
			tag = "position-center-center anchor-center-center size-full bg-over-media-0",
			ZIndex = 2
		}),
		Content = v28
	})
end

return ModeratedMomentItem
