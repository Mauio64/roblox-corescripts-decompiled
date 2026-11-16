local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local CorePackages = game:GetService("CorePackages")

local CoreGui = game:GetService("CoreGui")
local Modules = CoreGui.RobloxGui.Modules
local Utility = require(Modules.Shell.Utility)
local Http = require(CorePackages.Workspace.Packages.Http)
local Url = Http.Url

local ContentProvider = game:GetService("ContentProvider")
local baseUrl = ContentProvider.BaseUrl:lower()
local v = string.gsub(baseUrl, "/m.", "/www.")
local baseUrl2 = string.gsub(v, "http://", "https://")

local assetGameBaseUrl = string.gsub(baseUrl2, "https://www.", "https://assetgame.")
string.gsub(baseUrl2, "https://www.", "https://accountsettings.")
local Http2 = {}
Http2.BaseUrl = baseUrl2
Http2.AssetGameBaseUrl = assetGameBaseUrl
local GetFStringAppLocationForAppPresence = require(Modules.Shell.Flags.GetFStringAppLocationForAppPresence)

local function decodeJSON(result) -- 5 equivalent calls inferred from this helper
	if result == nil or #result == 0 then
		return nil
	end

	local success, result2 = pcall(function()
		return HttpService:JSONDecode(result)
	end)
	return if success then result2 else nil
end

local function rbxGetAsync(p, p2) -- 19 equivalent calls inferred from this helper
	local success, result = pcall(function()
		return game:HttpGetAsync(p)
	end)

	if not success then
		return nil
	end

	if p2 then
		return result
	end

	return decodeJSON(result) -- inferred equivalent call
end

local function rbxPostAsync(p, p2, p3) -- 7 equivalent calls inferred from this helper
	local success, result = pcall(function()
		return game:HttpPostAsync(p, p2, p3)
	end)

	if not success then
		return nil
	end

	return decodeJSON(result) -- inferred equivalent call
end

local function rbxApiGetAsync(p)
	local success, result = pcall(function()
		return HttpRbxApiService:GetAsync(p)
	end)

	if not success then
		return nil
	end

	return decodeJSON(result) -- inferred equivalent call
end

local function rbxApiPostAsync(p, p2, p3, p4)
	local success, result = pcall(function()
		return HttpRbxApiService:PostAsync(p, p2, p3, p4)
	end)

	if not success then
		return nil
	end

	return decodeJSON(result) -- inferred equivalent call
end

local function rbxApiPostAsyncFullUrl(p, jsonEncode, default, applicationJson) -- 1 equivalent call inferred from this helper
	local success, result = pcall(function()
		return HttpRbxApiService:PostAsyncFullUrl(p, jsonEncode, default, applicationJson)
	end)

	if not success then
		return nil
	end

	return decodeJSON(result) -- inferred equivalent call
end

local function rbxRequestInternal(p) -- 10 equivalent calls inferred from this helper
	local v2 = nil
	local signal = Utility.Signal()
	HttpService:RequestInternal(p):Start(function(p2, p3)
		if p2 and p3.StatusCode ~= 401 and not (p3.StatusCode < 200 or p3.StatusCode >= 400) then
			local body = p3.Body
			local result

			if not (body == nil or #body == 0) then
				local success
				success, result = pcall(function()
					return HttpService:JSONDecode(body)
				end)

				if not success then
					result = nil
				end
			end

			v2 = result
		end

		signal:fire()
	end)

	signal:wait()
	return v2
end

local function buildServiceUrl(p) -- 10 equivalent calls inferred from this helper
	return string.gsub(baseUrl2, "https://www.", "https://" .. p .. ".")
end

local function isStringNilOrEmpty(list): boolean
	return list == nil or #list == 0
end

function Http2.GetCuratedSortAsync(p, p2)
	return rbxGetAsync(string.format("%sgames/set?GameSetTargetId=%d&MaxRows=%d", baseUrl2, p, p2), false) -- inferred equivalent call
end

function Http2.GetCuratedSortByUrlAsync(p)
	return rbxGetAsync(p, false) -- inferred equivalent call
end

function Http2.GetUserPlacesAsync(p, p2, p3)
	return rbxGetAsync( -- inferred equivalent call
		string.format("%sgames/list-users-games-json?userid=%d&startIndex=%d&pageSize=%d", baseUrl2, p3, p, p2),
		false
	)
end

function Http2.SearchGamesAsync(p, p2, p3)
	return rbxGetAsync( -- inferred equivalent call
		string.format(
			"%sgames/list-json?keyword=%s&StartRows=%d&MaxRows=%d&filterByDeviceType=true",
			baseUrl2,
			HttpService:UrlEncode(p3),
			p,
			p2
		),
		false
	)
end

function Http2.GetGamesAsync(list)
	return rbxGetAsync(buildServiceUrl("games") .. "v1/games?universeIds=" .. table.concat(list, ","), false) -- inferred equivalent call
end

function Http2.PostExperienceGuidelines(universeId)
	return rbxRequestInternal({ -- inferred equivalent call
		Url = string.format(
			"%sexperience-guidelines-api/experience-guidelines/get-age-recommendation",
			buildServiceUrl("apis")
		),
		Method = "POST",
		Body = HttpService:JSONEncode({ universeId = universeId }),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	})
end

function Http2.GetGameIconIdAsync(p)
	return rbxGetAsync(baseUrl2 .. "places/icons/json?placeId=" .. tostring(p), false) -- inferred equivalent call
end

function Http2.GetGameVotesAsync(p)
	return rbxGetAsync(baseUrl2 .. "PlaceItem/GameDetailsVotingPanelJson?placeId=" .. tostring(p), false) -- inferred equivalent call
end

function Http2.GetRecommendedGamesAsync(p)
	return rbxGetAsync(baseUrl2 .. "Games/GetRecommendedGamesJson?currentPlaceId=" .. tostring(p), false) -- inferred equivalent call
end

function Http2.GetGameThumbnailsAsync(p)
	return rbxGetAsync(baseUrl2 .. "thumbnail/place-thumbnails?placeId=" .. tostring(p), false) -- inferred equivalent call
end

function Http2.GetBadgesForUniverseAsync(p, p2)
	local v2 = string.format("%sv1/universes/%d/badges?sortOrder=Asc&limit=100", buildServiceUrl("badges"), p) -- inferred equivalent call

	if p2 then
		v2 = string.format(v2 .. "&cursor=%s", p2)
	end

	return rbxGetAsync(v2, false) -- inferred equivalent call
end

function Http2.GetUserAwardedBadgesAsync(p, list)
	local joined = table.concat(list, ",")
	return rbxGetAsync( -- inferred equivalent call
		string.format("%sv1/users/%d/badges/awarded-dates?badgeIds=%s", buildServiceUrl("badges"), p, joined), -- inferred equivalent call
		false
	)
end

function Http2.PostFavoriteToggleAsync(p)
	return rbxPostAsync(baseUrl2 .. "favorite/toggle?assetID=" .. tostring(p), "favoriteToggle") -- inferred equivalent call
end

function Http2.PostGameVoteAsync(p, p2)
	return rbxPostAsync(baseUrl2 .. "voting/vote?assetId=" .. tostring(p) .. "&vote=" .. tostring(p2), "vote") -- inferred equivalent call
end

function Http2.RegisterAppPresence()
	return rbxPostAsync( -- inferred equivalent call
		string.format("%s/v1/presence/register-app-presence", buildServiceUrl("presence")),
		HttpService:JSONEncode({
			location = GetFStringAppLocationForAppPresence()
		}),
		nil
	)
end

function Http2.GetCrossplayEnabledStatusAsync()
	return rbxRequestInternal({ -- inferred equivalent call
		Url = string.format(
			"%suser-settings-api/v1/user-settings?requestedUserSettings=xboxCrossPlayStatusIsEnabled",
			buildServiceUrl("apis")
		),
		Method = "GET"
	})
end

function Http2.PostCrossplayStatusAsync(xboxCrossPlayStatusIsEnabled)
	return rbxRequestInternal({ -- inferred equivalent call
		Url = string.format("%suser-settings-api/v1/user-settings", buildServiceUrl("apis")),
		Method = "POST",
		Body = HttpService:JSONEncode({
			xboxCrossPlayStatusIsEnabled = xboxCrossPlayStatusIsEnabled
		}),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	})
end

function Http2.GetRecommendedUsersndsAsync()
	return rbxGetAsync(string.format("%s/v1/recommended-users", buildServiceUrl("friends")), false) -- inferred equivalent call
end

function Http2.GetUsersPresenceAsync(userIds)
	local jsonEncode = HttpService:JSONEncode({ userIds = userIds })
	return rbxPostAsync(string.format("%s/v1/presence/users", buildServiceUrl("presence")), jsonEncode) -- inferred equivalent call
end

function Http2.GetPlatformUserBalanceAsync()
	return rbxGetAsync(string.format("%sv1/user/currency", buildServiceUrl("economy")), false) -- inferred equivalent call
end

function Http2.GetTotalUserBalanceAsync()
	return rbxGetAsync(string.format("%sv1/user/currency", buildServiceUrl("economy")), false) -- inferred equivalent call
end

function Http2.GetUserOwnedPackagesAsync(p, value)
	return rbxGetAsync( -- inferred equivalent call
		baseUrl2 .. "users/inventory/list-json?userId=" .. tostring(p) .. "&assetTypeId=" .. tostring(32) .. "&pageNumber=" .. tostring(value or 1),
		false
	)
end

function Http2.GetCurrentlyWearingAsync(p)
	return rbxGetAsync(string.format("%s/v1/users/%d/currently-wearing", buildServiceUrl("avatar"), p), false) -- inferred equivalent call
end

function Http2.SetWearingAssetsAsync(assetIds)
	local jsonEncode = HttpService:JSONEncode({ assetIds = assetIds })
	return rbxRequestInternal({ -- inferred equivalent call
		Url = string.format("%s/v1/avatar/set-wearing-assets", buildServiceUrl("avatar")),
		Method = "POST",
		Body = jsonEncode,
		Headers = { ["Content-Type"] = "application/json" }
	})
end

function Http2.PurchaseProductAsync(p, expectedPrice, expectedSellerId, expectedCurrency)
	return rbxPostAsync( -- inferred equivalent call
		string.format("%s/v1/purchases/products/%d", buildServiceUrl("economy"), p), -- inferred equivalent call
		HttpService:JSONEncode({
			expectedCurrency = expectedCurrency,
			expectedPrice = expectedPrice,
			expectedSellerId = expectedSellerId
		}),
		nil
	)
end

function Http2.MultiGetBundleDetailsAsync(list)
	local joined = table.concat(list, ",")
	return rbxGetAsync(string.format("%sv1/bundles/details?bundleIds=%s", buildServiceUrl("catalog"), joined), false) -- inferred equivalent call
end

function Http2.GetUserOwnedBundlesAsync(p, p2)
	local v2 = string.format("%sv1/users/%s/bundles?sortOrder=Asc&limit=100", buildServiceUrl("catalog"), (tostring(p))) -- inferred equivalent call

	if p2 then
		v2 = string.format(v2 .. "&cursor=%s", p2)
	end

	return rbxGetAsync(v2, false) -- inferred equivalent call
end

function Http2.GetAssetThumbnailBatchAsync(list, p, p2)
	local v2 = buildServiceUrl("games") .. "v1/games/game-thumbnails?%s&height=" .. tostring(p2) .. "&width=" .. tostring(p) -- inferred equivalent call

	local v3 = "imageTokens=" .. table.concat(list, "&imageTokens=")
	return rbxGetAsync(string.format(v2, v3), false) -- inferred equivalent call
end

function Http2.ReportAbuseAsyncV2(p: string, p2: string, p3: string, p4: string, p5: string, p6: string, p7: string, p8: string, p9: string)
	local jsonEncode = HttpService:JSONEncode({
		tags = {
			ENTRY_POINT = {
				valueList = {
					{ data = p6 }
				}
			},
			SUBMITTER_USER_ID = {
				valueList = {
					{ data = p }
				}
			},
			REPORT_TARGET_USER_ID = {
				valueList = {
					{ data = p3 }
				}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {
					{ data = p8 }
				}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {
					{ data = p7 }
				}
			},
			REPORTER_COMMENT = {
				valueList = {
					{ data = p9 }
				}
			},
			REPORT_TARGET_ASSET_ID = {
				valueList = {
					{ data = p2 }
				}
			},
			REPORT_TARGET_ASSET_NAME = {
				valueList = {
					{ data = p4 }
				}
			},
			REPORT_TARGET_ASSET_DESCRIPTION = {
				valueList = {
					{ data = p5 }
				}
			}
		}
	})
	local v2 = Url.APIS_URL .. "abuse-reporting/v2/abuse-report"

	if not jsonEncode then
		return nil
	end

	return rbxApiPostAsyncFullUrl(v2, jsonEncode, Enum.ThrottlingPriority.Default, Enum.HttpContentType.ApplicationJson) -- inferred equivalent call
end

function Http2.GetConsecutiveDaysLoggedInAsync()
	return rbxRequestInternal({ -- inferred equivalent call
		Url = string.format("%sv1/xbox/get-login-consecutive-days", buildServiceUrl("auth")),
		Method = "GET"
	})
end

function Http2.IsValidUsername(list, list2)
	if list == nil or #list == 0 or list2 == nil or #list2 == 0 then
		return
	end

	return rbxRequestInternal({ -- inferred equivalent call
		Url = string.format(
			"%sv2/usernames/validate?request.username=%s&request.birthday=%s",
			buildServiceUrl("auth"), -- inferred equivalent call
			HttpService:UrlEncode(list),
			list2
		),
		Method = "GET"
	})
end

function Http2.IsValidPassword(list, list2)
	if list == nil or #list == 0 or list2 == nil or #list2 == 0 then
		return
	end

	return rbxRequestInternal({ -- inferred equivalent call
		Url = string.format(
			"%sv2/passwords/validate?request.username=%s&request.password=%s",
			buildServiceUrl("auth"), -- inferred equivalent call
			HttpService:UrlEncode(list),
			HttpService:UrlEncode(list2)
		),
		Method = "GET"
	})
end

function Http2.PostSponsoredGameClickAsync(p)
	local v2 = string.format("%sv1/sponsored-games/click", buildServiceUrl("ads"))
	local v3, v4 = string.format("\"%s\"", p)
	return rbxPostAsync(v2, v3, v4) -- inferred equivalent call
end

function Http2.GetUserVoteCountFromVotingApiAsync()
	return rbxRequestInternal({ -- inferred equivalent call
		Url = string.format("%svoting-api/user/get-vote-count?targetType=Place", buildServiceUrl("apis")),
		Method = "GET"
	})
end

function Http2.CreateCrossDeviceLoginCode()
	return rbxPostAsync(string.format("%sauth-token-service/v1/login/create", buildServiceUrl("apis")), "") -- inferred equivalent call
end

function Http2.CheckCrossDeviceLoginStatus(code, privateKey)
	return rbxRequestInternal({ -- inferred equivalent call
		Url = string.format("%sauth-token-service/v1/login/status", buildServiceUrl("apis")),
		Method = "POST",
		Body = HttpService:JSONEncode({ code = code, privateKey = privateKey }),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	})
end

function Http2.CancelCrossDeviceLogin(code)
	return rbxRequestInternal({ -- inferred equivalent call
		Url = string.format("%sauth-token-service/v1/login/cancel", buildServiceUrl("apis")),
		Method = "POST",
		Body = HttpService:JSONEncode({ code = code }),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	})
end

return Http2
