local IXPService = game:GetService("IXPService")
local MessageBusService = game:GetService("MessageBusService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Navigation").useNavigation
local SocialModalsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SocialModalsCommon")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Promise")
local permissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/PermissionsProtocol").PermissionsProtocol
local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/ExperimentLayers").AppUserLayers
local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RoactAppExperiment")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/UniversalAppPolicy").useAppPolicy

local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/LuaSocialLibrariesDeps").SocialLibraries.config({}).Dictionary.getDeepValue

local default = permissionsProtocol.default
local v5 = { permissionsProtocol.Permissions.CONTACTS_ACCESS }
local enumScreens = SocialModalsCommon.EnumScreens
local settingsRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/LinkingProtocol").Enums.SettingsRoute

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags")
local fFlagCIDeeplinkEnabledForAll = SharedFlags.FFlagCIDeeplinkEnabledForAll
local fFlagCiDeprecateFindFriendsModal = SharedFlags.FFlagCiDeprecateFindFriendsModal
local fFlagAddFriendsPageFAEUpsell = SharedFlags.FFlagAddFriendsPageFAEUpsell

local autoPromptStatus = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Signals/autoPromptStatus")

local messageId = MessageBusService:GetMessageId("Realtime", "appResume")

local function useBeginContactImporter(p2)
	local v6 = useNavigation()
	local state, setState = React.useState(false)

	local v7 = useAppPolicy(function(p3)
		return p3.getContactImporterEnabled()
	end)

	local entryPoint = p2 and p2.entryPoint or nil
	local v8 = (getDeepValue(v6, "state.routeName") or {}) == enumScreens.ContactImporter

	local v9 = useAppPolicy(function(p3)
		return p3.getContactImporterEncouraged()
	end)
	local v10

	if fFlagCIDeeplinkEnabledForAll then
		v10 = nil
	else
		v10 = RoactAppExperiment.useUserExperiment(
			{ appUserLayers.ContactImporterDevicePermissionNeededModalExposure },
			function(p3)
				return (p3[appUserLayers.ContactImporterDevicePermissionNeededModalExposure] or {}).systemSettingsDeeplinkEnabled
			end,
			false
		)
	end

	local v11 = not v9

	local v12 = React.useCallback(function(p3)
		local v13 = p3.status == permissionsProtocol.Status.AUTHORIZED
		setState(v13)

		if v13 then
			v6.navigate(enumScreens.ContactsList, {
				shouldUpdateUserSettings = true,
				entrypoint = entryPoint
			})
		end
	end, { v6, entryPoint })

	local v13 = React.useCallback(function(p3)
		local status = p3.status

		if status == permissionsProtocol.Status.AUTHORIZED then
			setState(true)

			if fFlagAddFriendsPageFAEUpsell then
				autoPromptStatus.setStatus(false)
			end
		elseif status == permissionsProtocol.Status.DENIED then
			if v9 then
				if fFlagAddFriendsPageFAEUpsell then
					local lastTime = os.clock()

					default:requestPermissions(v5):andThen(function(p4)
						local v14 = os.clock() - lastTime >= 0.5
							or p4.status == permissionsProtocol.Status.AUTHORIZED
						autoPromptStatus.setStatus(v14)
						return p4
					end):andThen(v12)
				else
					default:requestPermissions(v5):andThen(v12)
				end
			elseif fFlagAddFriendsPageFAEUpsell then
				autoPromptStatus.setStatus(false)
			end
		elseif fFlagAddFriendsPageFAEUpsell then
			autoPromptStatus.setStatus(false)
		end

		return Promise.resolve(p3.status)
	end, { v12, v9 })

	local v14 = React.useCallback(function()
		if fFlagCiDeprecateFindFriendsModal and v8 then
			default:requestPermissions(v5):andThen(function(p3)
				if p3.status ~= permissionsProtocol.Status.AUTHORIZED then
					v6.replace(enumScreens.SettingsPermissionInteractiveAlert, {
						settingsRoute = settingsRoute.Contacts
					})

					return
				end

				setState(true)
				v6.replace(enumScreens.ContactsList, { entrypoint = entryPoint })
			end)
		elseif v9 then
			if state then
				v6.navigate(enumScreens.ContactsList, { entrypoint = entryPoint })
				return
			end

			if not fFlagCIDeeplinkEnabledForAll then
				IXPService:LogUserLayerExposure(appUserLayers.ContactImporterDevicePermissionNeededModalExposure)
			end

			if v10 or fFlagCIDeeplinkEnabledForAll then
				v6.navigate(enumScreens.SettingsPermissionInteractiveAlert, {
					settingsRoute = settingsRoute.Contacts
				})
			else
				v6.navigate(enumScreens.ContactsRevokedAccessDialog)
			end
		else
			if not v11 then
				return
			end

			default:requestPermissions(v5):andThen(function(p3)
				if p3.status == permissionsProtocol.Status.AUTHORIZED then
					v6.navigate(enumScreens.ContactsList, { entrypoint = entryPoint })
					return
				end

				if not fFlagCIDeeplinkEnabledForAll then
					IXPService:LogUserLayerExposure(appUserLayers.ContactImporterDevicePermissionNeededModalExposure)
				end

				if v10 or fFlagCIDeeplinkEnabledForAll then
					v6.navigate(enumScreens.SettingsPermissionInteractiveAlert, {
						settingsRoute = settingsRoute.Contacts
					})
				else
					v6.navigate(enumScreens.ContactsRevokedAccessDialog)
				end
			end)
		end
	end, { state, v7, v9, v11, entryPoint, v10 })

	React.useEffect(function()
		if fFlagAddFriendsPageFAEUpsell then
			autoPromptStatus.setStatus(nil)
		end

		local permissions = default:hasPermissions(v5)

		if v7 and (v9 or v11) then
			permissions:andThen(v13)
		elseif fFlagAddFriendsPageFAEUpsell then
			autoPromptStatus.setStatus(false)
		end

		if fFlagAddFriendsPageFAEUpsell then
			return function()
				autoPromptStatus.setStatus(nil)
			end
		end

		return nil
	end, { v7, v9, v11 })

	React.useEffect(function()
		if v10 or fFlagCIDeeplinkEnabledForAll then
			local connection = MessageBusService:Subscribe(messageId, function()
				default:hasPermissions(v5):andThen(function(p3)
					if p3 and p3.status == permissionsProtocol.Status.AUTHORIZED then
						setState(true)
					end
				end)
			end, false, true)
			return function()
				connection:Disconnect()
			end
		end

		return nil
	end, { v10 })

	if not v7 then
		return nil, nil
	end

	if v9 or v11 then
		return state, v14
	end

	return nil, nil
end

return useBeginContactImporter
