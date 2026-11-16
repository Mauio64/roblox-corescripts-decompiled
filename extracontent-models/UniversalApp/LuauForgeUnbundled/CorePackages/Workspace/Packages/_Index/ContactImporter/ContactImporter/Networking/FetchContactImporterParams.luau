local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")
local networkingUserSettings = dependencies.NetworkingUserSettings
local networkingAccountInformation = dependencies.NetworkingAccountInformation
local permissionsProtocol = dependencies.PermissionsProtocol
local promise = dependencies.Promise
local llama = dependencies.llama
local contactImporterModalInfo = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils/contactImporterModalInfo")
local updateOptedInUsers = dependencies.SocialModalsCommon.Utils.updateOptedInUsers
local contactImporterOSPermissions = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Utils/contactImporterOSPermissions")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants")
local SetContactImporterDisplayLogic = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Actions/SetContactImporterDisplayLogic")

local function fn(p2) end

return function(p2, object, p3)
	return function(object2)
		local v5 = {
			object2:dispatch(networkingUserSettings.GetUserSettings.API({})):andThen(function(p4)
				return promise.resolve(
					{
						phoneNumberDiscoverability = p4.responseBody.phoneNumberDiscoverability
					},
					fn
				)
			end),
			object2:dispatch(networkingAccountInformation.GetPhoneInformation.API()):andThen(function(p4)
				return promise.resolve({ isPhoneVerified = p4.responseBody.isVerified }, fn)
			end),
			object:hasPermissions({ permissionsProtocol.Permissions.CONTACTS_ACCESS }):andThen(function(p4)
				local v6 = p4 and p4.status == permissionsProtocol.Status.AUTHORIZED

				if not v6 then
					updateOptedInUsers:clearLocalStorage(p3)
				end

				return promise.resolve({ hasOSPermissions = v6 })
			end, fn)
		}

		promise.all(v5):andThen(function(items)
			local joined = {}

			for k, item in items do
				joined = llama.Dictionary.join(joined, item)
			end

			local userOptedInLocalStorage = contactImporterModalInfo:isUserOptedInLocalStorage(p3, p2)

			local shouldUserSeeModalPotentiallyAgain = contactImporterModalInfo:shouldUserSeeModalPotentiallyAgain(p3, p2)
			joined[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_AGAIN] = shouldUserSeeModalPotentiallyAgain

			joined[Constants.IS_USER_OPTED_IN_LOCAL_STORAGE] = userOptedInLocalStorage
			object2:dispatch(SetContactImporterDisplayLogic(joined))

			local lastOSPermissionSettings = contactImporterOSPermissions:getLastOSPermissionSettings(p3)
			local hasOSPermissions = joined.hasOSPermissions
			local v6 = lastOSPermissionSettings == hasOSPermissions

			contactImporterOSPermissions:updateOSPermissionSettings(p3, hasOSPermissions)
		end):catch(function() end)
	end
end
