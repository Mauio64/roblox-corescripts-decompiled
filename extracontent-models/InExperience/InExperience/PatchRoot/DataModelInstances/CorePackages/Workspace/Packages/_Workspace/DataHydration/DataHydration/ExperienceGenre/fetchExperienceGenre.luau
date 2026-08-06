local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local HttpClient = require(DataHydrationParent.HttpClient)
local UrlBuilder = require(DataHydrationParent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase
local withCsrfRetry = require(DataHydration.withCsrfRetry)
local ExperienceGenreStoreTypes = require(script.Parent.ExperienceGenreStoreTypes)
local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function resolveMutatingNetwork(t1: {[any]: any}?) -- line: 21
	-- upvalues: withCsrfRetry (copy), HttpClient (copy)
	return (t1 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

return {
	fetchExperienceGenre = function(n1: number, p1, t2: {[any]: any}?) -- line: 29
		-- upvalues: UrlBase (copy), ExperienceGenreStoreTypes (copy), fetch (copy), UrlBuilder (copy), asPromise (copy)
		local v15 = t2 or {}
		local v16 = v15.baseUrl or UrlBase.APIS
		local v17 = p1 or {}
		local t3 = {
			universeId = n1,
			genreTaxonomyVersion = v17.genreTaxonomyVersion or ExperienceGenreStoreTypes.DEFAULT_TAXONOMY_VERSION
		}

		if v17.includeGenreTaxonomyVersion then
			t3["responseOptions.includeGenreTaxonomyVersion"] = "true"
		end

		if v17.includeUpdateLockExpirationTime then
			t3["responseOptions.includeUpdateLockExpirationTime"] = "true"
		end

		if v17.includeVerificationState then
			t3["responseOptions.includeVerificationState"] = "true"
		end

		if v17.includeAppealState then
			t3["responseOptions.includeAppealState"] = "true"
		end

		if v17.includeCreatorSelectedGenre then
			t3["responseOptions.includeCreatorSelectedGenre"] = "true"
		end

		if v17.includeNotifyGenreChange then
			t3["responseOptions.includeNotifyGenreChange"] = "true"
		end

		local v19 = fetch({
			method = "GET",
			analyticsKey = "experience-genre.get",
			network = v15.network,
			url = UrlBuilder.UrlBuilder.addQueryString(v16 .. "/experience-genre-api/v1/Creator/ExperienceGenre", t3),
			decode = function(p2) -- line: 66
				return p2
			end
		})

		return asPromise(v19)
	end,
	setExperienceGenre = function(p3, t4: {[any]: any}?) -- line: 73
		-- upvalues: UrlBase (copy), ExperienceGenreStoreTypes (copy), fetch (copy), withCsrfRetry (copy), HttpClient (copy), asPromise (copy)
		local v22 = (t4 or {}).baseUrl or UrlBase.APIS
		local t5 = {
			universeId = p3.universeId,
			genre = p3.genre,
			genreTaxonomyVersion = p3.genreTaxonomyVersion or ExperienceGenreStoreTypes.DEFAULT_TAXONOMY_VERSION
		}

		if p3.responseOptions then
			t5.responseOptions = p3.responseOptions
		end

		local v24 = fetch({
			method = "POST",
			analyticsKey = "experience-genre.set",
			network = (t4 or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
			url = v22 .. "/experience-genre-api/v1/Creator/ExperienceGenre",
			body = t5,
			decode = function(p4) -- line: 95
				return p4
			end
		})

		return asPromise(v24)
	end
}
