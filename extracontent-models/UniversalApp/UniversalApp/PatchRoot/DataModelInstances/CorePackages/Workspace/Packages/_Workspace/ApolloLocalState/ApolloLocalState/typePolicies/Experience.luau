local makeDefaultReadPolicy = require(script.Parent.utils.makeDefaultReadPolicy)

return {
	fields = {
		isSponsored = {},
		thumbnails = {
			read = makeDefaultReadPolicy({})
		}
	}
}
