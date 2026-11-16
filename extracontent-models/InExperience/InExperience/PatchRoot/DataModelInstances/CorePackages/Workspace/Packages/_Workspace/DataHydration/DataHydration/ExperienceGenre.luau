local ExperienceGenreStoreTypes = require(script.ExperienceGenreStoreTypes)

local ExperienceGenre = {
	createExperienceGenreStore = require(script.createExperienceGenreStore),
	getExperienceGenreStore = require(script.getExperienceGenreStore),
	syncExperienceGenreToGameInfo = 0,
	ExperienceGenreStoreTypes = 0
}
local syncExperienceGenreToGameInfo = require(script.syncExperienceGenreToGameInfo)
ExperienceGenre.syncExperienceGenreToGameInfo = syncExperienceGenreToGameInfo.syncExperienceGenreToGameInfo
ExperienceGenre.ExperienceGenreStoreTypes = ExperienceGenreStoreTypes
return ExperienceGenre
