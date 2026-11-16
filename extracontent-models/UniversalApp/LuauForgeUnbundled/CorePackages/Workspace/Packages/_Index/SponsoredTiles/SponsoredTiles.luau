local module = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/TwoByOneGameTile")
require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/types")

return {
	WhyThisAdModal = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/WhyThisAdModal"),
	SponsoredUserCohort = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/Enums/SponsoredUserCohort"),
	OneByTwoTile = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/OneByTwoTile"),
	TwoByOneGameTile = module,
	renderOneByTwoTile = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/renderOneByTwoTile"),
	renderTwoByOneTile = require("@game/CorePackages/Workspace/Packages/_Index/SponsoredTiles/SponsoredTiles/renderTwoByOneTile")
}
