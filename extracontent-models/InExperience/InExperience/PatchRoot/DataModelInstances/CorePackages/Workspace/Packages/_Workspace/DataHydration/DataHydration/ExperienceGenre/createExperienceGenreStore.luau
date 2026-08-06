local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent

require(DataHydrationParent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)
local fetchExperienceGenre = require(script.Parent.fetchExperienceGenre)
local syncExperienceGenreToGameInfo = require(script.Parent.syncExperienceGenreToGameInfo).syncExperienceGenreToGameInfo

require(script.Parent.ExperienceGenreStoreTypes)

local t1 = {
	includeGenreTaxonomyVersion = true,
	includeUpdateLockExpirationTime = true,
	includeVerificationState = true,
	includeAppealState = true,
	includeCreatorSelectedGenre = true,
	includeNotifyGenreChange = true
}

local function createExperienceGenreStore(t2: {[any]: any}?) -- line: 31
	-- upvalues: t1 (copy), createSingleEntityResolver (copy), fetchExperienceGenre (copy), syncExperienceGenreToGameInfo (copy)
	local v9 = t2 or {}
	local t3 = {
		network = v9.network,
		baseUrl = v9.baseUrl
	}
	local v11 = v9.defaultGetOptions or t1
	local v12 = createSingleEntityResolver(function(n1: number) -- line: 36
		-- upvalues: fetchExperienceGenre (copy), v11 (copy), t3 (copy)
		return fetchExperienceGenre.fetchExperienceGenre(n1, v11, t3)
	end)

	return {
		getExperienceGenre = v12.get,
		fetchExperienceGenre = v12.fetch,
		getAndFetchExperienceGenre = v12.getAndFetch,
		setExperienceGenre = function(p1) -- line: 40
			-- upvalues: fetchExperienceGenre (copy), t3 (copy), v12 (copy), syncExperienceGenreToGameInfo (copy)
			return fetchExperienceGenre.setExperienceGenre(p1, t3):andThen(function(p2) -- line: 41
				-- upvalues: v12 (copy), p1 (copy), syncExperienceGenreToGameInfo (copy)
				v12.update(p1.universeId, p2)
				syncExperienceGenreToGameInfo(p1.universeId, nil, p2.genre)

				return p2
			end)
		end,
		updateExperienceGenre = v12.update,
		clear = v12.clear,
		dispose = v12.dispose
	}
end

return createExperienceGenreStore
