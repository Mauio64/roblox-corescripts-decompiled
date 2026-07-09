local ExperienceSongsRodux = script:FindFirstAncestor("ExperienceSongsRodux")
local ExperienceSongsRoduxParent = ExperienceSongsRodux.Parent
local PerformFetch = require(ExperienceSongsRoduxParent.Http).PerformFetch
local Promise = require(ExperienceSongsRoduxParent.Promise)
local AddSongs = require(ExperienceSongsRoduxParent.SongInfosRodux).AddSongs
local NextDataExpirationTimeRodux = require(ExperienceSongsRoduxParent.NextDataExpirationTimeRodux)
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local NextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local SetNextDataExpirationTime = NextDataExpirationTimeRodux.SetNextDataExpirationTime
local AddExperienceSongs = require(ExperienceSongsRodux.Actions.AddExperienceSongs)
local ExperienceSongsReducer = require(ExperienceSongsRodux.Reducers.ExperienceSongsReducer)
local getExperienceSongs = require(ExperienceSongsRodux.Requests.getExperienceSongs)
local SongInfoModel = require(ExperienceSongsRoduxParent.SongModels).SongInfoModel
local v14 = tonumber(settings():GetFVariable("LuaAppGameDetailsRefreshIntervalInSeconds")) or 0

return {
	KeyMapper = function(p1) -- line: 27
		return `luaapp.musicdiscovery.experiencesongs.{ p1 }`
	end,
	Fetch = function(p2, s1: string) -- line: 35
		-- upvalues: PerformFetch (copy), ExpirationTimeNamespace (copy), NextDataExpirationTimeReducer (copy), ExperienceSongsReducer (copy), Promise (copy), getExperienceSongs (copy), SongInfoModel (copy), AddSongs (copy), AddExperienceSongs (copy), v14 (copy), SetNextDataExpirationTime (copy)
		return PerformFetch.Single(`luaapp.musicdiscovery.experiencesongs.{ s1 }`, function(p3) -- line: 36
			-- upvalues: ExpirationTimeNamespace (copy), NextDataExpirationTimeReducer (copy), s1 (copy), ExperienceSongsReducer (copy), Promise (copy), getExperienceSongs (copy), p2 (copy), SongInfoModel (copy), AddSongs (copy), AddExperienceSongs (copy), v14 (copy), SetNextDataExpirationTime (copy)
			local v19 = p3:getState()
			local GameDetailPage = ExpirationTimeNamespace.GameDetailPage
			local v21 = (v19.Personalization[NextDataExpirationTimeReducer.key][GameDetailPage] or {})[s1]
			local v22 = v19.Personalization[ExperienceSongsReducer.key][s1] or nil

			if v22 ~= nil and (v21 ~= nil and v21 > tick()) then
				return Promise.resolve(v22)
			end

			return getExperienceSongs(p2, s1, 100):andThen(function(p4) -- line: 50
				-- upvalues: SongInfoModel (copy), p3 (copy), AddSongs (copy), AddExperienceSongs (copy), s1 (copy), v14 (copy), SetNextDataExpirationTime (copy), GameDetailPage (copy)
				local t1 = {}
				local t2 = {}

				for _, v27 in p4 and (not not p4.responseBody and p4.responseBody.songs) or {} do
					SongInfoModel.fromBaseJson(v27):match(function(p5) -- line: 57
						-- upvalues: t2 (copy), t1 (copy)
						table.insert(t2, p5.assetId)
						t1[p5.assetId] = p5
					end):matchError(function(p6) -- line: 61
						warn(`ApiFetchExperienceSongs could not parse song: { p6 }`)
					end)
				end

				if next(t1) then
					p3:dispatch(AddSongs(t1))
				end

				p3:dispatch(AddExperienceSongs({
					[s1] = t2
				}))

				local v28 = math.floor(tick() + v14)

				p3:dispatch(SetNextDataExpirationTime(s1, v28, GameDetailPage))
			end, function(_) -- line: 76
			end)
		end)
	end
}
