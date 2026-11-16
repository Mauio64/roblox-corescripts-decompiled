local parent = script:FindFirstAncestor("DataHydration").Parent

require(script.Parent.types)
local monetizationClientTool = require(script.Parent.monetizationClientTool)
local FFlagCreatorAgentChatMonetizationOneConsent = require(script.Parent.FFlagCreatorAgentChatMonetizationOneConsent)

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceRemoveDevProductPriceCap = SharedFlags.FFlagBuildExperienceRemoveDevProductPriceCap
local StudioManageDevProductTool = require(script.Parent.StudioManageDevProductTool)
local StudioManageGamePassTool = require(script.Parent.StudioManageGamePassTool)
local StudioManageSubscriptionTool = require(script.Parent.StudioManageSubscriptionTool)

local TOOL_NAME = StudioManageDevProductTool.TOOL_NAME
local MAXIMUM_SAFE_INTEGER = monetizationClientTool.MAXIMUM_SAFE_INTEGER

local description = "Per-kind ranges are checked on the client: developerProduct " .. (FFlagBuildExperienceRemoveDevProductPriceCap and "at least 1" or "1 through 100") .. ", gamePass 1 through 999,999,999, subscription at least 49."

local v = {
	developerproduct = "developerProduct",
	gamepass = "gamePass",
	subscription = "subscription"
}

local v2 = {
	developerProduct = "productId",
	gamePass = "gamePassId",
	subscription = "subscriptionId"
}

local v3 = {
	developerProduct = {
		"gamePassId",
		"subscriptionId",
		"productType",
		"cancelRenewals",
		"createAndGoLive"
	},
	gamePass = { "productId", "subscriptionId", "productType", "cancelRenewals" },
	subscription = { "productId", "gamePassId" }
}

local function resolveKind(p) -- 2 equivalent calls inferred from this helper
	if typeof(p) == "table" and typeof(p.kind) == "string" then
		return v[string.lower(p.kind)]
	end

	return nil
end

local function describeKindError(p)
	if typeof(p) == "table" and p.kind ~= nil then
		return ("Unsupported kind '%s'. Use developerProduct, gamePass or subscription."):format((tostring(p.kind)))
	end

	return "kind is required: developerProduct, gamePass or subscription."
end

local function findCrossKindError(p, kind: string)
	for _, v4 in v3[kind] do
		if p[v4] ~= nil then
			local v5 = v2[kind]

			if string.sub(v4, -2) == "Id" then
				return (("%s does not apply to kind=%s. Use %s."):format(v4, kind, v5))
			end

			return (("%s does not apply to kind=%s."):format(v4, kind))
		end
	end

	if kind == "subscription" or typeof(p.action) ~= "string" or string.lower(p.action) ~= "delete" then
		return nil
	end

	return "delete is only supported for kind=subscription."
end

local function parseDeveloperProduct(p)
	return StudioManageDevProductTool.parseManageDevProductInput(p), nil
end

local v4 = {
	developerProduct = parseDeveloperProduct,
	gamePass = function(p)
		return StudioManageGamePassTool.parseInput(p, true)
	end,
	subscription = StudioManageSubscriptionTool.parseInput
}

local function withLegacyKind(p)
	if typeof(p) ~= "table" then
		return p
	end

	local clone = table.clone(p)
	clone.kind = "developerProduct"
	return clone
end

local StudioManageMonetizationTool = {}
StudioManageMonetizationTool.TOOL_NAME = "manage_monetization"
StudioManageMonetizationTool.KINDS = { "developerProduct", "gamePass", "subscription" }
StudioManageMonetizationTool.resolveKind = resolveKind

function StudioManageMonetizationTool.createLocalToolDefinition(enum)
	local set = {}

	for _, item in enum do
		set[item] = true
	end

	local v5 = set.gamePass == true or set.subscription == true
	local enum2 = { "create", "list", "update", "activate", "deactivate" }

	if set.subscription then
		table.insert(enum2, "delete")
	end

	return {
		name = "manage_monetization",
		inputSchema = {
			type = "object",
			additionalProperties = false,
			required = { "kind", "action" },
			properties = {
				kind = { type = "string", enum = enum },
				action = { type = "string", enum = enum2 },
				name = { type = "string" },
				description = { type = "string" },
				priceInRobux = {
					type = "integer",
					minimum = 1,
					maximum = MAXIMUM_SAFE_INTEGER,
					description = description
				},
				productId = set.developerProduct and { type = "integer" } or nil,
				gamePassId = set.gamePass and {
					type = "integer",
					minimum = 1,
					maximum = MAXIMUM_SAFE_INTEGER
				} or nil,
				subscriptionId = set.subscription and { type = "string" } or nil,
				productType = set.subscription and {
					type = "string",
					enum = { "consumable", "currency", "durable" }
				} or nil,
				cancelRenewals = set.subscription and { type = "boolean" } or nil,
				imageAssetId = { type = "integer", minimum = 1, maximum = MAXIMUM_SAFE_INTEGER },
				createAndGoLive = FFlagCreatorAgentChatMonetizationOneConsent and v5 and {
					type = "boolean",
					description = "Only for create of a gamePass or subscription when the creator explicitly requests creation and going live in one approval. Creation stays off sale or inactive until a supported benefit is published and verified; custom or uncertain wiring stays off without another approval."
				} or nil
			}
		}
	}
end

function StudioManageMonetizationTool.forKind(kind: string, p)
	local function isKindEnabled(kind2: string): boolean -- 1 equivalent call inferred from this helper
		return kind2 == "developerProduct" or p == nil or p[kind2] == true
	end

	local function ownsRequest(p2): boolean -- 1 equivalent call inferred from this helper
		local kind2 = resolveKind(p2) -- inferred equivalent call

		if kind2 == nil then
			return kind == "developerProduct"
		end

		return kind2 == kind or kind == "developerProduct" and not isKindEnabled(kind2) -- inferred equivalent call
	end

	local function findRequestInTurnState(p2, p3)
		local v5

		if p3 == nil then
			v5 = {}
		else
			v5 = table.clone(p3)
		end

		while true do
			local requestInTurnState, v6, v7, v8 = monetizationClientTool.findRequestInTurnState(
				p2,
				"manage_monetization",
				v5
			)

			if requestInTurnState == nil then
				break
			end

			if ownsRequest(v6) then -- inferred equivalent call
				return requestInTurnState, v6, v7, v8
			end

			v5[requestInTurnState] = true
		end

		if kind ~= "developerProduct" then
			return nil, nil, nil, nil
		end

		local requestInTurnState, v6, v7, v8 = monetizationClientTool.findRequestInTurnState(p2, TOOL_NAME, v5)

		if requestInTurnState == nil then
			return nil, nil, nil, nil
		end

		if typeof(v6) == "table" then
			v6 = table.clone(v6)
			v6.kind = "developerProduct"
		end

		return requestInTurnState, v6, v7, v8
	end

	local function parseInput(p2)
		local kind2 = resolveKind(p2) -- inferred equivalent call

		if kind2 == nil then
			return nil, describeKindError(p2)
		end

		if kind2 ~= kind then
			return nil, ("kind=%s is not available in this session."):format(kind2), "kind_unavailable"
		end

		local crossKindError = findCrossKindError(p2, kind)

		if crossKindError ~= nil then
			return nil, crossKindError
		end

		local clone = table.clone(p2)
		clone.kind = nil
		return v4[kind](clone)
	end

	return {
		TOOL_NAME = "manage_monetization",
		KIND = kind,
		findRequestInTurnState = findRequestInTurnState,
		parseInput = parseInput,
		getActionKind = monetizationClientTool.getActionKind,
		formatResultContent = function(p2)
			if typeof(p2) == "table" and p2.kind == nil then
				p2 = table.clone(p2)
				p2.kind = kind
			end

			return monetizationClientTool.formatResultContent(p2)
		end,
		formatRejectionContent = function(p2: string, p3: string?)
			return monetizationClientTool.formatRejectionContent(p2, p3, kind)
		end,
		findManageDevProductRequestInTurnState = findRequestInTurnState,
		parseManageDevProductInput = parseInput,
		resolveRequestKind = resolveKind
	}
end

return StudioManageMonetizationTool
