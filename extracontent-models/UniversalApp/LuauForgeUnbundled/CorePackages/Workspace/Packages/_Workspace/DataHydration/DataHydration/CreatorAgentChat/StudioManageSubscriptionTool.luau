require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local monetizationClientTool = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/monetizationClientTool")
local FFlagCreatorAgentChatMonetizationOneConsent = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/FFlagCreatorAgentChatMonetizationOneConsent")

local v5 = { "create", "list", "update", "activate", "deactivate", "delete" }

local MAXIMUM_SAFE_INTEGER = monetizationClientTool.MAXIMUM_SAFE_INTEGER
local v6 = { "consumable", "currency", "durable" }

local function hasRequiredCreateFields(data): boolean
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
				action = { type = "string", enum = v5 },
				name = { type = "string" },
				description = { type = "string" },
				productType = { type = "string", enum = v6 },
				priceInRobux = {
					type = "integer",
					minimum = 49,
					maximum = MAXIMUM_SAFE_INTEGER
				},
				subscriptionId = { type = "string" },
				cancelRenewals = { type = "boolean" },
				imageAssetId = {
					type = "integer",
					minimum = 1,
					maximum = MAXIMUM_SAFE_INTEGER
				},
				createAndGoLive = FFlagCreatorAgentChatMonetizationOneConsent and {
					type = "boolean",
					description = "Only for create when the creator explicitly requests creation and activation in one approval. Creation stays inactive until a supported benefit is published and verified; custom or uncertain wiring stays inactive without another approval."
				} or nil
			}
		}
	},
	findRequestInTurnState = monetizationClientTool.createRequestFinder("manage_subscription"),
	parseInput = function(data)
		local action, v7 = monetizationClientTool.parseAction(data, v5)

		if action == nil then
			return nil, v7
		end

		local v8 = monetizationClientTool.checkStringFields(data, {
			"name",
			"description",
			"productType",
			"subscriptionId"
		})

		if v8 ~= nil then
			return nil, v8
		end

		if data.cancelRenewals ~= nil and typeof(data.cancelRenewals) ~= "boolean" then
			return nil, "cancelRenewals must be a boolean."
		end

		local price, v9 = monetizationClientTool.parsePrice(data.priceInRobux, 49, MAXIMUM_SAFE_INTEGER)

		if v9 ~= nil then
			return nil, v9
		end

		local productType = if data.productType ~= nil then string.lower(data.productType) else nil

		if productType ~= nil and not table.find(v6, productType) then
			return nil, "productType must be consumable, currency or durable."
		end

		local v10 = {
			action = action,
			name = data.name,
			description = data.description,
			productType = productType,
			priceInRobux = price,
			subscriptionId = 0,
			cancelRenewals = 0,
			imageAssetId = 0
		}

		local v11 = if data.subscriptionId ~= "" then data.subscriptionId else nil
		v10.subscriptionId = v11
		v10.cancelRenewals = data.cancelRenewals
		v10.imageAssetId = monetizationClientTool.parsePositiveSafeInteger(data.imageAssetId)

		if data.imageAssetId ~= nil and v10.imageAssetId == nil then
			return
				nil,
				("imageAssetId must be a positive integer no greater than %.0f."):format(MAXIMUM_SAFE_INTEGER)
		end

		if data.createAndGoLive ~= nil and not FFlagCreatorAgentChatMonetizationOneConsent then
			return nil, "createAndGoLive is unavailable."
		end

		local createAndGoLive, v12 = monetizationClientTool.parseCreateAndGoLive(data.createAndGoLive, action)

		if v12 ~= nil then
			return nil, v12
		end

		v10.createAndGoLive = createAndGoLive

		if (action == "create" or action == "list") and data.subscriptionId ~= nil then
			return
				nil,
				"subscriptionId is only used to update, activate, deactivate or delete a subscription."
		end

		if
			action ~= "create"
			and action ~= "update"
			and (data.description ~= nil or data.priceInRobux ~= nil or data.imageAssetId ~= nil)
		then
			return
				nil,
				"Only create and update can set a subscription description, priceInRobux or imageAssetId."
		end

		if action ~= "create" and action ~= "update" and (data.name ~= nil or data.productType ~= nil) then
			return nil, "A subscription name and productType are only used on create."
		end

		if action ~= "deactivate" and data.cancelRenewals ~= nil then
			return nil, "cancelRenewals is only used on deactivate."
		end

		if action == "create" then
			local v13

			if v10.name == nil or v10.name == "" or v10.productType == nil then
				v13 = false
			else
				v13 = v10.priceInRobux ~= nil
			end

			if not v13 then
				return nil, "A name, productType and priceInRobux are required to create a subscription."
			end
		else
			if action ~= "list" and v10.subscriptionId == nil then
				return nil, "A subscriptionId is required for this action."
			end

			if action == "update" then
				if v10.name ~= nil then
					return nil, "A subscription's name can't be changed after it is created."
				end

				if v10.productType ~= nil then
					return nil, "A subscription's product type can't be changed after it is created."
				end

				if v10.description == nil and v10.priceInRobux == nil and v10.imageAssetId == nil then
					return nil, "An update needs a description, priceInRobux or imageAssetId."
				end
			elseif action == "deactivate" and v10.cancelRenewals == nil then
				return
					nil,
					"cancelRenewals is required: ask the creator whether current subscribers keep renewing."
			end
		end

		return v10, nil
	end,
	getActionKind = monetizationClientTool.getActionKind,
	formatResultContent = monetizationClientTool.formatResultContent,
	formatRejectionContent = monetizationClientTool.formatRejectionContent
}
