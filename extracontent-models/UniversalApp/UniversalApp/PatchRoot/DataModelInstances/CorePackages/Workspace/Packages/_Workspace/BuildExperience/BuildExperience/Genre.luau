local GenreTaxonomy = require(script.GenreTaxonomy)
local resolveGenreLevels = require(script.resolveGenreLevels)

return {
	GenreTaxonomy = GenreTaxonomy,
	resolveGenreLevels = resolveGenreLevels.resolveGenreLevels
}
