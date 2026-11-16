local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local withCsrfRetry = require(DataHydration.withCsrfRetry)
local ExperienceGenreStoreTypes = require(script.Parent.ExperienceGenreStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function resolveMutatingNetwork(options) -- 1 equivalent call inferred from this helper
	return (options or {}).network or withCsrfRetry(HttpClient.createRequestInternalNetwork())
end

local FetchExperienceGenre = {}

function FetchExperienceGenre.fetchExperienceGenre(universeId: number, options, options2)
	local v = options2 or {}
	local baseUrl = v.baseUrl or UrlBase.APIS
	local v2 = options or {}

	local v3 = {
		universeId = universeId,
		genreTaxonomyVersion = v2.genreTaxonomyVersion or ExperienceGenreStoreTypes.DEFAULT_TAXONOMY_VERSION
	}

	if v2.includeGenreTaxonomyVersion then
		v3["responseOptions.includeGenreTaxonomyVersion"] = "true"
	end

	if v2.includeUpdateLockExpirationTime then
		v3["responseOptions.includeUpdateLockExpirationTime"] = "true"
	end

	if v2.includeVerificationState then
		v3["responseOptions.includeVerificationState"] = "true"
	end

	if v2.includeAppealState then
		v3["responseOptions.includeAppealState"] = "true"
	end

	if v2.includeCreatorSelectedGenre then
		v3["responseOptions.includeCreatorSelectedGenre"] = "true"
	end

	if v2.includeNotifyGenreChange then
		v3["responseOptions.includeNotifyGenreChange"] = "true"
	end

	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = UrlBuilder.UrlBuilder.addQueryString(baseUrl .. "/experience-genre-api/v1/Creator/ExperienceGenre", v3),
		analyticsKey = "experience-genre.get",
		decode = function(p)
			return p
		end
	})))
end

function FetchExperienceGenre.setExperienceGenre(data, options)
	local baseUrl = (options or {}).baseUrl or UrlBase.APIS

	local body = {
		universeId = data.universeId,
		genre = data.genre,
		genreTaxonomyVersion = data.genreTaxonomyVersion or ExperienceGenreStoreTypes.DEFAULT_TAXONOMY_VERSION
	}

	if data.responseOptions then
		body.responseOptions = data.responseOptions
	end

	return asPromise((fetch({
		network = resolveMutatingNetwork(options), -- inferred equivalent call
		method = "POST",
		url = baseUrl .. "/experience-genre-api/v1/Creator/ExperienceGenre",
		body = body,
		analyticsKey = "experience-genre.set",
		decode = function(p)
			return p
		end
	})))
end

return FetchExperienceGenre
