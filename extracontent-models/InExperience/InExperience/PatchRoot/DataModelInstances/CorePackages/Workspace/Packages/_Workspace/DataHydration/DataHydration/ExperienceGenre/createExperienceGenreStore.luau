local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createSingleEntityResolver = require(DataHydration.createSingleEntityResolver)

local fetchExperienceGenre = require(script.Parent.fetchExperienceGenre)
local syncExperienceGenreToGameInfo = require(script.Parent.syncExperienceGenreToGameInfo)
local syncExperienceGenreToGameInfo2 = syncExperienceGenreToGameInfo.syncExperienceGenreToGameInfo
require(script.Parent.ExperienceGenreStoreTypes)

local v = {
	includeGenreTaxonomyVersion = true,
	includeUpdateLockExpirationTime = true,
	includeVerificationState = true,
	includeAppealState = true,
	includeCreatorSelectedGenre = true,
	includeNotifyGenreChange = true
}

local function createExperienceGenreStore(options)
	local v2 = options or {}
	local v3 = { network = v2.network, baseUrl = v2.baseUrl }
	local defaultGetOptions = v2.defaultGetOptions or v

	local singleEntityResolver = createSingleEntityResolver(function(p: number)
		return fetchExperienceGenre.fetchExperienceGenre(p, defaultGetOptions, v3)
	end)

	local function setExperienceGenre(p)
		return fetchExperienceGenre.setExperienceGenre(p, v3):andThen(function(p2)
			singleEntityResolver.update(p.universeId, p2)

			syncExperienceGenreToGameInfo2(p.universeId, nil, p2.genre)
			return p2
		end)
	end

	return {
		getExperienceGenre = singleEntityResolver.get,
		fetchExperienceGenre = singleEntityResolver.fetch,
		getAndFetchExperienceGenre = singleEntityResolver.getAndFetch,
		setExperienceGenre = setExperienceGenre,
		updateExperienceGenre = singleEntityResolver.update,
		clear = singleEntityResolver.clear,
		dispose = singleEntityResolver.dispose
	}
end

return createExperienceGenreStore
