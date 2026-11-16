local EditProfile = script:FindFirstAncestor("EditProfile")
local HttpService = game:GetService("HttpService")
local EditSocialLinksModal = require(script.Parent.EditSocialLinksModal)
local parent = EditProfile.Parent
local React = require(parent.React)
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local SocialLinksNetworking = require(EditProfile.Networking.SocialLinksNetworking)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector

local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfileEnableSocialNetworksUsernames = SharedFlags2.FFlagProfileEnableSocialNetworksUsernames

local function EditSocialLinksModalContainer()
	local v = useDispatch()
	local userId = useLocalUserId()
	local v2 = useNavigation()

	local v3 = useSelector(function(p)
		return getDeepValue(p, "Profile.SocialLinks.selfSocialLinks")
	end)

	local function cancelOnActivated() -- 1 equivalent call inferred from this helper
		v2.goBack()
	end

	local function openEditSocialNetworksErrorModal(code)
		local v4 = {
			name = AppPage.EditSocialNetworksError,
			extraProps = { errorCode = code }
		}

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v4))
		else
			v(NavigateDown(v4))
		end
	end

	local function saveSocialLinks(promotionChannelsVisibilityPrivacy: string, facebook: string, twitter: string, youtube: string, twitch: string, guilded: string)
		return v(SocialLinksNetworking.SetSocialLinks.API({
			promotionChannelsVisibilityPrivacy = promotionChannelsVisibilityPrivacy,
			facebook = facebook,
			twitter = twitter,
			youtube = youtube,
			twitch = twitch,
			guilded = guilded
		})):andThen(function(_)
			v(SocialLinksNetworking.GetSelfSocialLinks.API({
				alwaysReturnUrls = false,
				filterLink = false
			})):catch(function(_) end)

			v(SocialLinksNetworking.GetSocialLinks.API({
				userId = userId,
				alwaysReturnUrls = true,
				filterLink = true
			})):andThen(function(_)
				if FFlagProfileEnableSocialNetworksUsernames then
					v(SocialLinksNetworking.GetSocialLinks.API({
						userId = userId,
						alwaysReturnUrls = false,
						filterLink = true
					}))
				end
			end):catch(function(_) end)
			cancelOnActivated() -- inferred equivalent call
		end):catch(function(p)
			local success, result = pcall(function()
				return HttpService:JSONDecode(p.Body)
			end)

			openEditSocialNetworksErrorModal(success and result and result.errors and result.errors[1] and result.errors[1].code or -1)
		end)
	end

	return React.createElement(EditSocialLinksModal, {
		socialNetworksVisbility = v3.visibility,
		socialNetworks = v3.socialLinks,
		cancelOnActivated = cancelOnActivated,
		saveOnActivated = saveSocialLinks
	})
end

return EditSocialLinksModalContainer
