local Foundation = script:FindFirstAncestor("Foundation")

require(Foundation.Enums.ColorMode)
local Device = require(Foundation.Enums.Device)
local Flags = require(Foundation.Utility.Flags)
local FontName = require(Foundation.Enums.FontName)
local ThemeName = require(Foundation.Enums.ThemeName)

local TypographyVariants = require(Foundation.Generated.StyleRules.TypographyVariants)

local v = {
	Common = function()
		return require(Foundation.Generated.StyleRules.CommonAttribute)
	end,
	Console = function()
		return require(Foundation.Generated.StyleRules.ConsoleAttribute)
	end,
	Desktop = function()
		return require(Foundation.Generated.StyleRules.DesktopAttribute)
	end
}

local v2 = {
	[ThemeName.CircuitRush] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.CircuitRush.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.CircuitRush.LightAttribute)
		end
	},
	[ThemeName.Classic] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.Classic.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.Classic.LightAttribute)
		end
	},
	[ThemeName.CosmicDust] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.CosmicDust.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.CosmicDust.LightAttribute)
		end
	},
	[ThemeName.Default] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.Default.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.Default.LightAttribute)
		end
	},
	[ThemeName.ElectricLime] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.ElectricLime.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.ElectricLime.LightAttribute)
		end
	},
	[ThemeName.Halloween2026] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.Halloween2026.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.Halloween2026.LightAttribute)
		end
	},
	[ThemeName.HyperPlum] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.HyperPlum.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.HyperPlum.LightAttribute)
		end
	},
	[ThemeName.InfernoBlast] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.InfernoBlast.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.InfernoBlast.LightAttribute)
		end
	},
	[ThemeName.Kids] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.Kids.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.Kids.LightAttribute)
		end
	},
	[ThemeName.KineticEnergy] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.KineticEnergy.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.KineticEnergy.LightAttribute)
		end
	},
	[ThemeName.LavaGlow] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.LavaGlow.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.LavaGlow.LightAttribute)
		end
	},
	[ThemeName.NebulaDrift] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.NebulaDrift.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.NebulaDrift.LightAttribute)
		end
	},
	[ThemeName.NitroFrost] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.NitroFrost.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.NitroFrost.LightAttribute)
		end
	},
	[ThemeName.PixelPop] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.PixelPop.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.PixelPop.LightAttribute)
		end
	},
	[ThemeName.PolarFreeze] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.PolarFreeze.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.PolarFreeze.LightAttribute)
		end
	},
	[ThemeName.QuantumPulse] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.QuantumPulse.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.QuantumPulse.LightAttribute)
		end
	},
	[ThemeName.StarBurst] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.StarBurst.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.StarBurst.LightAttribute)
		end
	},
	[ThemeName.SuperCharge] = {
		Dark = function()
			return require(Foundation.Generated.StyleRules.SuperCharge.DarkAttribute)
		end,
		Light = function()
			return require(Foundation.Generated.StyleRules.SuperCharge.LightAttribute)
		end
	}
}

local BuilderSans = FontName.BuilderSans

local v3 = {
	[FontName.BuilderSans] = {
		Desktop = function()
			return require(Foundation.Generated.StyleRules.Typography.BuilderSans.DesktopAttribute)
		end,
		Console = function()
			return require(Foundation.Generated.StyleRules.Typography.BuilderSans.ConsoleAttribute)
		end
	},
	[FontName.Cartoon] = {
		Desktop = function()
			return require(Foundation.Generated.StyleRules.Typography.Cartoon.DesktopAttribute)
		end,
		Console = function()
			return require(Foundation.Generated.StyleRules.Typography.Cartoon.ConsoleAttribute)
		end
	}
}

local v4 = {
	[FontName.BuilderSans] = {
		Desktop = function()
			return require(Foundation.Generated.StyleRules.Legacy.Typography.BuilderSans.DesktopAttribute)
		end,
		Console = function()
			return require(Foundation.Generated.StyleRules.Legacy.Typography.BuilderSans.ConsoleAttribute)
		end
	},
	[FontName.Cartoon] = {
		Desktop = function()
			return require(Foundation.Generated.StyleRules.Legacy.Typography.Cartoon.DesktopAttribute)
		end,
		Console = function()
			return require(Foundation.Generated.StyleRules.Legacy.Typography.Cartoon.ConsoleAttribute)
		end
	}
}

local function getGeneratedRules(p, p2, p3)
	local v5 = p or ThemeName.Default

	local common = v.Common()
	local v6 = (v2[v5] or v2[ThemeName.Default])[p2]()
	local v7

	if p3 == Device.Console and not Flags.FoundationDisableTokenScaling then
		v7 = v[Device.Console]()
	else
		v7 = v[Device.Desktop]()
	end

	if not (v6 and v7 and common) then
		return {}
	end

	local clone = table.clone(v7)

	for k, v8 in common do
		clone[k] = v8
	end

	for k, v8 in v6 do
		clone[k] = v8
	end

	local v8 = TypographyVariants[v5] or BuilderSans
	local v9

	if Flags.FoundationFontFaceMigration then
		v9 = v3[v8] or v3[BuilderSans]
	else
		v9 = v4[v8] or v4[BuilderSans]
	end

	local v10

	if p3 == Device.Console and not Flags.FoundationDisableTokenScaling then
		v10 = Device.Console
	else
		v10 = Device.Desktop
	end

	local v11 = v9[v10]

	if not v11 then
		return clone
	end

	local v12 = v11()

	if v12 then
		for k, v13 in v12 do
			clone[k] = v13
		end
	end

	return clone
end

return getGeneratedRules
