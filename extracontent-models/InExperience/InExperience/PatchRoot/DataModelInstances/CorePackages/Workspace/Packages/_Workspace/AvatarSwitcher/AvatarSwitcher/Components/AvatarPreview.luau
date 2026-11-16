local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")

local parent = AvatarSwitcher.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2

local OutfitViewport = require(AvatarSwitcher.Components.OutfitViewport.OutfitViewport)
local Constants = require(AvatarSwitcher.Constants)

local defineFastFlag = game:DefineFastFlag("AvatarSwitcher3DPreview", false)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherAccurateAvatarWarning = AvatarExperienceFlags.FFlagAvatarSwitcherAccurateAvatarWarning
local AvatarExperienceFlags2 = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherWarningLayoutFix = AvatarExperienceFlags2.FFlagAvatarSwitcherWarningLayoutFix
local AvatarExperienceFlags3 = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherCounters = AvatarExperienceFlags3.FFlagAvatarSwitcherCounters
local SharedFlags = require(parent.SharedFlags)
local FFlagAXBackgroundsInOutfitThumbnails = SharedFlags.FFlagAXBackgroundsInOutfitThumbnails

local v = {
	AVATAR = FoundationCloudAssets.Assets["pictograms/avatar"],
	AVATAR_ISSUE = FoundationCloudAssets.Assets["pictograms/avatar_issue"]
}

local function AvatarPreview(props)
	local state, setState = React.useState(false)
	React.useEffect(function()
		setState(false)
	end, { props.outfitId })

	local v2 = useLocalization({
		selectAvatar = "Feature.AvatarSwitcher.Message.SelectAvatar",
		unkownSupportHeader = "Feature.AvatarSwitcher.Heading.UnknownSupport",
		unkownSupportContent = "Feature.AvatarSwitcher.Message.UnknownSupport",
		partiallyUnsupported = "Feature.AvatarSwitcher.Message.PartiallyUnsupported"
	})

	local v3 = useTokens()

	if props.outfitId == nil then
		return (React.createElement(Foundation.View, {
			tag = "size-full col align-x-center align-y-center",
			padding = {
				bottom = UDim.new(0, props.messageBottomPadding or v3.Padding.Medium)
			}
		}, {
			Image = React.createElement(Foundation.Image, {
				Image = v.AVATAR.assetId,
				Size = UDim2.fromOffset(v.AVATAR.size.X / 3, v.AVATAR.size.Y / 3),
				LayoutOrder = 1
			}),
			Text = React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-medium",
				Text = v2.selectAvatar,
				LayoutOrder = 2
			})
		}))
	end

	if props.showAvatarSupportWarning then
		return (React.createElement(Foundation.View, {
			tag = "size-full",
			padding = {
				bottom = UDim.new(0, props.messageBottomPadding or v3.Padding.Medium)
			}
		}, {
			ScrollView = React.createElement(Foundation.ScrollView, {
				tag = "size-full",
				scroll = {
					CanvasSize = UDim2.fromScale(0, 1),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					scrollBarVisibility = Foundation.Enums.ScrollBarVisibility.None
				}
			}, {
				ScrollingContent = React.createElement(
					Foundation.View,
					{ tag = "size-full col align-x-center align-y-center" },
					{
						Image = React.createElement(Foundation.Image, {
							Image = v.AVATAR_ISSUE.assetId,
							Size = UDim2.fromOffset(v.AVATAR_ISSUE.size.X / 3, v.AVATAR_ISSUE.size.Y / 3),
							LayoutOrder = 1
						}),
						Header = React.createElement(Foundation.Text, {
							tag = "auto-y size-full-0 text-title-medium text-wrap padding-bottom-small",
							Text = v2.unkownSupportHeader,
							LayoutOrder = 2
						}),
						Content = React.createElement(Foundation.Text, {
							tag = "auto-y size-full-0 text-body-small text-wrap",
							Text = v2.unkownSupportContent,
							LayoutOrder = 3
						})
					}
				)
			})
		}))
	end

	if defineFastFlag and not state then
		local createElement = React.createElement
		local view = Foundation.View

		local createElement2 = React.createElement
		local view2 = Foundation.View

		local createElement3 = React.createElement
		local v4 = {
			outfitId = props.outfitId,
			rigType = props.rigType,
			onLoadingFailed = function()
				if FFlagAvatarSwitcherCounters then
					sendAXCounterV2(Constants.Counters.AvatarPreviewLoadFailed)
				end

				setState(true)
			end,
			onLoaded = 0
		}
		local onLoaded

		if FFlagAvatarSwitcherAccurateAvatarWarning then
			onLoaded = props.onAvatarPreviewLoaded
		end

		v4.onLoaded = onLoaded
		return createElement(view, { tag = "size-full col" }, {
			OutfitViewportContainer = createElement2(view2, {
				tag = "size-full-0 grow",
				LayoutOrder = 1
			}, {
				OutfitViewport = createElement3(OutfitViewport, v4)
			}),
			CompatibilityWarningContainer = not FFlagAvatarSwitcherWarningLayoutFix and props.showAvatarTypeCompatibilityWarning and React.createElement(
				Foundation.View,
				{ tag = "size-full-0 auto-y padding-y-medium", LayoutOrder = 2 },
				{
					InfoIcon = React.createElement(Foundation.Image, {
						Image = "icons/actions/info",
						Size = UDim2.fromOffset(v3.Size.Size_500, v3.Size.Size_500),
						LayoutOrder = 1
					}),
					CompatibilityWarning = React.createElement(Foundation.Text, {
						tag = "auto-y position-top-right anchor-top-right text-caption-small text-wrap text-align-x-left padding-top-xsmall",
						Size = UDim2.new(1, -v3.Size.Size_500 - v3.Gap.Small, 0, 0),
						Text = v2.partiallyUnsupported,
						LayoutOrder = 2
					})
				}
			)
		})
	else
		local createElement = React.createElement
		local image = Foundation.Image
		local image2

		if FFlagAXBackgroundsInOutfitThumbnails then
			image2 = `rbxthumb://type=Outfit&id={props.outfitId}&w=420&h=420&includeBackground=true`
		else
			image2 = `rbxthumb://type=Outfit&id={props.outfitId}&w=420&h=420`
		end

		return (createElement(image, {
			tag = "size-full",
			Image = image2,
			ScaleType = props.imageScaleType
		}, {}))
	end
end

return AvatarPreview
