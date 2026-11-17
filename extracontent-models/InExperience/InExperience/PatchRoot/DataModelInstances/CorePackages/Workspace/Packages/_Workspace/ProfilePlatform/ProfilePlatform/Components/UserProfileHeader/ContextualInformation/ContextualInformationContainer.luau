local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local Enums = require(ProfilePlatform.Common.Enums)

local UIBlox = require(parent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin

local NetworkingGames = require(ProfilePlatform.Networking.NetworkingGames)

local ContextualGeneric = require(script.Parent.ContextualGeneric)
local ContextualPresence = require(script.Parent.ContextualPresence)
local ContextualMutualFriends = require(script.Parent.ContextualMutualFriends)
local ContextualPlayedTogether = require(script.Parent.ContextualPlayedTogether)

local function ContextualInformationContainer(p)
	local sourceInfo = useProfileWrapperContext().sourceInfo

	local contextualInformation = (useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}).contextualInformation
	local context = contextualInformation.context
	local contextDetails = contextualInformation.contextDetails
	local v

	if context == Enums.ContextualTypes.SentFromExperience then
		v = contextDetails[context].sourceUniverseId
	elseif context == Enums.ContextualTypes.PlayedTogether then
		v = contextDetails[context].mostFrequentUniverseId
	else
		v = nil
	end

	local v2 = useDispatch()
	useEffectOnMount(function()
		if context == Enums.ContextualTypes.SentFromExperience or context == Enums.ContextualTypes.PlayedTogether then
			v2(NetworkingGames.GetExperiencesDetails.API({ v })):catch(function(_) end)
		end
	end)

	local experienceName = useSelector(function(p2)
		return getDeepValue(p2, `ProfilePlatform.Games.byGameId.{tostring(v)}.name`) or ""
	end)

	local deepValue = getDeepValue(sourceInfo, "contextualOverride.icon")
	local deepValue2 = getDeepValue(sourceInfo, "contextualOverride.text")
	local contextualInformation2

	if context == Enums.ContextualTypes.Presence then
		contextualInformation2 = React.createElement(ContextualPresence)
	elseif context == Enums.ContextualTypes.MutualFriends then
		local contextDetail = contextDetails[context]

		contextualInformation2 = React.createElement(ContextualMutualFriends, {
			mutualFriends = contextDetail.mutualFriends,
			mutualFriendsCount = contextDetail.mutualFriendsCount
		})
	elseif context == Enums.ContextualTypes.PlayedTogether then
		contextualInformation2 = React.createElement(ContextualPlayedTogether, {
			experienceName = experienceName
		})
	else
		contextualInformation2 = React.createElement(ContextualGeneric, {
			contextualType = context,
			experienceName = experienceName,
			iconOverride = deepValue,
			textOverride = deepValue2
		})
	end

	return React.createElement(
		HorizontalPageMargin,
		{
			size = p.size,
			layoutOrder = p.layoutOrder,
			useAutomaticSizing = true,
			backgroundTransparency = 1
		},
		{ contextualInformation = contextualInformation2 }
	)
end

return ContextualInformationContainer
