require(script.Parent.types)
local monetizationClientTool = require(script.Parent.monetizationClientTool)
local FFlagCreatorAgentChatMonetizationOneConsent = require(script.Parent.FFlagCreatorAgentChatMonetizationOneConsent)

local enum = { "create", "list", "update", "activate", "deactivate", "delete" }

local MAXIMUM_SAFE_INTEGER = monetizationClientTool.MAXIMUM_SAFE_INTEGER
local enum2 = { "consumable", "currency", "durable" }

local function hasRequiredCreateFields(data): boolean -- 1 equivalent call inferred from this helper
	return data.name ~= nil and data.name ~= "" and data.productType ~= nil and data.priceInRobux ~= nil
end

return {
	TOOL_NAME = "manage_subscription",
	LOCAL_TOOL_DEFINITION = {
		name = "manage_subscription",
		inputSchema = {
			type = "object",
			additionalProperties = false,
			required = { "action" },
			properties = {
				action = { type = "string", enum = enum },
				name = { type = "string" },
				description = { type = "string" },
				productType = { type = "string", enum = enum2 },
				priceInRobux = { type = "integer", minimum = 49, maximum = MAXIMUM_SAFE_INTEGER },
				subscriptionId = { type = "string" },
				cancelRenewals = { type = "boolean" },
				imageAssetId = { type = "integer", minimum = 1, maximum = MAXIMUM_SAFE_INTEGER },
				createAndGoLive = FFlagCreatorAgentChatMonetizationOneConsent and {
					type = "boolean",
					description = "Only for create when the creator explicitly requests creation and activation in one approval. Creation stays inactive until a supported benefit is published and verified; custom or uncertain wiring stays inactive without another approval."
				} or nil
			}
		}
	},
	findRequestInTurnState = monetizationClientTool.createRequestFinder("manage_subscription"),
	parseInput = function(data)
		local action, v = monetizationClientTool.parseAction(data, enum)

		if action == nil then
			return nil, v
		end

		local v2 = monetizationClientTool.checkStringFields(data, {
			"name",
			"description",
			"productType",
			"subscriptionId"
		})

		if v2 ~= nil then
			return nil, v2
		end

		if data.cancelRenewals ~= nil and typeof(data.cancelRenewals) ~= "boolean" then
			return nil, "cancelRenewals must be a boolean."
		end

		local price, v3 = monetizationClientTool.parsePrice(data.priceInRobux, 49, MAXIMUM_SAFE_INTEGER)

		if v3 ~= nil then
			return nil, v3
		end

		local productType

		if data.productType ~= nil then
			productType = string.lower(data.productType)
		end

		if productType ~= nil and not table.find(enum2, productType) then
			return nil, "productType must be consumable, currency or durable."
		end

		local v4 = {
			action = action,
			name = data.name,
			description = data.description,
			productType = productType,
			priceInRobux = price,
			subscriptionId = 0,
			cancelRenewals = 0,
			imageAssetId = 0
		}
		local subscriptionId

		if data.subscriptionId ~= "" then
			subscriptionId = data.subscriptionId
		end

		v4.subscriptionId = subscriptionId
		v4.cancelRenewals = data.cancelRenewals
		v4.imageAssetId = monetizationClientTool.parsePositiveSafeInteger(data.imageAssetId)

		if data.imageAssetId ~= nil and v4.imageAssetId == nil then
			return nil, ("imageAssetId must be a positive integer no greater than %.0f."):format(MAXIMUM_SAFE_INTEGER)
		end

		if data.createAndGoLive ~= nil and not FFlagCreatorAgentChatMonetizationOneConsent then
			return nil, "createAndGoLive is unavailable."
		end

		local createAndGoLive, v5 = monetizationClientTool.parseCreateAndGoLive(data.createAndGoLive, action)

		if v5 ~= nil then
			return nil, v5
		end

		v4.createAndGoLive = createAndGoLive

		if (action == "create" or action == "list") and data.subscriptionId ~= nil then
			return nil, "subscriptionId is only used to update, activate, deactivate or delete a subscription."
		end

		if
			action ~= "create"
			and action ~= "update"
			and (data.description ~= nil or data.priceInRobux ~= nil or data.imageAssetId ~= nil)
		then
			return nil, "Only create and update can set a subscription description, priceInRobux or imageAssetId."
		end

		if action ~= "create" and action ~= "update" and (data.name ~= nil or data.productType ~= nil) then
			return nil, "A subscription name and productType are only used on create."
		end

		if action ~= "deactivate" and data.cancelRenewals ~= nil then
			return nil, "cancelRenewals is only used on deactivate."
		end

		if action == "create" then
			if not hasRequiredCreateFields(v4) then -- inferred equivalent call
				return nil, "A name, productType and priceInRobux are required to create a subscription."
			end
		else
			if action ~= "list" and v4.subscriptionId == nil then
				return nil, "A subscriptionId is required for this action."
			end

			if action == "update" then
				if v4.name ~= nil then
					return nil, "A subscription's name can't be changed after it is created."
				end

				if v4.productType ~= nil then
					return nil, "A subscription's product type can't be changed after it is created."
				end

				if v4.description == nil and v4.priceInRobux == nil and v4.imageAssetId == nil then
					return nil, "An update needs a description, priceInRobux or imageAssetId."
				end
			elseif action == "deactivate" and v4.cancelRenewals == nil then
				return nil, "cancelRenewals is required: ask the creator whether current subscribers keep renewing."
			end
		end

		return v4, nil
	end,
	getActionKind = monetizationClientTool.getActionKind,
	formatResultContent = monetizationClientTool.formatResultContent,
	formatRejectionContent = monetizationClientTool.formatRejectionContent
}
