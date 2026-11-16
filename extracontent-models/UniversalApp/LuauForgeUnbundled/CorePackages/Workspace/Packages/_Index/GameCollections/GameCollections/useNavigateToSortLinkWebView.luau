local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Navigation").useNavigation
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/UrlBuilder").UrlBuilder
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppEnums").AppPage
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/UniversalAppPolicy").useAppPolicy
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppHooks").useRoactService
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactServiceTags").AppEventIngestService
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/t")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Loggers").mutedError
local LinkingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/LinkingProtocol")
local deepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default

local strictInterface = t.strictInterface({
	action = t.string,
	linkPath = t.string,
	webViewSupported = t.boolean,
	gameSetTypeId = t.optional(t.string),
	durationInSeconds = t.optional(t.number)
})

local function validateEventSchema(p2)
	local v5, v6 = strictInterface(p2)

	if not v5 then
		mutedError(v6)
	end
end

local function useNavigateToSortLinkWebView()
	local v5 = useNavigation()
	local v6 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	local v7 = useRoactService(appEventIngestService)

	return React.useCallback(function(value, p2, p3, p4, callback)
		local v8 = {
			linkPath = value,
			action = "click",
			gameSetTypeId = p4,
			webViewSupported = v6,
			durationInSeconds = nil
		}
		local v9, v10 = strictInterface(v8)

		if not v9 then
			mutedError(v10)
		end

		v7:sendEventDeferred(p2, "navigateToSortLink", v8)

		if not v6 then
			warn("WebView is not supported on this platform")

			return
		end

		local fromString = urlBuilder.fromString
		local v11 = if string.find(value, "/") == 1 then value:gsub("/", "www:", 1) else value
		local v12 = fromString(v11)()
		local lastTime = os.clock()
		local v13 = {
			linkPath = value,
			action = "open",
			gameSetTypeId = p4,
			webViewSupported = v6,
			durationInSeconds = nil
		}
		local v14, v15 = strictInterface(v13)

		if not v14 then
			mutedError(v15)
		end

		v7:sendEventDeferred(p2, "navigateToSortLink", v13)

		default:isURLRegistered(v12):andThen(function(p5)
			if not p5 then
				v5.navigate(appPage.GenericWebPage, {
					detail = v12,
					extraProps = {
						title = p3,
						onClose = function()
							local v17 = {
								linkPath = value,
								action = "close",
								gameSetTypeId = p4,
								webViewSupported = v6,
								durationInSeconds = os.clock() - lastTime
							}
							local v18, v19 = strictInterface(v17)

							if not v18 then
								mutedError(v19)
							end

							v7:sendEventDeferred(p2, "navigateToSortLink", v17)

							if callback then
								callback()
							end
						end
					}
				})

				return
			end

			if not default:isInternalDlicEnabled() then
				default:detectURL(v12)
				return
			end

			default:detectDeeplinkIntent((default:createInternalDlic(v12, deepLinkSource.LuaInternal)))
		end)
	end, { v5, v6 })
end

return useNavigateToSortLinkWebView
