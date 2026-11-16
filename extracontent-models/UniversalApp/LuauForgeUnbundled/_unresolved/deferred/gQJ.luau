local fFlagAXBackgroundGenerationCreateTileTooltip = require("@luauforge/deferred/gQK").FFlagAXBackgroundGenerationCreateTileTooltip

local module = require("@luauforge/deferred/gQL")

local v5 = if fFlagAXBackgroundGenerationCreateTileTooltip then require("@luauforge/deferred/gQO") else nil

local module2 = require("@luauforge/deferred/gQS")
local module3 = require("@luauforge/deferred/gRj")
local module4 = require("@luauforge/deferred/gRy")
local module5 = require("@luauforge/deferred/gRA")
local module6 = require("@luauforge/deferred/gRB")
local module7 = require("@luauforge/deferred/gRC")
local module8 = require("@luauforge/deferred/gRv")
local module9 = require("@luauforge/deferred/gRx")
local module10 = require("@luauforge/deferred/gRI")
local module11 = require("@luauforge/deferred/gRJ")
local module12 = require("@luauforge/deferred/gRb")
local module13 = require("@luauforge/deferred/gRK")
local module14 = require("@luauforge/deferred/gRL")

return {
	PlusCreateTile = module,
	PlusCreateTileContainer = v5,
	BackgroundGenerationPage = module2,
	useBackgroundGenerationController = module3,
	BackgroundsPlusSubscribeBanner = module4,
	BackgroundsPlusSectionHeader = module5,
	BackgroundsPlusSubscribeLink = module6,
	BackgroundsPlusLocalizationKeys = require("@luauforge/deferred/gRT"),
	BackgroundsPlusAnalytics = require("@luauforge/deferred/gRG"),
	BackgroundGenerationAnalytics = require("@luauforge/deferred/gRU"),
	useBackgroundsPlusAccess = module7,
	usePollUntilTerminal = module8,
	Constants = module9,
	promptUtils = module10,
	PublishBackgroundSheet = module11,
	GenerationResultMenu = module12,
	PublishConfirmDialog = module13,
	usePublishController = module14
}
