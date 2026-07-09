local SongDetailRodux = script:FindFirstAncestor("SongDetailRodux")
local SongDetailRoduxParent = SongDetailRodux.Parent
local PerformFetch = require(SongDetailRoduxParent.Http).PerformFetch
local Promise = require(SongDetailRoduxParent.Promise)
local AddSongs = require(SongDetailRoduxParent.SongInfosRodux).AddSongs
local NextDataExpirationTimeRodux = require(SongDetailRoduxParent.NextDataExpirationTimeRodux)
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local NextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local SetNextDataExpirationTime = NextDataExpirationTimeRodux.SetNextDataExpirationTime
local AddArtistSongs = require(SongDetailRodux.Actions.AddArtistSongs)
local ArtistSongReducer = require(SongDetailRodux.Reducers.ArtistSongReducer)
local getArtistSongs = require(SongDetailRodux.Requests.getArtistSongs)
local SongInfoModel = require(SongDetailRoduxParent.SongModels).SongInfoModel
local SharedFlags = require(SongDetailRoduxParent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local FIntSongDetailsRefreshIntervalSeconds = SharedFlags.FIntSongDetailsRefreshIntervalSeconds
local n1 = 0

if FFlagEnableTopSongsSort then
	n1 = tonumber(FIntSongDetailsRefreshIntervalSeconds) or 0
end

return {
	KeyMapper = function(s1: string) -- line: 34
		return `luaapp.musicdiscovery.artistsongs.{ s1 }`
	end,
	GetFetchingStatus = function(p1, s2: string) -- line: 42
		-- upvalues: PerformFetch (copy)
		return PerformFetch.GetStatus(p1, `luaapp.musicdiscovery.artistsongs.{ s2 }`)
	end,
	Fetch = function(p2, s3: string) -- line: 46
		-- upvalues: PerformFetch (copy), ExpirationTimeNamespace (copy), NextDataExpirationTimeReducer (copy), ArtistSongReducer (copy), Promise (copy), getArtistSongs (copy), SongInfoModel (copy), AddSongs (copy), AddArtistSongs (copy), n1 (ref), SetNextDataExpirationTime (copy)
		local v23 = `luaapp.musicdiscovery.artistsongs.{ s3 }`

		return PerformFetch.Single(v23, function(p3) -- line: 48
			-- upvalues: ExpirationTimeNamespace (copy), NextDataExpirationTimeReducer (copy), v23 (copy), ArtistSongReducer (copy), s3 (copy), Promise (copy), getArtistSongs (copy), p2 (copy), SongInfoModel (copy), AddSongs (copy), AddArtistSongs (copy), n1 (ref), SetNextDataExpirationTime (copy)
			local v25 = p3:getState()
			local SongDetailPage = ExpirationTimeNamespace.SongDetailPage
			local v27 = (v25.Personalization[NextDataExpirationTimeReducer.key][SongDetailPage] or {})[v23]
			local v28 = v25.Personalization[ArtistSongReducer.key][s3] or nil

			if v28 ~= nil and (v27 ~= nil and v27 > tick()) then
				return Promise.resolve(v28)
			end

			return getArtistSongs(p2, s3, 100):andThen(function(p4) -- line: 58
				-- upvalues: SongInfoModel (copy), p3 (copy), AddSongs (copy), AddArtistSongs (copy), s3 (copy), n1 (ref), SetNextDataExpirationTime (copy), v23 (copy), SongDetailPage (copy)
				local t1 = {}
				local t2 = {}

				for _, v33 in p4 and (not not p4.responseBody and p4.responseBody.songs) or {} do
					SongInfoModel.fromBaseJson(v33):match(function(p5) -- line: 65
						-- upvalues: t2 (copy), t1 (copy)
						table.insert(t2, p5.assetId)
						t1[p5.assetId] = p5
					end):matchError(function(p6) -- line: 69
						warn(`ApiFetchArtistSongs could not parse song: { p6 }`)
					end)
				end

				if next(t1) then
					p3:dispatch(AddSongs(t1))
				end

				p3:dispatch(AddArtistSongs({
					[s3] = t2
				}))

				local v34 = math.floor(tick() + n1)

				p3:dispatch(SetNextDataExpirationTime(v23, v34, SongDetailPage))
			end, function(_) -- line: 81
			end)
		end)
	end
}
