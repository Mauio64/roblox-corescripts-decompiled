local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Promise")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactNavigation")
local horizontalPageMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").App.Container.HorizontalPageMargin

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Responsive")
local usePreferredInput = Responsive.usePreferredInput

local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SduiSharedUtilities")
local sduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local useComponentConfig = SduiSharedUtilities.useComponentConfig

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")

local fFlagGroupPeekEngagementTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagGroupPeekEngagementTelemetry

local groupPeekSdui = nil
local function getGroupPeekSdui()
	if groupPeekSdui == nil then
		groupPeekSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GroupPeekSdui")
	end

	return groupPeekSdui
end

local function getIdentifier(p2, p3)
	if p3 == Enums.Components.Announcements then
		return p2.Identifiers.Announcement
	end

	return p2.Identifiers.ForumsDiscovery
end

local function SectionEntry(props)
	if groupPeekSdui == nil then
		groupPeekSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GroupPeekSdui")
	end

	local v5 = groupPeekSdui

	local configKey = v5.getConfigKey(props.groupId)
	local v6

	if props.section == Enums.Components.Announcements then
		v6 = v5.Identifiers.Announcement
	else
		v6 = v5.Identifiers.ForumsDiscovery
	end

	local v7 = useComponentConfig(configKey, v6)
	local v8

	if fFlagGroupPeekEngagementTelemetry then
		v8 = React.useMemo(function()
			return {
				sessionId = props.sessionId,
				groupId = tonumber(props.groupId),
				locationTab = "peek",
				pageRoute = "/peek"
			}
		end, { props.sessionId, props.groupId })
	end

	if v7 == nil then
		return nil
	end

	return React.createElement(
		horizontalPageMargin,
		{
			size = UDim2.new(1, 0, 0, 0),
			backgroundTransparency = 1,
			layoutOrder = props.layoutOrder,
			useAutomaticSizing = true
		},
		{
			Sdui = React.createElement(sduiFeatureEntryPoint, {
				appPage = v5.AppPage,
				configKey = configKey,
				identifier = v6,
				shouldDisplayLoading = false,
				shouldDisplayError = false,
				LayoutOrder = 1,
				additionalAnalyticsData = v8
			})
		}
	)
end

local function GroupPeekSduiSection(p2)
	local v5 = useProfileWrapperContext()

	local profileId = v5.profileId

	local v6 = usePreferredInput() ~= Responsive.Input.Directional

	if v6 then
		v6 = not (profileId == nil) and profileId ~= ""
	end

	local v7 = React.useCallback(function(p3)
		Promise.try(function()
			if groupPeekSdui == nil then
				groupPeekSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GroupPeekSdui")
			end

			return groupPeekSdui.fetchGroupPeekPage(profileId, p3)
		end):catch(function() end)
	end, { profileId })

	React.useEffect(function()
		if not v6 then
			return
		end

		if groupPeekSdui == nil then
			groupPeekSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GroupPeekSdui")
		end

		groupPeekSdui.registerGroupAnnouncementActions()
		v7(false)
	end, { v6, v7 })

	if v6 then
		return React.createElement(React.Fragment, nil, {
			NavEvents = React.createElement(RoactNavigation.NavigationEvents, {
				onDidFocus = function()
					v7(true)
				end
			}),
			Section = React.createElement(SectionEntry, {
				groupId = profileId,
				layoutOrder = p2.layoutOrder,
				section = p2.section,
				sessionId = v5.profileSessionId
			})
		})
	end

	return nil
end

return React.memo(GroupPeekSduiSection)
