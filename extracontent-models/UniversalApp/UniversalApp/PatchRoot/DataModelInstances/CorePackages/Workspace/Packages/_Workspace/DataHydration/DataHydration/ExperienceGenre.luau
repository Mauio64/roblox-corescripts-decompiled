local ExperienceGenreStoreTypes = require(script.ExperienceGenreStoreTypes)

return {
	createExperienceGenreStore = require(script.createExperienceGenreStore),
	getExperienceGenreStore = require(script.getExperienceGenreStore),
	syncExperienceGenreToGameInfo = require(script.syncExperienceGenreToGameInfo).syncExperienceGenreToGameInfo,
	ExperienceGenreStoreTypes = ExperienceGenreStoreTypes
}
