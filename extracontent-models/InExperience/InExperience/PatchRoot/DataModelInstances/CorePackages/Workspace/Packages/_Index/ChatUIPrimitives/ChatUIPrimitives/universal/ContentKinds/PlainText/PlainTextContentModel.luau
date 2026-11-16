require(script.Parent.Parent.Parent.Types)
require(script.Parent.PlainTextTypes)

local PlainTextContentModel = {}

function PlainTextContentModel.detailFromText(p: string)
	return {
		fallbackText = p,
		displayText = { text = p },
		wasRewritten = false
	}
end

function PlainTextContentModel.fromText(p: string)
	return {
		plainText = PlainTextContentModel.detailFromText(p)
	}
end

function PlainTextContentModel.draftFromText(text: string)
	return {
		plainText = { text = text }
	}
end

function PlainTextContentModel.getDetail(p)
	return p.plainText
end

function PlainTextContentModel.getDraft(p)
	return p.plainText
end

function PlainTextContentModel.fromDraft(p)
	local draft = PlainTextContentModel.getDraft(p)

	if draft == nil then
		return nil
	end

	return PlainTextContentModel.fromText(draft.text)
end

return PlainTextContentModel
