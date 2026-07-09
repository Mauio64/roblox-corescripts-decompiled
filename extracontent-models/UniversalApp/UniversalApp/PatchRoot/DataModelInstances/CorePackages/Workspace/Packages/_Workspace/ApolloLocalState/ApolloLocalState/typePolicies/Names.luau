local makeDefaultReadPolicy = require(script.Parent.utils.makeDefaultReadPolicy)

return {
	fields = {
		alias = {
			read = makeDefaultReadPolicy("")
		},
		contactName = {
			read = makeDefaultReadPolicy("")
		},
		platformName = {
			read = makeDefaultReadPolicy("")
		}
	}
}
