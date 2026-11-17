local AmpV2Wizard = script:FindFirstAncestor("AmpV2Wizard")

require(AmpV2Wizard.Types)
local FFlagAmpV2WizardRetryAmp = require(AmpV2Wizard.Flags.FFlagAmpV2WizardRetryAmp)
local TextScreenNode = require(AmpV2Wizard.Nodes.TextScreenNode)
local OdpHandoffNode = require(AmpV2Wizard.Nodes.OdpHandoffNode)
local CreateOdpSessionNode = require(AmpV2Wizard.Nodes.CreateOdpSessionNode)
local PinEntryNode = require(AmpV2Wizard.Nodes.PinEntryNode)
local UserAgreementNode = require(AmpV2Wizard.Nodes.UserAgreementNode)
local AgreementConsentsNode = require(AmpV2Wizard.Nodes.AgreementConsentsNode)
local VerificationMethodSelectionNode = require(AmpV2Wizard.Nodes.VerificationMethodSelectionNode)
local SessionPollingNode = require(AmpV2Wizard.Nodes.SessionPollingNode)
local RedirectNode = require(AmpV2Wizard.Nodes.RedirectNode)
local RemoteParentRequestNode = require(AmpV2Wizard.Nodes.RemoteParentRequestNode)
local default = {
	TextScreen = { component = TextScreenNode },
	OdpHandoff = { component = OdpHandoffNode, fillsViewport = true },
	CreateOdpSession = { component = CreateOdpSessionNode, ownsLoadingState = true },
	PinEntry = { component = PinEntryNode, fillsViewport = true },
	UserAgreement = { component = UserAgreementNode, fillsViewport = true },
	AgreementConsents = { component = AgreementConsentsNode, fillsViewport = true },
	VerificationMethodSelection = {
		component = VerificationMethodSelectionNode,
		fillsViewport = true
	},
	SessionPolling = { component = SessionPollingNode, ownsLoadingState = true },
	Redirect = { component = RedirectNode, ownsLoadingState = true },
	RemoteParentRequest = { component = RemoteParentRequestNode, ownsLoadingState = true },
	OdpAgeEstimation = {
		component = require(AmpV2Wizard.Nodes.OdpAgeEstimationNode),
		ownsLoadingState = true
	},
	OdpGovernmentId = {
		component = require(AmpV2Wizard.Nodes.OdpGovernmentIdNode),
		ownsLoadingState = true
	}
}

local ComponentRegistry = {}
ComponentRegistry.default = default

function ComponentRegistry.get(p, p2: string)
	local v = p[p2]
	return if v then v.component else nil
end

function ComponentRegistry.ownsLoadingState(p, p2: string): boolean
	local v = p[p2]
	return v ~= nil and v.ownsLoadingState == true
end

function ComponentRegistry.fillsViewport(p, p2: string): boolean
	local v = p[p2]
	return v ~= nil and v.fillsViewport == true
end

function ComponentRegistry.capabilities(p)
	local v = p or default
	local result = {}

	for k in v do
		table.insert(result, k)
	end

	if FFlagAmpV2WizardRetryAmp and ComponentRegistry.get(v, "RemoteParentRequest") == RemoteParentRequestNode then
		table.insert(result, "RemoteParentRequestRetryAmp")
	end

	table.sort(result)
	return result
end

return ComponentRegistry
