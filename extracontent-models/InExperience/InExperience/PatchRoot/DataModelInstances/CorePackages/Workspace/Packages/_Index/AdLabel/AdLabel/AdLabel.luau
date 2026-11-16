local parent = script.Parent
local parent2 = parent.Parent
local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local Icon = Foundation.Icon
local View = Foundation.View
local Text = Foundation.Text
local Menu = Foundation.Menu
local Enums = Foundation.Enums
local WhyThisAdModal = require(parent.WhyThisAdModal)
local AdDisclosureTelemetry = require(parent.AdDisclosureTelemetry)

local useLocalization = Localization.Hooks.useLocalization

local function AdLabel(props)
	local v = useLocalization({
		adLabel = "Feature.EnhancedVideo.Label.Ad",
		whyThisAdLabel = "Feature.GameDetails.Action.WhyThisAd",
		errorAdDisclosureText = "Feature.GameDetails.Message.SponsoredDisclosure.Error"
	})

	local items = {
		{ id = "whyThisAd", icon = Enums.IconName.CircleI, text = v.whyThisAdLabel }
	}

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local function toggleMenu(flag: boolean) -- 3 equivalent calls inferred from this helper
		AdDisclosureTelemetry.logAdDisclosureMenuToggled(flag)
		setState(flag)
	end

	local function toggleWhyThisAdModal(flag: boolean) -- 2 equivalent calls inferred from this helper
		AdDisclosureTelemetry.logAdDisclosureWhyThisAdToggled(flag)
		setState2(flag)
	end

	local createElement = React.createElement

	local v2 = {
		Menu = React.createElement(Menu, {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -10, 1, 0),
			isOpen = state,
			items = items,
			size = Enums.InputSize.Medium,
			align = Enums.PopoverAlign.End,
			width = UDim.new(0, 180),
			onPressedOutside = function()
				toggleMenu(false) -- inferred equivalent call
			end,
			onActivated = function(p)
				if p == "whyThisAd" then
					toggleMenu(false) -- inferred equivalent call
					toggleWhyThisAdModal(true) -- inferred equivalent call
					props.sendPauseEvent()
				end
			end
		}, {
			AdLabel = React.createElement(View, {
				tag = "row align-x-center align-y-center size-1300-600 stroke-standard stroke-default radius-small bg-over-media-100",
				onActivated = function()
					toggleMenu(not state) -- inferred equivalent call
				end
			}, {
				AdText = React.createElement(Text, {
					Text = v.adLabel,
					tag = "size-0-full auto-x text-label-small",
					LayoutOrder = 1
				}),
				TrailingIconWrapper = React.createElement(
					View,
					{ tag = "auto-xy padding-left-small", LayoutOrder = 2 },
					{
						MoreIcon = React.createElement(Icon, {
							name = Enums.IconName.CircleThreeDotsHorizontal,
							size = Enums.IconSize.XSmall
						})
					}
				)
			})
		}),
		WhyThisAdModal = 0
	}
	local whyThisAdModal

	if state2 then
		local createElement2 = React.createElement
		local adDisclosureBody

		if props.adDisclosureText == nil or props.adDisclosureText == "" then
			adDisclosureBody = v.errorAdDisclosureText
		else
			adDisclosureBody = props.adDisclosureText
		end

		whyThisAdModal = createElement2(WhyThisAdModal, {
			adDisclosureBody = adDisclosureBody,
			showAdPreferencesUrl = props.showAdPreferencesUrl,
			onClose = function()
				toggleWhyThisAdModal(false) -- inferred equivalent call
			end
		})
	end

	v2.WhyThisAdModal = whyThisAdModal
	return createElement(View, { tag = "size-full margin-bottom-medium" }, v2)
end

return React.memo(AdLabel)
