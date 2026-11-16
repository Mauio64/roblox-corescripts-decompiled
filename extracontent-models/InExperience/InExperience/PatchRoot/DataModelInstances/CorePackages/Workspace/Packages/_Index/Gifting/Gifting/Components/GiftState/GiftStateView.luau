local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local FoundationCloudAssets = require(parent.FoundationCloudAssets)

local Button = Foundation.Button
local Image = Foundation.Image
local Loading = Foundation.Loading
local Text = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local useTokens = Foundation.Hooks.useTokens

local Assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset

preloadAsset("pictograms/collaborators")
preloadAsset("pictograms/alert")

local GiftStateEnum = require(script.Parent.GiftStateEnum)

local function GiftStateView(props)
	local v

	if props.retryLabel == nil then
		v = false
	else
		v = props.onRetry ~= nil
	end

	local v2 = useTokens()
	local state = props.state
	local v3

	if state == GiftStateEnum.Empty then
		v3 = Assets["pictograms/collaborators"]
	elseif state == GiftStateEnum.Error or state == GiftStateEnum.Blocked then
		v3 = Assets["pictograms/alert"]
	end

	local createElement = React.createElement
	local v4 = {
		tag = "col align-x-center gap-medium size-full-0 auto-y padding-y-xxlarge",
		testId = `gift-state-{string.lower(state)}`
	}
	local loading

	if state == GiftStateEnum.Loading then
		loading = React.createElement(Loading, {
			testId = "gift-state-loading-indicator",
			LayoutOrder = 1
		})
	end

	local illustration

	if v3 then
		illustration = React.createElement(Image, {
			Image = v3.assetId,
			imageStyle = v2.Color.Content.Emphasis,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromOffset(320 * v2.Config.UI.Scale, 180 * v2.Config.UI.Scale),
			testId = "gift-state-illustration",
			LayoutOrder = 1
		})
	end

	local title

	if props.titleText then
		title = React.createElement(Text, {
			tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-center content-emphasis",
			Text = props.titleText,
			testId = "gift-state-title",
			LayoutOrder = 2
		})
	end

	local body

	if props.bodyText then
		body = React.createElement(Text, {
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-center content-default",
			Text = props.bodyText,
			testId = "gift-state-body",
			LayoutOrder = 3
		})
	end

	local retry

	if v then
		retry = React.createElement(Button, {
			text = props.retryLabel,
			variant = ButtonVariant.Standard,
			onActivated = props.onRetry,
			testId = "gift-state-retry",
			LayoutOrder = 4
		})
	end

	return createElement(View, v4, {
		Loading = loading,
		Illustration = illustration,
		Title = title,
		Body = body,
		Retry = retry
	})
end

return React.memo(GiftStateView)
