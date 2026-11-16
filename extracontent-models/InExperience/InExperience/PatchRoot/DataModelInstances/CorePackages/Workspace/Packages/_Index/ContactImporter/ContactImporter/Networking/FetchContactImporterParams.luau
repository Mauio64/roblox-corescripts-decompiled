local parent = script.Parent.Parent
local dependencies = require(parent.dependencies)
local networkingUserSettings = dependencies.NetworkingUserSettings
local networkingAccountInformation = dependencies.NetworkingAccountInformation
local permissionsProtocol = dependencies.PermissionsProtocol
local promise = dependencies.Promise
local llama = dependencies.llama
local contactImporterModalInfo = require(parent.Utils.contactImporterModalInfo)
local updateOptedInUsers = dependencies.SocialModalsCommon.Utils.updateOptedInUsers
local contactImporterOSPermissions = require(parent.Utils.contactImporterOSPermissions)
local Constants = require(parent.Common.Constants)
local SetContactImporterDisplayLogic = require(parent.Actions.SetContactImporterDisplayLogic)

local function fn(_) end

return function(p: string, object, p2)
	return function(object2)
		local v = {
			object2:dispatch(networkingUserSettings.GetUserSettings.API({})):andThen(function(p3)
				return promise.resolve({
					phoneNumberDiscoverability = p3.responseBody.phoneNumberDiscoverability
				}, fn)
			end),
			object2:dispatch(networkingAccountInformation.GetPhoneInformation.API()):andThen(function(p3)
				return promise.resolve({ isPhoneVerified = p3.responseBody.isVerified }, fn)
			end),
			object:hasPermissions({ permissionsProtocol.Permissions.CONTACTS_ACCESS }):andThen(function(p3)
				local hasOSPermissions = p3 and p3.status == permissionsProtocol.Status.AUTHORIZED

				if not hasOSPermissions then
					updateOptedInUsers:clearLocalStorage(p2)
				end

				return promise.resolve({ hasOSPermissions = hasOSPermissions })
			end, fn)
		}

		promise.all(v):andThen(function(items)
			local joined = {}

			for _, item in items do
				joined = llama.Dictionary.join(joined, item)
			end

			local userOptedInLocalStorage = contactImporterModalInfo:isUserOptedInLocalStorage(p2, p)

			local shouldUserSeeModalPotentiallyAgain = contactImporterModalInfo:shouldUserSeeModalPotentiallyAgain(
				p2,
				p
			)
			joined[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_AGAIN] = shouldUserSeeModalPotentiallyAgain

			joined[Constants.IS_USER_OPTED_IN_LOCAL_STORAGE] = userOptedInLocalStorage
			object2:dispatch(SetContactImporterDisplayLogic(joined))

			local lastOSPermissionSettings = contactImporterOSPermissions:getLastOSPermissionSettings(p2)
			local hasOSPermissions = joined.hasOSPermissions
			local _ = lastOSPermissionSettings == hasOSPermissions

			contactImporterOSPermissions:updateOSPermissionSettings(p2, hasOSPermissions)
		end):catch(function() end)
	end
end
