local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local AppEventIngestService = require(Modules.LuaApp.Services.AppEventIngestService)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local OpenContactImporterLearnMoreLink = require(Modules.LuaApp.Thunks.OpenContactImporterLearnMoreLink)
local OpenProfilePeekView = require(Modules.LuaApp.Thunks.OpenProfilePeekView)
local EnumScreens = require(CorePackages.Workspace.Packages.SocialModalsCommon).EnumScreens
local getContactImporterParams = require(CorePackages.Workspace.Packages.ContactImporter).Utils.getContactImporterParams
local OpenAmpWizardContainer = require(CorePackages.Workspace.Packages.AmpUpsell).OpenAmpWizardContainer

return function() -- line: 20
	-- upvalues: useSelector (copy), getContactImporterParams (copy), useDispatch (copy), SetCurrentToastMessage (copy), OpenContactImporterLearnMoreLink (copy), OpenProfilePeekView (copy), OpenAmpWizardContainer (copy), useNavigation (copy), useRoactService (copy), AppEventIngestService (copy), RoactAnalytics (copy), EnumScreens (copy)
	local v15 = useSelector(getContactImporterParams)
	local isDiscoverabilityUnset = v15.isDiscoverabilityUnset
	local isPhoneVerified = v15.isPhoneVerified
	local v18 = useDispatch()

	local function v19(p1) -- line: 26
		-- upvalues: v18 (copy), SetCurrentToastMessage (copy)
		v18(SetCurrentToastMessage({
			toastMessage = p1
		}))
	end
	local function v20() -- line: 31
		-- upvalues: v18 (copy), OpenContactImporterLearnMoreLink (copy)
		v18(OpenContactImporterLearnMoreLink())
	end
	local function v21(p2, p3) -- line: 34
		-- upvalues: v18 (copy), OpenProfilePeekView (copy)
		v18(OpenProfilePeekView(p2, p3))
	end
	local function v22(p4, p5) -- line: 38
		-- upvalues: v18 (copy), OpenAmpWizardContainer (copy)
		v18(OpenAmpWizardContainer(p4, p5))
	end

	local v23 = useNavigation()
	local v24 = useRoactService(AppEventIngestService)
	local v25 = useRoactService(RoactAnalytics)

	return function() -- line: 46
		-- upvalues: v23 (copy), EnumScreens (copy), v19 (copy), v20 (copy), v25 (copy), v24 (copy), isDiscoverabilityUnset (copy), isPhoneVerified (copy), v21 (copy), v22 (copy)
		v23.navigate(EnumScreens.ContactImporter, {
			isFromAddFriendsPage = false,
			showToast = v19,
			openLearnMoreLink = v20,
			diagService = if not v25 then nil else v25.Diag,
			eventIngestService = v24,
			closeModal = v23.pop,
			isDiscoverabilityUnset = isDiscoverabilityUnset,
			isPhoneVerified = isPhoneVerified,
			openProfilePeekView = v21,
			openAmpUpsell = v22
		})
	end
end
