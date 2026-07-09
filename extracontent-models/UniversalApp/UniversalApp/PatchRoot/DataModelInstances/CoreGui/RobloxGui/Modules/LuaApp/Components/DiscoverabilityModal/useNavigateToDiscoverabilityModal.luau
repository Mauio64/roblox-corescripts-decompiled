local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local OpenContactImporterLearnMoreLink = require(Modules.LuaApp.Thunks.OpenContactImporterLearnMoreLink)
local dependencies = require(CorePackages.Workspace.Packages.DiscoverabilityModal).dependencies
local getContactImporterParams = require(CorePackages.Workspace.Packages.ContactImporter).Utils.getContactImporterParams
local EnumScreens = require(CorePackages.Workspace.Packages.SocialModalsCommon).EnumScreens

return function() -- line: 17
	-- upvalues: useSelector (copy), getContactImporterParams (copy), useDispatch (copy), useNavigation (copy), SetCurrentToastMessage (copy), OpenContactImporterLearnMoreLink (copy), dependencies (copy), React (copy), Promise (copy), EnumScreens (copy)
	local v13 = useSelector(getContactImporterParams)
	local isDiscoverabilityUnset = v13.isDiscoverabilityUnset
	local isPhoneVerified = v13.isPhoneVerified
	local v16 = useDispatch()
	local v17 = useNavigation()

	local function v18(p1) -- line: 23
		-- upvalues: v16 (copy), SetCurrentToastMessage (copy)
		v16(SetCurrentToastMessage({
			toastMessage = p1
		}))
	end
	local function v19() -- line: 28
		-- upvalues: v16 (copy), OpenContactImporterLearnMoreLink (copy)
		v16(OpenContactImporterLearnMoreLink())
	end

	React.useEffect(function() -- line: 35
		-- upvalues: v16 (copy), dependencies (copy), Promise (copy)
		v16(dependencies.NetworkingUserSettings.GetUserSettingsMetadata.API()):catch(function() -- line: 36
			-- upvalues: Promise (copy)
			Promise.reject()
		end)
	end, {})

	return function(p2) -- line: 41
		-- upvalues: isDiscoverabilityUnset (copy), isPhoneVerified (copy), v17 (copy), EnumScreens (copy), v18 (copy), v19 (copy)
		if isDiscoverabilityUnset and isPhoneVerified then
			v17.navigate(EnumScreens.DiscoverabilityOverlay, {
				showToast = v18,
				openLearnMoreLink = v19,
				isStandaloneDiscoverabilityModal = p2.isStandaloneDiscoverabilityModal,
				navigateOnActivated = p2.navigateOnActivated,
				entryPoint = p2.entryPoint
			})

			return
		end

		p2.navigateOnActivated()
	end
end
