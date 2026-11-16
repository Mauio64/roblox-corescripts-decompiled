local PresetContentModel = require(script.Parent.Parent.ContentKinds.Preset.PresetContentModel)

return {
	fromPreset = function(p: string, p2: string, p3: string?)
		return PresetContentModel.fromPreset(p, p2, p3)
	end
}
