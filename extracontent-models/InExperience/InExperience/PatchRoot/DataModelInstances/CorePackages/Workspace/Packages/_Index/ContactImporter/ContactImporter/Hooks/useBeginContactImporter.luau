local parent = script:FindFirstAncestor("ContactImporter").Parent

local IXPService = game:GetService("IXPService")
local MessageBusService = game:GetService("MessageBusService")

local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local SocialModalsCommon = require(parent.SocialModalsCommon)
local Promise = require(parent.Promise)
local PermissionsProtocol = require(parent.PermissionsProtocol)
local permissionsProtocol = PermissionsProtocol.PermissionsProtocol
local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local RoactAppExperiment = require(parent.RoactAppExperiment)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local getDeepValue = LuaSocialLibrariesDeps.SocialLibraries.config({}).Dictionary.getDeepValue

local default = permissionsProtocol.default
local v = { permissionsProtocol.Permissions.CONTACTS_ACCESS }
local EnumScreens = SocialModalsCommon.EnumScreens
local LinkingProtocol = require(parent.LinkingProtocol)
local SettingsRoute = LinkingProtocol.Enums.SettingsRoute

local SharedFlags = require(parent.SharedFlags)
local FFlagCIDeeplinkEnabledForAll = SharedFlags.FFlagCIDeeplinkEnabledForAll
local FFlagCiDeprecateFindFriendsModal = SharedFlags.FFlagCiDeprecateFindFriendsModal
local FFlagAddFriendsPageFAEUpsell = SharedFlags.FFlagAddFriendsPageFAEUpsell

local autoPromptStatus = require(script.Parent.Parent.Signals.autoPromptStatus)

local messageId = MessageBusService:GetMessageId("Realtime", "appResume")

local function useBeginContactImporter(p)
	local v2 = useNavigation()
	local state, setState = React.useState(false)

	local v3 = useAppPolicy(function(p2)
		return p2.getContactImporterEnabled()
	end)

	local entryPoint = p and p.entryPoint or nil
	local v4 = (getDeepValue(v2, "state.routeName") or {}) == EnumScreens.ContactImporter

	local v5 = useAppPolicy(function(p2)
		return p2.getContactImporterEncouraged()
	end)
	local v6

	if FFlagCIDeeplinkEnabledForAll then
		v6 = nil
	else
		v6 = RoactAppExperiment.useUserExperiment(
			{ AppUserLayers.ContactImporterDevicePermissionNeededModalExposure },
			function(p2)
				return (p2[AppUserLayers.ContactImporterDevicePermissionNeededModalExposure] or {}).systemSettingsDeeplinkEnabled
			end,
			false
		)
	end

	local v7 = not v5

	local v8 = React.useCallback(function(p2)
		local v8 = p2.status == permissionsProtocol.Status.AUTHORIZED
		setState(v8)

		if v8 then
			v2.navigate(EnumScreens.ContactsList, {
				shouldUpdateUserSettings = true,
				entrypoint = entryPoint
			})
		end
	end, { v2, entryPoint })

	local v9 = React.useCallback(function(p2)
		local status = p2.status

		if status == permissionsProtocol.Status.AUTHORIZED then
			setState(true)

			if FFlagAddFriendsPageFAEUpsell then
				autoPromptStatus.setStatus(false)
			end
		elseif status == permissionsProtocol.Status.DENIED then
			if v5 then
				if FFlagAddFriendsPageFAEUpsell then
					local lastTime = os.clock()

					default:requestPermissions(v):andThen(function(p3)
						local v9 = os.clock() - lastTime >= 0.5 or p3.status == permissionsProtocol.Status.AUTHORIZED
						autoPromptStatus.setStatus(v9)
						return p3
					end):andThen(v8)
				else
					default:requestPermissions(v):andThen(v8)
				end
			elseif FFlagAddFriendsPageFAEUpsell then
				autoPromptStatus.setStatus(false)
			end
		elseif FFlagAddFriendsPageFAEUpsell then
			autoPromptStatus.setStatus(false)
		end

		return Promise.resolve(p2.status)
	end, { v8, v5 })

	local v10 = React.useCallback(function()
		if FFlagCiDeprecateFindFriendsModal and v4 then
			default:requestPermissions(v):andThen(function(p2)
				if p2.status ~= permissionsProtocol.Status.AUTHORIZED then
					v2.replace(EnumScreens.SettingsPermissionInteractiveAlert, {
						settingsRoute = SettingsRoute.Contacts
					})

					return
				end

				setState(true)
				v2.replace(EnumScreens.ContactsList, { entrypoint = entryPoint })
			end)
		elseif v5 then
			if state then
				v2.navigate(EnumScreens.ContactsList, { entrypoint = entryPoint })
				return
			end

			if not FFlagCIDeeplinkEnabledForAll then
				IXPService:LogUserLayerExposure(AppUserLayers.ContactImporterDevicePermissionNeededModalExposure)
			end

			if v6 or FFlagCIDeeplinkEnabledForAll then
				v2.navigate(EnumScreens.SettingsPermissionInteractiveAlert, {
					settingsRoute = SettingsRoute.Contacts
				})
			else
				v2.navigate(EnumScreens.ContactsRevokedAccessDialog)
			end
		else
			if not v7 then
				return
			end

			default:requestPermissions(v):andThen(function(p2)
				if p2.status == permissionsProtocol.Status.AUTHORIZED then
					v2.navigate(EnumScreens.ContactsList, { entrypoint = entryPoint })
					return
				end

				if not FFlagCIDeeplinkEnabledForAll then
					IXPService:LogUserLayerExposure(AppUserLayers.ContactImporterDevicePermissionNeededModalExposure)
				end

				if v6 or FFlagCIDeeplinkEnabledForAll then
					v2.navigate(EnumScreens.SettingsPermissionInteractiveAlert, {
						settingsRoute = SettingsRoute.Contacts
					})
				else
					v2.navigate(EnumScreens.ContactsRevokedAccessDialog)
				end
			end)
		end
	end, { state, v3, v5, v7, entryPoint, v6 })

	React.useEffect(function()
		if FFlagAddFriendsPageFAEUpsell then
			autoPromptStatus.setStatus(nil)
		end

		local permissions = default:hasPermissions(v)

		if v3 and (v5 or v7) then
			permissions:andThen(v9)
		elseif FFlagAddFriendsPageFAEUpsell then
			autoPromptStatus.setStatus(false)
		end

		if FFlagAddFriendsPageFAEUpsell then
			return function()
				autoPromptStatus.setStatus(nil)
			end
		end

		return nil
	end, { v3, v5, v7 })

	React.useEffect(function()
		if v6 or FFlagCIDeeplinkEnabledForAll then
			local connection = MessageBusService:Subscribe(messageId, function()
				default:hasPermissions(v):andThen(function(p2)
					if p2 and p2.status == permissionsProtocol.Status.AUTHORIZED then
						setState(true)
					end
				end)
			end, false, true)
			return function()
				connection:Disconnect()
			end
		end

		return nil
	end, { v6 })

	if not v3 then
		return nil, nil
	end

	if v5 or v7 then
		return state, v10
	end

	return nil, nil
end

return useBeginContactImporter
