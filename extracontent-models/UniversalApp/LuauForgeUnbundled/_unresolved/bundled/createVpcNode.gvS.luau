require("@luauforge/bundled/gvb")
local appPage = require("@luauforge/bundled/gvP").AppPage

require("@luauforge/bundled/gvc")
local module = require("@luauforge/bundled/gvT")
local module2 = require("@luauforge/bundled/gvl")
local module3 = require("@luauforge/bundled/gvo")
local fFlagLuaAppOdpRequestSentToast = require("@luauforge/bundled/gvp").FFlagLuaAppOdpRequestSentToast

local fFlagLuaAppAmpWizardSendAnalyticsSessionId = require("@luauforge/bundled/gvp").FFlagLuaAppAmpWizardSendAnalyticsSessionId

local function createVpcNode(p2)
	return module(function(p3, data, data2, callback)
		local odpAnalytics = module2.createOdpAnalytics(data2.analyticsStrings)

		local function popThenReport(p4)
			p3.navigation.pop()
			callback(p4)
		end
		local push = p3.navigation.push
		local vpcUpsellContainer = appPage.VPCUpsellContainer
		local v6 = {
			recourseAction = p2,
			parentConsentTypes = data.requestType and { data.requestType } or nil,
			recourseData = data.requestDetails,
			isInExperienceEntry = data.isInExperienceEntry,
			entryPointEventCtx = data2.analytics.flowId,
			analyticsSessionId = 0,
			vpcEntryAnalytics = 0,
			onRequestSent = 0,
			onSuccess = 0,
			onCancel = 0,
			onRetryAmp = 0
		}
		local v7 = if fFlagLuaAppAmpWizardSendAnalyticsSessionId then data2.analyticsSessionId else nil
		v6.analyticsSessionId = v7

		local v8 = if fFlagLuaAppAmpWizardSendAnalyticsSessionId then module3.createVpcEntryAnalytics(
			data2.analyticsStrings,
			data2.analyticsSessionId,
			data2.analytics.surface,
			data.requestType
		) else nil
		v6.vpcEntryAnalytics = v8

		v6.onRequestSent = fFlagLuaAppOdpRequestSentToast and function(p4)
			odpAnalytics.remoteRequestSent(
				data2.odpEventContext,
				data2.analyticsSessionId,
				data2.launchProps
			)
		end or nil

		function v6.onSuccess()
			p3.navigation.pop()
			callback("Success")
		end
		function v6.onCancel()
			p3.navigation.pop()
			callback("Cancel")
		end
		function v6.onRetryAmp()
			p3.navigation.pop()
			callback("RetryAmp")
		end

		push(vpcUpsellContainer, { extraProps = v6 })
	end)
end

return createVpcNode
