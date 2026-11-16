local PlainTextContentModel = require(script.Parent.Parent.ContentKinds.PlainText.PlainTextContentModel)

return {
	fromText = function(p: string)
		return PlainTextContentModel.fromText(p)
	end
}
