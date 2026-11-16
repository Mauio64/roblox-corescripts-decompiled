require(script.Parent.Parent.Parent.Types)
require(script.Parent.PresetTypes)

local PresetContentModel = {}

function PresetContentModel.detailFromPreset(presetId: string, p: string, presetVersion: string?)
	return { fallbackText = p, presetId = presetId, presetVersion = presetVersion, displayText = p }
end

function PresetContentModel.fromPreset(p: string, p2: string, p3: string?)
	return {
		preset = PresetContentModel.detailFromPreset(p, p2, p3)
	}
end

function PresetContentModel.draftFromPreset(presetId: string, displayText: string)
	return {
		preset = { presetId = presetId, displayText = displayText }
	}
end

function PresetContentModel.getDetail(p)
	return p.preset
end

function PresetContentModel.getDraft(p)
	return p.preset
end

function PresetContentModel.fromDraft(p)
	local draft = PresetContentModel.getDraft(p)

	if draft == nil then
		return nil
	end

	return PresetContentModel.fromPreset(draft.presetId, draft.displayText, nil)
end

return PresetContentModel
