local Parent = script:FindFirstAncestor("GameDetail").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities
local getExperienceDetailsUrl = require(script.Parent.getExperienceDetailsUrl)
local getExperienceDetailsPageKey = require(script.Parent.getExperienceDetailsPageKey)
local FFlagSduiEdpClientTemplateCache = require(Parent.SharedFlags).FFlagSduiEdpClientTemplateCache

local function fetchExperienceDetailsPage(s1: string, p1, b1: boolean?) -- line: 16
	-- upvalues: getExperienceDetailsUrl (copy), Parent (copy), FFlagSduiEdpClientTemplateCache (copy), SduiCapabilities (copy), getSduiTemplateStore (copy), AppPage (copy), SduiApiStorePostConfigContentType (copy), getSduiApiStore (copy), SduiResponseType (copy), getExperienceDetailsPageKey (copy)
	local v16 = getExperienceDetailsUrl(s1)
	local ServiceContractsProto = require(Parent.ServiceContractsProto)
	local experience_details_page = ServiceContractsProto.apppageplatform.experiencedetails.experience_details_page
	local t1 = nil

	if FFlagSduiEdpClientTemplateCache then
		local v20 = SduiCapabilities.getEnabledCapabilityNumbers({
			"CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON",
			"CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION",
			"CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION"
		})
		local v21 = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities.new({
			enabled_capabilities = v20
		})
		local v22 = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(AppPage.ExperienceDetail)

		t1 = {
			contentType = SduiApiStorePostConfigContentType.Proto,
			protoMessage = experience_details_page.ExperienceDetailsPageRequest,
			body = {
				cached_roblox_component_to_template_id = v22,
				client_capabilities = v21
			}
		}
	end

	getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = v16,
		surfaceKey = AppPage.ExperienceDetail,
		configKey = getExperienceDetailsPageKey(s1),
		loadTimer = p1,
		apiProto = experience_details_page.ExperienceDetailsPageResponse,
		postConfig = if not FFlagSduiEdpClientTemplateCache then nil else t1,
		enableTemplateCache = not not FFlagSduiEdpClientTemplateCache or nil
	}, b1)
end

return fetchExperienceDetailsPage
