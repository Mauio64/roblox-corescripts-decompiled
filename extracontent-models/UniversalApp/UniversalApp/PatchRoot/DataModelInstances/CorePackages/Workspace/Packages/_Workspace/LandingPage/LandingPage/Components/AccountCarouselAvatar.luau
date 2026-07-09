local LandingPage = script:FindFirstAncestor("LandingPage")
local LandingPageParent = LandingPage.Parent
local React = require(LandingPageParent.React)
local Foundation = require(LandingPageParent.Foundation)
local UserLib = require(LandingPageParent.UserLib)
local getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local Constants = UserLib.Utils.Constants
local useLocalization = require(LandingPageParent.Localization).Hooks.useLocalization
local GetFFlagEnableAccountCarouselEvents = require(LandingPageParent.SharedFlags).GetFFlagEnableAccountCarouselEvents
local AuthAnalytics = require(LandingPageParent.AuthAnalytics)
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local authButtonClick = AuthAnalytics.Events.authButtonClick
local AccountCarouselAvatarScaleFactor = require(LandingPage.Constants.LandingPageConstants).Common.AccountCarouselAvatarScaleFactor

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 36
	-- upvalues: useLocalization (copy), React (copy), Foundation (copy), GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy), AccountCarouselAvatarScaleFactor (copy), getRbxthumbWithTypeSizeAndOptions (copy), Constants (copy)
	local v16 = useLocalization({
		signedOut = "Authentication.AccountPicker.Label.SignedOut"
	})
	local v17 = "@" .. t1.accountInfo.username

	if not t1.accountInfo.has_valid_session then
		v17 = "@" .. t1.accountInfo.username .. " • " .. v16.signedOut
	end

	return React.createElement(Foundation.View, {
		tag = "col align-x-center padding-bottom-large",
		ref = p1,
		onActivated = function() -- line: 46
			-- upvalues: GetFFlagEnableAccountCarouselEvents (copy), authButtonClick (copy), EventStreamConstants (copy), t1 (copy)
			if GetFFlagEnableAccountCarouselEvents() then
				authButtonClick(EventStreamConstants.Context.AccountPickerLandingScreen, EventStreamConstants.Button.AccountPickerAccountSelected, t1.accountInfo.user_id, nil)
			end

			t1.onActivated()
		end,
		Size = UDim2.new(0, t1.avatarSize.X.Offset * AccountCarouselAvatarScaleFactor, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		onAbsoluteSizeChanged = function(_) -- line: 60
			-- upvalues: t1 (copy), AccountCarouselAvatarScaleFactor (copy)
			local v19 = t1.avatarSize.Y.Offset * AccountCarouselAvatarScaleFactor + 40 + 40

			t1.setAvatarElementHeightForParent(v19)
		end,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		}
	}, {
		AvatarImage = React.createElement(Foundation.Image, {
			LayoutOrder = 1,
			Size = t1.avatarSize,
			ImageRect = t1.avatarSize,
			Image = getRbxthumbWithTypeSizeAndOptions(tostring(t1.accountInfo.user_id), Constants.RbxthumbTypes.Avatar, 352),
			ScaleType = Enum.ScaleType.Crop,
			scale = not t1.isHighlighted and 1 or AccountCarouselAvatarScaleFactor,
			imageStyle = if t1.isHighlighted then {} else {
				Transparency = 0.5
			}
		}),
		DisplayName = React.createElement(Foundation.Text, {
			LayoutOrder = 3,
			tag = "auto-xy text-align-x-center text-heading-medium content-emphasis",
			Text = t1.accountInfo.display_name,
			textStyle = {
				Transparency = not t1.isHighlighted and 1 or 0
			}
		}),
		Username = React.createElement(Foundation.Text, {
			LayoutOrder = 4,
			tag = "auto-xy text-align-x-center text-body-medium content-muted padding-bottom-large",
			Text = v17,
			textStyle = {
				Transparency = not t1.isHighlighted and 1 or 0
			}
		})
	})
end))
