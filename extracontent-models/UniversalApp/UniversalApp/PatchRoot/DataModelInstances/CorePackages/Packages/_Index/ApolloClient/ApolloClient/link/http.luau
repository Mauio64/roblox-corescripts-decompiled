local parseAndCheckHttpResponse = require(script.parseAndCheckHttpResponse)
local Http = {}

Http.parseAndCheckHttpResponse = parseAndCheckHttpResponse.parseAndCheckHttpResponse

local serializeFetchParameter = require(script.serializeFetchParameter)
Http.serializeFetchParameter = serializeFetchParameter.serializeFetchParameter

local selectHttpOptionsAndBody = require(script.selectHttpOptionsAndBody)

Http.fallbackHttpConfig = selectHttpOptionsAndBody.fallbackHttpConfig
Http.selectHttpOptionsAndBody = selectHttpOptionsAndBody.selectHttpOptionsAndBody

local checkFetcher = require(script.checkFetcher)
Http.checkFetcher = checkFetcher.checkFetcher
local createSignalIfSupported = require(script.createSignalIfSupported)
Http.createSignalIfSupported = createSignalIfSupported.createSignalIfSupported
local selectURI = require(script.selectURI)
Http.selectURI = selectURI.selectURI
local createHttpLink = require(script.createHttpLink)
Http.createHttpLink = createHttpLink.createHttpLink
local HttpLink = require(script.HttpLink)
Http.HttpLink = HttpLink.HttpLink

local rewriteURIForGET = require(script.rewriteURIForGET)
Http.rewriteURIForGET = rewriteURIForGET.rewriteURIForGET

return Http
