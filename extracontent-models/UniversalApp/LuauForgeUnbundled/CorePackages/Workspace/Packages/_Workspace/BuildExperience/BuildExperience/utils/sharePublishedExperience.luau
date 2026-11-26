local default = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local universalShareSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/ShareSheet").UniversalShareSheet
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags")

local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local createExperienceShareLink = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/createExperienceShareLink")
local fFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local v5 = if fFlagEnableShareSheet then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration") else nil
local v6 = if fFlagEnableShareSheet then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals") else nil
local v7 = if fFlagEnableShareSheet then require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact") else nil

local function getGameShareUrl(p2)
	return `https://www.roblox.com/games/{p2}`
end

local function formatSuccessSnackbarText(list)
	local item = list[1]
	return LocalizationStrings.formatGameSharedWithTarget(not item and "" or item.displayName)
end

local function sharePublishedExperience(p2, p3)
	local formatted = `https://www.roblox.com/games/{p2}`

	if fFlagEnableShareSheet then
		local show = universalShareSheet.show
		local v8 = {
			context = "BuildExperienceGameShare",
			telemetryId = tostring(p2),
			formatSuccessSnackbarText = formatSuccessSnackbarText,
			messagePlaceholder = 0,
			url = 0
		}

		local v9 = if p3 then LocalizationStrings.formatShareExperience(p3) else nil
		v8.messagePlaceholder = v9

		v8.url = formatted
		show(v8)

		return nil
	elseif isSubjectToDesktopPolicies() then
		default:setClipboardText({
			text = formatted,
			context = "BuildExperienceGameShare"
		})

		return { url = formatted, copiedToClipboard = true }
	else
		default:shareUrl({ url = formatted, context = "BuildExperienceGameShare" })

		return { url = formatted, copiedToClipboard = false }
	end
end

return {
	getGameShareUrl = getGameShareUrl,
	sharePublishedExperience = sharePublishedExperience,
	useSharePublishedExperience = fFlagEnableShareSheet and function(p2)
		local v8 = if p2 then tostring(p2) else nil
		local v9 = React.useMemo(function()
			return v6.createComputed(function(p3)
				if v8 == nil then
					return nil
				end

				return v5.Game.getGameInfoStore(p3).getAndFetchGameInfo(v8).data(p3)
			end)
		end, { v8 })
		local v10 = v7.useSignalState(v9)

		local name = if v10 and not v10.isUnavailable and v10.name ~= "" then v10.name else nil

		local v11 = Localization.Hooks.useLocalization({
			gameShared = LocalizationStrings.SHARE_GAME_SHARED,
			messagePlaceholder = name ~= nil and {
				LocalizationStrings.SHARE_EXPERIENCE,
				EXPERIENCE_NAME = name
			} or nil
		})

		local v12 = React.useContext(Localization.LocalizationRoactContext)
		local v13 = React.useCallback(function(list)
			local item = list[1]

			if item == nil or item.displayName == "" then
				return v11.gameShared
			end

			return v12:Format(LocalizationStrings.SHARE_GAME_SHARED_WITH_TARGET, {
				DISPLAY_NAME = item.displayName
			})
		end, { v11.gameShared, v12 })

		local messagePlaceholder = v11.messagePlaceholder
		return React.useCallback(function(p3)
			local function showShareSheet(p4)
				universalShareSheet.show({
					context = "BuildExperienceGameShare",
					recipientSource = universalShareSheet.RecipientSource.OneToOneFriends,
					telemetryId = tostring(p3),
					formatSuccessSnackbarText = v13,
					messagePlaceholder = messagePlaceholder,
					url = p4 or `https://www.roblox.com/games/{p3}`
				})
			end

			if p2 == nil then
				showShareSheet(nil)
			else
				createExperienceShareLink(p2, false):andThen(showShareSheet, function()
					showShareSheet(nil)
				end)
			end
		end, { v13, messagePlaceholder, p2 })
	end or function()
		return React.useCallback(function(p2)
			sharePublishedExperience(p2, nil)
		end, {})
	end
}
