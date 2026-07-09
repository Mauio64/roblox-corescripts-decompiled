local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local SetCentralOverlay = require(CorePackages.Workspace.Packages.CentralOverlay).Actions.SetCentralOverlay
local CentralOverlayType = require(CorePackages.Workspace.Packages.RobloxAppEnums).CentralOverlayType
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local mutedError = require(CorePackages.Workspace.Packages.Loggers).mutedError
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Logout = require(Modules.LuaApp.Thunks.Authentication.Logout)
local ResetNavigationHistory = require(Modules.LuaApp.Thunks.ResetNavigationHistory)
local SetModerationStatus = require(CorePackages.Workspace.Packages.NotApprovedPageShared).SetModerationStatus
local Constants = require(CorePackages.Workspace.Packages.NotApprovedPageShared).Constants

local function ModerationEventReceiver() -- line: 36
	-- upvalues: useDispatch (copy), useSelector (copy), React (copy), Constants (copy), ArgCheck (copy), mutedError (copy), SetModerationStatus (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Logout (copy), ResetNavigationHistory (copy), AppPage (copy)
	local v16 = useDispatch()
	local v17 = useSelector(function(p1) -- line: 38
		return p1.Moderation
	end)

	React.useEffect(function() -- line: 42
		-- upvalues: v17 (copy), Constants (copy), ArgCheck (copy), mutedError (copy), v16 (copy), SetModerationStatus (copy), SetCentralOverlay (copy), CentralOverlayType (copy), Logout (copy), ResetNavigationHistory (copy), AppPage (copy)
		if not v17 or (not v17.userModerated or not v17.moderationDetail) then
			return
		end

		local moderationDetail = v17.moderationDetail
		local punishmentTypeDescription = moderationDetail.punishmentTypeDescription
		local v21 = Constants.PUNISHMENT_TYPE_TO_INTERVENTION_MAP[punishmentTypeDescription]

		ArgCheck.isNotNil(v21, "interventionType should not be nil")

		if v21 == nil then
			mutedError("ModerationEventReceiver Got Invalid Moderation Type: `" .. tostring(punishmentTypeDescription) .. "`")
			v21 = Constants.INTERVENTION_TYPES.None
		end

		if v21 == Constants.INTERVENTION_TYPES.None then
			v16(SetModerationStatus(false))

			return
		end

		if moderationDetail.selfServiceDeactivated == true then
			v16(SetCentralOverlay(CentralOverlayType.AccountReactivationPrompt, {
				moderationDetail = moderationDetail,
				interventionType = v21,
				LogoutThunk = Logout
			}))

			return
		end

		v16(ResetNavigationHistory({{
			name = AppPage.NotApprovedPage,
			extraProps = {
				moderationDetail = moderationDetail,
				interventionType = v21,
				LogoutThunk = Logout
			}
		}}))
	end, { v17 })

	return nil
end

return ModerationEventReceiver
