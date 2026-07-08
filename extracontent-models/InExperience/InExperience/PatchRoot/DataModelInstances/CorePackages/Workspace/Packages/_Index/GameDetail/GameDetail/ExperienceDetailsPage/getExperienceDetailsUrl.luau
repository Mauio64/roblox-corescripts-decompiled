local Parent = script:FindFirstAncestor("GameDetail").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local Url = require(Parent.Http).Url
local SduiCapabilities = require(Parent.SduiSharedUtilities).SduiCapabilities
local FFlagSduiCapabilityBindings = require(Parent.SharedFlags).FFlagSduiCapabilityBindings
local FFlagSduiEdpClientTemplateCache = require(Parent.SharedFlags).FFlagSduiEdpClientTemplateCache

local function getExperienceDetailsUrl(s1: string) -- line: 10
	-- upvalues: UrlBuilder (copy), Url (copy), FFlagSduiCapabilityBindings (copy), FFlagSduiEdpClientTemplateCache (copy), Parent (copy), SduiCapabilities (copy)
	local v9 = UrlBuilder.new({
		path = "experience-details-api/v2/universes/{universeId}/experience-details",
		base = Url.APIS_URL
	})({
		universeId = s1
	})

	if FFlagSduiCapabilityBindings and not FFlagSduiEdpClientTemplateCache then
		require(Parent.ServiceContractsProto)

		local t1 = {}

		SduiCapabilities.addToQueryParams(t1, {
			"CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON",
			"CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION"
		})

		if next(t1) ~= nil then
			v9 = UrlBuilder.addQueryString(v9, t1)
		end
	end

	return v9
end

return getExperienceDetailsUrl
