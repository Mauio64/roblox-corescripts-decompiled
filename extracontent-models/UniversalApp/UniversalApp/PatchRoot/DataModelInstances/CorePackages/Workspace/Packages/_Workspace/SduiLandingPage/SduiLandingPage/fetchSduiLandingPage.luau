local Parent = script:FindFirstAncestor("SduiLandingPage").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiLandingPageKey = require(script.Parent.getSduiLandingPageKey)
local getSduiLandingPageUrl = require(script.Parent.getSduiLandingPageUrl)

local function fetchSduiLandingPage(s1: string, s2: string, p1, b1: boolean?) -- line: 14
	-- upvalues: getSduiLandingPageUrl (copy), getSduiLandingPageKey (copy), Parent (copy), getSduiApiStore (copy), SduiResponseType (copy), AppPage (copy)
	local v13 = getSduiLandingPageUrl(s1, s2)
	local v14 = getSduiLandingPageKey(s1)
	local SpotlightCollectionPageResponse = require(Parent.ServiceContractsProto).apppageplatform.spotlightcollection.spotlight_collection_page.SpotlightCollectionPageResponse
	local t1 = {}

	local function getProtoForPageIdentifier(s3: string) -- line: 31
		-- upvalues: t1 (copy), SpotlightCollectionPageResponse (copy)
		return t1[s3] or SpotlightCollectionPageResponse
	end

	getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.ProtobufJson,
		url = v13,
		surfaceKey = AppPage.SduiLandingPage,
		configKey = v14,
		loadTimer = p1,
		apiProto = t1[s1] or SpotlightCollectionPageResponse
	}, b1)

	return v14
end

return fetchSduiLandingPage
