local EditProfile = script:FindFirstAncestor("EditProfile")
local EditDescriptionModal = require(script.Parent.EditDescriptionModal)
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local getDeepValue = require(EditProfileParent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local UsersNetworking = require(EditProfile.Networking.UsersNetworking)
local useDispatch = require(EditProfileParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useScreenSize = require(EditProfileParent.RobloxAppHooks).useScreenSize
local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local useLocalization = require(EditProfileParent.Localization).Hooks.useLocalization
local TextKeys = require(EditProfile.Common.TextKeys)
local HttpService = game:GetService("HttpService")
local EditProfileIXP = require(EditProfile.Flags.EditProfileIXP)
local Analytics = require(EditProfile.Analytics)
local EventNames = Analytics.EventNames
local useAnalytics = Analytics.useAnalytics

local function EditDescriptionModalContainer(p1) -- line: 36
	-- upvalues: useDispatch (copy), useScreenSize (copy), useLocalUserId (copy), React (copy), EditProfileIXP (copy), useAnalytics (copy), useLocalization (copy), TextKeys (copy), UsersNetworking (copy), getDeepValue (copy), HttpService (copy), EventNames (copy), EditDescriptionModal (copy)
	local v19 = useDispatch()
	local v20 = useScreenSize()
	local v21 = useLocalUserId()
	local v22 = p1.navigation.getParam("setDescription")
	local v23, v24 = React.useState(false)
	local v25, v26 = React.useState(false)
	local v27 = if not (not p1.IXPNotEnabled and EditProfileIXP.useIsExperimentEnabled()) then nil else useAnalytics()
	local v28 = useLocalization({
		About = TextKeys.About,
		Caption = TextKeys.AboutModalCaption,
		ThrottleError = TextKeys.TooManyAttemptsTryAgainLater
	})
	local v29 = p1.navigation.getParam("initialText")

	local function saveDescription(s1: string) -- line: 59
		-- upvalues: v19 (copy), UsersNetworking (copy), v21 (copy), v22 (copy), getDeepValue (copy), p1 (copy), HttpService (copy), v27 (copy), EventNames (copy), v24 (copy), v26 (copy)
		return v19(UsersNetworking.SetDescription.API(v21, s1)):andThen(function(p2) -- line: 61
			-- upvalues: v22 (copy), getDeepValue (copy), p1 (copy)
			v22(getDeepValue(p2, "responseBody.description"))
			p1.navigation.goBack()
		end):catch(function(p3) -- line: 65
			-- upvalues: HttpService (copy), v27 (copy), EventNames (copy), v24 (copy), v26 (copy)
			local data = HttpService:JSONDecode(p3.Body)

			if data.errors[1].code == 2 then
				if v27 then
					v27.fireAnalyticsEvent(EventNames.DescriptionPINBlocked)
				end

				v24(true)

				return
			end

			if data.errors[1].code == 0 then
				v26(true)
			end
		end)
	end

	return React.createElement(EditDescriptionModal, {
		screenSize = v20,
		title = v28.About,
		description = v28.Caption,
		throttleErrorText = v28.ThrottleError,
		initialText = v29,
		cancelOnActivated = function() -- line: 55
			-- upvalues: p1 (copy)
			p1.navigation.goBack()
		end,
		saveOnActivated = saveDescription,
		textError = v23,
		throttleError = v25
	})
end

return EditDescriptionModalContainer
