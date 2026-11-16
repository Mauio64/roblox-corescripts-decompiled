local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SignalsReact")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/DataHydration")
local userProfileStore = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserProfiles/Stores").UserProfileStore
local useExperienceBannerImage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/GameDetail").useExperienceBannerImage
local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/TextKeys")
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/MobileGameJoinCard/MobileGameJoinCard")
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/InExperienceGameJoinCard/Types")

local getRbxThumb = Foundation.Utility.getRbxThumb
local thumbnailType = Foundation.Enums.ThumbnailType
local thumbnailSize = Foundation.Enums.ThumbnailSize
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local dataStatus = DataHydration.DataStatus
local presenceType = DataHydration.Presence.PresenceEnums.PresenceType
local v5 = DataHydration.Presence.PresenceStore.get()
local v6 = userProfileStore.get()

local function noop() end

local function isInGame(p2): boolean
	return p2 ~= nil and p2.userPresenceType == presenceType.InGame and p2.universeId ~= ""
end

local function useInExperienceGameJoinCardViewModel(data)
	local userId = data.userId
	local onJoin = data.onJoin
	local onClose = data.onClose

	local v7 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local presence = v5.GetPresenceByUserId(userId)
			local data2 = presence.data(p2)
			return {
				presence = data2,
				isLoading = data2 == nil and presence.status(p2) == dataStatus.NotReady
			}
		end)
	end, { userId })
	local v8 = SignalsReact.useSignalState(v7)
	local presence = v8.presence
	local v9

	if presence == nil or presence.userPresenceType ~= presenceType.InGame then
		v9 = false
	else
		v9 = presence.universeId ~= ""
	end

	local v10 = React.useMemo(function()
		return v6.fetchNamesByUserIds({ userId })
	end, { userId })
	local v11 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local v12 = v10(p2)
			local v13 = v12 and v12.data and v12.data[1]
			local v14 = not (v13 and v13.names) and "" or v13.names.getCombinedName(p2)
			return {
				name = v14,
				isLoading = v14 == "" and v12 ~= nil and v12.status == "fetching"
			}
		end)
	end, { v10 })
	local v12 = SignalsReact.useSignalState(v11)

	local state, setState = React.useState(nil)
	React.useEffect(function()
		if v9 then
			setState(presence)
		end
	end, { presence, v9 })

	if v9 then
		state = presence
	end

	local v13 = not state and "" or state.universeId
	local v14 = if state and state.rootPlaceId ~= "" then state.rootPlaceId else nil

	local v15 = useExperienceBannerImage(v13, v14)

	local v16 = if v13 ~= "" then getRbxThumb(thumbnailType.GameIcon, v13, thumbnailSize.Medium) else nil

	local v17 = React.useMemo(function()
		if v9 and presence ~= nil then
			return {
				userId = userId,
				placeId = presence.placeId,
				rootPlaceId = presence.rootPlaceId,
				universeId = presence.universeId
			}
		end

		return nil
	end, { userId, presence, v9 })

	local ref = React.useRef(false)
	local v18 = React.useCallback(function()
		if ref.current or v17 == nil then
			return
		end

		ref.current = true
		onJoin(v17)
		onClose()
	end, { v17, onJoin, onClose })

	local v19 = useLocalization({ join = TextKeys[userCtaAction.JoinExperience] })

	local isLoading = v8.isLoading or v12.isLoading

	local v20 = {
		{
			id = userCtaAction.JoinExperience,
			text = v19.join,
			variant = buttonVariant.Emphasis,
			inputSize = inputSize.Medium,
			width = UDim.new(1, 0),
			isLoading = isLoading,
			isDisabled = not v9,
			keepOpenOnActivate = true,
			onActivated = v18
		}
	}

	return {
		onClose = onClose,
		onJoin = v18,
		onViewProfile = nil,
		onViewExperienceDetails = nil,
		userId = userId,
		universeId = v13,
		playerName = v12.name,
		experienceName = not state and "" or state.lastLocation,
		bannerImageUrl = v15.url,
		thumbnailImageUrl = v16,
		onChat = noop,
		canUsePlatformChat = false,
		isLoading = isLoading,
		isInExperience = v9,
		ageCheckRequired = false,
		actions = v20,
		areActionsLoading = false,
		disableAppTelemetry = true
	}
end

return useInExperienceGameJoinCardViewModel
