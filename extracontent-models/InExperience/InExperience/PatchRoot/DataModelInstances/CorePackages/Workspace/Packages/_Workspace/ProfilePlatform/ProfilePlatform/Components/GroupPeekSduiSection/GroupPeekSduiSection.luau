local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Promise = require(parent.Promise)
local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local UIBlox = require(parent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin

local Responsive = require(parent.Responsive)
local usePreferredInput = Responsive.usePreferredInput

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint
local useComponentConfig = SduiSharedUtilities.useComponentConfig

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)

local SharedFlags = require(parent.SharedFlags)
local FFlagGroupPeekEngagementTelemetry = SharedFlags.FFlagGroupPeekEngagementTelemetry

local groupPeekSdui = nil
local function getGroupPeekSdui() -- 3 equivalent calls inferred from this helper
	if groupPeekSdui == nil then
		local GroupPeekSdui = require(parent.GroupPeekSdui)
		groupPeekSdui = GroupPeekSdui
	end

	return groupPeekSdui
end

local function getIdentifier(groupPeekSdui2, section: string) -- 1 equivalent call inferred from this helper
	if section == Enums.Components.Announcements then
		return groupPeekSdui2.Identifiers.Announcement
	end

	return groupPeekSdui2.Identifiers.ForumsDiscovery
end

local function SectionEntry(props)
	local groupPeekSdui2 = getGroupPeekSdui() -- inferred equivalent call
	local configKey = groupPeekSdui2.getConfigKey(props.groupId)

	local identifier = getIdentifier(groupPeekSdui2, props.section) -- inferred equivalent call
	local v = useComponentConfig(configKey, identifier)
	local additionalAnalyticsData

	if FFlagGroupPeekEngagementTelemetry then
		additionalAnalyticsData = React.useMemo(function()
			return {
				sessionId = props.sessionId,
				groupId = tonumber(props.groupId),
				locationTab = "peek",
				pageRoute = "/peek"
			}
		end, { props.sessionId, props.groupId })
	end

	if v == nil then
		return nil
	end

	return React.createElement(
		HorizontalPageMargin,
		{
			size = UDim2.new(1, 0, 0, 0),
			backgroundTransparency = 1,
			layoutOrder = props.layoutOrder,
			useAutomaticSizing = true
		},
		{
			Sdui = React.createElement(SduiFeatureEntryPoint, {
				appPage = groupPeekSdui2.AppPage,
				configKey = configKey,
				identifier = identifier,
				shouldDisplayLoading = false,
				shouldDisplayError = false,
				LayoutOrder = 1,
				additionalAnalyticsData = additionalAnalyticsData
			})
		}
	)
end

local function GroupPeekSduiSection(p)
	local v = useProfileWrapperContext()

	local profileId = v.profileId

	local v2 = usePreferredInput() ~= Responsive.Input.Directional

	if v2 then
		if profileId == nil then
			v2 = false
		else
			v2 = profileId ~= ""
		end
	end

	local v3 = React.useCallback(function(flag: boolean)
		Promise.try(function()
			return getGroupPeekSdui().fetchGroupPeekPage(profileId, flag) -- inferred equivalent call
		end):catch(function() end)
	end, { profileId })

	React.useEffect(function()
		if not v2 then
			return
		end

		getGroupPeekSdui().registerGroupAnnouncementActions() -- inferred equivalent call
		v3(false)
	end, { v2, v3 })

	if v2 then
		return React.createElement(React.Fragment, nil, {
			NavEvents = React.createElement(RoactNavigation.NavigationEvents, {
				onDidFocus = function()
					v3(true)
				end
			}),
			Section = React.createElement(SectionEntry, {
				groupId = profileId,
				layoutOrder = p.layoutOrder,
				section = p.section,
				sessionId = v.profileSessionId
			})
		})
	end

	return nil
end

return React.memo(GroupPeekSduiSection)
