local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local NetworkingUserSettings = dependencies.NetworkingUserSettings
local NetworkingAccountInformation = dependencies.NetworkingAccountInformation
local PermissionsProtocol = dependencies.PermissionsProtocol
local Promise = dependencies.Promise
local llama = dependencies.llama
local contactImporterModalInfo = require(ParentParent.Utils.contactImporterModalInfo)
local updateOptedInUsers = dependencies.SocialModalsCommon.Utils.updateOptedInUsers
local contactImporterOSPermissions = require(ParentParent.Utils.contactImporterOSPermissions)
local Constants = require(ParentParent.Common.Constants)
local SetContactImporterDisplayLogic = require(ParentParent.Actions.SetContactImporterDisplayLogic)

local function v13(_) -- line: 14
end

return function(s1: string, p2, p3) -- line: 18
	-- upvalues: NetworkingUserSettings (copy), Promise (copy), v13 (copy), NetworkingAccountInformation (copy), PermissionsProtocol (copy), updateOptedInUsers (copy), llama (copy), contactImporterModalInfo (copy), Constants (copy), SetContactImporterDisplayLogic (copy), contactImporterOSPermissions (copy)
	return function(p4) -- line: 19
		-- upvalues: NetworkingUserSettings (copy), Promise (copy), v13 (copy), NetworkingAccountInformation (copy), p2 (copy), PermissionsProtocol (copy), updateOptedInUsers (copy), p3 (copy), llama (copy), contactImporterModalInfo (copy), s1 (copy), Constants (copy), SetContactImporterDisplayLogic (copy), contactImporterOSPermissions (copy)
		local t1 = {
			p4:dispatch(NetworkingUserSettings.GetUserSettings.API({})):andThen(function(p5) -- line: 22
				-- upvalues: Promise (copy), v13 (copy)
				return Promise.resolve({
					phoneNumberDiscoverability = p5.responseBody.phoneNumberDiscoverability
				}, v13)
			end),
			p4:dispatch(NetworkingAccountInformation.GetPhoneInformation.API()):andThen(function(p6) -- line: 27
				-- upvalues: Promise (copy), v13 (copy)
				return Promise.resolve({
					isPhoneVerified = p6.responseBody.isVerified
				}, v13)
			end),
			p2:hasPermissions({ PermissionsProtocol.Permissions.CONTACTS_ACCESS }):andThen(function(p7) -- line: 32
				-- upvalues: PermissionsProtocol (copy), updateOptedInUsers (copy), p3 (copy), Promise (copy)
				local v23 = p7 and p7.status == PermissionsProtocol.Status.AUTHORIZED

				if not v23 then
					updateOptedInUsers:clearLocalStorage(p3)
				end

				return Promise.resolve({
					hasOSPermissions = v23
				})
			end, v13)
		}

		Promise.all(t1):andThen(function(p8) -- line: 41
			-- upvalues: llama (copy), contactImporterModalInfo (copy), p3 (copy), s1 (copy), Constants (copy), p4 (copy), SetContactImporterDisplayLogic (copy), contactImporterOSPermissions (copy)
			local t2 = {}

			for _, v27 in p8 do
				t2 = llama.Dictionary.join(t2, v27)
			end

			local v28 = contactImporterModalInfo:isUserOptedInLocalStorage(p3, s1)
			local v29 = contactImporterModalInfo:shouldUserSeeModalPotentiallyAgain(p3, s1)

			t2[Constants.SHOULD_SHOW_CONTACT_IMPORTER_UPSELL_AGAIN] = v29
			t2[Constants.IS_USER_OPTED_IN_LOCAL_STORAGE] = v28
			p4:dispatch(SetContactImporterDisplayLogic(t2))

			local v30 = contactImporterOSPermissions:getLastOSPermissionSettings(p3)
			local hasOSPermissions = t2.hasOSPermissions

			if v30 == hasOSPermissions then
			end

			contactImporterOSPermissions:updateOSPermissionSettings(p3, hasOSPermissions)
		end):catch(function() -- line: 64
		end)
	end
end
