local parent = script:FindFirstAncestor("AvatarExperienceModel").Parent

local enumerate = require(parent.enumerate)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCatalogMakeupTaxonomy = AvatarExperienceFlags.FFlagAXCatalogMakeupTaxonomy
local FFlagAXCatalogM41Props = AvatarExperienceFlags.FFlagAXCatalogM41Props
local FFlagAXCatalogM41FullMasks = AvatarExperienceFlags.FFlagAXCatalogM41FullMasks
local FFlagAXCatalogM41HandAndArm = AvatarExperienceFlags.FFlagAXCatalogM41HandAndArm
local FFlagAXM41AllCategoriesToTaxonomy = AvatarExperienceFlags.FFlagAXM41AllCategoriesToTaxonomy
local FFlagAXCatalogBackgroundsSupport = AvatarExperienceFlags.FFlagAXCatalogBackgroundsSupport

return enumerate(script.Name, {
	AllItems = FFlagAXM41AllCategoriesToTaxonomy and "tZsUsd2BqGViQrJ9Vs3Wah" or nil,
	Body = FFlagAXM41AllCategoriesToTaxonomy and "mwkR3QvDBVzYk4o9RAVVa2" or nil,
	FullBodies = FFlagAXM41AllCategoriesToTaxonomy and "kfHzJwaNYM8s2CWRqYUhRa" or nil,
	Hair = FFlagAXM41AllCategoriesToTaxonomy and "d6a7M7r9MMrpf7z7VxW9ZS" or nil,
	DynamicHeads = FFlagAXM41AllCategoriesToTaxonomy and "s5NLP7BS9PRLKvUVca4XKg" or nil,
	ClassicHeads = FFlagAXM41AllCategoriesToTaxonomy and "1JiaNPKxcc5RL2X6b4VQwv" or nil,
	ClassicFaces = FFlagAXM41AllCategoriesToTaxonomy and "9atv5s8UMicJWBZXYMTjWH" or nil,
	Makeup = FFlagAXCatalogMakeupTaxonomy and "dBM565GC3YYTdi9UKvr87Z" or nil,
	EyeMakeup = FFlagAXCatalogMakeupTaxonomy and "1e7vNivWk2To6BdYJt5RGF" or nil,
	LipMakeup = FFlagAXCatalogMakeupTaxonomy and "c3PEmGVddwsc6bKqtuR7rC" or nil,
	FaceMakeup = FFlagAXCatalogMakeupTaxonomy and "tm9VSS61JdHJGtKvbjKa4D" or nil,
	Eyelashes = FFlagAXCatalogMakeupTaxonomy and "4zqsNnG4Tp7xZThAEpv2dN" or nil,
	Eyebrows = FFlagAXCatalogMakeupTaxonomy and "1cMbsG373EMD4ncRqGhtyZ" or nil,
	Backgrounds = FFlagAXCatalogBackgroundsSupport and "ijFKKMZq6jV4gkJQC4v7L1" or nil,
	Props = FFlagAXCatalogM41Props and "gCkG9kjqiv3Hfg4H3pkUoy" or nil,
	Clothing = "5G3bZScC9Hxp2D2EUtGSNm",
	Shirts = "pJ71PxerdfEuarTNRtSZYs",
	TShirts = "fLRqNzGqjX7MzcqeMro9hc",
	Sweaters = "31M6WgEMmyq9TTfk3pUUpZ",
	Jackets = "kPZpEVNdProGcqMbj1jDKJ",
	Pants = "1MvRtnnsy2FJWmkErSBxBa",
	DressesAndSkirts = "oSSCBSqkQPZu6HataAUAxB",
	Bodysuits = "u5jaNLyf2ZhvR95GS37ui5",
	Shorts = "etAPg889P243JyjdbZCXhw",
	Shoes = "uLRgNoJ1awZkhpVw9WyvKo",
	ClassicShirts = "2a2rf9qyeTd8W5iegK2Prc",
	ClassicTShirts = "43H35nJKHzCQM63q3wPaJG",
	ClassicPants = "49cFNAJWuwiJJVUSADG6DR",
	Accessories = FFlagAXM41AllCategoriesToTaxonomy and "wNYJso48d1XnhMyFWT3oX3" or nil,
	HeadAccessories = FFlagAXM41AllCategoriesToTaxonomy and "thukPQUFe5EHxRrtsgq43u" or nil,
	FaceAccessories = FFlagAXM41AllCategoriesToTaxonomy and "b5rkQhGSfwhfTK177y6ERa" or nil,
	FullMasks = FFlagAXCatalogM41FullMasks and "pdftcazVqwGjmgpC29ELFY" or nil,
	NeckAccessories = FFlagAXM41AllCategoriesToTaxonomy and "tvckLAbtDAGwF9Y2sph2Ce" or nil,
	ShoulderAccessories = FFlagAXM41AllCategoriesToTaxonomy and "8i1sggNTrxoN799hpRrR1S" or nil,
	HandAndArm = FFlagAXCatalogM41HandAndArm and "gFxqvTwUAxkggrRJz3NPZg" or nil,
	FrontAccessories = FFlagAXM41AllCategoriesToTaxonomy and "kj535RzJxHTCnXPBLo5KaE" or nil,
	BackAccessories = FFlagAXM41AllCategoriesToTaxonomy and "7yGywzp5JeDsNjhXWJqSw3" or nil,
	WaistAccessories = FFlagAXM41AllCategoriesToTaxonomy and "6jYQPDtkVwQZcKtvVpyYAN" or nil,
	Gear = FFlagAXM41AllCategoriesToTaxonomy and "gUtxkR951g3VPgRkb5ay8u" or nil,
	Animations = FFlagAXM41AllCategoriesToTaxonomy and "9fPpW3SJ6UkieQU5jJ4dgP" or nil,
	AnimationBundles = FFlagAXM41AllCategoriesToTaxonomy and "whf6kUVBwk2xdwKUmRYN6G" or nil,
	Emotes = FFlagAXM41AllCategoriesToTaxonomy and "ioNxAT977DFP2hMnAJbsbF" or nil
})
