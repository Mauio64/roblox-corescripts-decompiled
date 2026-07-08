local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local Foundation = require(AvatarSwitcherParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local FoundationCloudAssets = require(AvatarSwitcherParent.FoundationCloudAssets)
local useLocalization = require(AvatarSwitcherParent.Localization).Hooks.useLocalization
local sendAXCounterV2 = require(AvatarSwitcherParent.AvatarExperienceAnalytics).sendAXCounterV2
local OutfitViewport = require(AvatarSwitcher.Components.OutfitViewport.OutfitViewport)
local Constants = require(AvatarSwitcher.Constants)
local v11 = game:DefineFastFlag("AvatarSwitcher3DPreview", false)
local FFlagAvatarSwitcherAccurateAvatarWarning = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherAccurateAvatarWarning
local FFlagAvatarSwitcherWarningLayoutFix = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherWarningLayoutFix
local FFlagAvatarSwitcherCounters = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherCounters
local FFlagAXBackgroundsInOutfitThumbnails = require(AvatarSwitcherParent.SharedFlags).FFlagAXBackgroundsInOutfitThumbnails
local t1 = {
	AVATAR = FoundationCloudAssets.Assets["pictograms/avatar"],
	AVATAR_ISSUE = FoundationCloudAssets.Assets["pictograms/avatar_issue"]
}

local function AvatarPreview(t2: {[any]: any}) -- line: 46
	-- upvalues: React (copy), useLocalization (copy), useTokens (copy), Foundation (copy), t1 (copy), v11 (copy), OutfitViewport (copy), FFlagAvatarSwitcherCounters (copy), sendAXCounterV2 (copy), Constants (copy), FFlagAvatarSwitcherAccurateAvatarWarning (copy), FFlagAvatarSwitcherWarningLayoutFix (copy), FFlagAXBackgroundsInOutfitThumbnails (copy)
	local v19, v20 = React.useState(false)

	React.useEffect(function() -- line: 48
		-- upvalues: v20 (copy)
		v20(false)
	end, { t2.outfitId })

	local v21 = useLocalization({
		selectAvatar = "Feature.AvatarSwitcher.Message.SelectAvatar",
		unkownSupportHeader = "Feature.AvatarSwitcher.Heading.UnknownSupport",
		unkownSupportContent = "Feature.AvatarSwitcher.Message.UnknownSupport",
		partiallyUnsupported = "Feature.AvatarSwitcher.Message.PartiallyUnsupported"
	})
	local v22 = useTokens()

	if t2.outfitId == nil then
		return (React.createElement(Foundation.View, {
			tag = "size-full col align-x-center align-y-center",
			padding = {
				bottom = UDim.new(0, t2.messageBottomPadding or v22.Padding.Medium)
			}
		}, {
			Image = React.createElement(Foundation.Image, {
				LayoutOrder = 1,
				Image = t1.AVATAR.assetId,
				Size = UDim2.fromOffset(t1.AVATAR.size.X / 3, t1.AVATAR.size.Y / 3)
			}),
			Text = React.createElement(Foundation.Text, {
				tag = "auto-xy text-title-medium",
				LayoutOrder = 2,
				Text = v21.selectAvatar
			})
		}))
	end

	if t2.showAvatarSupportWarning then
		return (React.createElement(Foundation.View, {
			tag = "size-full",
			padding = {
				bottom = UDim.new(0, t2.messageBottomPadding or v22.Padding.Medium)
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
				ScrollingContent = React.createElement(Foundation.View, {
					tag = "size-full col align-x-center align-y-center"
				}, {
					Image = React.createElement(Foundation.Image, {
						LayoutOrder = 1,
						Image = t1.AVATAR_ISSUE.assetId,
						Size = UDim2.fromOffset(t1.AVATAR_ISSUE.size.X / 3, t1.AVATAR_ISSUE.size.Y / 3)
					}),
					Header = React.createElement(Foundation.Text, {
						tag = "auto-y size-full-0 text-title-medium text-wrap padding-bottom-small",
						LayoutOrder = 2,
						Text = v21.unkownSupportHeader
					}),
					Content = React.createElement(Foundation.Text, {
						tag = "auto-y size-full-0 text-body-small text-wrap",
						LayoutOrder = 3,
						Text = v21.unkownSupportContent
					})
				})
			})
		}))
	end

	if v11 and not v19 then
		return React.createElement(Foundation.View, {
			tag = "size-full col"
		}, {
			OutfitViewportContainer = React.createElement(Foundation.View, {
				tag = "size-full-0 grow",
				LayoutOrder = 1
			}, {
				OutfitViewport = React.createElement(OutfitViewport, {
					outfitId = t2.outfitId,
					rigType = t2.rigType,
					onLoadingFailed = function() -- line: 131
						-- upvalues: FFlagAvatarSwitcherCounters (copy), sendAXCounterV2 (copy), Constants (copy), v20 (copy)
						if FFlagAvatarSwitcherCounters then
							sendAXCounterV2(Constants.Counters.AvatarPreviewLoadFailed)
						end

						v20(true)
					end,
					onLoaded = if not FFlagAvatarSwitcherAccurateAvatarWarning then nil else t2.onAvatarPreviewLoaded
				})
			}),
			CompatibilityWarningContainer = not FFlagAvatarSwitcherWarningLayoutFix and (t2.showAvatarTypeCompatibilityWarning and React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y padding-y-medium",
				LayoutOrder = 2
			}, {
				InfoIcon = React.createElement(Foundation.Image, {
					Image = "icons/actions/info",
					LayoutOrder = 1,
					Size = UDim2.fromOffset(v22.Size.Size_500, v22.Size.Size_500)
				}),
				CompatibilityWarning = React.createElement(Foundation.Text, {
					tag = "auto-y position-top-right anchor-top-right text-caption-small text-wrap text-align-x-left padding-top-xsmall",
					LayoutOrder = 2,
					Size = UDim2.new(1, -v22.Size.Size_500 - v22.Gap.Small, 0, 0),
					Text = v21.partiallyUnsupported
				})
			}))
		})
	end

	return (React.createElement(Foundation.Image, {
		tag = "size-full",
		Image = if not FFlagAXBackgroundsInOutfitThumbnails then `rbxthumb://type=Outfit&id={ t2.outfitId }&w=420&h=420` else `rbxthumb://type=Outfit&id={ t2.outfitId }&w=420&h=420&includeBackground=true`,
		ScaleType = t2.imageScaleType
	}, {}))
end

return AvatarPreview
