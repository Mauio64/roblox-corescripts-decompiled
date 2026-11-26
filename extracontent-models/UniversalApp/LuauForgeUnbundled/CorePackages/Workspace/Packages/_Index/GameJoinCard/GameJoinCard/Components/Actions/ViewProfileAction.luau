local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppEnums")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags")
local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction

local text = Foundation.Text
local view = Foundation.View
local controlState = Foundation.Enums.ControlState
local inputSize = Foundation.Enums.InputSize
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local appPage = RobloxAppEnums.AppPage
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagSocialCarouselBuildPresence = SharedFlags.FFlagSocialCarouselBuildPresence

local AnalyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants")
local gameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local viewProfileSourceValues = AnalyticsConstants.viewProfileSourceValues
local useGameJoinCardAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useGameJoinCardAnalytics")
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
local getTelemetryFields = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/getTelemetryFields")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/ViewProfileLink")

local function ViewProfileLink(props)
	local v5 = useTokens()
	local state, setState = React.useState(false)
	local v6 = React.useCallback(function(p2)
		setState(p2 == controlState.Hover)
	end, {})

	local createElement = React.createElement
	local v8 = {
		Name = "ViewProfileButton",
		Size = UDim2.new(1, 0, 0, v5.Size.Size_600),
		tag = "row align-x-center align-y-center",
		onActivated = props.onActivated,
		onStateChanged = v6,
		stateLayer = { affordance = stateLayerAffordance.None },
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local v12 = if state then `<u>{props.text}</u>` else props.text
	return createElement(view, v8, {
		Label = createElement2(text, {
			Text = v12,
			RichText = true,
			tag = "auto-xy text-title-medium text-align-x-center content-emphasis"
		})
	})
end

return {
	[userCtaAction.ViewProfile] = function(data)
		return {
			id = userCtaAction.ViewProfile,
			inputSize = inputSize.Medium,
			width = UDim.new(1, 0),
			text = data.localized[userCtaAction.ViewProfile],
			render = function(p2, p3)
				return React.createElement(
					if fFlagSocialCarouselBuildPresence then module8 else ViewProfileLink,
					{
						text = p2.text,
						onActivated = function()
							p2.onActivated(viewProfileSourceValues.ViewProfileButton)
						end,
						LayoutOrder = p3
					}
				)
			end,
			onActivated = function(p2)
				local v6 = p2 or viewProfileSourceValues.ViewProfileButton

				if data.userId ~= "" then
					local v7 = getTelemetryFields(data)

					if v6 == viewProfileSourceValues.UserTile then
						useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
							gameJoinCardButtonAction.OpenProfileFromUserTile,
							v7
						)
					elseif v6 == viewProfileSourceValues.ViewProfileButton then
						useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
							gameJoinCardButtonAction.OpenProfileFromViewProfile,
							v7
						)
					end
				end

				local v7 = if fFlagEnableSplitPane then data.navigation.push else data.navigation.navigate
				v7(appPage.ProfilePlatform, { detail = data.userId })
			end
		}
	end
}
