local module = require("@luauforge/bundled/fup")

local v5 = { Dynamic = "Dynamic", Calm = "Calm", Special = "Special" }

local v6 = {
	{
		id = v5.Dynamic,
		themeKeys = {
			module.CosmicDust,
			module.PolarFreeze,
			module.SuperCharge,
			module.ElectricLime,
			module.LavaGlow,
			module.StarBurst,
			module.PixelPop
		}
	},
	{
		id = v5.Calm,
		themeKeys = {
			module.NebulaDrift,
			module.NitroFrost,
			module.CircuitRush,
			module.KineticEnergy,
			module.InfernoBlast,
			module.HyperPlum,
			module.QuantumPulse
		}
	},
	{
		id = v5.Special,
		themeKeys = { module.Classic, module.Halloween2026 }
	}
}

return {
	Category = v5,
	Categories = v6,
	buildCategories = function(items, p2)
		local set = {}

		for k, item in items do
			set[item] = true
		end

		local categories = {}

		for k, v7 in v6 do
			local themeKeys = {}

			for k2, themeKey in v7.themeKeys do
				if set[themeKey] then
					table.insert(themeKeys, themeKey)
				end
			end

			if #themeKeys > 0 then
				table.insert(categories, {
					label = p2[v7.id] or v7.id,
					themeKeys = themeKeys
				})
			end
		end

		return categories
	end,
	findCategoryIndex = function(items, p2)
		if p2 == module.Default then
			return nil
		end

		for k, item in items do
			for k2, themeKey in item.themeKeys do
				if themeKey == p2 then
					return k
				end
			end
		end

		return nil
	end
}
