local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local Players = game:GetService("Players")

local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local MomentsCommon = require(parent.MomentsCommon)
require(parent.MomentsTypes)
local React = require(parent.React)

local Image = Foundation.Image
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local Text = Foundation.Text

local useImageLoadingState = MomentsCommon.Hooks.useImageLoadingState
local useLocalization = Localization.Hooks.useLocalization

local Constants = require(Moments.Constants)

local v = {
	moderatedBody = "Feature.Moments.Label.ModeratedRodeoBody",
	unavailableBody = "Feature.Moments.Label.MomentUnavailableDefault"
}

local function ModeratedMomentItem(p)
	local v2 = useLocalization(v)
	local localPlayer = Players.LocalPlayer
	local userId

	if localPlayer then
		userId = localPlayer.UserId
	else
		userId = nil
	end

	local v3 = React.useMemo(function(): boolean
		return userId ~= nil and p.creatorId == userId
	end, { p.creatorId, userId or false })

	local image = "rbxthumb://type=Asset&id=" .. p.moment.assetId .. "&w=480&h=270"
	local v4

	if v3 then
		v4 = image
	end

	local v5 = useImageLoadingState(v4)
	local content

	if v3 then
		local createElement = React.createElement
		local v6 = { Size = UDim2.fromScale(1, 1), ScaleType = Enum.ScaleType.Crop, Image = image }
		local skeleton

		if not v5 then
			skeleton = React.createElement(Skeleton, { Size = UDim2.fromScale(1, 1) })
		end

		content = createElement(Image, v6, { Skeleton = skeleton })
	end

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v6 = {
		sizeConstraint = { MaxSize = Constants.MaxSize.BottomUI },
		tag = "col flex-evenly align-x-center position-center-center anchor-center-center size-full padding-xlarge",
		testId = "--moments-moderated-overlay-text",
		ZIndex = 3
	}

	local createElement3 = React.createElement
	local text = if v3 then v2.moderatedBody else v2.unavailableBody
	return createElement(View, { tag = "position-center-center anchor-center-center size-full" }, {
		OverlayText = createElement2(View, v6, {
			Text = createElement3(Text, { Text = text, tag = "auto-xy text-wrap", LayoutOrder = 1 })
		}),
		Overlay = React.createElement(View, {
			tag = "position-center-center anchor-center-center size-full bg-over-media-0",
			ZIndex = 2
		}),
		Content = content
	})
end

return ModeratedMomentItem
