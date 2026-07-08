local Parent = script:FindFirstAncestor("ContactImporter").Parent
local IXPService = game:GetService("IXPService")
local MessageBusService = game:GetService("MessageBusService")
local React = require(Parent.React)
local useNavigation = require(Parent.Navigation).useNavigation
local SocialModalsCommon = require(Parent.SocialModalsCommon)
local Promise = require(Parent.Promise)
local PermissionsProtocol = require(Parent.PermissionsProtocol).PermissionsProtocol
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local RoactAppExperiment = require(Parent.RoactAppExperiment)
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local getDeepValue = require(Parent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Dictionary.getDeepValue
local default = PermissionsProtocol.default
local t1 = { PermissionsProtocol.Permissions.CONTACTS_ACCESS }
local EnumScreens = SocialModalsCommon.EnumScreens
local SettingsRoute = require(Parent.LinkingProtocol).Enums.SettingsRoute
local SharedFlags = require(Parent.SharedFlags)
local FFlagCIDeeplinkEnabledForAll = SharedFlags.FFlagCIDeeplinkEnabledForAll
local FFlagCiDeprecateFindFriendsModal = SharedFlags.FFlagCiDeprecateFindFriendsModal
local FFlagAddFriendsPageFAEUpsell = SharedFlags.FFlagAddFriendsPageFAEUpsell
local autoPromptStatus = require(script.Parent.Parent.Signals.autoPromptStatus)
local MessageId = MessageBusService:GetMessageId("Realtime", "appResume")

local function useBeginContactImporter(t2: {[any]: any}) -- line: 39
	-- upvalues: useNavigation (copy), React (copy), useAppPolicy (copy), getDeepValue (copy), EnumScreens (copy), FFlagCIDeeplinkEnabledForAll (copy), RoactAppExperiment (copy), AppUserLayers (copy), PermissionsProtocol (copy), FFlagAddFriendsPageFAEUpsell (copy), autoPromptStatus (copy), default (copy), t1 (copy), Promise (copy), FFlagCiDeprecateFindFriendsModal (copy), SettingsRoute (copy), IXPService (copy), MessageBusService (copy), MessageId (copy)
	local v25 = useNavigation()
	local v26, v27 = React.useState(false)
	local v28 = useAppPolicy(function(p1) -- line: 43
		return p1.getContactImporterEnabled()
	end)
	local v29 = t2 and t2.entryPoint or nil
	local v30 = (getDeepValue(v25, "state.routeName") or {}) == EnumScreens.ContactImporter
	local v31 = useAppPolicy(function(p2) -- line: 51
		return p2.getContactImporterEncouraged()
	end)
	local u32 = nil

	if not FFlagCIDeeplinkEnabledForAll then
		u32 = RoactAppExperiment.useUserExperiment({ AppUserLayers.ContactImporterDevicePermissionNeededModalExposure }, function(p3) -- line: 61
			-- upvalues: AppUserLayers (copy)
			return (p3[AppUserLayers.ContactImporterDevicePermissionNeededModalExposure] or {}).systemSettingsDeeplinkEnabled
		end, false)
	end

	local v33 = not v31
	local v34 = React.useCallback(function(p4) -- line: 70
		-- upvalues: PermissionsProtocol (copy), v27 (copy), v25 (copy), EnumScreens (copy), v29 (copy)
		local v41 = p4.status == PermissionsProtocol.Status.AUTHORIZED

		v27(v41)

		if v41 then
			v25.navigate(EnumScreens.ContactsList, {
				shouldUpdateUserSettings = true,
				entrypoint = v29
			})
		end
	end, {
		v25,
		v29
	})
	local v35 = React.useCallback(function(p5) -- line: 82
		-- upvalues: PermissionsProtocol (copy), v27 (copy), FFlagAddFriendsPageFAEUpsell (copy), autoPromptStatus (copy), v31 (copy), default (copy), t1 (copy), v34 (copy), Promise (copy)
		local status = p5.status

		if status == PermissionsProtocol.Status.AUTHORIZED then
			v27(true)

			if FFlagAddFriendsPageFAEUpsell then
				autoPromptStatus.setStatus(false)
			end
		elseif status == PermissionsProtocol.Status.DENIED then
			if v31 then
				if FFlagAddFriendsPageFAEUpsell then
					local elapsed = os.clock()

					default:requestPermissions(t1):andThen(function(p6) -- line: 101
						-- upvalues: elapsed (copy), PermissionsProtocol (copy), autoPromptStatus (copy)
						local v48 = os.clock() - elapsed >= 0.5 or p6.status == PermissionsProtocol.Status.AUTHORIZED

						autoPromptStatus.setStatus(v48)

						return p6
					end):andThen(v34)
				else
					default:requestPermissions(t1):andThen(v34)
				end
			elseif FFlagAddFriendsPageFAEUpsell then
				autoPromptStatus.setStatus(false)
			end
		elseif FFlagAddFriendsPageFAEUpsell then
			autoPromptStatus.setStatus(false)
		end

		return Promise.resolve(p5.status)
	end, {
		v34,
		v31
	})
	local v36 = React.useCallback(function() -- line: 121
		-- upvalues: FFlagCiDeprecateFindFriendsModal (copy), v30 (copy), default (copy), t1 (copy), PermissionsProtocol (copy), v27 (copy), v25 (copy), EnumScreens (copy), v29 (copy), SettingsRoute (copy), v31 (copy), v26 (copy), FFlagCIDeeplinkEnabledForAll (copy), IXPService (copy), AppUserLayers (copy), u32 (ref), v33 (copy)
		if FFlagCiDeprecateFindFriendsModal and v30 then
			default:requestPermissions(t1):andThen(function(p7) -- line: 123
				-- upvalues: PermissionsProtocol (copy), v27 (copy), v25 (copy), EnumScreens (copy), v29 (copy), SettingsRoute (copy)
				if p7.status == PermissionsProtocol.Status.AUTHORIZED then
					v27(true)
					v25.replace(EnumScreens.ContactsList, {
						entrypoint = v29
					})

					return
				end

				v25.replace(EnumScreens.SettingsPermissionInteractiveAlert, {
					settingsRoute = SettingsRoute.Contacts
				})
			end)

			return
		end

		if v31 then
			if v26 then
				v25.navigate(EnumScreens.ContactsList, {
					entrypoint = v29
				})

				return
			end

			if not FFlagCIDeeplinkEnabledForAll then
				IXPService:LogUserLayerExposure(AppUserLayers.ContactImporterDevicePermissionNeededModalExposure)
			end

			if u32 or FFlagCIDeeplinkEnabledForAll then
				v25.navigate(EnumScreens.SettingsPermissionInteractiveAlert, {
					settingsRoute = SettingsRoute.Contacts
				})

				return
			end

			v25.navigate(EnumScreens.ContactsRevokedAccessDialog)

			return
		end

		if v33 then
			default:requestPermissions(t1):andThen(function(p8) -- line: 154
				-- upvalues: PermissionsProtocol (copy), v25 (copy), EnumScreens (copy), v29 (copy), FFlagCIDeeplinkEnabledForAll (copy), IXPService (copy), AppUserLayers (copy), u32 (ref), SettingsRoute (copy)
				if p8.status == PermissionsProtocol.Status.AUTHORIZED then
					v25.navigate(EnumScreens.ContactsList, {
						entrypoint = v29
					})

					return
				end

				if not FFlagCIDeeplinkEnabledForAll then
					IXPService:LogUserLayerExposure(AppUserLayers.ContactImporterDevicePermissionNeededModalExposure)
				end

				if u32 or FFlagCIDeeplinkEnabledForAll then
					v25.navigate(EnumScreens.SettingsPermissionInteractiveAlert, {
						settingsRoute = SettingsRoute.Contacts
					})

					return
				end

				v25.navigate(EnumScreens.ContactsRevokedAccessDialog)
			end)

			return
		end
	end, {
		v26,
		v28,
		v31,
		v33,
		v29,
		u32
	})

	React.useEffect(function() -- line: 189
		-- upvalues: FFlagAddFriendsPageFAEUpsell (copy), autoPromptStatus (copy), default (copy), t1 (copy), v28 (copy), v31 (copy), v33 (copy), v35 (copy)
		if FFlagAddFriendsPageFAEUpsell then
			autoPromptStatus.setStatus(nil)
		end

		local v45 = default:hasPermissions(t1)

		if v28 and (v31 or v33) then
			v45:andThen(v35)
		elseif FFlagAddFriendsPageFAEUpsell then
			autoPromptStatus.setStatus(false)
		end

		if FFlagAddFriendsPageFAEUpsell then
			return function() -- line: 203
				-- upvalues: autoPromptStatus (copy)
				autoPromptStatus.setStatus(nil)
			end
		end

		return nil
	end, {
		v28,
		v31,
		v33
	})
	React.useEffect(function() -- line: 211
		-- upvalues: u32 (ref), FFlagCIDeeplinkEnabledForAll (copy), MessageBusService (copy), MessageId (copy), default (copy), t1 (copy), PermissionsProtocol (copy), v27 (copy)
		if u32 or FFlagCIDeeplinkEnabledForAll then
			local v46 = MessageBusService:Subscribe(MessageId, function() -- line: 213
				-- upvalues: default (copy), t1 (copy), PermissionsProtocol (copy), v27 (copy)
				default:hasPermissions(t1):andThen(function(p9) -- line: 214
					-- upvalues: PermissionsProtocol (copy), v27 (copy)
					if p9 and p9.status == PermissionsProtocol.Status.AUTHORIZED then
						v27(true)
					end
				end)
			end, false, true)

			return function() -- line: 221
				-- upvalues: v46 (copy)
				v46:Disconnect()
			end
		end

		return nil
	end, { u32 })

	if v28 then
		if v31 or v33 then
			return v26, v36
		end

		return nil, nil
	end

	return nil, nil
end

return useBeginContactImporter
