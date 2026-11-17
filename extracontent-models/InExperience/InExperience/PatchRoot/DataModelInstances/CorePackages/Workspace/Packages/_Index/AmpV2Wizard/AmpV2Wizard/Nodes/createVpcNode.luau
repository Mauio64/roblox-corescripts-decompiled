local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")
local parent = AmpV2Wizard.Parent

require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

require(AmpV2Wizard.Types)
local createUpsellNode = require(AmpV2Wizard.Nodes.createUpsellNode)
local OdpAnalytics = require(AmpV2Wizard.OdpAnalytics)
local VpcEntryAnalytics = require(AmpV2Wizard.VpcEntryAnalytics)
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppOdpRequestSentToast = SharedFlags.FFlagLuaAppOdpRequestSentToast

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppAmpWizardSendAnalyticsSessionId = SharedFlags2.FFlagLuaAppAmpWizardSendAnalyticsSessionId

local function createVpcNode(recourseAction: string)
	return createUpsellNode(function(p, data, data2, callback)
		local odpAnalytics = OdpAnalytics.createOdpAnalytics(data2.analyticsStrings)

		local function popThenReport(p2: string) -- 3 equivalent calls inferred from this helper
			p.navigation.pop()
			callback(p2)
		end
		local push = p.navigation.push
		local vpcUpsellContainer = AppPage.VPCUpsellContainer
		local extraProps = {
			recourseAction = recourseAction,
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
		local analyticsSessionId

		if FFlagLuaAppAmpWizardSendAnalyticsSessionId then
			analyticsSessionId = data2.analyticsSessionId
		end

		extraProps.analyticsSessionId = analyticsSessionId
		local vpcEntryAnalytics

		if FFlagLuaAppAmpWizardSendAnalyticsSessionId then
			vpcEntryAnalytics = VpcEntryAnalytics.createVpcEntryAnalytics(
				data2.analyticsStrings,
				data2.analyticsSessionId,
				data2.analytics.surface,
				data.requestType
			)
		end

		extraProps.vpcEntryAnalytics = vpcEntryAnalytics

		extraProps.onRequestSent = FFlagLuaAppOdpRequestSentToast and function(_: string?)
			odpAnalytics.remoteRequestSent(data2.odpEventContext, data2.analyticsSessionId, data2.launchProps)
		end or nil

		function extraProps.onSuccess()
			popThenReport("Success") -- inferred equivalent call
		end
		function extraProps.onCancel()
			popThenReport("Cancel") -- inferred equivalent call
		end
		function extraProps.onRetryAmp()
			popThenReport("RetryAmp") -- inferred equivalent call
		end

		push(vpcUpsellContainer, { extraProps = extraProps })
	end)
end

return createVpcNode
