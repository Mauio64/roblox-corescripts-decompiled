local Foundation = script:FindFirstAncestor("Foundation")

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

local InternalDrawerLayout = require(Foundation.Enums.InternalDrawerLayout)
local InternalDrawerSide = require(Foundation.Enums.InternalDrawerSide)
require(Foundation.Providers.Style.Tokens)
require(Foundation.Components.Types)
local VariantsContext = require(Foundation.Providers.Style.VariantsContext)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function variantsFactory(data)
	return {
		common = {
			innerEdge = {
				backgroundStyle = data.Color.Stroke.Default,
				thickness = data.Stroke.Standard
			},
			shadow = { tag = "shadow-overlay-300" }
		},
		layout = {
			[InternalDrawerLayout.FullBleed] = {
				surface = { margin = 0 },
				innerEdge = { isVisible = true }
			},
			[InternalDrawerLayout.Inset] = {
				surface = {
					tag = "stroke-standard stroke-default radius-large",
					margin = data.Padding.Medium
				},
				innerEdge = { isVisible = false },
				shadow = { tag = "radius-large" }
			}
		},
		side = {
			[InternalDrawerSide.Start] = {
				surface = {
					tag = "anchor-top-left",
					anchorScaleX = 0,
					openOffsetSign = 1,
					hiddenOffsetSign = -1
				},
				innerEdge = { tag = "position-top-right anchor-top-right" },
				shadow = { tag = "anchor-top-left" }
			},
			[InternalDrawerSide.End] = {
				surface = {
					tag = "anchor-top-left",
					anchorScaleX = 1,
					openOffsetSign = -1,
					hiddenOffsetSign = 1
				},
				innerEdge = { tag = "position-top-left anchor-top-left" },
				shadow = { tag = "anchor-top-left" }
			}
		}
	}
end

local function useInternalDrawerVariants(p, p2)
	local v = useTokens()
	local v2 = VariantsContext.useVariants("InternalDrawer", variantsFactory, v)

	return composeStyleVariant(v2.common, v2.layout[p], v2.side[p2])
end

return useInternalDrawerVariants
