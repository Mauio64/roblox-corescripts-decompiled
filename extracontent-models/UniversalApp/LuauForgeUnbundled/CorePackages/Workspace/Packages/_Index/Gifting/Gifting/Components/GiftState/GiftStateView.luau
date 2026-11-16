local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")
local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/FoundationCloudAssets")

local button = Foundation.Button
local image = Foundation.Image
local loading = Foundation.Loading
local text = Foundation.Text
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens

local assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset

preloadAsset("pictograms/collaborators")
preloadAsset("pictograms/alert")

local GiftStateEnum = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftState/GiftStateEnum")

local function GiftStateView(props)
	local v5 = not (props.retryLabel == nil) and props.onRetry ~= nil
	local v6 = useTokens()
	local state = props.state
	local v7

	if state == GiftStateEnum.Empty then
		v7 = assets["pictograms/collaborators"]
	elseif state == GiftStateEnum.Error or state == GiftStateEnum.Blocked then
		v7 = assets["pictograms/alert"]
	end

	local createElement = React.createElement
	local v9 = {
		tag = "col align-x-center gap-medium size-full-0 auto-y padding-y-xxlarge",
		testId = `gift-state-{string.lower(state)}`
	}

	local v11 = if state == GiftStateEnum.Loading then React.createElement(loading, {
		testId = "gift-state-loading-indicator",
		LayoutOrder = 1
	}) else nil

	local v12 = if v7 then React.createElement(image, {
		Image = v7.assetId,
		imageStyle = v6.Color.Content.Emphasis,
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(320 * v6.Config.UI.Scale, 180 * v6.Config.UI.Scale),
		testId = "gift-state-illustration",
		LayoutOrder = 1
	}) else nil

	local v13 = if props.titleText then React.createElement(text, {
		tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-emphasis",
		Text = props.titleText,
		testId = "gift-state-title",
		LayoutOrder = 2
	}) else nil

	local v14 = if props.bodyText then React.createElement(text, {
		tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default",
		Text = props.bodyText,
		testId = "gift-state-body",
		LayoutOrder = 3
	}) else nil

	local v15 = if v5 then React.createElement(button, {
		text = props.retryLabel,
		variant = buttonVariant.Standard,
		onActivated = props.onRetry,
		testId = "gift-state-retry",
		LayoutOrder = 4
	}) else nil
	return createElement(view, v9, {
		Loading = v11,
		Illustration = v12,
		Title = v13,
		Body = v14,
		Retry = v15
	})
end

return React.memo(GiftStateView)
