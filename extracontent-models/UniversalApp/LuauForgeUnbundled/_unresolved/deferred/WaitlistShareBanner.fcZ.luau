local module = require("@luauforge/deferred/eko")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/fbS")
local assets = module3.Assets
local preloadAsset = module3.preloadAsset
local button = Foundation.Button
local image = Foundation.Image
local text = Foundation.Text
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local useLocalization = require("@luauforge/deferred/ekQ").Hooks.useLocalization

local module4 = require("@luauforge/deferred/ekv")
local module5 = require("@luauforge/deferred/eku")

local pictogramseducation = assets["pictograms/education"]

local function WaitlistShareBanner(props)
	local v5 = useTokens()
	local v6 = useLocalization({
		title = props.titleKey,
		body = props.bodyKey,
		shareAction = module4.ShareBannerAction
	})

	local v7 = props.mediaType == "Reward" and props.mediaImage ~= nil and props.mediaImage ~= ""
	local v8 = props.mediaType == "Alumni"

	module.useEffect(function()
		if v8 then
			preloadAsset("pictograms/education")
		end
	end, { v8 })

	local state, setState = module.useState(0)
	local v9 = module.useCallback(function(p2)
		setState(p2.AbsoluteSize.Y)
	end, {})

	local v10 = math.max(state, module5.Waitlist.MIN_HEIGHT)

	local v11 = not (v7 or v8) and 0 or math.round(v10 * module5.Waitlist.MEDIA_ASPECT_RATIO)

	local udim = UDim2.new(1, -v11, 0, 0)
	local v12 = v10 / module5.Waitlist.MIN_HEIGHT
	local v13 = math.round(module5.Waitlist.ALUMNI_PICTOGRAM_WIDTH * v12)
	local v14 = math.round(module5.Waitlist.ALUMNI_PICTOGRAM_HEIGHT * v12)
	local v15 = math.round(module5.Waitlist.ALUMNI_PICTOGRAM_OFFSET_X * v12)
	local v16 = math.round(module5.Waitlist.ALUMNI_PICTOGRAM_OFFSET_Y * v12)

	local createElement = module.createElement
	local v18 = {
		LayoutOrder = props.LayoutOrder,
		testId = "waitlist-share-banner",
		tag = "col size-full-0 auto-y radius-medium bg-shift-200"
	}

	local createElement2 = module.createElement
	local v21 = {
		LayoutOrder = 1,
		ClipsDescendants = true,
		tag = "row size-full-0 auto-y radius-medium",
		sizeConstraint = {
			MinSize = Vector2.new(0, module5.Waitlist.MIN_HEIGHT)
		}
	}

	local v22 = {
		Content = module.createElement(
			view,
			{
				LayoutOrder = 1,
				Size = udim,
				tag = "col align-x-left gap-small auto-y padding-medium",
				onAbsoluteSizeChanged = v9
			},
			{
				TextBlock = module.createElement(
					view,
					{
						LayoutOrder = 1,
						tag = "col align-x-left gap-xxsmall size-full-0 auto-y padding-bottom-xsmall"
					},
					{
						Title = module.createElement(text, {
							LayoutOrder = 1,
							Text = v6.title,
							tag = "size-full-0 auto-y text-title-large text-wrap text-align-x-left content-emphasis"
						}),
						Body = module.createElement(text, {
							LayoutOrder = 2,
							Text = v6.body,
							tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
						})
					}
				),
				CTA = module.createElement(
					view,
					{
						LayoutOrder = 2,
						tag = "row align-x-left size-full-0 auto-y padding-top-xsmall"
					},
					{
						ShareButtonWrapper = module.createElement(view, {
							testId = "waitlist-share-button-wrapper",
							tag = "auto-xy",
							sizeConstraint = {
								MinSize = Vector2.new(module5.Waitlist.SHARE_BUTTON_MIN_WIDTH, 0)
							}
						}, {
							ShareButton = module.createElement(button, {
								text = v6.shareAction,
								variant = buttonVariant.Emphasis,
								size = inputSize.Small,
								onActivated = props.onShare,
								fillBehavior = fillBehavior.Fill
							})
						})
					}
				)
			}
		),
		Media = 0
	}
	local v23

	if v7 then
		v23 = module.createElement(
			view,
			{
				LayoutOrder = 2,
				testId = "waitlist-reward-media",
				Size = UDim2.fromOffset(v11, v10),
				tag = "col align-x-center align-y-center"
			},
			{
				RewardImage = module.createElement(image, {
					testId = "waitlist-reward-image",
					Image = props.mediaImage,
					Size = UDim2.fromScale(1, 1),
					ScaleType = Enum.ScaleType.Fit,
					BackgroundTransparency = 1
				})
			}
		)
	elseif v8 then
		v23 = module.createElement(
			view,
			{
				LayoutOrder = 2,
				testId = "waitlist-graduation-media",
				Size = UDim2.fromOffset(v11, v10)
			},
			{
				AlumniPictogram = module.createElement(image, {
					testId = "waitlist-alumni-pictogram",
					Image = pictogramseducation.assetId,
					imageStyle = v5.Color.Content.Emphasis,
					Position = UDim2.fromOffset(v15, v16),
					Size = UDim2.fromOffset(v13, v14),
					ScaleType = Enum.ScaleType.Fit,
					BackgroundTransparency = 1
				})
			}
		)
	end

	v22.Media = v23
	return createElement(view, v18, { ContentClip = createElement2(view, v21, v22) })
end

return WaitlistShareBanner
