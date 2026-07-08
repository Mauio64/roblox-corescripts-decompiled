local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local Localization = require(ParentParent.Localization)
local Icon = Foundation.Icon
local View = Foundation.View
local FoundationText = Foundation.Text
local Menu = Foundation.Menu
local Enums = Foundation.Enums
local WhyThisAdModal = require(ParentParent.AdLabel).WhyThisAdModal
local AdDisclosureTelemetry = require(ParentParent.AdLabel).AdDisclosureTelemetry
local AdLabel = require(ParentParent.AdLabel).AdLabel
local FFlagLuaAppEnhancedVideoAdLabelPropUpdate = require(scriptParent.Parent.FFlagLuaAppEnhancedVideoAdLabelPropUpdate)
local useLocalization = Localization.Hooks.useLocalization
local EnhancedVideoStore = require(scriptParent.Parent.EnhancedVideoStore)
local useSignalState = require(ParentParent.SignalsReact).useSignalState

local function LegacyAdLabel(t1: {[any]: any}) -- line: 27
	-- upvalues: useLocalization (copy), Enums (copy), EnhancedVideoStore (copy), useSignalState (copy), React (copy), AdDisclosureTelemetry (copy), View (copy), Menu (copy), FoundationText (copy), Icon (copy), WhyThisAdModal (copy)
	local v20 = useLocalization({
		adLabel = "Feature.EnhancedVideo.Label.Ad",
		whyThisAdLabel = "Feature.GameDetails.Action.WhyThisAd",
		errorAdDisclosureText = "Feature.GameDetails.Message.SponsoredDisclosure.Error"
	})
	local t2 = {{
		id = "whyThisAd",
		icon = Enums.IconName.CircleI,
		text = v20.whyThisAdLabel
	}}
	local v22 = EnhancedVideoStore(false)
	local v23 = useSignalState(v22.getAdDisclosureText)
	local v24 = useSignalState(v22.getShowAdPreferencesUrl)
	local v25, v26 = React.useState(false)
	local v27, v28 = React.useState(false)

	local function toggleMenu(b1: boolean) -- line: 45
		-- upvalues: AdDisclosureTelemetry (copy), v26 (copy)
		AdDisclosureTelemetry.logAdDisclosureMenuToggled(b1)
		v26(b1)
	end
	local function toggleWhyThisAdModal(b2: boolean) -- line: 50
		-- upvalues: AdDisclosureTelemetry (copy), v28 (copy)
		AdDisclosureTelemetry.logAdDisclosureWhyThisAdToggled(b2)
		v28(b2)
	end

	return React.createElement(View, {
		tag = "size-full margin-bottom-medium"
	}, {
		Menu = React.createElement(Menu, {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -10, 1, 0),
			isOpen = v25,
			items = t2,
			size = Enums.InputSize.Medium,
			align = Enums.PopoverAlign.End,
			width = UDim.new(0, 180),
			onPressedOutside = function() -- line: 66
				-- upvalues: AdDisclosureTelemetry (copy), v26 (copy)
				AdDisclosureTelemetry.logAdDisclosureMenuToggled(false)
				v26(false)
			end,
			onActivated = function(p1) -- line: 69
				-- upvalues: AdDisclosureTelemetry (copy), v26 (copy), v28 (copy), t1 (copy)
				if p1 == "whyThisAd" then
					AdDisclosureTelemetry.logAdDisclosureMenuToggled(false)
					v26(false)
					AdDisclosureTelemetry.logAdDisclosureWhyThisAdToggled(true)
					v28(true)
					t1.sendPauseEvent()
				end
			end
		}, {
			AdLabel = React.createElement(View, {
				tag = "size-1300-600 bg-over-media-100 radius-small stroke-standard stroke-default row align-x-center align-y-center",
				onActivated = function() -- line: 79
					-- upvalues: v25 (copy), AdDisclosureTelemetry (copy), v26 (copy)
					local v38 = not v25

					AdDisclosureTelemetry.logAdDisclosureMenuToggled(v38)
					v26(v38)
				end
			}, {
				AdText = React.createElement(FoundationText, {
					tag = "auto-x size-0-full text-label-small",
					LayoutOrder = 1,
					Text = v20.adLabel
				}),
				TrailingIconWrapper = React.createElement(View, {
					tag = "auto-xy padding-left-small",
					LayoutOrder = 2
				}, {
					MoreIcon = React.createElement(Icon, {
						name = Enums.IconName.CircleThreeDotsHorizontal,
						size = Enums.IconSize.XSmall
					})
				})
			})
		}),
		WhyThisAdModal = if not v27 then nil else React.createElement(WhyThisAdModal, {
			adDisclosureBody = if v23 == "" then v20.errorAdDisclosureText else v23,
			showAdPreferencesUrl = v24,
			onClose = function() -- line: 105
				-- upvalues: AdDisclosureTelemetry (copy), v28 (copy)
				AdDisclosureTelemetry.logAdDisclosureWhyThisAdToggled(false)
				v28(false)
			end
		})
	})
end

if FFlagLuaAppEnhancedVideoAdLabelPropUpdate then
	return React.memo(if not FFlagLuaAppEnhancedVideoAdLabelPropUpdate then nil else function(t3: {[any]: any}) -- line: 114
		-- upvalues: EnhancedVideoStore (copy), useSignalState (copy), React (copy), AdLabel (copy)
		local v32 = EnhancedVideoStore(false)
		local v33 = useSignalState(v32.getAdDisclosureText)
		local v34 = useSignalState(v32.getShowAdPreferencesUrl)

		return React.createElement(AdLabel, {
			sendPauseEvent = t3.sendPauseEvent,
			adDisclosureText = v33,
			showAdPreferencesUrl = v34
		})
	end)
end

return React.memo(LegacyAdLabel)
