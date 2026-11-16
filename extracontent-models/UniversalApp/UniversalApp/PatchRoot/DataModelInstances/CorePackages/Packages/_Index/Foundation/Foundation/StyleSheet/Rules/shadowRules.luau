local Foundation = script:FindFirstAncestor("Foundation")

local ShadowPreset = require(Foundation.Enums.ShadowPreset)
require(Foundation.Providers.Style.Tokens)
require(script.Parent.Types)

local v = {
	{
		name = ShadowPreset.Raised100,
		layers = {
			{ blur = "100", spread = "0" },
			{ blur = "500", spread = "0" }
		}
	},
	{
		name = ShadowPreset.Raised300,
		layers = {
			{ blur = "100", spread = "0" },
			{ blur = "500", spread = "0" },
			{ blur = "800", spread = "0" },
			{ blur = "1400", spread = "0" }
		}
	},
	{
		name = ShadowPreset.Overlay100,
		layers = {
			{ offsetY = "50", blur = "100", spread = "-0.5" },
			{ offsetY = "250", blur = "500", spread = "-0.75" }
		}
	},
	{
		name = ShadowPreset.Overlay300,
		layers = {
			{ offsetY = "50", blur = "100", spread = "-0.5" },
			{ offsetY = "250", blur = "500", spread = "-0.75" },
			{ offsetY = "400", blur = "800", spread = "-1" },
			{ offsetY = "1200", blur = "1400", spread = "-1.5" }
		}
	}
}

local function sizeTokenField(p: string) -- 2 equivalent calls inferred from this helper
	return `Size_{p}`
end

local function shadowAttributeName(p: string, p2: string)
	return `Shadow{p}Size{p2}`
end

local function layerRule(formatted: string, data, p: number, size, color3: Color3)
	local formatted2 = `ShadowBlurSize{data.blur}`

	local spread = math.floor((tonumber(data.spread)))

	local properties = {
		BlurRadius = "$" .. formatted2,
		Color = color3,
		Transparency = 0.92,
		Spread = UDim2.fromOffset(spread, spread),
		ZIndex = -p
	}
	local attributes = {
		{
			name = formatted2,
			value = UDim.new(0, size[sizeTokenField(data.blur)]) -- inferred equivalent call
		}
	}

	if data.offsetY == nil then
		properties.Offset = UDim2.new()
	else
		local formatted3 = `ShadowOffsetSize{data.offsetY}`
		properties.Offset = "$" .. formatted3
		table.insert(attributes, {
			name = formatted3,
			value = UDim2.fromOffset(0, size[sizeTokenField(data.offsetY)]) -- inferred equivalent call
		})
	end

	return {
		tag = formatted,
		pseudo = "UIShadow",
		pseudoName = `{formatted}-{p}`,
		properties = properties,
		attributes = attributes
	}
end

local function shadowRules(p)
	local size = p.Size

	local color3 = p.Color.Common.Shadow.Color3
	local result = {}

	for _, v2 in v do
		local formatted = `shadow-{v2.name}`
		local layers = v2.layers

		local v3 = layerRule(formatted, layers[1], 1, size, color3)

		if #layers > 1 then
			local children = {}

			for i = 2, #layers do
				table.insert(children, layerRule(formatted, layers[i], i, size, color3))
			end

			v3.children = children
		end

		table.insert(result, v3)
	end

	return result
end

return shadowRules
