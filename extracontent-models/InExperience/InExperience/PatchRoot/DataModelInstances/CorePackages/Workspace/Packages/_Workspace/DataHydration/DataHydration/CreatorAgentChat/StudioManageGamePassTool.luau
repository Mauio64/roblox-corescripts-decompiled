require(script.Parent.types)
local monetizationClientTool = require(script.Parent.monetizationClientTool)
local FFlagCreatorAgentChatMonetizationOneConsent = require(script.Parent.FFlagCreatorAgentChatMonetizationOneConsent)

local enum = { "create", "list", "update", "activate", "deactivate" }

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
				action = { type = "string", enum = enum },
				name = { type = "string" },
				description = { type = "string" },
				priceInRobux = { type = "integer", minimum = 1, maximum = 999999999 },
				gamePassId = { type = "integer", minimum = 1, maximum = MAXIMUM_SAFE_INTEGER },
				createAndGoLive = FFlagCreatorAgentChatMonetizationOneConsent and {
					type = "boolean",
					description = "Only for create when the creator explicitly requests creation and sale in one approval. Creation stays off sale until a supported benefit is published and verified; custom or uncertain wiring stays off sale without another approval."
				} or nil
			}
		}
	},
	findRequestInTurnState = monetizationClientTool.createRequestFinder("manage_game_pass"),
	parseInput = function(data, flag: boolean?)
		local action, v = monetizationClientTool.parseAction(data, enum)

		if action == nil then
			return nil, v
		end

		local v2 = monetizationClientTool.checkStringFields(data, { "name", "description" })

		if v2 ~= nil then
			return nil, v2
		end

		local price, v3 = monetizationClientTool.parsePrice(data.priceInRobux, 1, 999999999)

		if v3 ~= nil then
			return nil, v3
		end

		local v4 = {
			action = action,
			name = data.name,
			description = data.description,
			priceInRobux = price,
			gamePassId = monetizationClientTool.parsePositiveSafeInteger(data.gamePassId)
		}

		if data.gamePassId ~= nil and v4.gamePassId == nil then
			return nil, ("gamePassId must be a positive integer no greater than %.0f."):format(MAXIMUM_SAFE_INTEGER)
		end

		if flag then
			v4.imageAssetId = monetizationClientTool.parsePositiveSafeInteger(data.imageAssetId)

			if data.imageAssetId ~= nil and v4.imageAssetId == nil then
				return
					nil,
					("imageAssetId must be a positive integer no greater than %.0f."):format(MAXIMUM_SAFE_INTEGER)
			end
		end

		if data.createAndGoLive ~= nil and not FFlagCreatorAgentChatMonetizationOneConsent then
			return nil, "createAndGoLive is unavailable."
		end

		local createAndGoLive, v5 = monetizationClientTool.parseCreateAndGoLive(data.createAndGoLive, action)

		if v5 ~= nil then
			return nil, v5
		end

		v4.createAndGoLive = createAndGoLive

		if (action == "create" or action == "list") and data.gamePassId ~= nil then
			return nil, "gamePassId is only used to update, activate or deactivate a game pass."
		end

		if
			action == "create"
			or action == "update"
			or data.name == nil and data.description == nil and data.priceInRobux == nil and v4.imageAssetId == nil
		then
			if action == "create" then
				if v4.name == nil or v4.name == "" or v4.priceInRobux == nil then
					return nil, "A name and priceInRobux are required to create a game pass."
				end
			else
				if action ~= "list" and v4.gamePassId == nil then
					return nil, "A gamePassId is required for this action."
				end

				if
					action == "update"
					and v4.name == nil
					and v4.description == nil
					and v4.priceInRobux == nil
					and v4.imageAssetId == nil
				then
					local v6 = nil

					if flag then
						return v6, "An update needs a name, description, priceInRobux or imageAssetId."
					end

					return v6, "An update needs a name, description or priceInRobux."
				elseif action == "update" and v4.name == "" then
					return nil, "A game pass name cannot be empty."
				end
			end

			return v4, nil
		else
			local v6 = nil

			if flag then
				return v6, "Only create and update can set a game pass name, description, priceInRobux or imageAssetId."
			end

			return v6, "Only create and update can set a game pass name, description or priceInRobux."
		end
	end,
	getActionKind = monetizationClientTool.getActionKind,
	formatResultContent = monetizationClientTool.formatResultContent,
	formatRejectionContent = monetizationClientTool.formatRejectionContent
}
