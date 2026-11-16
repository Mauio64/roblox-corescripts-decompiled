local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)

local FFlagBuildExperienceDevProductModerationReadback = require(BuildExperience.Flags.FFlagBuildExperienceDevProductModerationReadback)
local wasDeveloperProductTextModerated = require(BuildExperience.utils.wasDeveloperProductTextModerated)

require(script.Parent.chatTypes)
local chatConstants = require(script.Parent.chatConstants)
require(script.Parent.localToolOverlay)
local createManageDevProductStore = require(script.Parent.createManageDevProductStore)
local FFlagBuildExperienceDevProductRecovery = require(BuildExperience.Flags.FFlagBuildExperienceDevProductRecovery)

local FFlagBuildExperienceMonetizationFailureCauses = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationFailureCauses)

local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceRemoveDevProductPriceCap = SharedFlags.FFlagBuildExperienceRemoveDevProductPriceCap
local toolControllerUtils = require(script.Parent.toolControllerUtils)
local monetizationFailureCauses = require(BuildExperience.utils.monetizationFailureCauses)
local downloadGeneratedImageAsync = require(BuildExperience.utils.downloadGeneratedImageAsync)

local StudioManageDevProductTool = CreatorAgentChat.StudioManageDevProductTool
local Debug = CreatorAgentChat.debug
local awaitRequestState = toolControllerUtils.awaitRequestState
local getToolCallOrder = toolControllerUtils.getToolCallOrder

local manageDevProductStore = createManageDevProductStore()

local function awaitPromise(object)
	local v = nil
	local v2 = nil
	local v3 = false
	object:andThen(function(p)
		v = p
		v3 = true
	end, function(p)
		v2 = p
		v3 = true
	end)
	local v4 = os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS

	while not v3 and os.clock() < v4 do
		task.wait()
	end

	if not v3 then
		object:cancel()
		v2 = "The request timed out and its outcome is unknown. List developer products before retrying."
	end

	return v, v2
end

local function messageFromRejection(p) -- 1 equivalent call inferred from this helper
	if typeof(p) == "table" and typeof(p.errorMessage) == "string" then
		return p.errorMessage
	end

	if p == nil then
		return "The request timed out."
	end

	return (tostring(p))
end

local function detailCodeForFailure(action: string, value: string)
	local v = string.lower(value)

	if string.find(v, "outcome is unknown", 1, true) then
		return "outcome_unknown"
	end

	if string.find(v, "universe", 1, true) and string.find(v, "publish", 1, true) then
		return "universe_not_published"
	end

	return action .. "_failed"
end

local function describeImageFailure(value: string?)
	if value == nil or string.find(string.lower(value), "outcome is unknown", 1, true) then
		return monetizationFailureCauses.MESSAGES.imageTimedOut
	end

	if monetizationFailureCauses.classify(value) == nil then
		return monetizationFailureCauses.MESSAGES.imageFailed
	end

	return value
end

local function awaitMutation(p)
	local v, v2 = awaitPromise(p)

	if v ~= nil then
		return v, nil
	end

	local product

	if typeof(v2) == "table" then
		product = v2.product
	end

	local responseCode

	if typeof(v2) == "table" then
		responseCode = v2.responseCode
	end

	local v3

	if product == nil then
		v3 = responseCode == 429
	else
		v3 = false
	end

	local v4 = FFlagBuildExperienceDevProductModerationReadback
		and typeof(v2) == "table"
		and v2.outcome == "unverified"
		and "readback_unverified"
		or nil

	return product, messageFromRejection(v2), v3, v4 -- inferred equivalent call
end

local function proposalFromFlow(data, isApproved: boolean?, isRejected: boolean?)
	local v = {
		toolCallId = data.toolCallId,
		callOrder = data.callOrder,
		action = data.action,
		name = data.name,
		description = data.description,
		priceInRobux = data.priceInRobux,
		productId = data.productId,
		imageAssetId = data.imageAssetId,
		isApproved = isApproved,
		isRejected = isRejected,
		isPending = 0,
		hasError = 0,
		errorCause = 0,
		canRetry = 0
	}
	local isPending

	if FFlagBuildExperienceDevProductRecovery then
		isPending = data.isPending
	end

	v.isPending = isPending
	local hasError

	if FFlagBuildExperienceDevProductRecovery then
		if data.resultError == nil then
			hasError = false
		else
			hasError = not isRejected
		end
	end

	v.hasError = hasError
	local errorCause

	if
		FFlagBuildExperienceDevProductRecovery
		and FFlagBuildExperienceMonetizationFailureCauses
		and data.resultError ~= nil
		and not isRejected
	then
		errorCause = monetizationFailureCauses.classify(data.resultError) or data.canRetry and "rateLimited" or nil
	end

	v.errorCause = errorCause
	local canRetry

	if FFlagBuildExperienceDevProductRecovery then
		canRetry = data.canRetry and not isRejected
	end

	v.canRetry = canRetry
	return v
end

local function moderationError(data, data2)
	if data.action ~= "create" and data.action ~= "update" then
		return nil
	end

	local v, v2

	if FFlagBuildExperienceDevProductModerationReadback then
		v = wasDeveloperProductTextModerated(data.name, data2.name)
		v2 = wasDeveloperProductTextModerated(data.description, data2.description)
	else
		if data.name == nil or data2.name == nil then
			v = false
		else
			v = data2.name ~= data.name
		end

		if data.description == nil or data.description == "" or data2.description == nil then
			v2 = false
		else
			v2 = data2.description ~= data.description
		end
	end

	if not (v or v2) then
		return nil
	end

	local v3

	if FFlagBuildExperienceMonetizationFailureCauses then
		v3 = monetizationFailureCauses.MESSAGES.moderated .. " Do not create another product; product %s already exists. Ask the creator for plainer wording and update this product."
	else
		v3 = monetizationFailureCauses.MESSAGES.moderated .. " Product %s already exists; do not create another. Ask the creator for plainer wording and update this product."
	end

	return v3:format((tostring(data2.productId or data.productId or "unknown")))
end

local function createManageDevProductController(p, p2, data, callback, p3)
	local v = p3 or StudioManageDevProductTool
	local v2 = manageDevProductStore
	local v3 = nil
	local v4 = {}
	local v5 = nil

	local function performMutation(data2)
		local universeId = data2.universeId

		if universeId == nil then
			return nil, monetizationFailureCauses.MESSAGES.noUniverse
		end

		if
			not FFlagBuildExperienceRemoveDevProductPriceCap
			and data2.priceInRobux ~= nil
			and (data2.priceInRobux < 1 or data2.priceInRobux > 100)
		then
			return nil, "Developer-product prices must be between 1 and 100 Robux."
		end

		if data2.action == "create" then
			if data2.name == nil or data2.name == "" or data2.priceInRobux == nil then
				return nil, "A name and price are required to create a developer product."
			end

			local imageFile

			if data2.imageAssetId == nil then
				return awaitMutation(v2.create(universeId, {
					name = data2.name,
					description = data2.description,
					priceInRobux = data2.priceInRobux,
					imageFile = imageFile
				}))
			end

			local v6
			imageFile, v6 = awaitMutation(downloadGeneratedImageAsync(data2.imageAssetId))

			if imageFile ~= nil then
				return awaitMutation(v2.create(universeId, {
					name = data2.name,
					description = data2.description,
					priceInRobux = data2.priceInRobux,
					imageFile = imageFile
				}))
			end

			if not FFlagBuildExperienceDevProductRecovery then
				return nil, v6
			end

			if FFlagBuildExperienceMonetizationFailureCauses then
				return
					nil,
					`The product image could not be loaded. No product was created. {describeImageFailure(v6)}`,
					true
			end

			return nil, "The product image could not be loaded. No product was created.", true
		end

		if data2.productId == nil then
			return nil, "A productId is required for this action."
		end

		if data2.action == "update" then
			return awaitMutation(v2.update(
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
			return awaitMutation(v2.activate(universeId, data2.productId))
		end

		if data2.action == "deactivate" then
			return awaitMutation(v2.deactivate(universeId, data2.productId))
		end

		return nil, ("Unsupported action '%s'."):format(data2.action)
	end

	local function clearMutationCard(p4) -- 2 equivalent calls inferred from this helper
		data.removeDevProductTool(p4.toolCallId)
		data.removeDevProductAction(p4.toolCallId)
	end

	local function recoverFailedSubmission(state, p4: string?, p5: number?)
		if FFlagBuildExperienceDevProductRecovery and v3 ~= state then
			data.removeDevProductAction(state.toolCallId)
		elseif
			FFlagBuildExperienceDevProductRecovery
			and FFlagBuildExperienceMonetizationFailureCauses
			and state.attempted
			and toolControllerUtils.isConversationGone(p5)
		then
			state.isPending = false
			state.canRetry = false
			p2[state.toolCallId] = true
			data.markSubmitted(state.toolCallId)
			data.setDevProductTool(proposalFromFlow(state, true, false))
			data.removeDevProductAction(state.toolCallId)
			v3 = nil

			if callback ~= nil then
				callback(p4, p5)
			end
		else
			state.submitted = false

			if callback == nil then
				return
			end

			data.setDevProductTool(proposalFromFlow(state, false, false))
			callback(p4, p5)
		end
	end

	local function submitResult(data2, p4, flag: boolean, p5: string?)
		local submitActiveToolResult = p.submitActiveToolResult(p4, flag, data2.turnId, data2.referenceId)

		if submitActiveToolResult == nil then
			Debug.log("warn", "manage_developer_product tool_result submit aborted (no active session)", {
				toolCallId = data2.toolCallId
			})

			recoverFailedSubmission(data2, p5, nil)
		else
			local v6 = awaitRequestState(
				submitActiveToolResult.state,
				os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
			)

			if v6.status == "succeeded" then
				p2[data2.toolCallId] = true
				data.markSubmitted(data2.toolCallId)

				data.removeDevProductAction(data2.toolCallId)

				if v3 == data2 then
					v3 = nil
				end
			else
				recoverFailedSubmission(data2, p5, v6.errorCode)
				Debug.log("warn", "manage_developer_product tool_result submit failed", {
					sessionId = data2.sessionId,
					toolCallId = data2.toolCallId,
					turnId = data2.turnId,
					referenceId = data2.referenceId,
					action = data2.action,
					state = Debug.formatRequestState(v6)
				})
			end
		end
	end

	local function submitApproval(state)
		local product, resultError, v6

		if state.attempted then
			product = state.result
			resultError = state.resultError
			v6 = state.resultDetailCode
		else
			state.attempted = true
			local v7
			product, resultError, v7, v6 = performMutation(state)

			if product ~= nil and resultError == nil then
				resultError = moderationError(state, product)

				if resultError ~= nil then
					v6 = "name_moderated"
				end
			end

			state.result = product
			state.resultError = resultError

			if resultError ~= nil and v6 == nil then
				v6 = detailCodeForFailure(state.action, resultError)
			end

			state.resultDetailCode = v6

			if
				FFlagBuildExperienceDevProductRecovery
				and resultError ~= nil
				and v7
				and state.action == "create"
				and v3 == state
			then
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

		local v7, v8

		if product == nil or resultError ~= nil then
			v7 = v.formatResultContent({
				status = "error",
				action = state.action,
				detailCode = v6,
				message = resultError or "The developer product change failed.",
				product = product
			})
			v8 = true
		else
			v7, v8 = v.formatResultContent({
				status = "ok",
				action = state.action,
				product = product
			})
		end

		submitResult(state, v7, v8, nil)
	end

	local function submitRejection(p4, p5: string?)
		if not p4.attempted then
			submitResult(p4, v.formatRejectionContent(p4.action, p5), false, p5)
			return
		end

		data.setDevProductTool(proposalFromFlow(p4, true, false))
		submitApproval(p4)
	end

	local function onApproveImpl()
		local v6 = v3

		if v6 == nil or v6.submitted then
			return
		end

		v6.submitted = true

		if FFlagBuildExperienceDevProductRecovery then
			v6.isPending = true
			v6.canRetry = false
		end

		data.setDevProductTool(proposalFromFlow(v6, true, false))
		task.spawn(function()
			submitApproval(v6)
		end)
	end

	local function onRejectImpl()
		local v6 = v3

		if v6 == nil or v6.submitted then
			return
		end

		v6.submitted = true
		data.setDevProductTool(proposalFromFlow(v6, false, true))
		task.spawn(function()
			submitRejection(v6, nil)
		end)
	end

	local function runListRequest(manageDevProductRequestInTurnState: string, p4: number?, p5: string?, sessionId: string)
		local universeId = p.universeId
		local v6 = nil
		local v7

		if universeId == nil then
			v7 = monetizationFailureCauses.MESSAGES.noUniverse
		else
			v6, v7 = awaitMutation(v2.list(universeId))
		end

		local v8, v9

		if v6 == nil then
			v8 = v.formatResultContent({
				status = "error",
				action = "list",
				detailCode = "list_failed",
				message = v7 or "Could not list developer products."
			})
			v9 = true
		else
			v8, v9 = v.formatResultContent({
				status = "ok",
				action = "list",
				count = #v6.developerProducts,
				products = v6.developerProducts,
				nextPageToken = v6.nextPageToken,
				truncated = v6.nextPageToken ~= nil
			})
		end

		local submitActiveToolResult = p.submitActiveToolResult(v8, v9, p4, p5)
		v4[manageDevProductRequestInTurnState] = nil

		if submitActiveToolResult == nil then
			p2[manageDevProductRequestInTurnState] = nil
			return
		end

		local v10 = awaitRequestState(submitActiveToolResult.state, os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS)

		if v10.status ~= "succeeded" then
			p2[manageDevProductRequestInTurnState] = nil

			if v10.status == "pending" then
				submitActiveToolResult.dispose()
			end

			Debug.log("warn", "manage_developer_product list submit failed", {
				sessionId = sessionId,
				toolCallId = manageDevProductRequestInTurnState,
				state = Debug.formatRequestState(v10)
			})
		end
	end

	local function clearMutationFlow() -- 1 equivalent call inferred from this helper
		local v6 = v3

		if v6 ~= nil then
			clearMutationCard(v6) -- inferred equivalent call
		end

		v3 = nil
		v5 = nil
	end

	return {
		syncManageDevProductRequests = function(p4): boolean
			local manageDevProductRequestInTurnState, v6, turnId, referenceId = v.findManageDevProductRequestInTurnState(p4, p2)

			if manageDevProductRequestInTurnState == nil then
				clearMutationFlow() -- inferred equivalent call
				return false
			else
				local manageDevProductInput, v7, v8 = v.parseManageDevProductInput(v6)

				if manageDevProductInput == nil then
					if v4[manageDevProductRequestInTurnState] then
						return true
					end

					v4[manageDevProductRequestInTurnState] = true
					task.spawn(function()
						local v9

						if v7 == nil then
							v9 = FFlagBuildExperienceDevProductRecovery

							if v9 then
								if
									typeof(v6) == "table"
									and typeof(v6.action) == "string"
									and string.lower(v6.action) == "update"
								then
									v9 = v6.imageAssetId ~= nil
								else
									v9 = false
								end
							end
						else
							v9 = false
						end

						local kind

						if v.resolveRequestKind ~= nil then
							kind = v.resolveRequestKind(v6)
						end

						local formatResultContent = v.formatResultContent({
							status = "error",
							kind = kind,
							action = v9 and "update" or "unknown",
							detailCode = v9 and "unsupported_image_update" or v8 or "invalid_arguments",
							message = v9 and "Editing an existing developer product's image is not supported. No product was changed. Do not claim the image was updated or create a replacement product." or v7 or "The developer-product request was malformed."
						})

						local submitActiveToolResult = p.submitActiveToolResult(
							formatResultContent,
							true,
							turnId,
							referenceId
						)
						v4[manageDevProductRequestInTurnState] = nil

						if submitActiveToolResult == nil then
							return
						end

						local v10 = awaitRequestState(
							submitActiveToolResult.state,
							os.clock() + chatConstants.CAS_RPC_TIMEOUT_SECONDS
						)

						if v10.status == "succeeded" then
							p2[manageDevProductRequestInTurnState] = true
						elseif v10.status == "pending" then
							submitActiveToolResult.dispose()
						end
					end)
				elseif v.getActionKind(manageDevProductInput.action) == "read" then
					if v4[manageDevProductRequestInTurnState] then
						return true
					end

					p2[manageDevProductRequestInTurnState] = true
					v4[manageDevProductRequestInTurnState] = true
					task.spawn(function()
						runListRequest(manageDevProductRequestInTurnState, turnId, referenceId, p4.sessionId)
					end)
				elseif manageDevProductRequestInTurnState ~= v5 then
					v5 = manageDevProductRequestInTurnState
					local v9 = {
						sessionId = p4.sessionId,
						toolCallId = manageDevProductRequestInTurnState,
						callOrder = getToolCallOrder(p4, manageDevProductRequestInTurnState),
						turnId = turnId,
						referenceId = referenceId,
						universeId = p.universeId,
						action = manageDevProductInput.action,
						name = manageDevProductInput.name,
						description = manageDevProductInput.description,
						priceInRobux = manageDevProductInput.priceInRobux,
						productId = manageDevProductInput.productId,
						imageAssetId = manageDevProductInput.imageAssetId,
						submitted = false,
						attempted = false
					}

					v3 = v9
					data.setDevProductTool(proposalFromFlow(v9, false, false))
					data.setDevProductAction(manageDevProductRequestInTurnState, onApproveImpl, onRejectImpl)
					Debug.log("info", "manage_developer_product proposal displayed", {
						toolCallId = manageDevProductRequestInTurnState,
						turnId = turnId,
						referenceId = referenceId,
						action = manageDevProductInput.action
					})
				end

				return true
			end
		end,
		stopPending = function()
			local v6 = false

			for k in v4 do
				v4[k] = nil
				p2[k] = nil
				v6 = true
			end

			local v7 = v3

			if v7 == nil or v7.submitted then
				return v6
			end

			v7.submitted = true
			clearMutationCard(v7) -- inferred equivalent call
			v3 = nil
			v5 = nil
			v6 = true
			return true
		end,
		trySubmitComposerText = function(p4: string): boolean
			local v6 = v3

			if v6 == nil or v6.submitted then
				return false
			end

			v6.submitted = true
			data.setDevProductTool(proposalFromFlow(v6, false, true))
			task.spawn(function()
				submitRejection(v6, p4)
			end)
			return true
		end
	}
end

return createManageDevProductController
