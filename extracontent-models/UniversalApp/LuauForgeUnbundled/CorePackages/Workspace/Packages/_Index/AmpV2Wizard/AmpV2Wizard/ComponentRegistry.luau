require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Types")
local FFlagAmpV2WizardRetryAmp = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Flags/FFlagAmpV2WizardRetryAmp")
local TextScreenNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/TextScreenNode")
local OdpHandoffNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/OdpHandoffNode")
local CreateOdpSessionNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/CreateOdpSessionNode")
local PinEntryNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/PinEntryNode")
local UserAgreementNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/UserAgreementNode")
local AgreementConsentsNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/AgreementConsentsNode")
local VerificationMethodSelectionNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/VerificationMethodSelectionNode")
local SessionPollingNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/SessionPollingNode")
local RedirectNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/RedirectNode")
local RemoteParentRequestNode = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/RemoteParentRequestNode")
local v5 = {
	TextScreen = { component = TextScreenNode },
	OdpHandoff = { component = OdpHandoffNode, fillsViewport = true },
	CreateOdpSession = { component = CreateOdpSessionNode, ownsLoadingState = true },
	PinEntry = { component = PinEntryNode, fillsViewport = true },
	UserAgreement = { component = UserAgreementNode, fillsViewport = true },
	AgreementConsents = { component = AgreementConsentsNode, fillsViewport = true },
	VerificationMethodSelection = { component = VerificationMethodSelectionNode, fillsViewport = true },
	SessionPolling = { component = SessionPollingNode, ownsLoadingState = true },
	Redirect = { component = RedirectNode, ownsLoadingState = true },
	RemoteParentRequest = { component = RemoteParentRequestNode, ownsLoadingState = true },
	OdpAgeEstimation = { component = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/OdpAgeEstimationNode"), ownsLoadingState = true },
	OdpGovernmentId = { component = require("@game/CorePackages/Workspace/Packages/_Index/AmpV2Wizard/AmpV2Wizard/Nodes/OdpGovernmentIdNode"), ownsLoadingState = true }
}

local v6 = {}
v6.default = v5

function v6.get(p2, p3)
	local v7 = p2[p3]

	if v7 then
		return v7.component
	end

	return nil
end

function v6.ownsLoadingState(p2, p3): boolean
	local v7 = p2[p3]
	return v7 ~= nil and v7.ownsLoadingState == true
end

function v6.fillsViewport(p2, p3): boolean
	local v7 = p2[p3]
	return v7 ~= nil and v7.fillsViewport == true
end

function v6.capabilities(p2)
	local v7 = p2 or v5
	local result = {}

	for k in v7 do
		table.insert(result, k)
	end

	if FFlagAmpV2WizardRetryAmp and v6.get(v7, "RemoteParentRequest") == RemoteParentRequestNode then
		table.insert(result, "RemoteParentRequestRetryAmp")
	end

	table.sort(result)
	return result
end

return v6
