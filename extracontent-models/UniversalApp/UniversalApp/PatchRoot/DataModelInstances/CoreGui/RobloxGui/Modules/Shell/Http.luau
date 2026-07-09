local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Utility = require(Modules.Shell.Utility)
local Url = require(CorePackages.Workspace.Packages.Http).Url
local t1 = {}
local v8 = game:GetService("ContentProvider").BaseUrl:lower()
local v9 = string.gsub(v8, "/m.", "/www.")
local u10 = string.gsub(v9, "http://", "https://")
local v11 = string.gsub(u10, "https://www.", "https://assetgame.")

string.gsub(u10, "https://www.", "https://accountsettings.")
t1.BaseUrl = u10
t1.AssetGameBaseUrl = v11

local GetFStringAppLocationForAppPresence = require(Modules.Shell.Flags.GetFStringAppLocationForAppPresence)

local function decodeJSON(p1) -- line: 47
	-- upvalues: HttpService (copy)
	if p1 == nil or #p1 == 0 then
		return nil
	end

	local ok, result = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), p1 (copy)
		return HttpService:JSONDecode(p1)
	end)

	if not ok then
		return nil
	end

	return result
end
local function rbxGetAsync(p2, p3) -- line: 62
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: p2 (copy)
		return game:HttpGetAsync(p2)
	end)

	if not ok then
		return nil
	end

	if p3 then
		return result
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok2, result2 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok2 then
		return nil
	end

	return result2
end
local function rbxPostAsync(p4, p5, p6) -- line: 77
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 78
		-- upvalues: p4 (copy), p5 (copy), p6 (copy)
		return game:HttpPostAsync(p4, p5, p6)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok3, result3 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok3 then
		return nil
	end

	return result3
end
local function rbxApiGetAsync(p7) -- line: 89
	-- upvalues: HttpRbxApiService (copy), HttpService (copy)
	local ok, result = pcall(function() -- line: 90
		-- upvalues: HttpRbxApiService (copy), p7 (copy)
		return HttpRbxApiService:GetAsync(p7)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok4, result4 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok4 then
		return nil
	end

	return result4
end
local function rbxApiPostAsync(p8, p9, p10, p11) -- line: 101
	-- upvalues: HttpRbxApiService (copy), HttpService (copy)
	local ok, result = pcall(function() -- line: 102
		-- upvalues: HttpRbxApiService (copy), p8 (copy), p9 (copy), p10 (copy), p11 (copy)
		return HttpRbxApiService:PostAsync(p8, p9, p10, p11)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok5, result5 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok5 then
		return nil
	end

	return result5
end
local function rbxApiPostAsyncFullUrl(p12, p13, p14, p15) -- line: 113
	-- upvalues: HttpRbxApiService (copy), HttpService (copy)
	local ok, result = pcall(function() -- line: 114
		-- upvalues: HttpRbxApiService (copy), p12 (copy), p13 (copy), p14 (copy), p15 (copy)
		return HttpRbxApiService:PostAsyncFullUrl(p12, p13, p14, p15)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok6, result6 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok6 then
		return nil
	end

	return result6
end
local function rbxRequestInternal(p16) -- line: 125
	-- upvalues: Utility (copy), HttpService (copy)
	local u60 = nil
	local v61 = Utility.Signal()

	HttpService:RequestInternal(p16):Start(function(p17, p18) -- line: 130
		-- upvalues: u60 (ref), HttpService (copy), v61 (copy)
		if p17 and p18.StatusCode ~= 401 and not (p18.StatusCode < 200) and not (p18.StatusCode >= 400) then
			local Body = p18.Body
			local v317

			if Body == nil or #Body == 0 then
				v317 = nil
			else
				local ok, result = pcall(function() -- line: 52
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				v317 = if ok then result else nil
			end

			u60 = v317
		end

		v61:fire()
	end)
	v61:wait()

	return u60
end
local function buildServiceUrl(p19) -- line: 145
	-- upvalues: u10 (ref)
	return string.gsub(u10, "https://www.", "https://" .. p19 .. ".")
end
local function isStringNilOrEmpty(p20) -- line: 149
	return p20 == nil or #p20 == 0
end

function t1.GetCuratedSortAsync(p21, p22) -- line: 192
	-- upvalues: u10 (ref), HttpService (copy)
	local v66 = string.format("%sgames/set?GameSetTargetId=%d&MaxRows=%d", u10, p21, p22)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v66 (copy)
		return game:HttpGetAsync(v66)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok7, result7 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok7 then
		return nil
	end

	return result7
end
function t1.GetCuratedSortByUrlAsync(p23) -- line: 200
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: p23 (copy)
		return game:HttpGetAsync(p23)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok8, result8 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok8 then
		return nil
	end

	return result8
end
function t1.GetUserPlacesAsync(p24, p25, p26) -- line: 234
	-- upvalues: u10 (ref), HttpService (copy)
	local v79 = string.format("%sgames/list-users-games-json?userid=%d&startIndex=%d&pageSize=%d", u10, p26, p24, p25)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v79 (copy)
		return game:HttpGetAsync(v79)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok9, result9 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok9 then
		return nil
	end

	return result9
end
function t1.SearchGamesAsync(p27, p28, p29) -- line: 242
	-- upvalues: u10 (ref), HttpService (copy)
	local v87 = string.format("%sgames/list-json?keyword=%s&StartRows=%d&MaxRows=%d&filterByDeviceType=true", u10, HttpService:UrlEncode(p29), p27, p28)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v87 (copy)
		return game:HttpGetAsync(v87)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok10, result10 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok10 then
		return nil
	end

	return result10
end
function t1.GetGamesAsync(p30) -- line: 305
	-- upvalues: u10 (ref), HttpService (copy)
	local v93 = string.gsub(u10, "https://www.", "https://games.") .. "v1/games?universeIds=" .. table.concat(p30, ",")
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v93 (copy)
		return game:HttpGetAsync(v93)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok11, result11 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok11 then
		return nil
	end

	return result11
end
function t1.PostExperienceGuidelines(p31) -- line: 343
	-- upvalues: buildServiceUrl (copy), HttpService (copy), Utility (copy)
	local t2 = {
		Method = "POST",
		Url = string.format("%sexperience-guidelines-api/experience-guidelines/get-age-recommendation", buildServiceUrl("apis")),
		Body = HttpService:JSONEncode({
			universeId = p31
		}),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}
	local u100 = nil
	local v101 = Utility.Signal()

	HttpService:RequestInternal(t2):Start(function(p32, p33) -- line: 130
		-- upvalues: u100 (ref), HttpService (copy), v101 (copy)
		if p32 and p33.StatusCode ~= 401 and not (p33.StatusCode < 200) and not (p33.StatusCode >= 400) then
			local Body = p33.Body
			local v323

			if Body == nil or #Body == 0 then
				v323 = nil
			else
				local ok, result = pcall(function() -- line: 52
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				v323 = if ok then result else nil
			end

			u100 = v323
		end

		v101:fire()
	end)
	v101:wait()

	return u100
end
function t1.GetGameIconIdAsync(p34) -- line: 369
	-- upvalues: u10 (ref), HttpService (copy)
	local v103 = u10 .. "places/icons/json?placeId=" .. tostring(p34)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v103 (copy)
		return game:HttpGetAsync(v103)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok12, result12 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok12 then
		return nil
	end

	return result12
end
function t1.GetGameVotesAsync(p35) -- line: 388
	-- upvalues: u10 (ref), HttpService (copy)
	local v109 = u10 .. "PlaceItem/GameDetailsVotingPanelJson?placeId=" .. tostring(p35)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v109 (copy)
		return game:HttpGetAsync(v109)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok13, result13 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok13 then
		return nil
	end

	return result13
end
function t1.GetRecommendedGamesAsync(p36) -- line: 415
	-- upvalues: u10 (ref), HttpService (copy)
	local v115 = u10 .. "Games/GetRecommendedGamesJson?currentPlaceId=" .. tostring(p36)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v115 (copy)
		return game:HttpGetAsync(v115)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok14, result14 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok14 then
		return nil
	end

	return result14
end
function t1.GetGameThumbnailsAsync(p37) -- line: 444
	-- upvalues: u10 (ref), HttpService (copy)
	local v121 = u10 .. "thumbnail/place-thumbnails?placeId=" .. tostring(p37)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v121 (copy)
		return game:HttpGetAsync(v121)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok15, result15 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok15 then
		return nil
	end

	return result15
end
function t1.GetBadgesForUniverseAsync(p38, p39) -- line: 476
	-- upvalues: u10 (ref), HttpService (copy)
	local v128 = string.format("%sv1/universes/%d/badges?sortOrder=Asc&limit=100", string.gsub(u10, "https://www.", "https://badges."), p38)

	if p39 then
		v128 = string.format(v128 .. "&cursor=%s", p39)
	end

	local v129 = v128
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v129 (copy)
		return game:HttpGetAsync(v129)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok16, result16 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok16 then
		return nil
	end

	return result16
end
function t1.GetUserAwardedBadgesAsync(p40, p41) -- line: 497
	-- upvalues: u10 (ref), HttpService (copy)
	local v136 = table.concat(p41, ",")
	local v137 = string.format("%sv1/users/%d/badges/awarded-dates?badgeIds=%s", string.gsub(u10, "https://www.", "https://badges."), p40, v136)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v137 (copy)
		return game:HttpGetAsync(v137)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok17, result17 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok17 then
		return nil
	end

	return result17
end
function t1.PostFavoriteToggleAsync(p42) -- line: 510
	-- upvalues: u10 (ref), HttpService (copy)
	local v143 = u10 .. "favorite/toggle?assetID=" .. tostring(p42)
	local s1 = "favoriteToggle"
	local v145 = nil
	local ok, result = pcall(function() -- line: 78
		-- upvalues: v143 (copy), s1 (copy), v145 (copy)
		return game:HttpPostAsync(v143, s1, v145)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok18, result18 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok18 then
		return nil
	end

	return result18
end
function t1.PostGameVoteAsync(p43, p44) -- line: 531
	-- upvalues: u10 (ref), HttpService (copy)
	local v152 = u10 .. "voting/vote?assetId=" .. tostring(p43) .. "&vote=" .. tostring(p44)
	local s2 = "vote"
	local v154 = nil
	local ok, result = pcall(function() -- line: 78
		-- upvalues: v152 (copy), s2 (copy), v154 (copy)
		return game:HttpPostAsync(v152, s2, v154)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok19, result19 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok19 then
		return nil
	end

	return result19
end
function t1.RegisterAppPresence() -- line: 542
	-- upvalues: buildServiceUrl (copy), GetFStringAppLocationForAppPresence (copy), HttpService (copy)
	local v159 = string.format("%s/v1/presence/register-app-presence", buildServiceUrl("presence"))
	local t3 = {
		location = GetFStringAppLocationForAppPresence()
	}
	local json = HttpService:JSONEncode(t3)
	local v162 = nil
	local ok, result = pcall(function() -- line: 78
		-- upvalues: v159 (copy), json (copy), v162 (copy)
		return game:HttpPostAsync(v159, json, v162)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok20, result20 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok20 then
		return nil
	end

	return result20
end
function t1.GetCrossplayEnabledStatusAsync() -- line: 565
	-- upvalues: buildServiceUrl (copy), Utility (copy), HttpService (copy)
	local t4 = {
		Method = "GET",
		Url = string.format("%suser-settings-api/v1/user-settings?requestedUserSettings=xboxCrossPlayStatusIsEnabled", buildServiceUrl("apis"))
	}
	local u168 = nil
	local v169 = Utility.Signal()

	HttpService:RequestInternal(t4):Start(function(p45, p46) -- line: 130
		-- upvalues: u168 (ref), HttpService (copy), v169 (copy)
		if p45 and p46.StatusCode ~= 401 and not (p46.StatusCode < 200) and not (p46.StatusCode >= 400) then
			local Body = p46.Body
			local v329

			if Body == nil or #Body == 0 then
				v329 = nil
			else
				local ok, result = pcall(function() -- line: 52
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				v329 = if ok then result else nil
			end

			u168 = v329
		end

		v169:fire()
	end)
	v169:wait()

	return u168
end
function t1.PostCrossplayStatusAsync(p47) -- line: 578
	-- upvalues: buildServiceUrl (copy), HttpService (copy), Utility (copy)
	local t5 = {
		Method = "POST",
		Url = string.format("%suser-settings-api/v1/user-settings", buildServiceUrl("apis")),
		Body = HttpService:JSONEncode({
			xboxCrossPlayStatusIsEnabled = p47
		}),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}
	local u172 = nil
	local v173 = Utility.Signal()

	HttpService:RequestInternal(t5):Start(function(p48, p49) -- line: 130
		-- upvalues: u172 (ref), HttpService (copy), v173 (copy)
		if p48 and p49.StatusCode ~= 401 and not (p49.StatusCode < 200) and not (p49.StatusCode >= 400) then
			local Body = p49.Body
			local v335

			if Body == nil or #Body == 0 then
				v335 = nil
			else
				local ok, result = pcall(function() -- line: 52
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				v335 = if ok then result else nil
			end

			u172 = v335
		end

		v173:fire()
	end)
	v173:wait()

	return u172
end
function t1.GetRecommendedUsersndsAsync() -- line: 604
	-- upvalues: buildServiceUrl (copy), HttpService (copy)
	local v174 = string.format("%s/v1/recommended-users", buildServiceUrl("friends"))
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v174 (copy)
		return game:HttpGetAsync(v174)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok21, result21 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok21 then
		return nil
	end

	return result21
end
function t1.GetUsersPresenceAsync(p50) -- line: 626
	-- upvalues: HttpService (copy), buildServiceUrl (copy)
	local t6 = {
		userIds = p50
	}
	local json = HttpService:JSONEncode(t6)
	local v182 = string.format("%s/v1/presence/users", buildServiceUrl("presence"))
	local v183 = json
	local v184 = nil
	local ok, result = pcall(function() -- line: 78
		-- upvalues: v182 (copy), v183 (copy), v184 (copy)
		return game:HttpPostAsync(v182, v183, v184)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok22, result22 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok22 then
		return nil
	end

	return result22
end
function t1.GetPlatformUserBalanceAsync() -- line: 644
	-- upvalues: buildServiceUrl (copy), HttpService (copy)
	local v189 = string.format("%sv1/user/currency", buildServiceUrl("economy"))
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v189 (copy)
		return game:HttpGetAsync(v189)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok23, result23 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok23 then
		return nil
	end

	return result23
end
function t1.GetTotalUserBalanceAsync() -- line: 655
	-- upvalues: buildServiceUrl (copy), HttpService (copy)
	local v194 = string.format("%sv1/user/currency", buildServiceUrl("economy"))
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v194 (copy)
		return game:HttpGetAsync(v194)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok24, result24 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok24 then
		return nil
	end

	return result24
end
function t1.GetUserOwnedPackagesAsync(p51, p52) -- line: 747
	-- upvalues: u10 (ref), HttpService (copy)
	local v201 = p52 or 1
	local v202 = u10 .. "users/inventory/list-json?userId=" .. tostring(p51) .. "&assetTypeId=" .. tostring(32) .. "&pageNumber=" .. tostring(v201)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v202 (copy)
		return game:HttpGetAsync(v202)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok25, result25 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok25 then
		return nil
	end

	return result25
end
function t1.GetCurrentlyWearingAsync(p53) -- line: 763
	-- upvalues: u10 (ref), HttpService (copy)
	local v208 = string.format("%s/v1/users/%d/currently-wearing", string.gsub(u10, "https://www.", "https://avatar."), p53)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v208 (copy)
		return game:HttpGetAsync(v208)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok26, result26 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok26 then
		return nil
	end

	return result26
end
function t1.SetWearingAssetsAsync(p54) -- line: 791
	-- upvalues: HttpService (copy), buildServiceUrl (copy), Utility (copy)
	local t7 = {
		assetIds = p54
	}
	local json = HttpService:JSONEncode(t7)
	local v216 = string.format("%s/v1/avatar/set-wearing-assets", buildServiceUrl("avatar"))
	local t8 = {
		Method = "POST",
		Url = v216,
		Body = json,
		Headers = {
			["Content-Type"] = "application/json"
		}
	}
	local u218 = nil
	local v219 = Utility.Signal()

	HttpService:RequestInternal(t8):Start(function(p55, p56) -- line: 130
		-- upvalues: u218 (ref), HttpService (copy), v219 (copy)
		if p55 and p56.StatusCode ~= 401 and not (p56.StatusCode < 200) and not (p56.StatusCode >= 400) then
			local Body = p56.Body
			local v341

			if Body == nil or #Body == 0 then
				v341 = nil
			else
				local ok, result = pcall(function() -- line: 52
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				v341 = if ok then result else nil
			end

			u218 = v341
		end

		v219:fire()
	end)
	v219:wait()

	return u218
end
function t1.PurchaseProductAsync(p57, p58, p59, p60) -- line: 848
	-- upvalues: u10 (ref), HttpService (copy)
	local v224 = string.format("%s/v1/purchases/products/%d", string.gsub(u10, "https://www.", "https://economy."), p57)
	local json = HttpService:JSONEncode({
		expectedCurrency = p60,
		expectedPrice = p58,
		expectedSellerId = p59
	})
	local v226 = nil
	local ok, result = pcall(function() -- line: 78
		-- upvalues: v224 (copy), json (copy), v226 (copy)
		return game:HttpPostAsync(v224, json, v226)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok27, result27 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok27 then
		return nil
	end

	return result27
end
function t1.MultiGetBundleDetailsAsync(p61) -- line: 889
	-- upvalues: u10 (ref), HttpService (copy)
	local v232 = table.concat(p61, ",")
	local v233 = string.format("%sv1/bundles/details?bundleIds=%s", string.gsub(u10, "https://www.", "https://catalog."), v232)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v233 (copy)
		return game:HttpGetAsync(v233)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok28, result28 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok28 then
		return nil
	end

	return result28
end
function t1.GetUserOwnedBundlesAsync(p62, p63) -- line: 914
	-- upvalues: u10 (ref), HttpService (copy)
	local v240 = string.format("%sv1/users/%s/bundles?sortOrder=Asc&limit=100", string.gsub(u10, "https://www.", "https://catalog."), (tostring(p62)))

	if p63 then
		v240 = string.format(v240 .. "&cursor=%s", p63)
	end

	local v241 = v240
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v241 (copy)
		return game:HttpGetAsync(v241)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok29, result29 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok29 then
		return nil
	end

	return result29
end
function t1.GetAssetThumbnailBatchAsync(p64, p65, p66) -- line: 938
	-- upvalues: u10 (ref), HttpService (copy)
	local v249 = string.gsub(u10, "https://www.", "https://games.") .. "v1/games/game-thumbnails?%s&height=" .. tostring(p66) .. "&width=" .. tostring(p65)
	local v250 = "imageTokens=" .. table.concat(p64, "&imageTokens=")
	local v251 = string.format(v249, v250)
	local ok, result = pcall(function() -- line: 63
		-- upvalues: v251 (copy)
		return game:HttpGetAsync(v251)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok30, result30 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok30 then
		return nil
	end

	return result30
end
function t1.ReportAbuseAsyncV2(s3: string, s4: string, s5: string, s6: string, s7: string, s8: string, s9: string, s10: string, s11: string) -- line: 952
	-- upvalues: HttpService (copy), Url (copy), HttpRbxApiService (copy)
	local t9 = {
		tags = {
			ENTRY_POINT = {
				valueList = {{
					data = s8
				}}
			},
			SUBMITTER_USER_ID = {
				valueList = {{
					data = s3
				}}
			},
			REPORT_TARGET_USER_ID = {
				valueList = {{
					data = s5
				}}
			},
			REPORTED_ABUSE_CATEGORY = {
				valueList = {{
					data = s10
				}}
			},
			REPORTED_ABUSE_VECTOR = {
				valueList = {{
					data = s9
				}}
			},
			REPORTER_COMMENT = {
				valueList = {{
					data = s11
				}}
			},
			REPORT_TARGET_ASSET_ID = {
				valueList = {{
					data = s4
				}}
			},
			REPORT_TARGET_ASSET_NAME = {
				valueList = {{
					data = s6
				}}
			},
			REPORT_TARGET_ASSET_DESCRIPTION = {
				valueList = {{
					data = s7
				}}
			}
		}
	}
	local json = HttpService:JSONEncode(t9)
	local v267 = Url.APIS_URL .. "abuse-reporting/v2/abuse-report"

	if json then
		local Default = Enum.ThrottlingPriority.Default
		local ApplicationJson = Enum.HttpContentType.ApplicationJson
		local ok, result = pcall(function() -- line: 114
			-- upvalues: HttpRbxApiService (copy), v267 (copy), json (copy), Default (copy), ApplicationJson (copy)
			return HttpRbxApiService:PostAsyncFullUrl(v267, json, Default, ApplicationJson)
		end)

		if not ok then
			return nil
		end

		if result == nil or #result == 0 then
			return nil
		end

		local ok31, result31 = pcall(function() -- line: 52
			-- upvalues: HttpService (copy), result (copy)
			return HttpService:JSONDecode(result)
		end)

		if not ok31 then
			return nil
		end

		return result31
	end

	return nil
end
function t1.GetConsecutiveDaysLoggedInAsync() -- line: 1035
	-- upvalues: buildServiceUrl (copy), Utility (copy), HttpService (copy)
	local t10 = {
		Method = "GET",
		Url = string.format("%sv1/xbox/get-login-consecutive-days", buildServiceUrl("auth"))
	}
	local u275 = nil
	local v276 = Utility.Signal()

	HttpService:RequestInternal(t10):Start(function(p67, p68) -- line: 130
		-- upvalues: u275 (ref), HttpService (copy), v276 (copy)
		if p67 and p68.StatusCode ~= 401 and not (p68.StatusCode < 200) and not (p68.StatusCode >= 400) then
			local Body = p68.Body
			local v347

			if Body == nil or #Body == 0 then
				v347 = nil
			else
				local ok, result = pcall(function() -- line: 52
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				v347 = if ok then result else nil
			end

			u275 = v347
		end

		v276:fire()
	end)
	v276:wait()

	return u275
end
function t1.IsValidUsername(p69, p70) -- line: 1051
	-- upvalues: u10 (ref), HttpService (copy), Utility (copy)
	if p69 == nil or #p69 == 0 or (p70 == nil or #p70 == 0) then
		return
	end

	local t11 = {
		Method = "GET",
		Url = string.format("%sv2/usernames/validate?request.username=%s&request.birthday=%s", string.gsub(u10, "https://www.", "https://auth."), HttpService:UrlEncode(p69), p70)
	}
	local u280 = nil
	local v281 = Utility.Signal()

	HttpService:RequestInternal(t11):Start(function(p71, p72) -- line: 130
		-- upvalues: u280 (ref), HttpService (copy), v281 (copy)
		if p71 and p72.StatusCode ~= 401 and not (p72.StatusCode < 200) and not (p72.StatusCode >= 400) then
			local Body = p72.Body
			local v353

			if Body == nil or #Body == 0 then
				v353 = nil
			else
				local ok, result = pcall(function() -- line: 52
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				v353 = if ok then result else nil
			end

			u280 = v353
		end

		v281:fire()
	end)
	v281:wait()

	return u280
end
function t1.IsValidPassword(p73, p74) -- line: 1073
	-- upvalues: u10 (ref), HttpService (copy), Utility (copy)
	if p73 == nil or #p73 == 0 or (p74 == nil or #p74 == 0) then
		return
	end

	local t12 = {
		Method = "GET",
		Url = string.format("%sv2/passwords/validate?request.username=%s&request.password=%s", string.gsub(u10, "https://www.", "https://auth."), HttpService:UrlEncode(p73), HttpService:UrlEncode(p74))
	}
	local u285 = nil
	local v286 = Utility.Signal()

	HttpService:RequestInternal(t12):Start(function(p75, p76) -- line: 130
		-- upvalues: u285 (ref), HttpService (copy), v286 (copy)
		if p75 and p76.StatusCode ~= 401 and not (p76.StatusCode < 200) and not (p76.StatusCode >= 400) then
			local Body = p76.Body
			local v359

			if Body == nil or #Body == 0 then
				v359 = nil
			else
				local ok, result = pcall(function() -- line: 52
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				v359 = if ok then result else nil
			end

			u285 = v359
		end

		v286:fire()
	end)
	v286:wait()

	return u285
end
function t1.PostSponsoredGameClickAsync(p77) -- line: 1100
	-- upvalues: buildServiceUrl (copy), HttpService (copy)
	local v288 = string.format("%sv1/sponsored-games/click", buildServiceUrl("ads"))
	local v289, v290 = string.format("\"%s\"", p77)
	local ok, result = pcall(function() -- line: 78
		-- upvalues: v288 (copy), v289 (copy), v290 (copy)
		return game:HttpPostAsync(v288, v289, v290)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok32, result32 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok32 then
		return nil
	end

	return result32
end
function t1.GetUserVoteCountFromVotingApiAsync() -- line: 1117
	-- upvalues: buildServiceUrl (copy), Utility (copy), HttpService (copy)
	local t13 = {
		Method = "GET",
		Url = string.format("%svoting-api/user/get-vote-count?targetType=Place", buildServiceUrl("apis"))
	}
	local u296 = nil
	local v297 = Utility.Signal()

	HttpService:RequestInternal(t13):Start(function(p78, p79) -- line: 130
		-- upvalues: u296 (ref), HttpService (copy), v297 (copy)
		if p78 and p79.StatusCode ~= 401 and not (p79.StatusCode < 200) and not (p79.StatusCode >= 400) then
			local Body = p79.Body
			local v365

			if Body == nil or #Body == 0 then
				v365 = nil
			else
				local ok, result = pcall(function() -- line: 52
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				v365 = if ok then result else nil
			end

			u296 = v365
		end

		v297:fire()
	end)
	v297:wait()

	return u296
end
function t1.CreateCrossDeviceLoginCode() -- line: 1134
	-- upvalues: buildServiceUrl (copy), HttpService (copy)
	local v298 = string.format("%sauth-token-service/v1/login/create", buildServiceUrl("apis"))
	local s12 = ""
	local v300 = nil
	local ok, result = pcall(function() -- line: 78
		-- upvalues: v298 (copy), s12 (copy), v300 (copy)
		return game:HttpPostAsync(v298, s12, v300)
	end)

	if not ok then
		return nil
	end

	if result == nil or #result == 0 then
		return nil
	end

	local ok33, result33 = pcall(function() -- line: 52
		-- upvalues: HttpService (copy), result (copy)
		return HttpService:JSONDecode(result)
	end)

	if not ok33 then
		return nil
	end

	return result33
end
function t1.CheckCrossDeviceLoginStatus(p80, p81) -- line: 1148
	-- upvalues: buildServiceUrl (copy), HttpService (copy), Utility (copy)
	local t14 = {
		Method = "POST",
		Url = string.format("%sauth-token-service/v1/login/status", buildServiceUrl("apis")),
		Body = HttpService:JSONEncode({
			code = p80,
			privateKey = p81
		}),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}
	local u308 = nil
	local v309 = Utility.Signal()

	HttpService:RequestInternal(t14):Start(function(p82, p83) -- line: 130
		-- upvalues: u308 (ref), HttpService (copy), v309 (copy)
		if p82 and p83.StatusCode ~= 401 and not (p83.StatusCode < 200) and not (p83.StatusCode >= 400) then
			local Body = p83.Body
			local v371

			if Body == nil or #Body == 0 then
				v371 = nil
			else
				local ok, result = pcall(function() -- line: 52
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				v371 = if ok then result else nil
			end

			u308 = v371
		end

		v309:fire()
	end)
	v309:wait()

	return u308
end
function t1.CancelCrossDeviceLogin(p84) -- line: 1167
	-- upvalues: buildServiceUrl (copy), HttpService (copy), Utility (copy)
	local t15 = {
		Method = "POST",
		Url = string.format("%sauth-token-service/v1/login/cancel", buildServiceUrl("apis")),
		Body = HttpService:JSONEncode({
			code = p84
		}),
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		}
	}
	local u312 = nil
	local v313 = Utility.Signal()

	HttpService:RequestInternal(t15):Start(function(p85, p86) -- line: 130
		-- upvalues: u312 (ref), HttpService (copy), v313 (copy)
		if p85 and p86.StatusCode ~= 401 and not (p86.StatusCode < 200) and not (p86.StatusCode >= 400) then
			local Body = p86.Body
			local v377

			if Body == nil or #Body == 0 then
				v377 = nil
			else
				local ok, result = pcall(function() -- line: 52
					-- upvalues: HttpService (copy), Body (copy)
					return HttpService:JSONDecode(Body)
				end)

				v377 = if ok then result else nil
			end

			u312 = v377
		end

		v313:fire()
	end)
	v313:wait()

	return u312
end

return t1
