local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/RobloxAppEnums").AppPage
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local sduiCapabilities = SduiSharedUtilities.SduiCapabilities
local getExperienceDetailsUrl = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/getExperienceDetailsUrl")
local getExperienceDetailsPageKey = require("@game/CorePackages/Workspace/Packages/_Index/GameDetail/GameDetail/ExperienceDetailsPage/getExperienceDetailsPageKey")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/SharedFlags")
local fFlagSduiEdpClientTemplateCache = SharedFlags.FFlagSduiEdpClientTemplateCache
local fFlagSduiEdpTemplatePrewarm = SharedFlags.FFlagSduiEdpTemplatePrewarm
local fFlagSduiAdvertiseRuntimeSupportSets = SharedFlags.FFlagSduiAdvertiseRuntimeSupportSets
local fFlagInfoTableStableItemKeys = SharedFlags.FFlagInfoTableStableItemKeys
local fFlagLuaAppEdpMomentVideo = SharedFlags.FFlagLuaAppEdpMomentVideo

local function fetchExperienceDetailsPage(p2, p3, p4)
	local v5 = getExperienceDetailsUrl(p2)

	local ServiceContractsProto = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetail/ServiceContractsProto")
	local experience_details_page = ServiceContractsProto.apppageplatform.experiencedetails.experience_details_page
	local v6

	if fFlagSduiEdpClientTemplateCache then
		local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities
		local v7

		if fFlagSduiAdvertiseRuntimeSupportSets then
			v7 = sduiCapabilities.buildClientCapabilities()
		else
			local v8

			if fFlagSduiEdpTemplatePrewarm then
				v8 = sduiCapabilities.getEnabledCapabilityNumbers(sduiCapabilities.getEnabledCapabilities())
			else
				local v9 = {
					"CAPABILITY_SUPPORTS_EDP_PERSISTENT_ACTION_BAR_PLAY_BUTTON",
					"CAPABILITY_SUPPORTS_EDP_COMMUNITY_SECTION",
					"CAPABILITY_SUPPORTS_EDP_BUILD_TAG",
					"CAPABILITY_SUPPORTS_OPEN_EXPERIENCE_STORE_SEE_ALL_WITH_WEBVIEW_FALLBACK_ACTION",
					"CAPABILITY_SUPPORTS_PIN_SHORTCUT_ACTION",
					"CAPABILITY_SUPPORTS_SCALED_PLAY_BUTTON_AND_IMAGE_SIZES",
					"CAPABILITY_SUPPORTS_CONTAINER_QUERIES",
					"CAPABILITY_SUPPORTS_EDP_EARLY_ACCESS_UPSELL",
					fFlagLuaAppEdpMomentVideo and "CAPABILITY_SUPPORTS_EDP_MEDIA_GALLERY_MOMENT_VIDEO" or nil
				}

				if fFlagInfoTableStableItemKeys then
					table.insert(v9, "CAPABILITY_SUPPORTS_EDP_INFO_TABLE_STABLE_ITEM_KEYS")
				end

				v8 = sduiCapabilities.getEnabledCapabilityNumbers(v9)
			end

			v7 = clientCapabilities.new({ enabled_capabilities = v8 })
		end

		local cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(appPage.ExperienceDetail)

		v6 = {
			contentType = sduiApiStorePostConfigContentType.Proto,
			protoMessage = experience_details_page.ExperienceDetailsPageRequest,
			body = {
				cached_roblox_component_to_template_id = cachedRobloxComponentToTemplateId,
				client_capabilities = v7
			}
		}
	end

	local fetchIfNeeded = getSduiApiStore().fetchIfNeeded
	local v7 = {
		responseType = sduiResponseType.Protobuf,
		url = v5,
		surfaceKey = appPage.ExperienceDetail,
		configKey = getExperienceDetailsPageKey(p2),
		loadTimer = p3,
		apiProto = experience_details_page.ExperienceDetailsPageResponse,
		postConfig = 0,
		enableTemplateCache = 0
	}

	if not fFlagSduiEdpClientTemplateCache then
		v6 = nil
	end

	v7.postConfig = v6
	v7.enableTemplateCache = fFlagSduiEdpClientTemplateCache and true or nil
	fetchIfNeeded(v7, p4)
end

return fetchExperienceDetailsPage
