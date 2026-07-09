local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder
local AppPage = require(Parent.RobloxAppEnums).AppPage
local getAppFeaturePolicies = require(Parent.UniversalAppPolicy).getAppFeaturePolicies
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiCounterName = SduiCoreSystem.SduiErrors.SduiCounterName
local FFlagSduiExperienceDetailsSupport = require(Parent.SharedFlags).FFlagSduiExperienceDetailsSupport

local function isWebViewSupported() -- line: 17
	-- upvalues: getAppFeaturePolicies (copy)
	return getAppFeaturePolicies().getWebViewSupport()
end
local function openSduiWebLink(p1, s1: string, s2: string?, p2: ((...any) -> ...any)?) -- line: 24
	-- upvalues: UrlBuilder (copy), SduiErrorType (copy), getAppFeaturePolicies (copy), FFlagSduiExperienceDetailsSupport (copy), AppPage (copy), SduiCounterName (copy)
	local ok, result = pcall(function() -- line: 27
		-- upvalues: UrlBuilder (copy), s1 (copy)
		return UrlBuilder.fromString((if string.find(s1, "/") ~= 1 then s1 else s1:gsub("/", "www:", 1)))()
	end)
	local u17

	if ok then
		u17 = result
	else
		u17 = s1
		p1.dependencies.logger.reportError(SduiErrorType.FailedtoParseUrl, {
			name = s1,
			message = typeof(result) ~= "string" and "Unknown reason" or result
		}, p1.appPage)
	end

	local linkingProtocol = p1.dependencies.linkingProtocol
	local ok2, result2 = pcall(function() -- line: 42
		-- upvalues: linkingProtocol (copy), u17 (ref), getAppFeaturePolicies (copy), p1 (copy), FFlagSduiExperienceDetailsSupport (copy), s2 (copy), p2 (copy), AppPage (copy), SduiCounterName (copy)
		linkingProtocol:isURLRegistered(u17):andThen(function(p3) -- line: 43
			-- upvalues: linkingProtocol (copy), u17 (ref), getAppFeaturePolicies (copy), p1 (copy), FFlagSduiExperienceDetailsSupport (copy), s2 (copy), p2 (copy), AppPage (copy), SduiCounterName (copy)
			if p3 then
				linkingProtocol:detectURL(u17)

				return
			end

			if getAppFeaturePolicies().getWebViewSupport() then
				local v22 = p1.dependencies.getNavigation()
				local v23 = if not FFlagSduiExperienceDetailsSupport then nil else {
					titleKey = s2
				}

				if FFlagSduiExperienceDetailsSupport and v23 and p2 then
					function v23.onClose() -- line: 52
						-- upvalues: p2 (copy)
						p2()
					end
				end

				v22.navigate(AppPage.GenericWebPage, {
					detail = u17,
					extraProps = if not FFlagSduiExperienceDetailsSupport then nil else v23
				})

				return
			end

			p1.dependencies.logger.reportCounter(SduiCounterName.WebViewNotSupportedForLink, {
				name = u17
			})
		end)
	end)

	if not ok2 then
		p1.dependencies.logger.reportError(SduiErrorType.FailedToOpenLink, {
			name = s1,
			message = typeof(result2) ~= "string" and "Unknown reason" or result2
		}, p1.appPage)
	end
end

return openSduiWebLink
