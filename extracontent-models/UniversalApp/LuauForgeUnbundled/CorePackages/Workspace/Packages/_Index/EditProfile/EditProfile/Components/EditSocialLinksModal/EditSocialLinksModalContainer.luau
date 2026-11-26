local HttpService = game:GetService("HttpService")
local EditSocialLinksModal = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Components/EditSocialLinksModal/EditSocialLinksModal")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/React")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/LuaSocialLibrariesDeps")
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppNavigation").NavigationCommands else nil

local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppEnums").AppPage
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue
local SocialLinksNetworking = require("@game/CorePackages/Workspace/Packages/_Index/EditProfile/EditProfile/Networking/SocialLinksNetworking")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RobloxAppHooks").useLocalUserId
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/RoactUtils").Hooks.RoactRodux.useSelector

local fFlagProfileEnableSocialNetworksUsernames = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfile/SharedFlags").FFlagProfileEnableSocialNetworksUsernames

local function EditSocialLinksModalContainer()
	local v5 = useDispatch()
	local v6 = useLocalUserId()
	local v7 = useNavigation()

	local v8 = useSelector(function(p2)
		return getDeepValue(p2, "Profile.SocialLinks.selfSocialLinks")
	end)

	local function openEditSocialNetworksErrorModal(code)
		local v9 = {
			name = appPage.EditSocialNetworksError,
			extraProps = { errorCode = code }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v9))
		else
			v5(navigateDown(v9))
		end
	end

	local function saveSocialLinks(p2, p3, p4, p5, p6, p7)
		return v5(SocialLinksNetworking.SetSocialLinks.API({
			promotionChannelsVisibilityPrivacy = p2,
			facebook = p3,
			twitter = p4,
			youtube = p5,
			twitch = p6,
			guilded = p7
		})):andThen(function(p8)
			v5(SocialLinksNetworking.GetSelfSocialLinks.API({
				alwaysReturnUrls = false,
				filterLink = false
			})):catch(function(p9) end)

			v5(SocialLinksNetworking.GetSocialLinks.API({
				userId = v6,
				alwaysReturnUrls = true,
				filterLink = true
			})):andThen(function(p9)
				if fFlagProfileEnableSocialNetworksUsernames then
					v5(SocialLinksNetworking.GetSocialLinks.API({
						userId = v6,
						alwaysReturnUrls = false,
						filterLink = true
					}))
				end
			end):catch(function(p9) end)
			v7.goBack()
		end):catch(function(p8)
			local success, result = pcall(function()
				return HttpService:JSONDecode(p8.Body)
			end)

			local code = success
				and result
				and result.errors
				and result.errors[1]
				and result.errors[1].code
				or -1

			openEditSocialNetworksErrorModal(code)
		end)
	end

	return React.createElement(EditSocialLinksModal, {
		socialNetworksVisbility = v8.visibility,
		socialNetworks = v8.socialLinks,
		cancelOnActivated = function()
			v7.goBack()
		end,
		saveOnActivated = saveSocialLinks
	})
end

return EditSocialLinksModalContainer
