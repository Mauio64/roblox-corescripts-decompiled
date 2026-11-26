require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/types")
local monetizationClientTool = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/monetizationClientTool")
local FFlagCreatorAgentChatMonetizationOneConsent = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/FFlagCreatorAgentChatMonetizationOneConsent")

local v5 = { "create", "list", "update", "activate", "deactivate" }

local MAXIMUM_SAFE_INTEGER = monetizationClientTool.MAXIMUM_SAFE_INTEGER

return {
	TOOL_NAME = "manage_game_pass",
	LOCAL_TOOL_DEFINITION = {
		name = "manage_game_pass",
		inputSchema = {
			type = "object",
			additionalProperties = false,
			required = { "action" },
			properties = {
				action = { type = "string", enum = v5 },
				name = { type = "string" },
				description = { type = "string" },
				priceInRobux = { type = "integer", minimum = 1, maximum = 999999999 },
				gamePassId = {
					type = "integer",
					minimum = 1,
					maximum = MAXIMUM_SAFE_INTEGER
				},
				createAndGoLive = FFlagCreatorAgentChatMonetizationOneConsent and {
					type = "boolean",
					description = "Only for create when the creator explicitly requests creation and sale in one approval. Creation stays off sale until a supported benefit is published and verified; custom or uncertain wiring stays off sale without another approval."
				} or nil
			}
		}
	},
	findRequestInTurnState = monetizationClientTool.createRequestFinder("manage_game_pass"),
	parseInput = function(data, p2)
		local action, v6 = monetizationClientTool.parseAction(data, v5)

		if action == nil then
			return nil, v6
		end

		local v7 = monetizationClientTool.checkStringFields(data, { "name", "description" })

		if v7 ~= nil then
			return nil, v7
		end

		local price, v8 = monetizationClientTool.parsePrice(data.priceInRobux, 1, 999999999)

		if v8 ~= nil then
			return nil, v8
		end

		local v9 = {
			action = action,
			name = data.name,
			description = data.description,
			priceInRobux = price,
			gamePassId = monetizationClientTool.parsePositiveSafeInteger(data.gamePassId)
		}

		if data.gamePassId ~= nil and v9.gamePassId == nil then
			return
				nil,
				("gamePassId must be a positive integer no greater than %.0f."):format(MAXIMUM_SAFE_INTEGER)
		end

		if p2 then
			v9.imageAssetId = monetizationClientTool.parsePositiveSafeInteger(data.imageAssetId)

			if data.imageAssetId ~= nil and v9.imageAssetId == nil then
				return
					nil,
					("imageAssetId must be a positive integer no greater than %.0f."):format(MAXIMUM_SAFE_INTEGER)
			end
		end

		if data.createAndGoLive ~= nil and not FFlagCreatorAgentChatMonetizationOneConsent then
			return nil, "createAndGoLive is unavailable."
		end

		local createAndGoLive, v10 = monetizationClientTool.parseCreateAndGoLive(data.createAndGoLive, action)

		if v10 ~= nil then
			return nil, v10
		end

		v9.createAndGoLive = createAndGoLive

		if (action == "create" or action == "list") and data.gamePassId ~= nil then
			return nil, "gamePassId is only used to update, activate or deactivate a game pass."
		end

		if
			action == "create"
			or action == "update"
			or data.name == nil
			and data.description == nil
			and data.priceInRobux == nil
			and v9.imageAssetId == nil
		then
			if action == "create" then
				if v9.name == nil or v9.name == "" or v9.priceInRobux == nil then
					return nil, "A name and priceInRobux are required to create a game pass."
				end
			else
				if action ~= "list" and v9.gamePassId == nil then
					return nil, "A gamePassId is required for this action."
				end

				if
					action == "update"
					and v9.name == nil
					and v9.description == nil
					and v9.priceInRobux == nil
					and v9.imageAssetId == nil
				then
					local v11 = nil

					if p2 then
						return v11, "An update needs a name, description, priceInRobux or imageAssetId."
					end

					return v11, "An update needs a name, description or priceInRobux."
				elseif action == "update" and v9.name == "" then
					return nil, "A game pass name cannot be empty."
				end
			end

			return v9, nil
		else
			local v11 = nil

			if p2 then
				return
					v11,
					"Only create and update can set a game pass name, description, priceInRobux or imageAssetId."
			end

			return v11, "Only create and update can set a game pass name, description or priceInRobux."
		end
	end,
	getActionKind = monetizationClientTool.getActionKind,
	formatResultContent = monetizationClientTool.formatResultContent,
	formatRejectionContent = monetizationClientTool.formatRejectionContent
}
