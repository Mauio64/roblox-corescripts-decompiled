local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ecR")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")

local module3 = require("@luauforge/bundled/dwA")

local module4 = require("@luauforge/deferred/ecS")
local GetGameName = require("@game/CoreGui/RobloxGui/Modules/AvatarEditorPrompts/Thunks/GetGameName")

local retrievalStatus = require("@game/CorePackages/Workspace/Packages/Http").Enum.RetrievalStatus
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local Dash = require(CorePackages.Packages.Dash)
local removeTextSearchResults = require("@luauforge/bundled/dpZ").Modules.LuaApp.Actions.RemoveTextSearchResults
local module6 = require("@luauforge/bundled/cyO")

local fFlagSafetyResourceBannerTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSafetyResourceBannerTelemetry

local module7 = require("@luauforge/deferred/ecY")
local module8 = require("@luauforge/deferred/ecZ")
local module9 = require("@luauforge/deferred/eep")
local module10 = require("@luauforge/bundled/dCd")

return useSheetNavigation.connect(function(data, p2)
	local searchKeyword = p2.searchParameters.searchKeyword or ""
	local v5 = not (utf8.len(searchKeyword) >= module3.PLAYER_SEARCH_MIN_KEYWORD_UTF8_LEN)

	local safetyResource = nil
	local v6 = data.TextSearchResults[p2.searchUuid]
		and data.TextSearchResults[p2.searchUuid][module6.SearchTextTopicIds.HotlineSearchText]
	local text

	if v6 then
		text = v6.text

		if fFlagSafetyResourceBannerTelemetry then
			safetyResource = v6.safetyResource
		end
	end

	local v7 = {
		screenSize = data.ScreenSize,
		usersSearchResult = data.UsersSearchResults[searchKeyword],
		searchWordLengthNotSupported = v5,
		playerSearchStatus = v5 and retrievalStatus.Done or module9.GetFetchingStatus(data, searchKeyword),
		autoTabSearchStatus = v5 and retrievalStatus.Done or module4(data, searchKeyword),
		wideMode = data.FormFactor == formFactor.WIDE,
		hotlineSearchText = text,
		hotlineSafetyResource = 0
	}

	if not fFlagSafetyResourceBannerTelemetry then
		safetyResource = nil
	end

	v7.hotlineSafetyResource = safetyResource
	return v7
end, function(callback)
	return {
		fetchPlayerSearch = function(p2, ...)
			return callback(GetGameName(module9.Fetch(p2, ...)))
		end,
		removeUserSearchResults = function(p2)
			return callback(module10(p2))
		end,
		removeTextSearchResults = function(p2)
			return callback(removeTextSearchResults(p2))
		end
	}
end)(function(options)
	return module.createElement(module7, {
		renderChild = function(options2)
			return module.createElement(module8, Dash.join(options2 or {}, options or {}))
		end
	})
end)
