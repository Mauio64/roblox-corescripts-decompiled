local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local default = require(BuildExperienceParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local React = require(BuildExperienceParent.React)
local UniversalShareSheet = require(BuildExperienceParent.ShareSheet).UniversalShareSheet
local SharedFlags = require(BuildExperienceParent.SharedFlags)
local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local FFlagEnableShareSheet = SharedFlags.FFlagEnableShareSheet
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local v10 = if not FFlagEnableShareSheet then nil else require(BuildExperienceParent.DataHydration)
local v11 = if not FFlagEnableShareSheet then nil else require(BuildExperienceParent.Signals)
local v12 = if not FFlagEnableShareSheet then nil else require(BuildExperienceParent.SignalsReact)

local function formatSuccessSnackbarText(p1) -- line: 29
	-- upvalues: LocalizationStrings (copy)
	local v18 = p1[1]

	return LocalizationStrings.formatGameSharedWithTarget(not v18 and "" or v18.displayName)
end
local function sharePublishedExperience(n1: number, s1: string?) -- line: 34
	-- upvalues: FFlagEnableShareSheet (copy), UniversalShareSheet (copy), formatSuccessSnackbarText (copy), LocalizationStrings (copy), isSubjectToDesktopPolicies (copy), default (copy)
	local v21 = `https://www.roblox.com/games/{ n1 }`

	if FFlagEnableShareSheet then
		UniversalShareSheet.show({
			context = "BuildExperienceGameShare",
			telemetryId = tostring(n1),
			formatSuccessSnackbarText = formatSuccessSnackbarText,
			messagePlaceholder = if not s1 then nil else LocalizationStrings.formatShareExperience(s1),
			url = v21
		})

		return nil
	end

	if isSubjectToDesktopPolicies() then
		default:setClipboardText({
			context = "BuildExperienceGameShare",
			text = v21
		})

		return {
			copiedToClipboard = true,
			url = v21
		}
	end

	default:shareUrl({
		context = "BuildExperienceGameShare",
		url = v21
	})

	return {
		copiedToClipboard = false,
		url = v21
	}
end

local v15 = not FFlagEnableShareSheet and function() -- line: 101
	-- upvalues: React (copy), sharePublishedExperience (copy)
	return React.useCallback(function(n2: number) -- line: 102
		-- upvalues: sharePublishedExperience (copy)
		sharePublishedExperience(n2, nil)
	end, {})
end or function(n3: number?) -- line: 76
	-- upvalues: React (copy), v11 (copy), v10 (copy), v12 (copy), sharePublishedExperience (copy)
	local v23 = if not n3 then nil else tostring(n3)
	local v24 = React.useMemo(function() -- line: 78
		-- upvalues: v11 (copy), v23 (copy), v10 (copy)
		return v11.createComputed(function(p2) -- line: 79
			-- upvalues: v23 (copy), v10 (copy)
			if v23 == nil then
				return nil
			end

			return v10.Game.getGameInfoStore(p2).getAndFetchGameInfo(v23).data(p2)
		end)
	end, { v23 })
	local v25 = v12.useSignalState(v24)
	local v26 = if not v25 or (v25.isUnavailable or v25.name == "") then nil else v25.name

	return React.useCallback(function(n4: number) -- line: 96
		-- upvalues: sharePublishedExperience (copy), v26 (copy)
		sharePublishedExperience(n4, v26)
	end, { v26 })
end

return {
	getGameShareUrl = function(n5: number) -- line: 25
		return `https://www.roblox.com/games/{ n5 }`
	end,
	sharePublishedExperience = sharePublishedExperience,
	useSharePublishedExperience = v15
}
