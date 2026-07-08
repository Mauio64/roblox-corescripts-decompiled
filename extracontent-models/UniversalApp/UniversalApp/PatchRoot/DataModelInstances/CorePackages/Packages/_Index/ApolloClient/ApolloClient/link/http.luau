local t1 = {
	parseAndCheckHttpResponse = require(script.parseAndCheckHttpResponse).parseAndCheckHttpResponse,
	serializeFetchParameter = require(script.serializeFetchParameter).serializeFetchParameter
}
local selectHttpOptionsAndBody = require(script.selectHttpOptionsAndBody)

t1.fallbackHttpConfig = selectHttpOptionsAndBody.fallbackHttpConfig
t1.selectHttpOptionsAndBody = selectHttpOptionsAndBody.selectHttpOptionsAndBody
t1.checkFetcher = require(script.checkFetcher).checkFetcher
t1.createSignalIfSupported = require(script.createSignalIfSupported).createSignalIfSupported
t1.selectURI = require(script.selectURI).selectURI
t1.createHttpLink = require(script.createHttpLink).createHttpLink
t1.HttpLink = require(script.HttpLink).HttpLink
t1.rewriteURIForGET = require(script.rewriteURIForGET).rewriteURIForGET

return t1
