local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Foundation = require(parent.Foundation)
local DataHydration = require(parent.DataHydration)
local Stores = require(parent.UserProfiles.Stores)
local UserProfileStore = Stores.UserProfileStore
local GameDetail = require(parent.GameDetail)
local useExperienceBannerImage = GameDetail.useExperienceBannerImage
local UserCtaCommon = require(parent.UserCtaCommon)
local UserCtaAction = UserCtaCommon.Enums.UserCtaAction
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(GameJoinCard.Components.Actions.Types)
local TextKeys = require(GameJoinCard.Components.Actions.TextKeys)
require(GameJoinCard.Components.MobileGameJoinCard.MobileGameJoinCard)
require(script.Parent.Types)

local getRbxThumb = Foundation.Utility.getRbxThumb
local ThumbnailType = Foundation.Enums.ThumbnailType
local ThumbnailSize = Foundation.Enums.ThumbnailSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local DataStatus = DataHydration.DataStatus
local PresenceType = DataHydration.Presence.PresenceEnums.PresenceType
local v = DataHydration.Presence.PresenceStore.get()
local v2 = UserProfileStore.get()

local function noop() end

local function isInGame(presence): boolean -- 1 equivalent call inferred from this helper
	return presence ~= nil and presence.userPresenceType == PresenceType.InGame and presence.universeId ~= ""
end

local function useInExperienceGameJoinCardViewModel(data)
	local userId = data.userId
	local onJoin = data.onJoin
	local onClose = data.onClose

	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local presence = v.GetPresenceByUserId(userId)
			local data2 = presence.data(p)
			return {
				presence = data2,
				isLoading = data2 == nil and presence.status(p) == DataStatus.NotReady
			}
		end)
	end, { userId })
	local v4 = SignalsReact.useSignalState(v3)
	local presence = v4.presence
	local inGame = isInGame(presence) -- inferred equivalent call
	local v5 = React.useMemo(function()
		return v2.fetchNamesByUserIds({ userId })
	end, { userId })
	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p)
			local v6 = v5(p)
			local v7 = v6 and v6.data and v6.data[1]
			local name = not (v7 and v7.names) and "" or v7.names.getCombinedName(p)
			return {
				name = name,
				isLoading = name == "" and v6 ~= nil and v6.status == "fetching"
			}
		end)
	end, { v5 })
	local v7 = SignalsReact.useSignalState(v6)

	local state, setState = React.useState(nil)
	React.useEffect(function()
		if inGame then
			setState(presence)
		end
	end, { presence, inGame })

	if inGame then
		state = presence
	end

	local universeId = not state and "" or state.universeId
	local v8

	if state and state.rootPlaceId ~= "" then
		v8 = state.rootPlaceId
	end

	local v9 = useExperienceBannerImage(universeId, v8)
	local thumbnailImageUrl

	if universeId ~= "" then
		thumbnailImageUrl = getRbxThumb(ThumbnailType.GameIcon, universeId, ThumbnailSize.Medium)
	end

	local v10 = React.useMemo(function()
		if inGame and presence ~= nil then
			return {
				userId = userId,
				placeId = presence.placeId,
				rootPlaceId = presence.rootPlaceId,
				universeId = presence.universeId
			}
		end

		return nil
	end, { userId, presence, inGame })

	local ref = React.useRef(false)
	local v11 = React.useCallback(function()
		if ref.current or v10 == nil then
			return
		end

		ref.current = true
		onJoin(v10)
		onClose()
	end, { v10, onJoin, onClose })

	local v12 = useLocalization({ join = TextKeys[UserCtaAction.JoinExperience] })

	local isLoading = v4.isLoading or v7.isLoading

	local actions = {
		{
			id = UserCtaAction.JoinExperience,
			text = v12.join,
			variant = ButtonVariant.Emphasis,
			inputSize = InputSize.Medium,
			width = UDim.new(1, 0),
			isLoading = isLoading,
			isDisabled = not inGame,
			keepOpenOnActivate = true,
			onActivated = v11
		}
	}

	return {
		onClose = onClose,
		onJoin = v11,
		onViewProfile = nil,
		onViewExperienceDetails = nil,
		userId = userId,
		universeId = universeId,
		playerName = v7.name,
		experienceName = not state and "" or state.lastLocation,
		bannerImageUrl = v9.url,
		thumbnailImageUrl = thumbnailImageUrl,
		onChat = noop,
		canUsePlatformChat = false,
		isLoading = isLoading,
		isInExperience = inGame,
		ageCheckRequired = false,
		actions = actions,
		areActionsLoading = false,
		disableAppTelemetry = true
	}
end

return useInExperienceGameJoinCardViewModel
