local EditProfile = script:FindFirstAncestor("EditProfile")
local EditDisplayNameModal = require(script.Parent.EditDisplayNameModal)
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local UserProfiles = require(EditProfileParent.UserProfiles)
local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local writeNamesQuery = UserProfiles.Mutations.writeNamesQuery
local LuaSocialLibrariesDeps = require(EditProfileParent.LuaSocialLibrariesDeps)
local UIBlox = require(EditProfileParent.UIBlox)
local v10 = LuaSocialLibrariesDeps.SocialLibraries.config({})
local SetCurrentToastMessage = require(EditProfileParent.ToastRodux).Actions.SetCurrentToastMessage
local useDispatch = require(EditProfileParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useScreenSize = require(EditProfileParent.RobloxAppHooks).useScreenSize
local getDeepValue = v10.Dictionary.getDeepValue
local useEffectOnMount = require(EditProfileParent.RoactUtils).Hooks.useEffectOnMount
local UsersNetworking = require(EditProfile.Networking.UsersNetworking)
local Images = UIBlox.App.ImageSet.Images
local Analytics = require(EditProfile.Analytics)
local EventNames = Analytics.EventNames
local useAnalytics = Analytics.useAnalytics
local useDisplayNameText = require(EditProfile.Hooks.useDisplayNameText)

local function EditDisplayNameModalContainer(p1) -- line: 37
	-- upvalues: useDispatch (copy), useScreenSize (copy), useAnalytics (copy), useEffectOnMount (copy), EventNames (copy), useDisplayNameText (copy), useLocalUserId (copy), UserProfiles (copy), UsersNetworking (copy), writeNamesQuery (copy), getDeepValue (copy), SetCurrentToastMessage (copy), Images (copy), React (copy), EditDisplayNameModal (copy)
	local v24 = useDispatch()
	local v25 = useScreenSize()
	local v26 = p1.navigation.getParam("setDisplayNameAvailable")
	local v27 = useAnalytics()

	useEffectOnMount(function() -- line: 44
		-- upvalues: v27 (copy), EventNames (copy)
		v27.fireAnalyticsEvent(EventNames.DisplayNameModalLoaded)
	end)

	local v28 = useDisplayNameText()
	local v29 = useLocalUserId()
	local v30 = p1.navigation.getParam("displayName")
	local u31 = nil
	local v32 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { v29 },
		query = UserProfiles.Queries.userProfilesAllNamesByUserIds
	})

	if v32.data then
		u31 = UserProfiles.Selectors.getUserProfileFromId(v32.data, v29)
	end

	local function saveDisplayName(s1: string) -- line: 68
		-- upvalues: v24 (copy), UsersNetworking (copy), v29 (copy), writeNamesQuery (copy), v32 (copy), UserProfiles (copy), getDeepValue (copy), u31 (ref), v27 (copy), EventNames (copy), p1 (copy), SetCurrentToastMessage (copy), v28 (copy), Images (copy), v26 (copy)
		return v24(UsersNetworking.SetDisplayName.API(v29, s1)):andThen(function(_) -- line: 69
			-- upvalues: writeNamesQuery (copy), v32 (copy), UserProfiles (copy), v29 (copy), getDeepValue (copy), u31 (ref), s1 (copy), v27 (copy), EventNames (copy), p1 (copy), v24 (copy), SetCurrentToastMessage (copy), v28 (copy), Images (copy), v26 (copy)
			writeNamesQuery({
				client = v32.client,
				query = UserProfiles.Queries.userProfilesAllNamesByUserIds,
				userId = v29,
				names = {
					alias = getDeepValue(u31, "names.alias"),
					contactName = getDeepValue(u31, "names.contactName"),
					displayName = s1,
					username = getDeepValue(u31, "names.username")
				}
			})
			v27.fireAnalyticsEvent(EventNames.DisplayNameSaved, {
				displayName = s1
			})
			p1.navigation.goBack()
			v24(SetCurrentToastMessage({
				isLocalized = true,
				toastMessage = v28.displayNameUpdatedMessage,
				toastIcon = Images["icons/actions/accept"]
			}))
			v26(false)
		end)
	end

	return React.createElement(EditDisplayNameModal, {
		screenSize = v25,
		title = v28.displayNameEditMessage,
		description = v28.displayNameCaption,
		initialText = v30,
		localUserId = v29,
		cancelOnActivated = function() -- line: 64
			-- upvalues: p1 (copy)
			p1.navigation.goBack()
		end,
		saveOnActivated = saveDisplayName,
		validateDisplayName = function(s2: string) -- line: 97
			-- upvalues: v24 (copy), UsersNetworking (copy), v29 (copy)
			return v24(UsersNetworking.GetDisplayNameValidation.API(v29, s2))
		end
	})
end

return EditDisplayNameModalContainer
