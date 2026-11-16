local parent = script.Parent
local parent2 = parent.Parent.Parent
local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local Localization = require(parent2.Localization)
local Icon = Foundation.Icon
local View = Foundation.View
local Text = Foundation.Text
local Menu = Foundation.Menu
local Enums = Foundation.Enums
local AdLabel = require(parent2.AdLabel)
local WhyThisAdModal = AdLabel.WhyThisAdModal
local AdLabel2 = require(parent2.AdLabel)
local AdDisclosureTelemetry = AdLabel2.AdDisclosureTelemetry
local AdLabel3 = require(parent2.AdLabel)
local adLabel = AdLabel3.AdLabel

local FFlagLuaAppEnhancedVideoAdLabelPropUpdate = require(parent.Parent.FFlagLuaAppEnhancedVideoAdLabelPropUpdate)

local useLocalization = Localization.Hooks.useLocalization

local EnhancedVideoStore = require(parent.Parent.EnhancedVideoStore)
local SignalsReact = require(parent2.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function LegacyAdLabel(p)
	local v = useLocalization({
		adLabel = "Feature.EnhancedVideo.Label.Ad",
		whyThisAdLabel = "Feature.GameDetails.Action.WhyThisAd",
		errorAdDisclosureText = "Feature.GameDetails.Message.SponsoredDisclosure.Error"
	})

	local items = {
		{ id = "whyThisAd", icon = Enums.IconName.CircleI, text = v.whyThisAdLabel }
	}

	local enhancedVideoStore = EnhancedVideoStore(false)
	local adDisclosureBody = useSignalState(enhancedVideoStore.getAdDisclosureText)
	local showAdPreferencesUrl = useSignalState(enhancedVideoStore.getShowAdPreferencesUrl)

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
			onActivated = function(p2)
				if p2 == "whyThisAd" then
					toggleMenu(false) -- inferred equivalent call
					toggleWhyThisAdModal(true) -- inferred equivalent call
					p.sendPauseEvent()
				end
			end
		}, {
			AdLabel = React.createElement(View, {
				tag = "size-1300-600 bg-over-media-100 radius-small stroke-standard stroke-default row align-x-center align-y-center",
				onActivated = function()
					toggleMenu(not state) -- inferred equivalent call
				end
			}, {
				AdText = React.createElement(Text, {
					Text = v.adLabel,
					tag = "auto-x size-0-full text-label-small",
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

		if adDisclosureBody == "" then
			adDisclosureBody = v.errorAdDisclosureText
		end

		whyThisAdModal = createElement2(WhyThisAdModal, {
			adDisclosureBody = adDisclosureBody,
			showAdPreferencesUrl = showAdPreferencesUrl,
			onClose = function()
				toggleWhyThisAdModal(false) -- inferred equivalent call
			end
		})
	end

	v2.WhyThisAdModal = whyThisAdModal
	return createElement(View, { tag = "size-full margin-bottom-medium" }, v2)
end

local fn = FFlagLuaAppEnhancedVideoAdLabelPropUpdate and function(p)
	local enhancedVideoStore = EnhancedVideoStore(false)

	local adDisclosureText = useSignalState(enhancedVideoStore.getAdDisclosureText)

	local showAdPreferencesUrl = useSignalState(enhancedVideoStore.getShowAdPreferencesUrl)
	return React.createElement(adLabel, {
		sendPauseEvent = p.sendPauseEvent,
		adDisclosureText = adDisclosureText,
		showAdPreferencesUrl = showAdPreferencesUrl
	})
end or nil

if FFlagLuaAppEnhancedVideoAdLabelPropUpdate then
	return React.memo(fn)
end

return React.memo(LegacyAdLabel)
