local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module = require("@luauforge/deferred/gJH")
local axPartialPageModal = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.AXPartialPageModal
local UIBlox = require(CorePackages.Packages.UIBlox)
local getIconSize = UIBlox.App.ImageSet.getIconSize
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local Foundation = require(CorePackages.Packages.Foundation)
local FoundationCloudAssets = require(CorePackages.Packages.FoundationCloudAssets)
local view = Foundation.View
local text = Foundation.Text
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local fFlagAXFixAvatarScreenVR = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFixAvatarScreenVR

local module2 = require("@luauforge/deferred/gJI")

local assets = FoundationCloudAssets.Assets
FoundationCloudAssets.preloadAsset("pictograms/makeup_look")
local pictogramsmakeup_look = assets["pictograms/makeup_look"]

local function MakeupReleaseFtuxPrompt(props)
	local v5 = useLocalization({
		viewButtonText = "CommonUI.Messages.Action.View",
		dismissButtonText = "CommonUI.Messages.Action.Dismiss",
		titleText = "Feature.Avatar.Title.MakeupIntroFtux",
		bodyText = "Feature.Avatar.Description.MakeupIntroFtux"
	})

	local state, setState = React.useState(false)

	local v6 = Foundation.Hooks.useTokens()
	local iconSize2 = getIconSize(iconSize.XXLarge)

	local v7 = React.useCallback(function()
		props.navigation.dispatch(RoactNavigation.Actions.back(nil))
	end, { props.navigation })

	local v8 = React.useCallback(function()
		v7()
		props.onView()
	end, { props.onView, v7 })

	local v9 = React.useCallback(function()
		v7()
		props.onDismiss()
	end, { props.onDismiss, v7 })

	React.useEffect(function()
		setState(true)
	end, {})

	local v10 = React.useCallback(function()
		return {
			ViewFrame = React.createElement(
				view,
				{
					tag = "auto-y size-full-0 padding-bottom-xxlarge col align-x-left align-y-top"
				},
				{
					GraphicContainer = React.createElement(
						view,
						{
							tag = "position-center-center grow padding-bottom-small",
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 0, iconSize2)
						},
						{
							MakeupCategoryArt = React.createElement(Foundation.Image, {
								tag = "size-full",
								Image = pictogramsmakeup_look and pictogramsmakeup_look.assetId,
								ScaleType = Enum.ScaleType.Fit,
								imageStyle = v6.Color.Content.Emphasis
							})
						}
					),
					PromptBodyTitle = React.createElement(text, {
						tag = "auto-xy padding-bottom-small padding-top-medium text-align-x-left text-heading-small text-wrap",
						Text = v5.titleText,
						LayoutOrder = 3
					}),
					PromptBodyText = React.createElement(text, {
						tag = "auto-xy text-align-x-left text-truncate-end text-body-large text-wrap",
						Text = v5.bodyText,
						LayoutOrder = 4
					})
				}
			)
		}
	end, { iconSize2, v6, v5, pictogramsmakeup_look })

	return React.createElement(axPartialPageModal, {
		visible = state,
		onBackgroundPress = v9,
		buttonStackProps = {
			rowLayout = true,
			buttons = {
				{
					props = {
						onActivated = v8,
						text = v5.viewButtonText,
						variant = buttonVariant.Emphasis,
						size = inputSize.Medium
					}
				},
				{
					props = {
						onActivated = v9,
						text = v5.dismissButtonText,
						variant = buttonVariant.Standard,
						size = inputSize.Medium
					}
				}
			}
		}
	}, v10())
end

local v5 = module(MakeupReleaseFtuxPrompt)

if fFlagAXFixAvatarScreenVR then
	v5 = module2(v5)
end

return v5
