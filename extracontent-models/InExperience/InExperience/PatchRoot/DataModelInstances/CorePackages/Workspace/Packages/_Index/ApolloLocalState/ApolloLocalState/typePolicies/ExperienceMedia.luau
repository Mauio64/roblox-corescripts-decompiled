local makeDefaultReadPolicy = require(script.Parent.utils.makeDefaultReadPolicy)

return {
	fields = {
		imageId = { read = makeDefaultReadPolicy("-1") }
	}
}
