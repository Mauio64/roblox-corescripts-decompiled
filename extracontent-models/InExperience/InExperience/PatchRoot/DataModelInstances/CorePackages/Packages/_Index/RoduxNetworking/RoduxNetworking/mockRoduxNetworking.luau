local makeActionCreator = require(script.Parent.makeActionCreator)

local function makeMockRequestObject(p)
	local actionCreator = makeActionCreator(p)
	local function fn() end
	function actionCreator.API()
		return actionCreator.Succeeded()
	end

	actionCreator.Mock = { reply = fn, clear = fn, replyWithError = fn }

	return actionCreator
end

return function()
	return {
		GET = makeMockRequestObject,
		POST = makeMockRequestObject,
		PATCH = makeMockRequestObject,
		DELETE = makeMockRequestObject
	}
end
