local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local AppStorageService = game:GetService("AppStorageService")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local RoactUtils = require(parent.RoactUtils)
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local Cryo = require(parent.Cryo)

local DataHydration = require(parent.DataHydration)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local Signals = require(parent.Signals)

local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local SocialIdentity = require(ProfilePlatform.Components.UserProfileHeader.SocialIdentity)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local UserProfiles = require(parent.UserProfiles)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

local v = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function SocialIdentityContainer(p)
	local profileId = useProfileWrapperContext().profileId
	local isLocalUser = profileId == useLocalUserId()
	local v2 = isLocalUser and "NamesDisplayNameTooltipImpressionCount" or "NamesProfileTooltip"
	local item = tonumber(AppStorageService:GetItem(v2)) or 0
	local ref = React.useRef(item)

	local v3 = React.useCallback(function(value: number)
		AppStorageService:SetItem(v2, (tostring(value or 0)))
		AppStorageService:Flush()
	end)

	local dismissTooltip = React.useCallback(function()
		ref.current = 3
		v3(3)
	end)

	useEffectOnce(function()
		if ref.current then
			v3(ref.current + 1)
		end
	end, false)
	local isRobloxSubscriber

	if FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = useIsRobloxSubscriber(profileId or nil)
	end

	local isTrustedConnection = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p2)
			if profileId and profileId ~= "" then
				return (v.getIsTrustedConnection(profileId).data(p2))
			end

			return nil
		end)
	end, { profileId })))

	local createElement = React.createElement

	local union = Cryo.Dictionary.union

	if not FFlagEnableBlackbirdCheck then
		isRobloxSubscriber = nil
	end

	return createElement(SocialIdentity, (union(p, {
		isLocalUser = isLocalUser,
		isTooltipActive = false,
		dismissTooltip = dismissTooltip,
		isTrustedConnection = isTrustedConnection,
		isRobloxSubscriber = isRobloxSubscriber
	})))
end

return SocialIdentityContainer
