local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local React = require(BuildExperienceParent.React)
local Signals = require(BuildExperienceParent.Signals)
local SignalsReact = require(BuildExperienceParent.SignalsReact)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local PublishStatus = require(BuildExperience.Chat.PublishStatus)
local UniverseConfiguration = require(BuildExperienceParent.DataHydration.UniverseConfiguration)
local GameConfigurationLabels = require(BuildExperience.utils.GameConfigurationLabels)
local launchPlaytestWithLoadingState = require(BuildExperience.utils.launchPlaytestWithLoadingState)
local getPrivatePlaytestersStore = require(BuildExperienceParent.DataHydration.PrivatePlaytesters).getPrivatePlaytestersStore
local sendBuildExperienceEvent = require(BuildExperience.Telemetry.sendBuildExperienceEvent)
local FFlagBuildExperiencePrivateInvites = require(BuildExperience.Flags.FFlagBuildExperiencePrivateInvites)
local PrivacyType = UniverseConfiguration.PrivacyType

local function isInApp() -- line: 63
	return game.GameId == 0
end
local function isInGame() -- line: 67
	return game.GameId ~= 0
end
local function isAssistantDisabled(_: {[any]: any}) -- line: 71
	return game.GameId == 0
end
local function isPlaytestDisabled(t2: {[any]: any}) -- line: 75
	return game.GameId ~= 0 or (t2.placeId == nil or t2.isNewGameTarget and not t2.hasPublishedTurn)
end
local function isVersionHistoryDisabled(t3: {[any]: any}) -- line: 79
	return t3.placeId == nil
end
local function isInviteToPlaytestDisabled(t4: {[any]: any}) -- line: 83
	-- upvalues: getPrivatePlaytestersStore (copy)
	local v31 = getPrivatePlaytestersStore(false)

	return #v31.getAndFetchInvitedPlayers(t4.universeId).players(false) >= v31.MAX_INVITES
end
local function getPublishText(t5: {[any]: any}) -- line: 89
	-- upvalues: PublishStatus (copy), LocalizationStrings (copy)
	if PublishStatus.isPublishLatest(t5.hasPublishedVersion, t5.hasPublishedTurn) then
		return LocalizationStrings.BUILD_MENU_PUBLISH_LATEST
	end

	return LocalizationStrings.BUILD_MENU_PUBLISH
end
local function onShareActivated(t6: {[any]: any}) -- line: 98
	-- upvalues: UniverseConfiguration (copy), GameConfigurationLabels (copy), PrivacyType (copy)
	if t6.placeId == nil then
		return nil
	end

	local v34 = UniverseConfiguration.getUniverseConfigurationStore().getAndFetchConfiguration(t6.universeId).data()
	local v35 = GameConfigurationLabels.getAudience(v34)

	if v35 == PrivacyType.Private then
		return {
			type = "showPrivateShareTooltip"
		}
	end

	if v35 == PrivacyType.FriendsOnly then
		return {
			type = "confirmFriendsShare",
			placeId = t6.placeId
		}
	end

	if v35 == PrivacyType.Public then
		return {
			type = "share",
			placeId = t6.placeId
		}
	end

	return nil
end
local function onAssistantActivated(_: {[any]: any}) -- line: 115
	if game.GameId == 0 then
		return nil
	end

	return {
		type = "leaveExperience"
	}
end
local function onPlaytestActivated(t8: {[any]: any}) -- line: 123
	-- upvalues: sendBuildExperienceEvent (copy), launchPlaytestWithLoadingState (copy)
	if game.GameId ~= 0 or (t8.placeId == nil or t8.isNewGameTarget and not t8.hasPublishedTurn) or t8.placeId == nil then
		return nil
	end

	sendBuildExperienceEvent("PLAYTEST_CLICK", {
		universeId = t8.universeId,
		placeId = t8.placeId,
		conversationId = t8.sessionId
	}, {
		context = "overflow_menu"
	})
	launchPlaytestWithLoadingState(t8.placeId, "BuildOverflowMenu", true)

	return nil
end
local function onVersionHistoryActivated(t9: {[any]: any}) -- line: 137
	if t9.placeId == nil then
		return nil
	end

	return {
		type = "openVersionHistory"
	}
end
local function createBuildOverflowMenuStore() -- line: 147
	-- upvalues: LocalizationStrings (copy), isAssistantDisabled (copy), onAssistantActivated (copy), isPlaytestDisabled (copy), onPlaytestActivated (copy), getPublishText (copy), FFlagBuildExperiencePrivateInvites (copy), onShareActivated (copy), isVersionHistoryDisabled (copy), onVersionHistoryActivated (copy), isInviteToPlaytestDisabled (copy), sendBuildExperienceEvent (copy), Signals (copy), React (copy), getPrivatePlaytestersStore (copy), SignalsReact (copy)
	local t11 = {
		{
			items = {
				{
					id = "assistant",
					text = LocalizationStrings.BUILD_MENU_BACK_TO_BUILD,
					isDisabled = isAssistantDisabled,
					onActivated = onAssistantActivated
				},
				{
					id = "playtest",
					text = LocalizationStrings.BUILD_MENU_PLAYTEST,
					isDisabled = isPlaytestDisabled,
					onActivated = onPlaytestActivated
				}
			}
		},
		{
			items = {
				{
					id = "settings",
					text = LocalizationStrings.BUILD_MENU_SETTINGS,
					onActivated = function() -- line: 170
						return {
							type = "openPage",
							page = "settings"
						}
					end
				},
				{
					id = "publish",
					text = LocalizationStrings.BUILD_MENU_PUBLISH,
					getText = getPublishText,
					onActivated = function() -- line: 181
						return {
							type = "openPage",
							page = "publish"
						}
					end
				},
				{
					id = "share",
					text = LocalizationStrings.BUILD_MENU_SHARE,
					onActivated = function(t10: {[any]: any}) -- line: 191
						-- upvalues: FFlagBuildExperiencePrivateInvites (copy), onShareActivated (copy)
						if FFlagBuildExperiencePrivateInvites then
							return {
								type = "share"
							}
						end

						return (onShareActivated(t10))
					end
				},
				{
					id = "version-history",
					text = LocalizationStrings.BUILD_MENU_VERSION_HISTORY,
					isDisabled = isVersionHistoryDisabled,
					onActivated = onVersionHistoryActivated
				}
			}
		}
	}

	if FFlagBuildExperiencePrivateInvites then
		table.insert(t11[2].items, 2, {
			id = "invite-to-playtest",
			text = LocalizationStrings.BUILD_MENU_INVITE_TO_PLAYTEST,
			isDisabled = isInviteToPlaytestDisabled,
			onActivated = function(t12: {[any]: any}) -- line: 219
				-- upvalues: sendBuildExperienceEvent (copy)
				sendBuildExperienceEvent("ADD_TO_PLAYTEST_CLICK", {
					universeId = t12.universeId,
					placeId = t12.placeId,
					conversationId = t12.sessionId
				}, {
					source = "overflow_menu"
				})

				return {
					type = "openInvitePicker"
				}
			end
		})
	end

	local v40 = Signals.createSignal(t11)

	return {
		getItems = v40,
		useItems = function(t13: {[any]: any}?) -- line: 232
			-- upvalues: React (copy), Signals (copy), FFlagBuildExperiencePrivateInvites (copy), getPrivatePlaytestersStore (copy), SignalsReact (copy), v40 (copy)
			local v44 = if t13 == nil then nil else t13.universeId
			local v45 = React.useMemo(function() -- line: 238
				-- upvalues: Signals (copy), FFlagBuildExperiencePrivateInvites (copy), v44 (copy), getPrivatePlaytestersStore (copy)
				return Signals.createComputed(function(p1) -- line: 239
					-- upvalues: FFlagBuildExperiencePrivateInvites (copy), v44 (copy), getPrivatePlaytestersStore (copy)
					if not FFlagBuildExperiencePrivateInvites or v44 == nil then
						return 0
					end

					return #getPrivatePlaytestersStore(false).getAndFetchInvitedPlayers(v44).players(p1)
				end)
			end, { v44 })
			local v46 = SignalsReact.useSignalState(v45)
			local v47 = SignalsReact.useSignalState(v40)
			local v48 = React.useMemo(function() -- line: 252
				-- upvalues: v47 (copy)
				return table.clone(v47)
			end, {
				v47,
				v46
			})

			if t13 == nil then
				return {}
			end

			if not FFlagBuildExperiencePrivateInvites then
				return v47
			end

			return v48
		end
	}
end

return createBuildOverflowMenuStore
