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
local t1 = {
	moderatedBody = "Feature.Moments.Label.ModeratedRodeoBody",
	unavailableBody = "Feature.Moments.Label.MomentUnavailableDefault"
}

local function ModeratedMomentItem(t2: {[any]: any}) -- line: 36
	-- upvalues: useLocalization (copy), t1 (copy), useFormFactor (copy), Players (copy), React (copy), useImageLoadingState (copy), FoundationImage (copy), Skeleton (copy), View (copy), FormFactor (copy), Constants (copy), FoundationText (copy)
	local v20 = useLocalization(t1)
	local v21 = useFormFactor()
	local LocalPlayer = Players.LocalPlayer
	local v23 = if not LocalPlayer then nil else LocalPlayer.UserId
	local v24 = React.useMemo(function() -- line: 42
		-- upvalues: v23 (copy), t2 (copy)
		return v23 ~= nil and t2.creatorId == v23
	end, {
		t2.creatorId,
		v23 or false
	})
	local v25 = "rbxthumb://type=Asset&id=" .. t2.moment.assetId .. "&w=480&h=270"
	local v26 = useImageLoadingState(if not v24 then nil else v25)
	local v27 = nil

	if v24 then
		v27 = React.createElement(FoundationImage, {
			Size = UDim2.fromScale(1, 1),
			ScaleType = Enum.ScaleType.Crop,
			Image = v25
		}, {
			Skeleton = if v26 then nil else React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1)
			})
		})
	end

	return React.createElement(View, {
		tag = "position-center-center anchor-center-center size-full"
	}, {
		OverlayText = React.createElement(View, {
			tag = "col flex-evenly align-x-center position-center-center anchor-center-center size-full padding-xlarge",
			ZIndex = 3,
			sizeConstraint = {
				MaxSize = if v21 == FormFactor.Wide then Constants.MaxSize.BottomUI else nil
			}
		}, {
			Text = React.createElement(FoundationText, {
				tag = "auto-xy text-wrap",
				LayoutOrder = 1,
				Text = if not v24 then v20.unavailableBody else v20.moderatedBody
			})
		}),
		Overlay = React.createElement(View, {
			tag = "position-center-center anchor-center-center size-full bg-over-media-0",
			ZIndex = 2
		}),
		Content = v27
	})
end

return ModeratedMomentItem
