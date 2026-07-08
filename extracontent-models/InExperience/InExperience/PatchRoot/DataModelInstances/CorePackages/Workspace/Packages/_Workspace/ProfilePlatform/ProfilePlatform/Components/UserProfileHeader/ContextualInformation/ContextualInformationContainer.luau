local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useEffectOnMount = RoactUtils.Hooks.useEffectOnMount
local getDeepValue = require(ProfilePlatformParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local Enums = require(ProfilePlatform.Common.Enums)
local HorizontalPageMargin = require(ProfilePlatformParent.UIBlox).App.Container.HorizontalPageMargin
local NetworkingGames = require(ProfilePlatform.Networking.NetworkingGames)
local IXPService = game:GetService("IXPService")
local ContextualGeneric = require(script.Parent.ContextualGeneric)
local ContextualPresence = require(script.Parent.ContextualPresence)
local ContextualMutualFriends = require(script.Parent.ContextualMutualFriends)
local ContextualPlayedTogether = require(script.Parent.ContextualPlayedTogether)
local FFlagProfilePlatformEnablePlayedTogetherContextFrequentExperienceName = require(ProfilePlatform.Flags.FFlagProfilePlatformEnablePlayedTogetherContextFrequentExperienceName)
local FStringSocialProfileCurrentlyPlayingLayer = require(ProfilePlatform.Flags.FStringSocialProfileCurrentlyPlayingLayer)
local FFlagProfileCurrentlyPlayingIXPEnabled = require(ProfilePlatform.Flags.FFlagProfileCurrentlyPlayingIXPEnabled)

local function ContextualInformationContainer(t1: {[any]: any}) -- line: 45
	-- upvalues: useProfileWrapperContext (copy), useProfileJsonComponent (copy), Enums (copy), FFlagProfilePlatformEnablePlayedTogetherContextFrequentExperienceName (copy), useDispatch (copy), useEffectOnMount (copy), NetworkingGames (copy), React (copy), FFlagProfileCurrentlyPlayingIXPEnabled (copy), IXPService (copy), FStringSocialProfileCurrentlyPlayingLayer (copy), useSelector (copy), getDeepValue (copy), ContextualPresence (copy), ContextualMutualFriends (copy), ContextualPlayedTogether (copy), ContextualGeneric (copy), HorizontalPageMargin (copy)
	local sourceInfo = useProfileWrapperContext().sourceInfo
	local contextualInformation = (useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}).contextualInformation
	local context = contextualInformation.context
	local contextDetails = contextualInformation.contextDetails
	local v28 = if context ~= Enums.ContextualTypes.SentFromExperience then if not FFlagProfilePlatformEnablePlayedTogetherContextFrequentExperienceName or context ~= Enums.ContextualTypes.PlayedTogether then nil else contextDetails[context].mostFrequentUniverseId else contextDetails[context].sourceUniverseId
	local v29 = useDispatch()

	useEffectOnMount(function() -- line: 64
		-- upvalues: context (copy), Enums (copy), FFlagProfilePlatformEnablePlayedTogetherContextFrequentExperienceName (copy), v29 (copy), NetworkingGames (copy), v28 (copy)
		if context == Enums.ContextualTypes.SentFromExperience or FFlagProfilePlatformEnablePlayedTogetherContextFrequentExperienceName and context == Enums.ContextualTypes.PlayedTogether then
			v29(NetworkingGames.GetExperiencesDetails.API({ v28 })):catch(function(_) -- line: 72
			end)
		end
	end)
	React.useEffect(function() -- line: 76
		-- upvalues: FFlagProfileCurrentlyPlayingIXPEnabled (copy), context (copy), Enums (copy), IXPService (copy), FStringSocialProfileCurrentlyPlayingLayer (copy)
		if FFlagProfileCurrentlyPlayingIXPEnabled and context == Enums.ContextualTypes.Presence then
			IXPService:LogFlagLinkedUserLayerExposure(FStringSocialProfileCurrentlyPlayingLayer)
		end
	end, { context })

	local v30 = useSelector(function(p2) -- line: 82
		-- upvalues: getDeepValue (copy), v28 (copy)
		return getDeepValue(p2, `ProfilePlatform.Games.byGameId.{ tostring(v28) }.name`) or ""
	end)
	local v31 = getDeepValue(sourceInfo, "contextualOverride.icon")
	local v32 = getDeepValue(sourceInfo, "contextualOverride.text")
	local v33

	if context == Enums.ContextualTypes.Presence then
		v33 = React.createElement(ContextualPresence)
	elseif context == Enums.ContextualTypes.MutualFriends then
		local v34 = contextDetails[context]

		v33 = React.createElement(ContextualMutualFriends, {
			mutualFriends = v34.mutualFriends,
			mutualFriendsCount = v34.mutualFriendsCount
		})
	else
		v33 = if not FFlagProfilePlatformEnablePlayedTogetherContextFrequentExperienceName or context ~= Enums.ContextualTypes.PlayedTogether then React.createElement(ContextualGeneric, {
			contextualType = context,
			experienceName = v30,
			iconOverride = v31,
			textOverride = v32
		}) else React.createElement(ContextualPlayedTogether, {
			experienceName = v30
		})
	end

	return React.createElement(HorizontalPageMargin, {
		useAutomaticSizing = true,
		backgroundTransparency = 1,
		size = t1.size,
		layoutOrder = t1.layoutOrder
	}, {
		contextualInformation = v33
	})
end

return ContextualInformationContainer
