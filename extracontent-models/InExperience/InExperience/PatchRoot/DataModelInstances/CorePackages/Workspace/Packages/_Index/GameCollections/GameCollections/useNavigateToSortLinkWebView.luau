local parent = script:FindFirstAncestor("GameCollections").Parent

local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local React = require(parent.React)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local t = require(parent.t)
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError
local LinkingProtocol = require(parent.LinkingProtocol)
local DeepLinkSource = LinkingProtocol.Enums.DeepLinkSource
local default = LinkingProtocol.LinkingProtocol.default

local strictInterface = t.strictInterface({
	action = t.string,
	linkPath = t.string,
	webViewSupported = t.boolean,
	gameSetTypeId = t.optional(t.string),
	durationInSeconds = t.optional(t.number)
})

local function validateEventSchema(p) -- 1 equivalent call inferred from this helper
	local v, v2 = strictInterface(p)

	if not v then
		mutedError(v2)
	end
end

local function useNavigateToSortLinkWebView()
	local v = useNavigation()
	local webViewSupported = useAppPolicy(function(p)
		return p.getWebViewSupport()
	end)

	local v2 = useRoactService(AppEventIngestService)

	return React.useCallback(function(linkPath: string, p: string, title: string, gameSetTypeId: string?, callback)
		local function fn(action: string, durationInSeconds: number?) -- 3 equivalent calls inferred from this helper
			local v3 = {
				linkPath = linkPath,
				action = action,
				gameSetTypeId = gameSetTypeId,
				webViewSupported = webViewSupported,
				durationInSeconds = durationInSeconds
			}
			validateEventSchema(v3) -- inferred equivalent call
			v2:sendEventDeferred(p, "navigateToSortLink", v3)
		end

		fn("click") -- inferred equivalent call

		if not webViewSupported then
			warn("WebView is not supported on this platform")

			return
		end

		local fromString = urlBuilder.fromString
		local v3

		if string.find(linkPath, "/") == 1 then
			v3 = linkPath:gsub("/", "www:", 1)
		else
			v3 = linkPath
		end

		local detail = fromString(v3)()
		local lastTime = os.clock()
		fn("open") -- inferred equivalent call
		default:isURLRegistered(detail):andThen(function(p2)
			if not p2 then
				v.navigate(AppPage.GenericWebPage, {
					detail = detail,
					extraProps = {
						title = title,
						onClose = function()
							fn("close", os.clock() - lastTime) -- inferred equivalent call

							if callback then
								callback()
							end
						end
					}
				})
			elseif default:isInternalDlicEnabled() then
				default:detectDeeplinkIntent((default:createInternalDlic(detail, DeepLinkSource.LuaInternal)))
			else
				default:detectURL(detail)
			end
		end)
	end, { v, webViewSupported })
end

return useNavigateToSortLinkWebView
