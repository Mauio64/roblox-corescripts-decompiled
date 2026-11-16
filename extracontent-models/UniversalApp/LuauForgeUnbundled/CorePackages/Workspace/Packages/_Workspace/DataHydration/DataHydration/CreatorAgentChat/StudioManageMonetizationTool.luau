require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local monetizationClientTool = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/monetizationClientTool")
local FFlagCreatorAgentChatMonetizationOneConsent = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/FFlagCreatorAgentChatMonetizationOneConsent")

local fFlagBuildExperienceRemoveDevProductPriceCap = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceRemoveDevProductPriceCap
local StudioManageDevProductTool = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioManageDevProductTool")
local StudioManageGamePassTool = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioManageGamePassTool")
local StudioManageSubscriptionTool = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/StudioManageSubscriptionTool")

local TOOL_NAME = StudioManageDevProductTool.TOOL_NAME
local MAXIMUM_SAFE_INTEGER = monetizationClientTool.MAXIMUM_SAFE_INTEGER

local v5 = "Per-kind ranges are checked on the client: developerProduct " .. (fFlagBuildExperienceRemoveDevProductPriceCap and "at least 1" or "1 through 100") .. ", gamePass 1 through 999,999,999, subscription at least 49."

local v6 = {
	developerproduct = "developerProduct",
	gamepass = "gamePass",
	subscription = "subscription"
}

local v7 = {
	developerProduct = "productId",
	gamePass = "gamePassId",
	subscription = "subscriptionId"
}

local v8 = {
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

local function resolveKind(p2)
	if typeof(p2) == "table" and typeof(p2.kind) == "string" then
		return v6[string.lower(p2.kind)]
	end

	return nil
end

local function describeKindError(p2)
	if typeof(p2) == "table" and p2.kind ~= nil then
		return ("Unsupported kind '%s'. Use developerProduct, gamePass or subscription."):format((tostring(p2.kind)))
	end

	return "kind is required: developerProduct, gamePass or subscription."
end

local function findCrossKindError(p2, kind)
	for k, v9 in v8[kind] do
		if p2[v9] ~= nil then
			local v10 = v7[kind]

			if string.sub(v9, -2) == "Id" then
				return (("%s does not apply to kind=%s. Use %s."):format(v9, kind, v10))
			end

			return (("%s does not apply to kind=%s."):format(v9, kind))
		end
	end

	if kind == "subscription" or typeof(p2.action) ~= "string" or string.lower(p2.action) ~= "delete" then
		return nil
	end

	return "delete is only supported for kind=subscription."
end

local function parseDeveloperProduct(p2)
	return StudioManageDevProductTool.parseManageDevProductInput(p2), nil
end

local v9 = {
	developerProduct = parseDeveloperProduct,
	gamePass = function(p2)
		return StudioManageGamePassTool.parseInput(p2, true)
	end,
	subscription = StudioManageSubscriptionTool.parseInput
}

local function withLegacyKind(p2)
	if typeof(p2) ~= "table" then
		return p2
	end

	local clone = table.clone(p2)
	clone.kind = "developerProduct"
	return clone
end

return {
	TOOL_NAME = "manage_monetization",
	KINDS = { "developerProduct", "gamePass", "subscription" },
	resolveKind = resolveKind,
	createLocalToolDefinition = function(items)
		local set = {}

		for k, item in items do
			set[item] = true
		end

		local v10 = set.gamePass == true or set.subscription == true
		local v11 = { "create", "list", "update", "activate", "deactivate" }

		if set.subscription then
			table.insert(v11, "delete")
		end

		return {
			name = "manage_monetization",
			inputSchema = {
				type = "object",
				additionalProperties = false,
				required = { "kind", "action" },
				properties = {
					kind = { type = "string", enum = items },
					action = { type = "string", enum = v11 },
					name = { type = "string" },
					description = { type = "string" },
					priceInRobux = {
						type = "integer",
						minimum = 1,
						maximum = MAXIMUM_SAFE_INTEGER,
						description = v5
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
					imageAssetId = {
						type = "integer",
						minimum = 1,
						maximum = MAXIMUM_SAFE_INTEGER
					},
					createAndGoLive = FFlagCreatorAgentChatMonetizationOneConsent and v10 and {
						type = "boolean",
						description = "Only for create of a gamePass or subscription when the creator explicitly requests creation and going live in one approval. Creation stays off sale or inactive until a supported benefit is published and verified; custom or uncertain wiring stays off without another approval."
					} or nil
				}
			}
		}
	end,
	forKind = function(kind, p2)
		local function isKindEnabled(p3): boolean
			return p3 == "developerProduct" or p2 == nil or p2[p3] == true
		end

		local function ownsRequest(p3)
			local v10

			if typeof(p3) == "table" and typeof(p3.kind) == "string" then
				v10 = v6[string.lower(p3.kind)]
			end

			if v10 == nil then
				return kind == "developerProduct"
			end

			if v10 == kind then
				return true
			end

			local v11

			if kind == "developerProduct" then
				v11 = v10 ~= "developerProduct" and p2 ~= nil and p2[v10] ~= true
			else
				v11 = false
			end

			return v11
		end

		local function findRequestInTurnState(p3, p4)
			local v10 = if p4 == nil then {} else table.clone(p4)

			while true do
				local requestInTurnState, v11, v12, v13 = monetizationClientTool.findRequestInTurnState(
					p3,
					"manage_monetization",
					v10
				)

				if requestInTurnState == nil then
					break
				end

				local v14

				if typeof(v11) == "table" and typeof(v11.kind) == "string" then
					v14 = v6[string.lower(v11.kind)]
				end

				local v15

				if v14 == nil then
					v15 = kind == "developerProduct"
				elseif v14 == kind then
					v15 = true
				elseif kind == "developerProduct" then
					v15 = v14 ~= "developerProduct" and p2 ~= nil and p2[v14] ~= true
				else
					v15 = false
				end

				if v15 then
					return requestInTurnState, v11, v12, v13
				end

				v10[requestInTurnState] = true
			end

			if kind ~= "developerProduct" then
				return nil, nil, nil, nil
			end

			local requestInTurnState, v11, v12, v13 = monetizationClientTool.findRequestInTurnState(p3, TOOL_NAME, v10)

			if requestInTurnState == nil then
				return nil, nil, nil, nil
			end

			if typeof(v11) == "table" then
				v11 = table.clone(v11)
				v11.kind = "developerProduct"
			end

			return requestInTurnState, v11, v12, v13
		end

		local function parseInput(p3)
			local v10

			if typeof(p3) == "table" and typeof(p3.kind) == "string" then
				v10 = v6[string.lower(p3.kind)]
			end

			if v10 == nil then
				return nil, describeKindError(p3)
			end

			if v10 ~= kind then
				return nil, ("kind=%s is not available in this session."):format(v10), "kind_unavailable"
			end

			local crossKindError = findCrossKindError(p3, kind)

			if crossKindError ~= nil then
				return nil, crossKindError
			end

			local clone = table.clone(p3)
			clone.kind = nil
			return v9[kind](clone)
		end

		return {
			TOOL_NAME = "manage_monetization",
			KIND = kind,
			findRequestInTurnState = findRequestInTurnState,
			parseInput = parseInput,
			getActionKind = monetizationClientTool.getActionKind,
			formatResultContent = function(p3)
				if typeof(p3) == "table" and p3.kind == nil then
					p3 = table.clone(p3)
					p3.kind = kind
				end

				return monetizationClientTool.formatResultContent(p3)
			end,
			formatRejectionContent = function(p3, p4)
				return monetizationClientTool.formatRejectionContent(p3, p4, kind)
			end,
			findManageDevProductRequestInTurnState = findRequestInTurnState,
			parseManageDevProductInput = parseInput,
			resolveRequestKind = resolveKind
		}
	end
}
