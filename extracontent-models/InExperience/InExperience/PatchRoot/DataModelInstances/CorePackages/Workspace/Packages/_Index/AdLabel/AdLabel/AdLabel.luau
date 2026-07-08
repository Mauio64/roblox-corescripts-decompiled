local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local React = require(scriptParentParent.React)
local Foundation = require(scriptParentParent.Foundation)
local Localization = require(scriptParentParent.Localization)
local Icon = Foundation.Icon
local View = Foundation.View
local FoundationText = Foundation.Text
local Menu = Foundation.Menu
local Enums = Foundation.Enums
local WhyThisAdModal = require(scriptParent.WhyThisAdModal)
local AdDisclosureTelemetry = require(scriptParent.AdDisclosureTelemetry)
local useLocalization = Localization.Hooks.useLocalization

local function AdLabel(t1: {[any]: any}) -- line: 23
	-- upvalues: useLocalization (copy), Enums (copy), React (copy), AdDisclosureTelemetry (copy), View (copy), Menu (copy), FoundationText (copy), Icon (copy), WhyThisAdModal (copy)
	local v16 = useLocalization({
		adLabel = "Feature.EnhancedVideo.Label.Ad",
		whyThisAdLabel = "Feature.GameDetails.Action.WhyThisAd",
		errorAdDisclosureText = "Feature.GameDetails.Message.SponsoredDisclosure.Error"
	})
	local t2 = {{
		id = "whyThisAd",
		icon = Enums.IconName.CircleI,
		text = v16.whyThisAdLabel
	}}
	local v18, v19 = React.useState(false)
	local v20, v21 = React.useState(false)

	local function toggleMenu(b1: boolean) -- line: 37
		-- upvalues: AdDisclosureTelemetry (copy), v19 (copy)
		AdDisclosureTelemetry.logAdDisclosureMenuToggled(b1)
		v19(b1)
	end
	local function toggleWhyThisAdModal(b2: boolean) -- line: 42
		-- upvalues: AdDisclosureTelemetry (copy), v21 (copy)
		AdDisclosureTelemetry.logAdDisclosureWhyThisAdToggled(b2)
		v21(b2)
	end

	return React.createElement(View, {
		tag = "size-full margin-bottom-medium"
	}, {
		Menu = React.createElement(Menu, {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -10, 1, 0),
			isOpen = v18,
			items = t2,
			size = Enums.InputSize.Medium,
			align = Enums.PopoverAlign.End,
			width = UDim.new(0, 180),
			onPressedOutside = function() -- line: 58
				-- upvalues: AdDisclosureTelemetry (copy), v19 (copy)
				AdDisclosureTelemetry.logAdDisclosureMenuToggled(false)
				v19(false)
			end,
			onActivated = function(p1) -- line: 61
				-- upvalues: AdDisclosureTelemetry (copy), v19 (copy), v21 (copy), t1 (copy)
				if p1 == "whyThisAd" then
					AdDisclosureTelemetry.logAdDisclosureMenuToggled(false)
					v19(false)
					AdDisclosureTelemetry.logAdDisclosureWhyThisAdToggled(true)
					v21(true)
					t1.sendPauseEvent()
				end
			end
		}, {
			AdLabel = React.createElement(View, {
				tag = "row align-x-center align-y-center size-1300-600 stroke-standard stroke-default radius-small bg-over-media-100",
				onActivated = function() -- line: 71
					-- upvalues: v18 (copy), AdDisclosureTelemetry (copy), v19 (copy)
					local v27 = not v18

					AdDisclosureTelemetry.logAdDisclosureMenuToggled(v27)
					v19(v27)
				end
			}, {
				AdText = React.createElement(FoundationText, {
					tag = "size-0-full auto-x text-label-small",
					LayoutOrder = 1,
					Text = v16.adLabel
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
		WhyThisAdModal = if not v20 then nil else React.createElement(WhyThisAdModal, {
			adDisclosureBody = if t1.adDisclosureText == nil or t1.adDisclosureText == "" then v16.errorAdDisclosureText else t1.adDisclosureText,
			showAdPreferencesUrl = t1.showAdPreferencesUrl,
			onClose = function() -- line: 97
				-- upvalues: AdDisclosureTelemetry (copy), v21 (copy)
				AdDisclosureTelemetry.logAdDisclosureWhyThisAdToggled(false)
				v21(false)
			end
		})
	})
end

return React.memo(AdLabel)
