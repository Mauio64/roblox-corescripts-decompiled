local EditProfile = script:FindFirstAncestor("EditProfile")
local HttpService = game:GetService("HttpService")
local EditSocialLinksModal = require(script.Parent.EditSocialLinksModal)
local EditProfileParent = EditProfile.Parent
local React = require(EditProfileParent.React)
local LuaSocialLibrariesDeps = require(EditProfileParent.LuaSocialLibrariesDeps)
local NavigateDown = require(EditProfileParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(EditProfileParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v9 = if not FFlagSignalsNavP3Dispatch then nil else require(EditProfileParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(EditProfileParent.RobloxAppEnums).AppPage
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local SocialLinksNetworking = require(EditProfile.Networking.SocialLinksNetworking)
local useDispatch = require(EditProfileParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalUserId = require(EditProfileParent.RobloxAppHooks).useLocalUserId
local useNavigation = require(EditProfileParent.Navigation).useNavigation
local useSelector = require(EditProfileParent.RoactUtils).Hooks.RoactRodux.useSelector
local FFlagProfileEnableSocialNetworksUsernames = require(EditProfileParent.SharedFlags).FFlagProfileEnableSocialNetworksUsernames

local function EditSocialLinksModalContainer() -- line: 25
	-- upvalues: useDispatch (copy), useLocalUserId (copy), useNavigation (copy), useSelector (copy), getDeepValue (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), NavigateDown (copy), SocialLinksNetworking (copy), FFlagProfileEnableSocialNetworksUsernames (copy), HttpService (copy), React (copy), EditSocialLinksModal (copy)
	local v19 = useDispatch()
	local v20 = useLocalUserId()
	local v21 = useNavigation()
	local v22 = useSelector(function(p1) -- line: 30
		-- upvalues: getDeepValue (copy)
		return getDeepValue(p1, "Profile.SocialLinks.selfSocialLinks")
	end)

	local function openEditSocialNetworksErrorModal(p2) -- line: 38
		-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v9 (copy), v19 (copy), NavigateDown (copy)
		local t1 = {
			name = AppPage.EditSocialNetworksError,
			extraProps = {
				errorCode = p2
			}
		}

		if FFlagSignalsNavP3Dispatch then
			v9.down(v9.fromLegacyPage(t1))

			return
		end

		v19(NavigateDown(t1))
	end
	local function saveSocialLinks(s1: string, s2: string, s3: string, s4: string, s5: string, s6: string) -- line: 52
		-- upvalues: v19 (copy), SocialLinksNetworking (copy), v20 (copy), FFlagProfileEnableSocialNetworksUsernames (copy), v21 (copy), HttpService (copy), openEditSocialNetworksErrorModal (copy)
		return v19(SocialLinksNetworking.SetSocialLinks.API({
			promotionChannelsVisibilityPrivacy = s1,
			facebook = s2,
			twitter = s3,
			youtube = s4,
			twitch = s5,
			guilded = s6
		})):andThen(function(_) -- line: 68
			-- upvalues: v19 (copy), SocialLinksNetworking (copy), v20 (copy), FFlagProfileEnableSocialNetworksUsernames (copy), v21 (copy)
			v19(SocialLinksNetworking.GetSelfSocialLinks.API({
				alwaysReturnUrls = false,
				filterLink = false
			})):catch(function(_) -- line: 70
			end)
			v19(SocialLinksNetworking.GetSocialLinks.API({
				alwaysReturnUrls = true,
				filterLink = true,
				userId = v20
			})):andThen(function(_) -- line: 77
				-- upvalues: FFlagProfileEnableSocialNetworksUsernames (copy), v19 (copy), SocialLinksNetworking (copy), v20 (copy)
				if FFlagProfileEnableSocialNetworksUsernames then
					v19(SocialLinksNetworking.GetSocialLinks.API({
						alwaysReturnUrls = false,
						filterLink = true,
						userId = v20
					}))
				end
			end):catch(function(_) -- line: 86
			end)
			v21.goBack()
		end):catch(function(p7) -- line: 89
			-- upvalues: HttpService (copy), openEditSocialNetworksErrorModal (copy)
			local ok, result = pcall(function() -- line: 90
				-- upvalues: HttpService (copy), p7 (copy)
				return HttpService:JSONDecode(p7.Body)
			end)
			local n1 = -1

			if ok then
				n1 = result and (not not result.errors and (not not result.errors[1] and result.errors[1].code)) or -1
			end

			openEditSocialNetworksErrorModal(n1)
		end)
	end

	return React.createElement(EditSocialLinksModal, {
		socialNetworksVisbility = v22.visibility,
		socialNetworks = v22.socialLinks,
		cancelOnActivated = function() -- line: 34
			-- upvalues: v21 (copy)
			v21.goBack()
		end,
		saveOnActivated = saveSocialLinks
	})
end

return EditSocialLinksModalContainer
