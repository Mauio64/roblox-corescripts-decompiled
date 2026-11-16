local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local supportOverlayMonolithDependenciesContext = require("@luauforge/bundled/hRC").Providers.SupportOverlayMonolithDependenciesContext

local module = require("@luauforge/bundled/edP")
local module2 = require("@luauforge/bundled/fvl")
local module3 = require("@luauforge/bundled/eed")

local module4 = require("@luauforge/bundled/dNQ")
local module5 = require("@luauforge/bundled/dMx")
local module6 = require("@luauforge/bundled/fvh")
local module7 = require("@luauforge/bundled/dOj")

local module8 = require("@luauforge/bundled/ggX")
local module9 = require("@luauforge/bundled/fwb")
local module10 = require("@luauforge/bundled/gfg")
local module11 = require("@luauforge/bundled/gkk")

local module12 = require("@luauforge/bundled/goV")

local v5 = {
	SetCentralOverlay = module,
	CloseCentralOverlay = module2,
	GetOutfits = module8,
	GetOutfit = module9,
	EquipOutfit = module10,
	NavigateIntoAvatarExperience = module11,
	OpenProfilePeekView = module3,
	isWearingOutfit = module6.isWearingOutfit,
	getAvatarEditorCategories = module7,
	useSceneInteractionCallbacks = module12,
	CharacterKey = module4.CharacterKey,
	EditableCharacterKey = module4.EditableCharacterKey,
	OutfitsKey = module5.OutfitsKey
}

local function SupportOverlayMonolithDependenciesProvider(p2)
	return React.createElement(
		supportOverlayMonolithDependenciesContext.Provider,
		{ value = v5 },
		p2.children
	)
end

return SupportOverlayMonolithDependenciesProvider
