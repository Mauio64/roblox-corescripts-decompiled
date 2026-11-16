local AppStorageService = game:GetService("AppStorageService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useLocalUserId

local useEffectOnce = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.useEffectOnce
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Cryo")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/DataHydration")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact").useSignalState
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Signals")

local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local SocialIdentity = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/SocialIdentity")
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UserProfiles").Hooks.useIsRobloxSubscriber

local v5 = DataHydration.TrustedConnections.TrustedConnectionsStore.get()

local function SocialIdentityContainer(p2)
	local profileId = useProfileWrapperContext().profileId
	local v6 = profileId == useLocalUserId()
	local v7 = v6 and "NamesDisplayNameTooltipImpressionCount" or "NamesProfileTooltip"
	local item = tonumber(AppStorageService:GetItem(v7)) or 0
	local ref = React.useRef(item)

	local v8 = React.useCallback(function(value)
		AppStorageService:SetItem(v7, (tostring(value or 0)))
		AppStorageService:Flush()
	end)

	local v9 = React.useCallback(function()
		ref.current = 3
		v8(3)
	end)

	useEffectOnce(function()
		if ref.current then
			v8(ref.current + 1)
		end
	end, false)

	local v10 = if fFlagEnableBlackbirdCheck then useIsRobloxSubscriber(profileId or nil) else nil

	local v12 = useSignalState((React.useMemo(function()
		return Signals.createComputed(function(p3)
			if profileId and profileId ~= "" then
				return (v5.getIsTrustedConnection(profileId).data(p3))
			end

			return nil
		end)
	end, { profileId })))

	local createElement = React.createElement

	local union = Cryo.Dictionary.union

	if not fFlagEnableBlackbirdCheck then
		v10 = nil
	end

	return createElement(SocialIdentity, union(p2, {
		isLocalUser = v6,
		isTooltipActive = false,
		dismissTooltip = v9,
		isTrustedConnection = v12,
		isRobloxSubscriber = v10
	}))
end

return SocialIdentityContainer
