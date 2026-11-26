local module = require("@luauforge/bundled/fBQ")

local color = Color3.fromHex("#E92127")
local color2 = Color3.fromHex("#0242DC")

local colors = {
	[module.Default] = Color3.fromHex("#272930"),
	[module.Classic] = Color3.fromHex("#B5271F"),
	[module.Halloween2026] = color,
	[module.CosmicDust] = Color3.fromHex("#6625D0"),
	[module.PolarFreeze] = Color3.fromHex("#065684"),
	[module.SuperCharge] = Color3.fromHex("#045D4A"),
	[module.ElectricLime] = Color3.fromHex("#455903"),
	[module.LavaGlow] = Color3.fromHex("#A71811"),
	[module.StarBurst] = Color3.fromHex("#A5094F"),
	[module.PixelPop] = Color3.fromHex("#8E1F8E"),
	[module.NebulaDrift] = Color3.fromHex("#480B98"),
	[module.NitroFrost] = Color3.fromHex("#043B5D"),
	[module.CircuitRush] = Color3.fromHex("#043E32"),
	[module.KineticEnergy] = Color3.fromHex("#2E3C02"),
	[module.InfernoBlast] = Color3.fromHex("#6B0F0B"),
	[module.HyperPlum] = Color3.fromHex("#710437"),
	[module.QuantumPulse] = Color3.fromHex("#5D0E5D")
}

local colors2 = {
	[module.Default] = Color3.fromHex("#FFFFFF"),
	[module.Classic] = Color3.fromHex("#E2241A"),
	[module.Halloween2026] = color,
	[module.CosmicDust] = Color3.fromHex("#CBB7FD"),
	[module.PolarFreeze] = Color3.fromHex("#6CD1ED"),
	[module.SuperCharge] = Color3.fromHex("#81D887"),
	[module.ElectricLime] = Color3.fromHex("#B4D159"),
	[module.LavaGlow] = Color3.fromHex("#FBB2A9"),
	[module.StarBurst] = Color3.fromHex("#FBADC6"),
	[module.PixelPop] = Color3.fromHex("#F7ACF4"),
	[module.NebulaDrift] = Color3.fromHex("#DDCFFE"),
	[module.NitroFrost] = Color3.fromHex("#98E3F4"),
	[module.CircuitRush] = Color3.fromHex("#ADE7B1"),
	[module.KineticEnergy] = Color3.fromHex("#CAE388"),
	[module.InfernoBlast] = Color3.fromHex("#FECEC8"),
	[module.HyperPlum] = Color3.fromHex("#FBC9D8"),
	[module.QuantumPulse] = Color3.fromHex("#FBC8F8")
}

local v5 = { HalloweenSecondary = color2, Dark = colors, Light = colors2 }

function v5.get(p2, p3)
	local v6 = if p3 then colors2 else colors
	return v6[p2] or v6[module.Default]
end

return v5
