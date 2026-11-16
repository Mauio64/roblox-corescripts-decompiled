local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local Localization = require(parent.Localization)
local React = require(parent.React)
local ShareSheet = require(parent.ShareSheet)
local UniversalShareSheet = ShareSheet.UniversalShareSheet
local SharedFlags = require(parent.SharedFlags)

local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local createExperienceShareLink = require(BuildExperience.utils.createExperienceShareLink)
local FFlagBuildShareSheetFriendsSortAll = require(BuildExperience.Flags.FFlagBuildShareSheetFriendsSortAll)
local FFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local DataHydration

if FFlagEnableShareSheet then
	DataHydration = require(parent.DataHydration)
else
	DataHydration = nil
end

local Signals

if FFlagEnableShareSheet then
	Signals = require(parent.Signals)
else
	Signals = nil
end

local SignalsReact

if FFlagEnableShareSheet then
	SignalsReact = require(parent.SignalsReact)
else
	SignalsReact = nil
end

local function getGameShareUrl(p: number) -- 2 equivalent calls inferred from this helper
	return `https://www.roblox.com/games/{p}`
end

local function formatSuccessSnackbarText(list)
	local item = list[1]
	return LocalizationStrings.formatGameSharedWithTarget(not item and "" or item.displayName)
end

local function sharePublishedExperience(p: number, p2: string?)
	local gameShareUrl = getGameShareUrl(p) -- inferred equivalent call

	if FFlagEnableShareSheet then
		local show = UniversalShareSheet.show
		local v = {
			context = "BuildExperienceGameShare",
			telemetryId = tostring(p),
			formatSuccessSnackbarText = formatSuccessSnackbarText,
			messagePlaceholder = 0,
			url = 0
		}
		local messagePlaceholder

		if p2 then
			messagePlaceholder = LocalizationStrings.formatShareExperience(p2)
		end

		v.messagePlaceholder = messagePlaceholder

		v.url = gameShareUrl
		show(v)

		return nil
	elseif isSubjectToDesktopPolicies() then
		default:setClipboardText({ text = gameShareUrl, context = "BuildExperienceGameShare" })

		return { url = gameShareUrl, copiedToClipboard = true }
	else
		default:shareUrl({ url = gameShareUrl, context = "BuildExperienceGameShare" })

		return { url = gameShareUrl, copiedToClipboard = false }
	end
end

return {
	getGameShareUrl = getGameShareUrl,
	sharePublishedExperience = sharePublishedExperience,
	useSharePublishedExperience = FFlagEnableShareSheet and function(p: number?)
		local v

		if p then
			v = tostring(p)
		else
			v = nil
		end

		local v2 = React.useMemo(function()
			return Signals.createComputed(function(p2)
				if v == nil then
					return nil
				end

				return DataHydration.Game.getGameInfoStore(p2).getAndFetchGameInfo(v).data(p2)
			end)
		end, { v })
		local v3 = SignalsReact.useSignalState(v2)
		local name

		if v3 and not v3.isUnavailable and v3.name ~= "" then
			name = v3.name
		end

		local v4 = Localization.Hooks.useLocalization({
			gameShared = LocalizationStrings.SHARE_GAME_SHARED,
			messagePlaceholder = name ~= nil and {
				LocalizationStrings.SHARE_EXPERIENCE,
				EXPERIENCE_NAME = name
			} or nil
		})

		local v5 = React.useContext(Localization.LocalizationRoactContext)
		local formatSuccessSnackbarText2 = React.useCallback(function(list)
			local item = list[1]

			if item == nil or item.displayName == "" then
				return v4.gameShared
			end

			return v5:Format(LocalizationStrings.SHARE_GAME_SHARED_WITH_TARGET, {
				DISPLAY_NAME = item.displayName
			})
		end, { v4.gameShared, v5 })

		local messagePlaceholder = v4.messagePlaceholder
		return React.useCallback(function(p2: number, p3)
			local function showShareSheet(p4: string?)
				local show = UniversalShareSheet.show
				local recipientSource

				if FFlagBuildShareSheetFriendsSortAll then
					recipientSource = UniversalShareSheet.RecipientSource.OneToOneFriends
				else
					recipientSource = p3
				end

				show({
					context = "BuildExperienceGameShare",
					recipientSource = recipientSource,
					telemetryId = tostring(p2),
					formatSuccessSnackbarText = formatSuccessSnackbarText2,
					messagePlaceholder = messagePlaceholder,
					url = p4 or getGameShareUrl(p2) -- inferred equivalent call
				})
			end

			if p == nil then
				showShareSheet(nil)
			else
				createExperienceShareLink(p, false):andThen(showShareSheet, function()
					showShareSheet(nil)
				end)
			end
		end, { formatSuccessSnackbarText2, messagePlaceholder, p })
	end or function()
		return React.useCallback(function(p: number, _)
			sharePublishedExperience(p, nil)
		end, {})
	end
}
