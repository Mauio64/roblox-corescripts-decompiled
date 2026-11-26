local fFlagAXBackgroundGenerationCreateTileTooltip = require("@luauforge/deferred/hcQ").FFlagAXBackgroundGenerationCreateTileTooltip

local module = require("@luauforge/deferred/hcR")

local v5 = if fFlagAXBackgroundGenerationCreateTileTooltip then require("@luauforge/deferred/hcU") else nil

local module2 = require("@luauforge/deferred/hcY")
local module3 = require("@luauforge/deferred/hdp")
local module4 = require("@luauforge/deferred/hdE")
local module5 = require("@luauforge/deferred/hdG")
local module6 = require("@luauforge/deferred/hdH")
local module7 = require("@luauforge/deferred/hdI")
local module8 = require("@luauforge/deferred/hdT")
local module9 = require("@luauforge/deferred/hdB")
local module10 = require("@luauforge/deferred/hdD")
local module11 = require("@luauforge/deferred/hdU")
local module12 = require("@luauforge/deferred/hdV")
local module13 = require("@luauforge/deferred/hdh")
local module14 = require("@luauforge/deferred/hdW")
local module15 = require("@luauforge/deferred/hdX")

return {
	PlusCreateTile = module,
	PlusCreateTileContainer = v5,
	BackgroundGenerationPage = module2,
	useBackgroundGenerationController = module3,
	BackgroundsPlusSubscribeBanner = module4,
	BackgroundsPlusSectionHeader = module5,
	BackgroundsPlusSubscribeLink = module6,
	BackgroundsPlusLocalizationKeys = require("@luauforge/deferred/hef"),
	BackgroundsPlusAnalytics = require("@luauforge/deferred/hdM"),
	BackgroundGenerationAnalytics = require("@luauforge/deferred/heg"),
	useBackgroundsPlusAccess = module7,
	usePrefetchAiBackgroundEntitlement = module8,
	usePollUntilTerminal = module9,
	Constants = module10,
	promptUtils = module11,
	PublishBackgroundSheet = module12,
	GenerationResultMenu = module13,
	PublishConfirmDialog = module14,
	usePublishController = module15
}
