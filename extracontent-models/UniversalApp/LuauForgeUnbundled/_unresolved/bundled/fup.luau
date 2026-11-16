local module = require("@luauforge/bundled/ful")

local v5 = {
	Default = "Default",
	Classic = "Classic",
	Halloween2026 = "Halloween2026",
	CosmicDust = "CosmicDust",
	PolarFreeze = "PolarFreeze",
	SuperCharge = "SuperCharge",
	ElectricLime = "ElectricLime",
	LavaGlow = "LavaGlow",
	StarBurst = "StarBurst",
	PixelPop = "PixelPop",
	NebulaDrift = "NebulaDrift",
	NitroFrost = "NitroFrost",
	CircuitRush = "CircuitRush",
	KineticEnergy = "KineticEnergy",
	InfernoBlast = "InfernoBlast",
	HyperPlum = "HyperPlum",
	QuantumPulse = "QuantumPulse"
}

v5.Keys = {
	v5.Default,
	v5.Classic,
	v5.CosmicDust,
	v5.PolarFreeze,
	v5.SuperCharge,
	v5.ElectricLime,
	v5.LavaGlow,
	v5.StarBurst,
	v5.PixelPop,
	v5.NebulaDrift,
	v5.NitroFrost,
	v5.CircuitRush,
	v5.KineticEnergy,
	v5.InfernoBlast,
	v5.HyperPlum,
	v5.QuantumPulse
}

if module then
	table.insert(v5.Keys, 3, v5.Halloween2026)
end

v5.RobloxThemeKeys = { v5.Default }

v5.Labels = {
	[v5.Default] = "Feature.Accessibility.AppTheme.Default",
	[v5.Classic] = "Feature.Accessibility.AppTheme.Classic",
	[v5.Halloween2026] = "Feature.Accessibility.AppTheme.Halloween2026",
	[v5.CosmicDust] = "Feature.Accessibility.AppTheme.CosmicDust",
	[v5.PolarFreeze] = "Feature.Accessibility.AppTheme.PolarFreeze",
	[v5.SuperCharge] = "Feature.Accessibility.AppTheme.SuperCharge",
	[v5.ElectricLime] = "Feature.Accessibility.AppTheme.ElectricLime",
	[v5.LavaGlow] = "Feature.Accessibility.AppTheme.LavaGlow",
	[v5.StarBurst] = "Feature.Accessibility.AppTheme.StarBurst",
	[v5.PixelPop] = "Feature.Accessibility.AppTheme.PixelPop",
	[v5.NebulaDrift] = "Feature.Accessibility.AppTheme.NebulaDrift",
	[v5.NitroFrost] = "Feature.Accessibility.AppTheme.NitroFrost",
	[v5.CircuitRush] = "Feature.Accessibility.AppTheme.CircuitRush",
	[v5.KineticEnergy] = "Feature.Accessibility.AppTheme.KineticEnergy",
	[v5.InfernoBlast] = "Feature.Accessibility.AppTheme.InfernoBlast",
	[v5.HyperPlum] = "Feature.Accessibility.AppTheme.HyperPlum",
	[v5.QuantumPulse] = "Feature.Accessibility.AppTheme.QuantumPulse"
}

return v5
