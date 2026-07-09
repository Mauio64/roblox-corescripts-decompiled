local SongDetailRodux = script:FindFirstAncestor("SongDetailRodux")
local SongDetailRoduxParent = SongDetailRodux.Parent
local PerformFetch = require(SongDetailRoduxParent.Http).PerformFetch
local Promise = require(SongDetailRoduxParent.Promise)
local NextDataExpirationTimeRodux = require(SongDetailRoduxParent.NextDataExpirationTimeRodux)
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local NextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local SetNextDataExpirationTime = NextDataExpirationTimeRodux.SetNextDataExpirationTime
local SharedFlags = require(SongDetailRoduxParent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local FIntSongDetailsRefreshIntervalSeconds = SharedFlags.FIntSongDetailsRefreshIntervalSeconds
local n1 = 0

if FFlagEnableTopSongsSort then
	n1 = tonumber(FIntSongDetailsRefreshIntervalSeconds) or 0
end

local AddGames = require(SongDetailRoduxParent.GameInfosRodux).AddGames
local GameInfoModel = require(SongDetailRoduxParent.GameModels).GameInfoModel
local AddSongExperiences = require(SongDetailRodux.Actions.AddSongExperiences)
local getSongExperiences = require(SongDetailRodux.Requests.getSongExperiences)
local SongExperiencesReducer = require(SongDetailRodux.Reducers.SongExperiencesReducer)

return {
	KeyMapper = function(s1: string) -- line: 34
		return `luaapp.musicdiscovery.songexperiences.{ s1 }`
	end,
	GetFetchingStatus = function(p1, s2: string) -- line: 42
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p1, `luaapp.musicdiscovery.songexperiences.{ s2 }`)
	end,
	Fetch = function(p2, s3: string) -- line: 46
		-- upvalues: PerformFetch (copy), ExpirationTimeNamespace (copy), NextDataExpirationTimeReducer (copy), SongExperiencesReducer (copy), Promise (copy), getSongExperiences (copy), GameInfoModel (copy), AddGames (copy), AddSongExperiences (copy), n1 (ref), SetNextDataExpirationTime (copy)
		return PerformFetch.Single(`luaapp.musicdiscovery.songexperiences.{ s3 }`, function(p3) -- line: 47
			-- upvalues: s3 (copy), ExpirationTimeNamespace (copy), NextDataExpirationTimeReducer (copy), SongExperiencesReducer (copy), Promise (copy), getSongExperiences (copy), p2 (copy), GameInfoModel (copy), AddGames (copy), AddSongExperiences (copy), n1 (ref), SetNextDataExpirationTime (copy)
			local v24 = p3:getState()
			local v25 = `luaapp.musicdiscovery.songexperiences.{ s3 }`
			local SongDetailPage = ExpirationTimeNamespace.SongDetailPage
			local v27 = (v24.Personalization[NextDataExpirationTimeReducer.key][SongDetailPage] or {})[v25] or nil
			local v28 = v24.Personalization[SongExperiencesReducer.key][s3] or nil

			if v28 and (v27 and v27 > tick()) then
				return Promise.resolve(v28)
			end

			return getSongExperiences(p2, s3, 100):andThen(function(p4) -- line: 59
				-- upvalues: GameInfoModel (copy), p3 (copy), AddGames (copy), AddSongExperiences (copy), s3 (copy), n1 (ref), SetNextDataExpirationTime (copy), v25 (copy), SongDetailPage (copy)
				local v30 = p4 and (not not p4.responseBody and p4.responseBody.experiences) or {}
				local t1 = {}
				local t2 = {}

				for _, v in ipairs(v30) do
					GameInfoModel.fromMusicDiscoveryApi(v):match(function(p5) -- line: 66
						-- upvalues: t2 (copy), t1 (copy)
						t2[p5.universeId] = p5
						table.insert(t1, p5.universeId)
					end):matchError(function(p6) -- line: 70
						warn(`ApiFetchSongExperiences could not parse experience: { p6 }`)
					end)
				end

				if next(t2) then
					p3:dispatch(AddGames(t2))
				end

				p3:dispatch(AddSongExperiences({
					[s3] = t1
				}))

				local v35 = math.floor(tick() + n1)

				p3:dispatch(SetNextDataExpirationTime(v25, v35, SongDetailPage))
			end, function(_) -- line: 82
			end)
		end)
	end
}
