local parent = script:FindFirstAncestor("GameDetail").Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities
local getExperienceDetailsUrl = require(script.Parent.getExperienceDetailsUrl)
local getExperienceDetailsPageKey = require(script.Parent.getExperienceDetailsPageKey)
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiEdpClientTemplateCache = SharedFlags.FFlagSduiEdpClientTemplateCache
local FFlagSduiEdpTemplatePrewarm = SharedFlags.FFlagSduiEdpTemplatePrewarm
local FFlagSduiAdvertiseRuntimeSupportSets = SharedFlags.FFlagSduiAdvertiseRuntimeSupportSets
local FFlagInfoTableStableItemKeys = SharedFlags.FFlagInfoTableStableItemKeys
local FFlagLuaAppEdpMomentVideo = SharedFlags.FFlagLuaAppEdpMomentVideo

local function fetchExperienceDetailsPage(p: string, loadTimer, flag: boolean?)
	local experienceDetailsUrl = getExperienceDetailsUrl(p)

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local experience_details_page = ServiceContractsProto.apppageplatform.experiencedetails.experience_details_page
	local postConfig

	if FFlagSduiEdpClientTemplateCache then
		local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities
		local client_capabilities

		if FFlagSduiAdvertiseRuntimeSupportSets then
			client_capabilities = SduiCapabilities.buildClientCapabilities()
		else
			local enabled_capabilities

			if FFlagSduiEdpTemplatePrewarm then
				enabled_capabilities = SduiCapabilities.getEnabledCapabilityNumbers((SduiCapabilities.getEnabledCapabilities()))
			else
				local v = {
					"CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON",
					"CAPABILITY_SUPPORTS_EDP_COMMUNITY_SECTION",
					"CAPABILITY_SUPPORTS_EDP_BUILD_TAG",
					"CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION",
					"CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION",
					"CAPABILITY_SUPPORTS_SCALED_PLAY_BUTTON_AND_IMAGE_SIZES",
					"CAPABILITY_SUPPORTS_CONTAINER_QUERIES",
					"CAPABILITY_SUPPORTS_EDP_EARLY_ACCESS_UPSELL",
					FFlagLuaAppEdpMomentVideo and "CAPABILITY_SUPPORTS_EDP_MEDIA_GALLERY_MOMENT_VIDEO" or nil
				}

				if FFlagInfoTableStableItemKeys then
					table.insert(v, "CAPABILITY_SUPPORTS_EDP_INFO_TABLE_STABLE_ITEM_KEYS")
				end

				enabled_capabilities = SduiCapabilities.getEnabledCapabilityNumbers(v)
			end

			client_capabilities = clientCapabilities.new({
				enabled_capabilities = enabled_capabilities
			})
		end

		local cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(AppPage.ExperienceDetail)

		postConfig = {
			contentType = SduiApiStorePostConfigContentType.Proto,
			protoMessage = experience_details_page.ExperienceDetailsPageRequest,
			body = {
				cached_roblox_component_to_template_id = cachedRobloxComponentToTemplateId,
				client_capabilities = client_capabilities
			}
		}
	end

	local fetchIfNeeded = getSduiApiStore().fetchIfNeeded
	local v = {
		responseType = SduiResponseType.Protobuf,
		url = experienceDetailsUrl,
		surfaceKey = AppPage.ExperienceDetail,
		configKey = getExperienceDetailsPageKey(p),
		loadTimer = loadTimer,
		apiProto = experience_details_page.ExperienceDetailsPageResponse,
		postConfig = 0,
		enableTemplateCache = 0
	}

	if not FFlagSduiEdpClientTemplateCache then
		postConfig = nil
	end

	v.postConfig = postConfig
	v.enableTemplateCache = FFlagSduiEdpClientTemplateCache and true or nil
	fetchIfNeeded(v, flag)
end

return fetchExperienceDetailsPage
