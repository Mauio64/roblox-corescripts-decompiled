local CorePackages = game:GetService("CorePackages")

local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module = require("@luauforge/bundled/dFm")
local module2 = require("@luauforge/bundled/ehW")
local dependencies = require("@luauforge/bundled/cxh").dependencies

local getContactImporterParams = require("@luauforge/bundled/cqW").Utils.getContactImporterParams
local enumScreens = require("@luauforge/bundled/fAD").EnumScreens

return function()
	local v5 = useSelector(getContactImporterParams)
	local isDiscoverabilityUnset = v5.isDiscoverabilityUnset
	local isPhoneVerified = v5.isPhoneVerified
	local v6 = useDispatch()
	local v7 = useNavigation()
	local function fn(p2)
		v6(module({ toastMessage = p2 }))
	end
	local function fn2()
		v6(module2())
	end

	React.useEffect(function()
		v6(dependencies.NetworkingUserSettings.GetUserSettingsMetadata.API()):catch(function()
			Promise.reject()
		end)
	end, {})

	return function(data)
		if isDiscoverabilityUnset and isPhoneVerified then
			v7.navigate(enumScreens.DiscoverabilityOverlay, {
				showToast = fn,
				openLearnMoreLink = fn2,
				isStandaloneDiscoverabilityModal = data.isStandaloneDiscoverabilityModal,
				navigateOnActivated = data.navigateOnActivated,
				entryPoint = data.entryPoint
			})
		else
			data.navigateOnActivated()
		end
	end
end
