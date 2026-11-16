local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Components.Types)

local CardDensity = require(Foundation.Enums.CardDensity)

local composeStyleVariant = require(Foundation.Utility.composeStyleVariant)

require(Foundation.Providers.Style.Tokens)

local VariantsContext = require(Foundation.Providers.Style.VariantsContext)

require(script.Parent.Thumbnail)

local function variantsFactory(p)
	local bodySmall = p.Typography.BodySmall

	local function descriptionSizeConstraint(p2: number) -- 2 equivalent calls inferred from this helper
		return {
			MaxSize = Vector2.new(1e999, bodySmall.FontSize * bodySmall.LineHeight * p2)
		}
	end

	return {
		common = {
			container = { tag = "row align-y-center gap-medium size-full-0 auto-y" },
			content = { tag = "col fill auto-y" },
			title = {
				tag = "size-full-0 auto-y text-title-medium text-wrap text-align-x-left content-emphasis"
			},
			description = {
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-emphasis"
			}
		},
		densities = {
			[CardDensity.Compact] = {
				description = { sizeConstraint = descriptionSizeConstraint(1) } -- inferred equivalent call
			},
			[CardDensity.Default] = {
				description = { sizeConstraint = descriptionSizeConstraint(2) } -- inferred equivalent call
			}
		}
	}
end

return function(p, p2)
	local v = VariantsContext.useVariants("Banner.UpsellContent", variantsFactory, p)
	return composeStyleVariant(v.common, v.densities[p2])
end
