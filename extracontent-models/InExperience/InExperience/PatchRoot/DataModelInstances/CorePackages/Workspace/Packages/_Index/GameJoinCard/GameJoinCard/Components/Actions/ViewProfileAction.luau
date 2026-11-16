local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local SharedFlags = require(parent.SharedFlags)
local UserCtaCommon = require(parent.UserCtaCommon)
local UserCtaAction = UserCtaCommon.Enums.UserCtaAction

local Text = Foundation.Text
local View = Foundation.View
local ControlState = Foundation.Enums.ControlState
local InputSize = Foundation.Enums.InputSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local AppPage = RobloxAppEnums.AppPage
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local FFlagSocialCarouselBuildPresence = SharedFlags.FFlagSocialCarouselBuildPresence

local AnalyticsConstants = require(GameJoinCard.Analytics.AnalyticsConstants)
local GameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local useGameJoinCardAnalytics = require(GameJoinCard.Analytics.useGameJoinCardAnalytics)
require(script.Parent.Types)
local getTelemetryFields = require(script.Parent.getTelemetryFields)
local ViewProfileLink = require(script.Parent.ViewProfileLink)

local function ViewProfileLink2(props)
	local v = useTokens()
	local state, setState = React.useState(false)
	local onStateChanged = React.useCallback(function(p)
		setState(p == ControlState.Hover)
	end, {})

	local createElement = React.createElement
	local v2 = {
		Name = "ViewProfileButton",
		Size = UDim2.new(1, 0, 0, v.Size.Size_600),
		tag = "row align-x-center align-y-center",
		onActivated = props.onActivated,
		onStateChanged = onStateChanged,
		stateLayer = { affordance = StateLayerAffordance.None },
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local text

	if state then
		text = `<u>{props.text}</u>`
	else
		text = props.text
	end

	return createElement(View, v2, {
		Label = createElement2(Text, {
			Text = text,
			RichText = true,
			tag = "auto-xy text-title-medium text-align-x-center content-emphasis"
		})
	})
end

return {
	[UserCtaAction.ViewProfile] = function(data)
		return {
			id = UserCtaAction.ViewProfile,
			inputSize = InputSize.Medium,
			width = UDim.new(1, 0),
			text = data.localized[UserCtaAction.ViewProfile],
			render = function(p, layoutOrder)
				local createElement = React.createElement
				local v

				if FFlagSocialCarouselBuildPresence then
					v = ViewProfileLink
				else
					v = ViewProfileLink2
				end

				return createElement(v, {
					text = p.text,
					onActivated = function()
						p.onActivated(viewProfileSourceValues.ViewProfileButton)
					end,
					LayoutOrder = layoutOrder
				})
			end,
			onActivated = function(p)
				local v = p or viewProfileSourceValues.ViewProfileButton

				if data.userId ~= "" then
					local telemetryFields = getTelemetryFields(data)

					if v == viewProfileSourceValues.UserTile then
						useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
							GameJoinCardButtonAction.OpenProfileFromUserTile,
							telemetryFields
						)
					elseif v == viewProfileSourceValues.ViewProfileButton then
						useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
							GameJoinCardButtonAction.OpenProfileFromViewProfile,
							telemetryFields
						)
					end
				end

				local v2

				if FFlagEnableSplitPane then
					v2 = data.navigation.push
				else
					v2 = data.navigation.navigate
				end

				v2(AppPage.ProfilePlatform, { detail = data.userId })
			end
		}
	end
}
