local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local AppStorageService = game:GetService("AppStorageService")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useLocalUserId = require(ProfilePlatformParent.RobloxAppHooks).useLocalUserId
local useEffectOnce = require(ProfilePlatformParent.RoactUtils).Hooks.useEffectOnce
local Cryo = require(ProfilePlatformParent.Cryo)
local DataHydration = require(ProfilePlatformParent.DataHydration)
local useSignalState = require(ProfilePlatformParent.SignalsReact).useSignalState
local Signals = require(ProfilePlatformParent.Signals)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local SocialIdentity = require(ProfilePlatform.Components.UserProfileHeader.SocialIdentity)
local FFlagEnableBlackbirdCheck = require(ProfilePlatformParent.SharedFlags).FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require(ProfilePlatformParent.UserProfiles).Hooks.useIsRobloxSubscriber
local v15 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function SocialIdentityContainer(t1: {[any]: any}) -- line: 45
	-- upvalues: useProfileWrapperContext (copy), useLocalUserId (copy), AppStorageService (copy), React (copy), useEffectOnce (copy), FFlagEnableBlackbirdCheck (copy), useIsRobloxSubscriber (copy), Signals (copy), v15 (copy), useSignalState (copy), SocialIdentity (copy), Cryo (copy)
	local profileId = useProfileWrapperContext().profileId
	local v19 = profileId == useLocalUserId()
	local v20 = not v19 and "NamesProfileTooltip" or "NamesDisplayNameTooltipImpressionCount"
	local v21 = tonumber(AppStorageService:GetItem(v20)) or 0
	local v22 = React.useRef(v21)
	local v23 = React.useCallback(function(n1: number) -- line: 58
		-- upvalues: AppStorageService (copy), v20 (copy)
		AppStorageService:SetItem(v20, (tostring(n1 or 0)))
		AppStorageService:Flush()
	end)
	local v24 = React.useCallback(function() -- line: 63
		-- upvalues: v22 (copy), v23 (copy)
		v22.current = 3
		v23(3)
	end)

	useEffectOnce(function() -- line: 68
		-- upvalues: v22 (copy), v23 (copy)
		if v22.current then
			v23(v22.current + 1)
		end
	end, false)

	local v25 = nil

	if FFlagEnableBlackbirdCheck then
		v25 = useIsRobloxSubscriber(profileId or nil)
	end

	local v26 = React.useMemo(function() -- line: 80
		-- upvalues: Signals (copy), profileId (copy), v15 (copy)
		return Signals.createComputed(function(p1) -- line: 81
			-- upvalues: profileId (copy), v15 (copy)
			if profileId and profileId ~= "" then
				return (v15.getIsTrustedConnection(profileId).data(p1))
			end

			return nil
		end)
	end, { profileId })
	local v27 = useSignalState(v26)

	return React.createElement(SocialIdentity, (Cryo.Dictionary.union(t1, {
		isTooltipActive = false,
		isLocalUser = v19,
		dismissTooltip = v24,
		isTrustedConnection = v27,
		isRobloxSubscriber = if not FFlagEnableBlackbirdCheck then nil else v25
	})))
end

return SocialIdentityContainer
