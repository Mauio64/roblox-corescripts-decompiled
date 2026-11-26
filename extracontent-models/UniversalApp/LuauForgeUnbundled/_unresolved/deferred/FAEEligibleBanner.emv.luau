local module = require("@luauforge/deferred/eil")
local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization

local module2 = require("@luauforge/deferred/eiU")
local button = module2.Button
local icon = module2.Icon
local iconButton = module2.IconButton
local text = module2.Text
local view = module2.View
local buttonVariant = module2.Enums.ButtonVariant
local iconName = module2.Enums.IconName
local iconSize = module2.Enums.IconSize
local iconVariant = module2.Enums.IconVariant
local inputSize = module2.Enums.InputSize
local useTokens = module2.Hooks.useTokens

local module3 = require("@luauforge/deferred/emw")
local useSocialUpsellOverlayController = module3.Hooks.useSocialUpsellOverlayController
local socialUpsellType = module3.Enums.SocialUpsellType
local upsellEntrySurfaceType = module3.Analytics.Enum.UpsellEntrySurfaceType
local upsellComponent = module3.Analytics.Enum.UpsellComponent

local module4 = require("@luauforge/deferred/eiy")
local module5 = require("@luauforge/deferred/eiD")

local module6 = require("@luauforge/deferred/emx")

local fFlagCreateConnectionsHub = require("@luauforge/deferred/eiz").FFlagCreateConnectionsHub

local function FAEEligibleBanner(p2)
	local v5 = useSocialUpsellOverlayController(false)
	local v6, v7 = module6()
	local v8 = module5()
	local v9 = useTokens()

	local v10 = useLocalization({
		body = "Feature.Friends.Label.FAEEligibleBanner.Body",
		unlock = "Feature.FAE.Action.Unlock"
	})

	module.useEffect(function()
		if v6 then
			v8(module4.FAEEligibleBannerImpression)
		end
	end, { v6, v8 })

	local v11 = module.useCallback(function()
		v8(module4.FAEEligibleBannerClick)
		v7()
		v5.openSocialOverlay(socialUpsellType.FacialAgeEstimation, {
			upsellEntrySurface = upsellEntrySurfaceType.AddFriendsPage,
			upsellEntryComponent = upsellComponent.Banner,
			entryPointEventCtx = socialUpsellType.FacialAgeEstimation .. upsellEntrySurfaceType.AddFriendsPage,
			shouldIncludeVPC = true
		})
	end, { v7, v5.openSocialOverlay, v8 })

	local v12 = module.useCallback(function()
		v8(module4.FAEEligibleBannerClose)
		v7()
	end, { v7, v8 })

	if v6 then
		return module.createElement(view, {
			LayoutOrder = p2.layoutOrder,
			tag = {
				["col size-full-0 auto-y"] = true,
				["padding-y-xsmall"] = not fFlagCreateConnectionsHub
			}
		}, {
			Banner = module.createElement(view, {
				tag = {
					["row align-y-center gap-medium size-full-0 auto-y padding-x-medium padding-y-large bg-shift-200"] = true
				}
			}, {
				LeftGroup = module.createElement(
					view,
					{
						LayoutOrder = 1,
						tag = "row align-y-center fill gap-medium auto-y"
					},
					{
						InfoIcon = module.createElement(
							view,
							{
								LayoutOrder = 1,
								tag = "row align-x-center align-y-center radius-circle bg-system-emphasis",
								Size = UDim2.fromOffset(v9.Size.Size_600, v9.Size.Size_600)
							},
							{
								Glyph = module.createElement(icon, {
									name = iconName.StackableI,
									size = iconSize.Medium,
									variant = iconVariant.Filled,
									style = v9.Color.Extended.White.White_100
								})
							}
						),
						BodyText = module.createElement(text, {
							LayoutOrder = 2,
							Text = v10.body,
							tag = "fill auto-y text-body-medium text-wrap text-align-x-left content-emphasis"
						})
					}
				),
				RightGroup = module.createElement(
					view,
					{ LayoutOrder = 2, tag = "row align-y-center gap-small auto-xy" },
					{
						UnlockButton = module.createElement(button, {
							LayoutOrder = 1,
							text = v10.unlock,
							variant = buttonVariant.Standard,
							size = inputSize.Small,
							onActivated = v11
						}),
						CloseButton = module.createElement(iconButton, {
							LayoutOrder = 2,
							icon = iconName.X,
							size = inputSize.Small,
							variant = buttonVariant.Utility,
							onActivated = v12
						})
					}
				)
			})
		})
	end

	return nil
end

return FAEEligibleBanner
