local Parent = script:FindFirstAncestor("GameCollections").Parent
local useNavigation = require(Parent.Navigation).useNavigation
local React = require(Parent.React)
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local AppPage = require(Parent.RobloxAppEnums).AppPage
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local useRoactService = require(Parent.RobloxAppHooks).useRoactService
local AppEventIngestService = require(Parent.RoactServiceTags).AppEventIngestService
local t = require(Parent.t)
local mutedError = require(Parent.Loggers).mutedError
local default = require(Parent.LinkingProtocol).LinkingProtocol.default
local v12 = t.strictInterface({
	action = t.string,
	linkPath = t.string,
	webViewSupported = t.boolean,
	gameSetTypeId = t.optional(t.string),
	durationInSeconds = t.optional(t.number)
})

local function validateEventSchema(p1) -- line: 28
	-- upvalues: v12 (copy), mutedError (copy)
	local v16, v17 = v12(p1)

	if not v16 then
		mutedError(v17)
	end
end
local function useNavigateToSortLinkWebView() -- line: 36
	-- upvalues: useNavigation (copy), useAppPolicy (copy), useRoactService (copy), AppEventIngestService (copy), React (copy), v12 (copy), mutedError (copy), UrlBuilder (copy), default (copy), AppPage (copy)
	local v18 = useNavigation()
	local v19 = useAppPolicy(function(p2) -- line: 38
		return p2.getWebViewSupport()
	end)
	local v20 = useRoactService(AppEventIngestService)

	return React.useCallback(function(s1: string, s2: string, s3: string, s4: string?, p3: ((...any) -> ...any)?) -- line: 44
		-- upvalues: v19 (copy), v12 (copy), mutedError (copy), v20 (copy), UrlBuilder (copy), default (copy), v18 (copy), AppPage (copy)
		local t1 = {
			action = "click",
			durationInSeconds = nil,
			linkPath = s1,
			gameSetTypeId = s4,
			webViewSupported = v19
		}
		local v28, v29 = v12(t1)

		if not v28 then
			mutedError(v29)
		end

		v20:sendEventDeferred(s2, "navigateToSortLink", t1)

		if v19 then
			local v30 = UrlBuilder.fromString((if string.find(s1, "/") ~= 1 then s1 else s1:gsub("/", "www:", 1)))()
			local elapsed = os.clock()
			local t2 = {
				action = "open",
				durationInSeconds = nil,
				linkPath = s1,
				gameSetTypeId = s4,
				webViewSupported = v19
			}
			local v33, v34 = v12(t2)

			if not v33 then
				mutedError(v34)
			end

			v20:sendEventDeferred(s2, "navigateToSortLink", t2)
			default:isURLRegistered(v30):andThen(function(p4) -- line: 69
				-- upvalues: default (copy), v30 (copy), v18 (copy), AppPage (copy), s3 (copy), elapsed (copy), s1 (copy), s4 (copy), v19 (copy), v12 (copy), mutedError (copy), v20 (copy), s2 (copy), p3 (copy)
				if p4 then
					default:detectURL(v30)

					return
				end

				v18.navigate(AppPage.GenericWebPage, {
					detail = v30,
					extraProps = {
						title = s3,
						onClose = function() -- line: 77
							-- upvalues: elapsed (copy), s1 (copy), s4 (copy), v19 (copy), v12 (copy), mutedError (copy), v20 (copy), s2 (copy), p3 (copy)
							local v41 = os.clock() - elapsed
							local t3 = {
								action = "close",
								linkPath = s1,
								gameSetTypeId = s4,
								webViewSupported = v19,
								durationInSeconds = v41
							}
							local v43, v44 = v12(t3)

							if not v43 then
								mutedError(v44)
							end

							v20:sendEventDeferred(s2, "navigateToSortLink", t3)

							if p3 then
								p3()
							end
						end
					}
				})
			end)

			return
		end

		warn("WebView is not supported on this platform")
	end, {
		v18,
		v19
	})
end

return useNavigateToSortLinkWebView
