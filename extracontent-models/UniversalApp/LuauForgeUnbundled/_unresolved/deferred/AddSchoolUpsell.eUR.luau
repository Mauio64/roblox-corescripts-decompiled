local module = require("@luauforge/deferred/eUS")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceSideSheet/Foundation")
local module3 = require("@luauforge/deferred/eUT")
local assets = module3.Assets
local preloadAsset = module3.preloadAsset

local module4 = require("@luauforge/deferred/egU")

local useLocalization = require("@luauforge/deferred/ehw").Hooks.useLocalization
local module5 = require("@luauforge/deferred/ehb")

local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View
local icon = Foundation.Icon
local image = Foundation.Image
local button = Foundation.Button

local useTokens = Foundation.Hooks.useTokens

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconSize = Foundation.Enums.IconSize
local inputSize = Foundation.Enums.InputSize

local icon2 = module.Icon

preloadAsset("pictograms/education")

local pictogramseducation = assets["pictograms/education"]

local function PerkRow(props)
	return module4.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "row items-center gap-small size-full-0 auto-y"
		},
		{
			Icon = module4.createElement(icon, {
				LayoutOrder = 1,
				name = props.icon,
				size = iconSize.Medium
			}),
			Label = module4.createElement(text, {
				LayoutOrder = 2,
				Text = props.text,
				tag = "fill auto-y text-body-medium text-align-x-left text-truncate-end content-default"
			})
		}
	)
end

local function AddSchoolUpsell(props)
	local v5 = props.isOpen == nil or props.isOpen
	local v6 = useTokens()
	local v7 = useLocalization({
		heading = module5.UpsellHeading,
		body = module5.UpsellBody,
		perkFindFriends = module5.UpsellPerkFindFriends,
		perkPlayAndChat = module5.UpsellPerkPlayAndChat,
		perkTrends = module5.UpsellPerkTrends,
		disclaimer = module5.UpsellDisclaimer,
		actionContinue = module5.ActionContinue
	})

	local v8 = pictogramseducation.size / 3 * v6.Config.UI.Scale

	return module4.createElement(
		sheet.Root,
		{
			isOpen = v5,
			onClose = props.onClose,
			preferCenterSheet = true,
			testId = "schools-add-school-upsell-sheet"
		},
		{
			Content = module4.createElement(sheet.Content, nil, {
				Illustration = module4.createElement(
					view,
					{
						LayoutOrder = 1,
						tag = "col align-x-center size-full-0 auto-y padding-bottom-medium"
					},
					{
						Hero = module4.createElement(image, {
							Image = pictogramseducation.assetId,
							imageStyle = v6.Color.Content.Emphasis,
							ScaleType = Enum.ScaleType.Fit,
							Size = UDim2.fromOffset(v8.X, v8.Y),
							testId = "schools-add-school-upsell-hero"
						})
					}
				),
				Header = module4.createElement(
					view,
					{ LayoutOrder = 2, tag = "col gap-xsmall size-full-0 auto-y" },
					{
						Heading = module4.createElement(text, {
							LayoutOrder = 1,
							Text = v7.heading,
							tag = "size-full-0 auto-y text-heading-medium text-wrap text-align-x-left content-emphasis"
						}),
						Body = module4.createElement(text, {
							LayoutOrder = 2,
							Text = v7.body,
							tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default"
						})
					}
				),
				Perks = module4.createElement(
					view,
					{
						LayoutOrder = 3,
						tag = "col gap-large size-full-0 auto-y padding-top-xsmall"
					},
					{
						FindFriends = module4.createElement(PerkRow, {
							layoutOrder = 1,
							icon = icon2.PersonMagnifyingGlass,
							text = v7.perkFindFriends
						}),
						PlayAndChat = module4.createElement(PerkRow, {
							layoutOrder = 2,
							icon = icon2.ThreePeople,
							text = v7.perkPlayAndChat
						}),
						Trends = module4.createElement(PerkRow, {
							layoutOrder = 3,
							icon = icon2.Flame,
							text = v7.perkTrends
						})
					}
				),
				Disclaimer = module4.createElement(text, {
					LayoutOrder = 4,
					Text = v7.disclaimer,
					tag = "size-full-0 auto-y padding-top-xsmall text-body-medium text-wrap text-align-x-left content-default"
				})
			}),
			Actions = module4.createElement(sheet.Actions, nil, {
				Continue = module4.createElement(button, {
					LayoutOrder = 1,
					text = v7.actionContinue,
					size = inputSize.Large,
					variant = buttonVariant.Emphasis,
					fillBehavior = fillBehavior.Fill,
					onActivated = props.onContinue
				})
			})
		}
	)
end

return AddSchoolUpsell
