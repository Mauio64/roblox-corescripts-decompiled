local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local supportOverlayMonolithDependenciesContext = require("@luauforge/bundled/ibb").Providers.SupportOverlayMonolithDependenciesContext

local module = require("@luauforge/bundled/ehm")
local module2 = require("@luauforge/bundled/fCM")
local module3 = require("@luauforge/bundled/ehA")

local module4 = require("@luauforge/bundled/dRg")
local module5 = require("@luauforge/bundled/dPN")
local module6 = require("@luauforge/bundled/fCI")
local module7 = require("@luauforge/bundled/dRz")

local module8 = require("@luauforge/bundled/gLD")
local module9 = require("@luauforge/bundled/fDB")
local module10 = require("@luauforge/bundled/gJM")
local module11 = require("@luauforge/bundled/gOQ")

local module12 = require("@luauforge/bundled/gTy")

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
