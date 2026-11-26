local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount

local getDeepValue = require("@luauforge/bundled/fbc").SocialLibraries.config({}).Dictionary.getDeepValue

local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local horizontalPageMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").App.Container.HorizontalPageMargin

local module6 = require("@luauforge/bundled/fkN")

local ContextualGeneric = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/ContextualInformation/ContextualGeneric")
local ContextualPresence = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/ContextualInformation/ContextualPresence")
local ContextualMutualFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/ContextualInformation/ContextualMutualFriends")
local ContextualPlayedTogether = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/ContextualInformation/ContextualPlayedTogether")

local function ContextualInformationContainer(p2)
	local sourceInfo = useProfileWrapperContext().sourceInfo

	local contextualInformation = (useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}).contextualInformation
	local context = contextualInformation.context
	local contextDetails = contextualInformation.contextDetails
	local v5

	if context == Enums.ContextualTypes.SentFromExperience then
		v5 = contextDetails[context].sourceUniverseId
	elseif context == Enums.ContextualTypes.PlayedTogether then
		v5 = contextDetails[context].mostFrequentUniverseId
	else
		v5 = nil
	end

	local v6 = useDispatch()
	useEffectOnMount(function()
		if
			context == Enums.ContextualTypes.SentFromExperience
			or context == Enums.ContextualTypes.PlayedTogether
		then
			v6(module6.GetExperiencesDetails.API({ v5 })):catch(function(p3) end)
		end
	end)

	local v7 = useSelector(function(p3)
		return getDeepValue(p3, `ProfilePlatform.Games.byGameId.{tostring(v5)}.name`) or ""
	end)

	local deepValue = getDeepValue(sourceInfo, "contextualOverride.icon")
	local deepValue2 = getDeepValue(sourceInfo, "contextualOverride.text")
	local v8

	if context == Enums.ContextualTypes.Presence then
		v8 = React.createElement(ContextualPresence)
	elseif context == Enums.ContextualTypes.MutualFriends then
		local contextDetail = contextDetails[context]

		v8 = React.createElement(ContextualMutualFriends, {
			mutualFriends = contextDetail.mutualFriends,
			mutualFriendsCount = contextDetail.mutualFriendsCount
		})
	elseif context == Enums.ContextualTypes.PlayedTogether then
		v8 = React.createElement(ContextualPlayedTogether, { experienceName = v7 })
	else
		v8 = React.createElement(ContextualGeneric, {
			contextualType = context,
			experienceName = v7,
			iconOverride = deepValue,
			textOverride = deepValue2
		})
	end

	return React.createElement(
		horizontalPageMargin,
		{
			size = p2.size,
			layoutOrder = p2.layoutOrder,
			useAutomaticSizing = true,
			backgroundTransparency = 1
		},
		{ contextualInformation = v8 }
	)
end

return ContextualInformationContainer
