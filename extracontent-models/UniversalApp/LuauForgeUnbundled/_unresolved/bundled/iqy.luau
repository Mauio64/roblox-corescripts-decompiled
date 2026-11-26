local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module = require("@luauforge/bundled/eie")
local module2 = require("@luauforge/bundled/ecr")
local module3 = require("@luauforge/bundled/ecq")
local module4 = require("@luauforge/bundled/dFm")
local module5 = require("@luauforge/bundled/ehW")
local module6 = require("@luauforge/bundled/ehA")

local enumScreens = require("@luauforge/bundled/fAD").EnumScreens
local getContactImporterParams = require("@luauforge/bundled/cqW").Utils.getContactImporterParams
local openAmpWizardContainer = require("@luauforge/bundled/eif").OpenAmpWizardContainer

local fFlagAmpWizardEntryPointEventCtxFallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAmpWizardEntryPointEventCtxFallback

return function()
	local v5 = useSelector(getContactImporterParams)
	local isDiscoverabilityUnset = v5.isDiscoverabilityUnset
	local isPhoneVerified = v5.isPhoneVerified

	local v6 = useDispatch()
	local function fn(p2)
		v6(module4({ toastMessage = p2 }))
	end
	local function fn2()
		v6(module5())
	end
	local function fn3(p2, p3)
		v6(module6(p2, p3))
	end

	local function fn4(p2, p3)
		v6(openAmpWizardContainer(
			p2,
			p3,
			nil,
			fFlagAmpWizardEntryPointEventCtxFallback and "ContactImporter" or nil
		))
	end

	local v7 = useNavigation()
	local v8 = module(module2)
	local v9 = module(module3)

	return function()
		local navigate = v7.navigate
		local contactImporter = enumScreens.ContactImporter
		local v10 = {
			showToast = fn,
			openLearnMoreLink = fn2,
			isFromAddFriendsPage = false,
			diagService = 0,
			eventIngestService = 0,
			closeModal = 0,
			isDiscoverabilityUnset = 0,
			isPhoneVerified = 0,
			openProfilePeekView = 0,
			openAmpUpsell = 0
		}

		local v11 = if v9 then v9.Diag else nil
		v10.diagService = v11
		v10.eventIngestService = v8
		v10.closeModal = v7.pop
		v10.isDiscoverabilityUnset = isDiscoverabilityUnset
		v10.isPhoneVerified = isPhoneVerified
		v10.openProfilePeekView = fn3
		v10.openAmpUpsell = fn4
		navigate(contactImporter, v10)
	end
end
