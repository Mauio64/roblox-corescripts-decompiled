local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

local FFlagBuildExperienceDevProductModerationReadback = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDevProductModerationReadback")
local wasDeveloperProductTextModerated = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/wasDeveloperProductTextModerated")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
local chatConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/localToolOverlay")
local createManageDevProductStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/createManageDevProductStore")
local FFlagBuildExperienceDevProductRecovery = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceDevProductRecovery")

local FFlagBuildExperienceMonetizationFailureCauses = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationFailureCauses")

local fFlagBuildExperienceRemoveDevProductPriceCap = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SharedFlags").FFlagBuildExperienceRemoveDevProductPriceCap
local toolControllerUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/toolControllerUtils")
local monetizationFailureCauses = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/monetizationFailureCauses")
local downloadGeneratedImageAsync = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/downloadGeneratedImageAsync")

local studioManageDevProductTool = CreatorAgentChat.StudioManageDevProductTool
local Debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local v5 = createManageDevProductStore()

local function awaitPromise(object)
	local v6 = nil
	local v7 = nil
	local v8 = false
	object:andThen(function(p2)
		v6 = p2
		v8 = true
	end, function(p2)
		v7 = p2
		v8 = true
	end)
	local v9 = os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS

	while not v8 and os.clock() < v9 do
		task.wait()
	end

	if not v8 then
		object:cancel()
		v7 = "The request timed out and its outcome is unknown. List developer products before retrying."
	end

	return v6, v7
end

local function messageFromRejection(p2)
	if typeof(p2) == "table" and typeof(p2.errorMessage) == "string" then
		return p2.errorMessage
	end

	if p2 == nil then
		return "The request timed out."
	end

	return (tostring(p2))
end

local function detailCodeForFailure(action, value)
	local v6 = string.lower(value)

	if string.find(v6, "outcome is unknown", 1, true) then
		return "outcome_unknown"
	end

	if string.find(v6, "universe", 1, true) and string.find(v6, "publish", 1, true) then
		return "universe_not_published"
	end

	return action .. "_failed"
end

local function describeImageFailure(value)
	if value == nil or string.find(string.lower(value), "outcome is unknown", 1, true) then
		return monetizationFailureCauses.MESSAGES.imageTimedOut
	end

	if monetizationFailureCauses.classify(value) == nil then
		return monetizationFailureCauses.MESSAGES.imageFailed
	end

	return value
end

local function awaitMutation(p2)
	local v6, v7 = awaitPromise(p2)

	if v6 ~= nil then
		return v6, nil
	end

	local product = if typeof(v7) == "table" then v7.product else nil
	local responseCode = if typeof(v7) == "table" then v7.responseCode else nil
	local v8 = product == nil and responseCode == 429

	local v9 = FFlagBuildExperienceDevProductModerationReadback and typeof(v7) == "table" and v7.outcome == "unverified" and "readback_unverified"
		or nil
	local v10 = if typeof(v7) == "table" and typeof(v7.errorMessage) == "string" then v7.errorMessage else v7 == nil and "The request timed out." or tostring(v7)

	return product, v10, v8, v9
end

local function proposalFromFlow(data, p2, p3)
	local v6 = {
		toolCallId = data.toolCallId,
		callOrder = data.callOrder,
		action = data.action,
		name = data.name,
		description = data.description,
		priceInRobux = data.priceInRobux,
		productId = data.productId,
		imageAssetId = data.imageAssetId,
		isApproved = p2,
		isRejected = p3,
		isPending = 0,
		hasError = 0,
		errorCause = 0,
		canRetry = 0
	}

	local v7 = if FFlagBuildExperienceDevProductRecovery then data.isPending else nil
	v6.isPending = v7
	local v8 = if FFlagBuildExperienceDevProductRecovery then not (data.resultError == nil) and not p3 else nil
	v6.hasError = v8

	local v9 = if FFlagBuildExperienceDevProductRecovery and FFlagBuildExperienceMonetizationFailureCauses and data.resultError ~= nil and not p3 then monetizationFailureCauses.classify(data.resultError) or data.canRetry and "rateLimited" or nil else nil
	v6.errorCause = v9

	local v10 = if FFlagBuildExperienceDevProductRecovery then data.canRetry and not p3 else nil
	v6.canRetry = v10
	return v6
end

local function moderationError(data, data2)
	if data.action ~= "create" and data.action ~= "update" then
		return nil
	end

	local v6, v7

	if FFlagBuildExperienceDevProductModerationReadback then
		v6 = wasDeveloperProductTextModerated(data.name, data2.name)
		v7 = wasDeveloperProductTextModerated(data.description, data2.description)
	else
		v6 = not (data.name == nil or data2.name == nil) and data2.name ~= data.name

		if data.description == nil or data.description == "" or data2.description == nil then
			v7 = false
		else
			v7 = data2.description ~= data.description
		end
	end

	if not (v6 or v7) then
		return nil
	end

	local v8

	if FFlagBuildExperienceMonetizationFailureCauses then
		v8 = monetizationFailureCauses.MESSAGES.moderated .. " Do not create another product; product %s already exists. Ask the creator for plainer wording and update this product."
	else
		v8 = monetizationFailureCauses.MESSAGES.moderated .. " Product %s already exists; do not create another. Ask the creator for plainer wording and update this product."
	end

	return v8:format((tostring(data2.productId or data.productId or "unknown")))
end

local function createManageDevProductController(p2, p3, data, callback, p4)
	local v6 = p4 or studioManageDevProductTool
	local v7 = v5
	local v8 = nil
	local v9 = {}
	local v10 = nil

	local function performMutation(data2)
		local universeId = data2.universeId

		if universeId == nil then
			return nil, monetizationFailureCauses.MESSAGES.noUniverse
		end

		if
			not fFlagBuildExperienceRemoveDevProductPriceCap
			and data2.priceInRobux ~= nil
			and (data2.priceInRobux < 1 or data2.priceInRobux > 100)
		then
			return nil, "Developer-product prices must be between 1 and 100 Robux."
		end

		if data2.action == "create" then
			if data2.name == nil or data2.name == "" or data2.priceInRobux == nil then
				return nil, "A name and price are required to create a developer product."
			end

			local v11

			if data2.imageAssetId == nil then
				return awaitMutation(v7.create(universeId, {
					name = data2.name,
					description = data2.description,
					priceInRobux = data2.priceInRobux,
					imageFile = v11
				}))
			end

			local v12
			v11, v12 = awaitMutation(downloadGeneratedImageAsync(data2.imageAssetId))

			if v11 ~= nil then
				return awaitMutation(v7.create(universeId, {
					name = data2.name,
					description = data2.description,
					priceInRobux = data2.priceInRobux,
					imageFile = v11
				}))
			end

			if not FFlagBuildExperienceDevProductRecovery then
				return nil, v12
			end

			if FFlagBuildExperienceMonetizationFailureCauses then
				return
					nil,
					`The product image could not be loaded. No product was created. {describeImageFailure(v12)}`,
					true
			end

			return nil, "The product image could not be loaded. No product was created.", true
		end

		if data2.productId == nil then
			return nil, "A productId is required for this action."
		end

		if data2.action == "update" then
			return awaitMutation(v7.update(
				universeId,
				data2.productId,
				{
					name = data2.name,
					description = data2.description,
					priceInRobux = data2.priceInRobux
				},
				FFlagBuildExperienceDevProductModerationReadback
			))
		end

		if data2.action == "activate" then
			return awaitMutation(v7.activate(universeId, data2.productId))
		end

		if data2.action == "deactivate" then
			return awaitMutation(v7.deactivate(universeId, data2.productId))
		end

		return nil, ("Unsupported action '%s'."):format(data2.action)
	end

	local function clearMutationCard(p5)
		data.removeDevProductTool(p5.toolCallId)
		data.removeDevProductAction(p5.toolCallId)
	end

	local function recoverFailedSubmission(state, p5, p6)
		if FFlagBuildExperienceDevProductRecovery and v8 ~= state then
			data.removeDevProductAction(state.toolCallId)
		elseif FFlagBuildExperienceDevProductRecovery and FFlagBuildExperienceMonetizationFailureCauses and state.attempted and toolControllerUtils.isConversationGone(p6) then
			state.isPending = false
			state.canRetry = false
			p3[state.toolCallId] = true
			data.markSubmitted(state.toolCallId)
			data.setDevProductTool(proposalFromFlow(state, true, false))
			data.removeDevProductAction(state.toolCallId)
			v8 = nil

			if callback ~= nil then
				callback(p5, p6)
			end
		else
			state.submitted = false

			if callback == nil then
				return
			end

			data.setDevProductTool(proposalFromFlow(state, false, false))
			callback(p5, p6)
		end
	end

	local function submitResult(data2, p5, p6, p7)
		local submitActiveToolResult = p2.submitActiveToolResult(p5, p6, data2.turnId, data2.referenceId)

		if submitActiveToolResult == nil then
			Debug.log("warn", "manage_developer_product tool_result submit aborted (no active session)", {
				toolCallId = data2.toolCallId
			})

			recoverFailedSubmission(data2, p7, nil)
		else
			local v11 = awaitRequestState(
				submitActiveToolResult.state,
				os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
			)

			if v11.status == "succeeded" then
				p3[data2.toolCallId] = true
				data.markSubmitted(data2.toolCallId)

				data.removeDevProductAction(data2.toolCallId)

				if v8 == data2 then
					v8 = nil
				end
			else
				recoverFailedSubmission(data2, p7, v11.errorCode)
				Debug.log("warn", "manage_developer_product tool_result submit failed", {
					sessionId = data2.sessionId,
					toolCallId = data2.toolCallId,
					turnId = data2.turnId,
					referenceId = data2.referenceId,
					action = data2.action,
					state = Debug.formatRequestState(v11)
				})
			end
		end
	end

	local function submitApproval(state)
		local v11, v12, v13

		if state.attempted then
			v11 = state.result
			v12 = state.resultError
			v13 = state.resultDetailCode
		else
			state.attempted = true
			local v14
			v11, v12, v14, v13 = performMutation(state)

			if v11 ~= nil and v12 == nil then
				v12 = moderationError(state, v11)

				if v12 ~= nil then
					v13 = "name_moderated"
				end
			end

			state.result = v11
			state.resultError = v12

			if v12 ~= nil and v13 == nil then
				v13 = detailCodeForFailure(state.action, v12)
			end

			state.resultDetailCode = v13

			if FFlagBuildExperienceDevProductRecovery and v12 ~= nil and v14 and state.action == "create" and v8 == state then
				state.attempted = false
				state.submitted = false
				state.isPending = false
				state.canRetry = true
				data.setDevProductTool(proposalFromFlow(state, false, false))
				return
			end
		end

		if FFlagBuildExperienceDevProductRecovery then
			state.isPending = false
			state.canRetry = false

			if data.getOptimisticLocalTools(false).devProductByToolCallId[state.toolCallId] ~= nil then
				data.setDevProductTool(proposalFromFlow(state, true, false))
			end
		end

		local v14, v15

		if v11 == nil or v12 ~= nil then
			v14 = v6.formatResultContent({
				status = "error",
				action = state.action,
				detailCode = v13,
				message = v12 or "The developer product change failed.",
				product = v11
			})
			v15 = true
		else
			v14, v15 = v6.formatResultContent({
				status = "ok",
				action = state.action,
				product = v11
			})
		end

		submitResult(state, v14, v15, nil)
	end

	local function submitRejection(p5, p6)
		if p5.attempted then
			data.setDevProductTool(proposalFromFlow(p5, true, false))
			submitApproval(p5)
		else
			submitResult(p5, v6.formatRejectionContent(p5.action, p6), false, p6)
		end
	end

	local function onApproveImpl()
		local v11 = v8

		if v11 == nil or v11.submitted then
			return
		end

		v11.submitted = true

		if FFlagBuildExperienceDevProductRecovery then
			v11.isPending = true
			v11.canRetry = false
		end

		data.setDevProductTool(proposalFromFlow(v11, true, false))
		task.spawn(function()
			submitApproval(v11)
		end)
	end

	local function onRejectImpl()
		local v12 = v8

		if v12 == nil or v12.submitted then
			return
		end

		v12.submitted = true
		data.setDevProductTool(proposalFromFlow(v12, false, true))
		task.spawn(function()
			submitRejection(v12, nil)
		end)
	end

	local function runListRequest(manageDevProductRequestInTurnState, p5, p6, sessionId)
		local universeId = p2.universeId
		local v13 = nil
		local v14

		if universeId == nil then
			v14 = monetizationFailureCauses.MESSAGES.noUniverse
		else
			v13, v14 = awaitMutation(v7.list(universeId))
		end

		local v15, v16

		if v13 == nil then
			v15 = v6.formatResultContent({
				status = "error",
				action = "list",
				detailCode = "list_failed",
				message = v14 or "Could not list developer products."
			})
			v16 = true
		else
			v15, v16 = v6.formatResultContent({
				status = "ok",
				action = "list",
				count = #v13.developerProducts,
				products = v13.developerProducts,
				nextPageToken = v13.nextPageToken,
				truncated = v13.nextPageToken ~= nil
			})
		end

		local submitActiveToolResult = p2.submitActiveToolResult(v15, v16, p5, p6)
		v9[manageDevProductRequestInTurnState] = nil

		if submitActiveToolResult == nil then
			p3[manageDevProductRequestInTurnState] = nil
			return
		end

		local v17 = awaitRequestState(
			submitActiveToolResult.state,
			os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
		)

		if v17.status ~= "succeeded" then
			p3[manageDevProductRequestInTurnState] = nil

			if v17.status == "pending" then
				submitActiveToolResult.dispose()
			end

			Debug.log("warn", "manage_developer_product list submit failed", {
				sessionId = sessionId,
				toolCallId = manageDevProductRequestInTurnState,
				state = Debug.formatRequestState(v17)
			})
		end
	end

	local function clearMutationFlow()
		local v13 = v8

		if v13 ~= nil then
			data.removeDevProductTool(v13.toolCallId)
			data.removeDevProductAction(v13.toolCallId)
		end

		v8 = nil
		v10 = nil
	end

	return {
		syncManageDevProductRequests = function(p5): boolean
			local manageDevProductRequestInTurnState, v13, v14, v15 = v6.findManageDevProductRequestInTurnState(p5, p3)

			if manageDevProductRequestInTurnState == nil then
				local v16 = v8

				if v16 ~= nil then
					data.removeDevProductTool(v16.toolCallId)
					data.removeDevProductAction(v16.toolCallId)
				end

				v8 = nil
				v10 = nil

				return false
			else
				local manageDevProductInput, v16, v17 = v6.parseManageDevProductInput(v13)

				if manageDevProductInput == nil then
					if v9[manageDevProductRequestInTurnState] then
						return true
					end

					v9[manageDevProductRequestInTurnState] = true
					task.spawn(function()
						local v18

						if v16 == nil then
							v18 = FFlagBuildExperienceDevProductRecovery

							if v18 then
								if
									typeof(v13) == "table"
									and typeof(v13.action) == "string"
									and string.lower(v13.action) == "update"
								then
									v18 = v13.imageAssetId ~= nil
								else
									v18 = false
								end
							end
						else
							v18 = false
						end

						local v19 = if v6.resolveRequestKind ~= nil then v6.resolveRequestKind(v13) else nil
						local formatResultContent = v6.formatResultContent({
							status = "error",
							kind = v19,
							action = v18 and "update" or "unknown",
							detailCode = v18 and "unsupported_image_update" or v17 or "invalid_arguments",
							message = v18 and "Editing an existing developer product's image is not supported. No product was changed. Do not claim the image was updated or create a replacement product." or v16 or "The developer-product request was malformed."
						})

						local submitActiveToolResult = p2.submitActiveToolResult(
							formatResultContent,
							true,
							v14,
							v15
						)
						v9[manageDevProductRequestInTurnState] = nil

						if submitActiveToolResult == nil then
							return
						end

						local v20 = awaitRequestState(
							submitActiveToolResult.state,
							os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
						)

						if v20.status == "succeeded" then
							p3[manageDevProductRequestInTurnState] = true
						elseif v20.status == "pending" then
							submitActiveToolResult.dispose()
						end
					end)
				elseif v6.getActionKind(manageDevProductInput.action) == "read" then
					if v9[manageDevProductRequestInTurnState] then
						return true
					end

					p3[manageDevProductRequestInTurnState] = true
					v9[manageDevProductRequestInTurnState] = true
					task.spawn(function()
						runListRequest(manageDevProductRequestInTurnState, v14, v15, p5.sessionId)
					end)
				elseif manageDevProductRequestInTurnState ~= v10 then
					v10 = manageDevProductRequestInTurnState
					local v18 = {
						sessionId = p5.sessionId,
						toolCallId = manageDevProductRequestInTurnState,
						callOrder = getToolCallOrder(p5, manageDevProductRequestInTurnState),
						turnId = v14,
						referenceId = v15,
						universeId = p2.universeId,
						action = manageDevProductInput.action,
						name = manageDevProductInput.name,
						description = manageDevProductInput.description,
						priceInRobux = manageDevProductInput.priceInRobux,
						productId = manageDevProductInput.productId,
						imageAssetId = manageDevProductInput.imageAssetId,
						submitted = false,
						attempted = false
					}

					v8 = v18
					data.setDevProductTool(proposalFromFlow(v18, false, false))
					data.setDevProductAction(
						manageDevProductRequestInTurnState,
						onApproveImpl,
						onRejectImpl
					)
					Debug.log("info", "manage_developer_product proposal displayed", {
						toolCallId = manageDevProductRequestInTurnState,
						turnId = v14,
						referenceId = v15,
						action = manageDevProductInput.action
					})
				end

				return true
			end
		end,
		stopPending = function()
			local v13 = false

			for k in v9 do
				v9[k] = nil
				p3[k] = nil
				v13 = true
			end

			local v14 = v8

			if v14 == nil or v14.submitted then
				return v13
			end

			v14.submitted = true
			data.removeDevProductTool(v14.toolCallId)
			data.removeDevProductAction(v14.toolCallId)

			v8 = nil
			v10 = nil
			v13 = true
			return true
		end,
		trySubmitComposerText = function(p5): boolean
			local v13 = v8

			if v13 == nil or v13.submitted then
				return false
			end

			v13.submitted = true
			data.setDevProductTool(proposalFromFlow(v13, false, true))
			task.spawn(function()
				submitRejection(v13, p5)
			end)
			return true
		end
	}
end

return createManageDevProductController
